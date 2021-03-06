<?php
/* +**********************************************************************************
 * The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 * Contributor(s): YetiForce.com
 * ********************************************************************************** */

namespace vtlib;

/**
 * Provides API to work with vtiger CRM Custom View (Filter).
 */
class Filter
{
	/** ID of this filter instance */
	public $id;
	public $name;
	public $isdefault;
	public $status = false; // 5.1.0 onwards
	public $inmetrics = false;
	public $entitytype = false;
	public $presence = 1;
	public $featured = 0;
	public $description;
	public $privileges = 1;
	public $sort;
	public $module;

	/**
	 * Initialize this filter instance.
	 *
	 * @param mixed $module Mixed id or name of the module
	 */
	public function initialize($valuemap, $module = false)
	{
		$this->id = $valuemap['cvid'];
		$this->name = $valuemap['viewname'];
		$this->module = Module::getInstance($module ? $module : $valuemap['tabid']);
	}

	/**
	 * Create this instance.
	 *
	 * @param Module Instance of the module to which this filter should be associated with
	 */
	public function __create($moduleInstance)
	{
		$this->module = $moduleInstance;
		$this->isdefault = ($this->isdefault === true || $this->isdefault == 'true') ? 1 : 0;
		$this->inmetrics = ($this->inmetrics === true || $this->inmetrics == 'true') ? 1 : 0;
		if (!isset($this->sequence)) {
			$sequence = (new \App\Db\Query())->from('vtiger_customview')
				->where(['entitytype' => $this->module->name])
				->max('sequence');
			$this->sequence = $sequence ? (int) $sequence + 1 : 0;
		}
		if (!isset($this->status)) {
			if ($this->presence == 0) {
				$this->status = '0';
			} // Default
			else {
				$this->status = '3';
			} // Public
		}
		$db = \App\Db::getInstance();
		$db->createCommand()->insert('vtiger_customview', [
			'viewname' => $this->name,
			'setdefault' => $this->isdefault,
			'setmetrics' => $this->inmetrics,
			'entitytype' => $this->module->name,
			'status' => $this->status,
			'privileges' => $this->privileges,
			'featured' => $this->featured,
			'sequence' => $this->sequence,
			'presence' => $this->presence,
			'description' => $this->description,
			'sort' => $this->sort,
		])->execute();
		$this->id = $db->getLastInsertID('vtiger_customview_cvid_seq');
		\App\Log::trace("Creating Filter $this->name ... DONE", __METHOD__);
	}

	public function __update()
	{
		\App\Log::trace("Updating Filter $this->name ... DONE", __METHOD__);
	}

	/**
	 * Delete this instance.
	 */
	public function __delete()
	{
		$db = \App\Db::getInstance();
		$db->createCommand()->delete('vtiger_cvadvfilter', ['cvid' => $this->id])->execute();
		$db->createCommand()->delete('vtiger_cvcolumnlist', ['cvid' => $this->id])->execute();
		$db->createCommand()->delete('vtiger_customview', ['cvid' => $this->id])->execute();
	}

	/**
	 * Save this instance.
	 *
	 * @param Module Instance of the module to use
	 */
	public function save($moduleInstance = false)
	{
		if ($this->id) {
			$this->__update();
		} else {
			$this->__create($moduleInstance);
		}
		return $this->id;
	}

	/**
	 * Delete this instance.
	 */
	public function delete()
	{
		$this->__delete();
	}

	/**
	 * Get the column value to use in custom view tables.
	 *
	 * @param FieldBasic $fieldInstance
	 *
	 * @return string
	 */
	public function __getColumnValue(FieldBasic $fieldInstance)
	{
		$tod = explode('~', $fieldInstance->typeofdata);
		$displayinfo = $fieldInstance->getModuleName() . '_' . str_replace(' ', '_', $fieldInstance->label) . ':' . $tod[0];
		$cvcolvalue = "$fieldInstance->table:$fieldInstance->column:$fieldInstance->name:$displayinfo";

		return $cvcolvalue;
	}

	/**
	 * Add the field to this filer instance.
	 *
	 * @param FieldBasic $fieldInstance
	 * @param int        $index
	 *
	 * @return $this
	 */
	public function addField(FieldBasic $fieldInstance, $index = 0)
	{
		$db = \App\Db::getInstance();
		$db->createCommand()->update('vtiger_cvcolumnlist', ['columnindex' => new \yii\db\Expression('columnindex + 1')], ['and', ['cvid' => $this->id], ['>=', 'columnindex', $index]])->execute();
		$db->createCommand()->insert('vtiger_cvcolumnlist', [
			'cvid' => $this->id,
			'columnindex' => $index,
			'field_name' => $fieldInstance->name,
			'module_name' => $fieldInstance->getModuleName()
		])->execute();
		\App\Log::trace("Adding $fieldInstance->name to $this->name filter ... DONE", __METHOD__);

		return $this;
	}

