{*<!-- {[The file is published on the basis of YetiForce Public License 3.0 that can be found in the following directory: licenses/LicenseEN.txt or yetiforce.com]} -->*}
{strip}
	<div class="tpl-Settings-LayoutEditor-EditField">
		<div class="modal-header">
			<h5 class="modal-title">{App\Language::translate('LBL_EDIT_CUSTOM_FIELD', $QUALIFIED_MODULE)}</h5>
			<button type="button" class="close" data-dismiss="modal" title="{\App\Language::translate('LBL_CLOSE')}">
				<span aria-hidden="true">&times;</span>
			</button>
		</div>
		<div class="modal-body row">
			<div class="col-md-12">
				<form class="form-horizontal fieldDetailsForm sendByAjax validateForm" method="POST">
					<input type="hidden" name="module" value="LayoutEditor"/>
					<input type="hidden" name="parent" value="Settings"/>
					<input type="hidden" name="action" value="Field"/>
					<input type="hidden" name="mode" value="save"/>
					<input type="hidden" name="fieldid" value="{$FIELD_MODEL->getId()}"/>
					<input type="hidden" name="sourceModule" value="{$SELECTED_MODULE_NAME}"/>
					{assign var=IS_MANDATORY value=$FIELD_MODEL->isMandatory()}
					{assign var=FIELD_INFO value=$FIELD_MODEL->getFieldInfo()}
					<strong>{App\Language::translate('LBL_LABEL_NAME', $QUALIFIED_MODULE)}
						: </strong>{App\Language::translate($FIELD_MODEL->getFieldLabel(), $SELECTED_MODULE_NAME)}<br/>
					<strong>{App\Language::translate('LBL_FIELD_NAME', $QUALIFIED_MODULE)}
						: </strong>{$FIELD_MODEL->getFieldName()}
					<hr class="marginTop10">
					<div class="checkbox">
						<input type="hidden" name="mandatory" value="O"/>
						<input type="checkbox"
							   name="mandatory"
							   id="mandatory" {if $IS_MANDATORY} checked {/if} {if $FIELD_MODEL->isMandatoryOptionDisabled()} readonly="readonly" {/if}
							   value="M"/>
						<label for="mandatory" class="ml-1">
							{App\Language::translate('LBL_MANDATORY_FIELD', $QUALIFIED_MODULE)}
						</label>
					</div>
					<div class="checkbox">
						<input type="hidden" name="presence" value="1"/>
						<input type="checkbox"
							   name="presence"
							   id="presence" {if $FIELD_MODEL->isActiveField()} checked {/if} {strip} {/strip}
								{if $FIELD_MODEL->isActiveOptionDisabled()} readonly="readonly" class="optionDisabled"{/if} {if $IS_MANDATORY} readonly="readonly" {/if}
							   value="{$FIELD_MODEL->get('presence')}"/>
						<label for="presence">
							{App\Language::translate('LBL_ACTIVE', $QUALIFIED_MODULE)}
						</label>
					</div>

					<div class="checkbox">
						<input type="hidden" name="quickcreate" value="1"/>
						<input type="checkbox"
							   name="quickcreate"
							   id="quickcreate" {if $FIELD_MODEL->isQuickCreateEnabled()} checked {/if}{strip} {/strip}
								{if $FIELD_MODEL->isQuickCreateOptionDisabled()} readonly="readonly" class="optionDisabled"{/if} {if $IS_MANDATORY} readonly="readonly" {/if}
							   value="2"/>
						<label for="quickcreate">
							{App\Language::translate('LBL_QUICK_CREATE', $QUALIFIED_MODULE)}
						</label>
					</div>
					<div class="checkbox">
						<input type="hidden" name="summaryfield" value="0"/>
						<input type="checkbox"
							   name="summaryfield"
							   id="summaryfield" {if $FIELD_MODEL->isSummaryField()} checked {/if}{strip} {/strip}
								{if $FIELD_MODEL->isSummaryFieldOptionDisabled()} readonly="readonly" class="optionDisabled"{/if}
							   value="1"/>
						<label for="summaryfield">
							{App\Language::translate('LBL_SUMMARY_FIELD', $QUALIFIED_MODULE)}
						</label>
					</div>
					<div class="checkbox">
						<input type="hidden" name="header_field" value="0"/>
						<input type="checkbox" name="header_field"
							   id="header_field" {if $FIELD_MODEL->isHeaderField()} checked {/if}
							   value="btn-default"/>
						<label for="header_field">
							{App\Language::translate('LBL_HEADER_FIELD', $QUALIFIED_MODULE)}
						</label>
					</div>
					<div class="checkbox">
						<input type="hidden" name="masseditable" value="2"/>
						<input type="checkbox"
							   name="masseditable"
							   id="masseditable" {if $FIELD_MODEL->isMassEditable()} checked {/if} {strip} {/strip}
								{if $FIELD_MODEL->isMassEditOptionDisabled()} readonly="readonly" {/if} value="1"/>
						<label for="masseditable">
							{App\Language::translate('LBL_MASS_EDIT', $QUALIFIED_MODULE)}
						</label>
					</div>

					<div class="checkbox">
						<input type="hidden" name="defaultvalue" value=""/>
						<input type="checkbox"
							   name="defaultvalue"
							   id="defaultvalue" {if $FIELD_MODEL->hasDefaultValue()} checked {/if} {strip} {/strip}
								{if $FIELD_MODEL->isDefaultValueOptionDisabled()} readonly="readonly" {/if} value=""/>
						<label for="defaultvalue">
							{App\Language::translate('LBL_DEFAULT_VALUE', $QUALIFIED_MODULE)}
						</label>
						<div class="defaultValueUi {if !$FIELD_MODEL->hasDefaultValue()} zeroOpacity {/if}">
							{if $FIELD_MODEL->isDefaultValueOptionDisabled() neq "true"}
								<label for="fieldDefaultValue"
									   class="sr-only">{App\Language::translate('LBL_DEFAULT_VALUE', $QUALIFIED_MODULE)}
								</label>
								{if $FIELD_MODEL->getFieldDataType() eq "picklist"}
									{assign var=PICKLIST_VALUES value=$FIELD_MODEL->getPicklistValues()}
									<select class="col-md-2 select2"
											name="fieldDefaultValue"
											id="fieldDefaultValue" {if !$FIELD_MODEL->hasDefaultValue()} disabled="" {/if}
											data-validation-engine="validate[required,funcCall[Vtiger_Base_Validator_Js.invokeValidation]]"
											data-fieldinfo='{\App\Purifier::encodeHtml(\App\Json::encode($FIELD_INFO))}'>
										{foreach item=PICKLIST_VALUE key=PICKLIST_NAME from=$PICKLIST_VALUES}
											<option value="{\App\Purifier::encodeHtml($PICKLIST_NAME)}" {if App\Purifier::decodeHtml($FIELD_MODEL->get('defaultvalue')) eq $PICKLIST_NAME} selected {/if}>{App\Language::translate($PICKLIST_VALUE, $SELECTED_MODULE_NAME)}</option>
										{/foreach}
									</select>
								{elseif $FIELD_MODEL->getFieldDataType() eq "multipicklist"}
									{assign var=PICKLIST_VALUES value=$FIELD_MODEL->getPicklistValues()}
									{assign var="FIELD_VALUE_LIST" value=explode(' |##| ',$FIELD_MODEL->get('defaultvalue'))}
									<select multiple class="col-md-2 select2"
											data-validation-engine="validate[required,funcCall[Vtiger_Base_Validator_Js.invokeValidation]]" {if !$FIELD_MODEL->hasDefaultValue()} disabled="" {/if}
											name="fieldDefaultValue" id="fieldDefaultValue"
											data-fieldinfo='{\App\Purifier::encodeHtml(\App\Json::encode($FIELD_INFO))}'>
										{foreach item=PICKLIST_VALUE from=$PICKLIST_VALUES}
											<option value="{\App\Purifier::encodeHtml($PICKLIST_VALUE)}" {if in_array(\App\Purifier::encodeHtml($PICKLIST_VALUE), $FIELD_VALUE_LIST)} selected {/if}>{App\Language::translate($PICKLIST_VALUE, $SELECTED_MODULE_NAME)}</option>
										{/foreach}
									</select>
								{elseif $FIELD_MODEL->getFieldDataType() eq "boolean"}
									<div class="checkbox">
										<input type="hidden" name="fieldDefaultValue" id="fieldDefaultValue" value=""/>
										<input type="checkbox" name="fieldDefaultValue" id="fieldDefaultValue"
											   value="1"{strip} {/strip}
												{if $FIELD_MODEL->get('defaultvalue') eq 1} checked {/if}
											   data-fieldinfo='{\App\Json::encode($FIELD_INFO)}'/>
									</div>
								{elseif $FIELD_MODEL->getFieldDataType() eq "time"}
									<div class="input-group time">
										<input type="text" class="form-control-sm form-control clockPicker"
											   data-format="{$USER_MODEL->get('hour_format')}"
											   data-validation-engine="validate[required,funcCall[Vtiger_Base_Validator_Js.invokeValidation]]" {if !$FIELD_MODEL->hasDefaultValue()} disabled="" {/if}
											   data-toregister="time" value="{$FIELD_MODEL->get('defaultvalue')}"
											   name="fieldDefaultValue" id="fieldDefaultValue"
											   data-fieldinfo='{\App\Json::encode($FIELD_INFO)}'/>
										<div class="input-group-append">
										<span class="input-group-text u-cursor-pointer js-clock__btn" data-js="click">
											<span class="far fa-clock"></span>
										</span>
										</div>
									</div>
								{elseif $FIELD_MODEL->getFieldDataType() eq "date"}
									{assign var=IS_CUSTOM_DEFAULT_VALUE value=\App\TextParser::isVaribleToParse($FIELD_MODEL->get('defaultvalue'))}
									<div class="input-group date {if $IS_CUSTOM_DEFAULT_VALUE} d-none{/if}">
										{assign var=FIELD_NAME value=$FIELD_MODEL->getName()}
										<input type="text" class="form-control dateField"
											   data-validation-engine="validate[required,funcCall[Vtiger_Base_Validator_Js.invokeValidation]]" {if !$FIELD_MODEL->hasDefaultValue() || $IS_CUSTOM_DEFAULT_VALUE} disabled="" {/if}
											   name="fieldDefaultValue" id="fieldDefaultValue" data-toregister="date"
											   data-date-format="{$USER_MODEL->get('date_format')}"
											   data-fieldinfo='{\App\Json::encode($FIELD_INFO)}'{strip} {/strip}
											   value="{if !$IS_CUSTOM_DEFAULT_VALUE}{$FIELD_MODEL->getEditViewDisplayValue($FIELD_MODEL->get('defaultvalue'))}{/if}"/>
										<div class=" input-group-append">
										<span class="input-group-text u-cursor-pointer js-date__btn" data-js="click">
											<span class="fas fa-calendar-alt"></span>
										</span>
										</div>
										<span class="input-group-btn"
											  title="{\App\Purifier::encodeHtml(App\Language::translate('LBL_CUSTOM_CONFIGURATION', $QUALIFIED_MODULE))}">
										<button class="btn btn-light configButton" type="button"><span
													class="fas fa-cog"></span></button>
									</span>
									</div>
									<div class="input-group {if !$IS_CUSTOM_DEFAULT_VALUE} d-none{/if}">
										<input type="text" class="form-control"
											   name="fieldDefaultValue"
											   id="fieldDefaultValue" {if !$FIELD_MODEL->hasDefaultValue() || !$IS_CUSTOM_DEFAULT_VALUE} disabled{/if}
											   value="{if $IS_CUSTOM_DEFAULT_VALUE}{$FIELD_MODEL->get('defaultvalue')}{/if}"
											   data-validation-engine="validate[required,funcCall[Vtiger_Base_Validator_Js.invokeValidation]]"
											   data-fieldinfo="{\App\Purifier::encodeHtml('{"type":"textParser"}')}"/>
										<span class="input-group-btn">
										<button class="btn btn-light varibleToParsers" type="button"><span
													class="fas fa-edit"></span></button>
										<button class="btn btn-light active configButton" type="button"
												title="{\App\Purifier::encodeHtml(App\Language::translate('LBL_CUSTOM_CONFIGURATION', $QUALIFIED_MODULE))}"><span
													class="fas fa-cog"></span></button>
									</span>
									</div>
								{elseif $FIELD_MODEL->getFieldDataType() eq "percentage"}
									<div class="input-group">
										<input type="number"
											   data-validation-engine="validate[required,funcCall[Vtiger_Base_Validator_Js.invokeValidation]]" {if !$FIELD_MODEL->hasDefaultValue()} disabled="" {/if}
											   class="form-control" name="fieldDefaultValue"
											   id="fieldDefaultValue" {strip} {/strip}
											   value="{$FIELD_MODEL->get('defaultvalue')}"
											   data-fieldinfo='{\App\Json::encode($FIELD_INFO)}' step="any"/>
										<span class="input-group-addon">%</span>
									</div>
								{elseif $FIELD_MODEL->getFieldDataType() eq "currency"}
									<div class="input-group">
										<span class="input-group-addon">{$USER_MODEL->get('currency_symbol')}</span>
										<input type="text"
											   data-validation-engine="validate[required,funcCall[Vtiger_Base_Validator_Js.invokeValidation]]" {if !$FIELD_MODEL->hasDefaultValue()} disabled="" {/if}
											   class="form-control" name="fieldDefaultValue"
											   id="fieldDefaultValue" {strip} {/strip}
											   data-fieldinfo='{\App\Json::encode($FIELD_INFO)}'
											   value="{$FIELD_MODEL->getEditViewDisplayValue($FIELD_MODEL->get('defaultvalue'))}"
											   data-decimal-separator='{$USER_MODEL->get('currency_decimal_separator')}'
											   data-group-separator='{$USER_MODEL->get('currency_grouping_separator')}'/>
									</div>
								{else if $FIELD_MODEL->getUIType() eq 19}
									<textarea class="input-medium"
											  data-validation-engine="validate[required,funcCall[Vtiger_Base_Validator_Js.invokeValidation]]" {if !$FIELD_MODEL->hasDefaultValue()} disabled="" {/if}
											  name="fieldDefaultValue" id="fieldDefaultValue"
											  value="{$FIELD_MODEL->get('defaultvalue')}"
											  data-fieldinfo='{\App\Json::encode($FIELD_INFO)}'></textarea>
								{else}
									<input type="text" class="input-medium form-control"
										   data-validation-engine="validate[required,funcCall[Vtiger_Base_Validator_Js.invokeValidation]]" {if !$FIELD_MODEL->hasDefaultValue()} disabled="" {/if}
										   name="fieldDefaultValue" id="fieldDefaultValue"
										   value="{$FIELD_MODEL->get('defaultvalue')}"
										   data-fieldinfo='{\App\Json::encode($FIELD_INFO)}'/>
								{/if}
							{/if}
						</div>
					</div>
					{if in_array($FIELD_MODEL->getFieldDataType(),['string','phone','currency','url','integer','double'])}
					<div>
						<div class="form-group">
							<label for="fieldMask"><strong>{App\Language::translate('LBL_FIELD_MASK', $QUALIFIED_MODULE)}</strong></label>
							<div class=" input-group">
								<input type="text" class="form-control" id="fieldMask" name="fieldMask"
									   value="{$FIELD_MODEL->get('fieldparams')}"/>
								<div class="input-group-append">
								<span class="input-group-text js-popover-tooltip u-cursor-pointer" data-js="popover"
									  data-placement="top"
									  data-content="{App\Language::translate('LBL_FIELD_MASK_INFO', $QUALIFIED_MODULE)}">
									<span class="fas fa-info-circle"></span>
								</span>
								</div>
							</div>
						</div>
						{/if}
						<div class="form-group">
							<label for="maxlengthtext"><strong>{App\Language::translate('LBL_MAX_LENGTH_TEXT', $QUALIFIED_MODULE)}</strong></label>
							<input type="text" class="form-control" id="maxlengthtext" name="maxlengthtext"
								   value="{$FIELD_MODEL->get('maxlengthtext')}"/>
						</div>
						<div class="form-group">
							<label for="maxwidthcolumn"><strong>{App\Language::translate('LBL_MAX_WIDTH_COLUMN', $QUALIFIED_MODULE)}</strong></label>
							<input type="text" class="form-control" id="maxwidthcolumn" name="maxwidthcolumn"
								   value="{$FIELD_MODEL->get('maxwidthcolumn')}"/>
						</div>
						{if AppConfig::developer('CHANGE_GENERATEDTYPE')}
							<div class="checkbox">
								<input type="checkbox" name="generatedtype" id="generatedtype"
									   value="1" {if $FIELD_MODEL->get('generatedtype') eq 1} checked {/if} />
								<label for="generatedtype">
									{App\Language::translate('LBL_GENERATED_TYPE', $QUALIFIED_MODULE)}
								</label>
							</div>
						{/if}
						{if AppConfig::developer('CHANGE_VISIBILITY')}
							<div class="form-group">
								<label for="displaytype">
									<strong>{App\Language::translate('LBL_DISPLAY_TYPE', $QUALIFIED_MODULE)}</strong>
									{assign var=DISPLAY_TYPE value=Vtiger_Field_Model::showDisplayTypeList()}
								</label>
								<div class="defaultValueUi">
									<select name="displaytype" class="form-control select2" id="displaytype">
										{foreach key=DISPLAY_TYPE_KEY item=DISPLAY_TYPE_VALUE from=$DISPLAY_TYPE}
											<option value="{$DISPLAY_TYPE_KEY}" {if $DISPLAY_TYPE_KEY == $FIELD_MODEL->get('displaytype')} selected {/if} >{App\Language::translate($DISPLAY_TYPE_VALUE, $QUALIFIED_MODULE)}</option>
										{/foreach}
									</select>
								</div>
							</div>
						{/if}
						{include file=\App\Layout::getTemplatePath('Modals/Footer.tpl', $QUALIFIED_MODULE) BTN_SUCCESS='LBL_SAVE' BTN_DANGER='LBL_CANCEL'}
				</form>
			</div>
		</div>
	</div>
{/strip}