	/**
	 * Add rule to this filter instance.
	 *
	 * @param FieldBasic $fieldInstance
	 * @param string One of [EQUALS, NOT_EQUALS, STARTS_WITH, ENDS_WITH, CONTAINS, DOES_NOT_CONTAINS, LESS_THAN,
	 *                       GREATER_THAN, LESS_OR_EQUAL, GREATER_OR_EQUAL]
	 * @param string Value to use for comparision
	 * @param int Index count to use
	 *
	 * @return $this
	 */
	public function addRule(FieldBasic $fieldInstance, $comparator, $comparevalue, $index = 0, $group = 1, $condition = 'and')
	{
		if (empty($comparator)) {
			return $this;
		}

		$comparator = self::translateComparator($comparator);
		$cvcolvalue = $this->__getColumnValue($fieldInstance);

		$db = \App\Db::getInstance();
		$db->createCommand()->update('vtiger_cvadvfilter', ['columnindex' => new \yii\db\Expression('columnindex + 1')], ['and', ['cvid' => $this->id], ['>=', 'columnindex', $index]])->execute();
		$db->createCommand()->insert('vtiger_cvadvfilter', [
			'cvid' => $this->id,
			'columnindex' => $index,
			'columnname' => $cvcolvalue,
			'comparator' => $comparator,
			'value' => $comparevalue,
			'groupid' => $group,
			'column_condition' => $condition,
		])->execute();
		\App\Log::trace('Adding Condition ' . self::translateComparator($comparator, true) . " on $fieldInstance->name of $this->name filter ... DONE", __METHOD__);

		return $this;
	}

	/**
	 * Translate comparator (condition) to long or short form.
	 */
	public static function translateComparator($value, $tolongform = false)
	{
		$comparator = false;
		if ($tolongform) {
			$comparator = strtolower($value);
			if ($comparator == 'e') {
				$comparator = 'EQUALS';
			} elseif ($comparator == 'n') {
				$comparator = 'NOT_EQUALS';
			} elseif ($comparator == 's') {
				$comparator = 'STARTS_WITH';
			} elseif ($comparator == 'ew') {
				$comparator = 'ENDS_WITH';
			} elseif ($comparator == 'c') {
				$comparator = 'CONTAINS';
			} elseif ($comparator == 'k') {
				$comparator = 'DOES_NOT_CONTAINS';
			} elseif ($comparator == 'l') {
				$comparator = 'LESS_THAN';
			} elseif ($comparator == 'g') {
				$comparator = 'GREATER_THAN';
			} elseif ($comparator == 'm') {
				$comparator = 'LESS_OR_EQUAL';
			} elseif ($comparator == 'h') {
				$comparator = 'GREATER_OR_EQUAL';
			}
		} else {
			$comparator = strtoupper($value);
			if ($comparator == 'EQUALS') {
				$comparator = 'e';
			} elseif ($comparator == 'NOT_EQUALS') {
				$comparator = 'n';
			} elseif ($comparator == 'STARTS_WITH') {
				$comparator = 's';
			} elseif ($comparator == 'ENDS_WITH') {
				$comparator = 'ew';
			} elseif ($comparator == 'CONTAINS') {
				$comparator = 'c';
			} elseif ($comparator == 'DOES_NOT_CONTAINS') {
				$comparator = 'k';
			} elseif ($comparator == 'LESS_THAN') {
				$comparator = 'l';
			} elseif ($comparator == 'GREATER_THAN') {
				$comparator = 'g';
			} elseif ($comparator == 'LESS_OR_EQUAL') {
				$comparator = 'm';
			} elseif ($comparator == 'GREATER_OR_EQUAL') {
				$comparator = 'h';
			}
		}
		return $comparator;
	}

	/**
	 * Get instance by filterid or filtername.
	 *
	 * @param mixed filterid or filtername
	 * @param mixed $module Mixed id or name of the module
	 */
	public static function getInstance($value, $module = false)
	{
		$instance = false;
		$moduleName = is_numeric($module) ? \App\Module::getModuleName($module) : $module;
		if (Utils::isNumber($value)) {
			$query = (new \App\Db\Query())->from('vtiger_customview')->where(['cvid' => $value]);
		} else {
			$query = (new \App\Db\Query())->from('vtiger_customview')->where(['viewname' => $value, 'entitytype' => $moduleName]);
		}
		$result = $query->one();
		if ($result) {
			$instance = new self();
			$instance->initialize($result, $module);
		}
		return $instance;
	}

	/**
	 * Get all instances of filter for the module.
	 *
	 * @param ModuleBasic $moduleInstance
	 *
	 * @return self
	 */
	public static function getAllForModule(ModuleBasic $moduleInstance)
	{
		$instances = false;
		$dataReader = (new \App\Db\Query())->from('vtiger_customview')
			->where(['entitytype' => $moduleInstance->name])
			->createCommand()->query();
		while ($row = $dataReader->read()) {
			$instance = new self();
			$instance->initialize($row, $moduleInstance->id);
			$instances[] = $instance;
		}
		return $instances;
	}

	/**
	 * Delete filter associated for module.
	 *
	 * @param ModuleBasic $moduleInstance
	 */
	public static function deleteForModule(ModuleBasic $moduleInstance)
	{
		$cvids = (new \App\Db\Query())->from('vtiger_customview')
			->where(['entitytype' => $moduleInstance->name])
			->column();
		if (!empty($cvids)) {
			$db = \App\Db::getInstance();
			$db->createCommand()->delete('vtiger_cvadvfilter', ['cvid' => $cvids])->execute();
			$db->createCommand()->delete('vtiger_cvcolumnlist', ['cvid' => $cvids])->execute();
			$db->createCommand()->delete('vtiger_customview', ['cvid' => $cvids])->execute();
		}
	}
}
