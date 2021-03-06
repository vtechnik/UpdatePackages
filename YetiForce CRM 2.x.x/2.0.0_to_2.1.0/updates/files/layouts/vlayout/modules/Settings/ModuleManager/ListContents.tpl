{*<!--
/*********************************************************************************
** The contents of this file are subject to the vtiger CRM Public License Version 1.0
 * ("License"); You may not use this file except in compliance with the License
 * The Original Code is:  vtiger CRM Open Source
 * The Initial Developer of the Original Code is vtiger.
 * Portions created by vtiger are Copyright (C) vtiger.
 * All Rights Reserved.
 * Contributor(s): YetiForce.com
 ********************************************************************************/
-->*}
{strip}
	<div class="" id="moduleManagerContents">
		<div class="widget_header row">
			<div class="col-md-6"><h3>{vtranslate('LBL_MODULE_MANAGER', $QUALIFIED_MODULE)}</h3></div>
			<div class="col-md-6">
				<span class="btn-toolbar pull-right margin0px">
					<span class="btn-group">
						<button class="btn btn-default createModule" type="button">
							<strong>{vtranslate('LBL_CREATE_MODULE', $QUALIFIED_MODULE)}</strong>
						</button>
					</span>
					{if vglobal('systemMode') != 'demo'}
					<span class="btn-group">
						<button class="btn btn-default" type="button" onclick='window.location.href="{$IMPORT_USER_MODULE_URL}"'>
							<strong>{vtranslate('LBL_IMPORT_ZIP', $QUALIFIED_MODULE)}</strong>
						</button>
					</span>
					{/if}
				</span>
			</div>
		</div>
		<hr>
		
		<div class="contents">
			{assign var=COUNTER value=0}
			<table class="table table-bordered equalSplit">
				<tr>
				{foreach item=MODULE_MODEL key=MODULE_ID from=$ALL_MODULES}
					{assign var=MODULE_NAME value=$MODULE_MODEL->get('name')}
					{if $MODULE_NAME eq 'OSSMenuManager'} {continue}{/if}
					{assign var=MODULE_ACTIVE value=$MODULE_MODEL->isActive()}
					{if $COUNTER eq 2}
						</tr><tr>
						{assign var=COUNTER value=0}
					{/if}

					<td class="opacity">
						<div class="row moduleManagerBlock">
							<span class="col-md-1">
								<input type="checkbox" value="" name="moduleStatus" data-module="{$MODULE_NAME}" data-module-translation="{vtranslate($MODULE_NAME, $MODULE_NAME)}" {if $MODULE_MODEL->isActive()}checked{/if} />
							</span>
							<span class="col-md-1">
								{if $MODULE_MODEL->isExportable()}
									<a href="index.php?module=ModuleManager&parent=Settings&action=ModuleExport&mode=exportModule&forModule={$MODULE_MODEL->get('name')}"><i class="glyphicon glyphicon-download"></i></a>
								{/if}&nbsp;
							</span>
							<span class="col-md-2 moduleImage {if !$MODULE_ACTIVE}dull {/if}">
								{if vimage_path($MODULE_NAME|cat:'.png') != false}
									<img class="alignMiddle" src="{vimage_path($MODULE_NAME|cat:'.png')}" alt="{vtranslate($MODULE_NAME, $MODULE_NAME)}" title="{vtranslate($MODULE_NAME, $MODULE_NAME)}"/>
								{else}
									<img class="alignMiddle" src="{vimage_path('DefaultModule.png')}" alt="{vtranslate($MODULE_NAME, $MODULE_NAME)}" title="{vtranslate($MODULE_NAME, $MODULE_NAME)}"/>
								{/if}	
							</span>
							<span class="col-md-5 moduleName {if !$MODULE_ACTIVE}dull {/if}"><h4 class="no-margin">{vtranslate($MODULE_NAME, $MODULE_NAME)}</h4></span>
                            {assign var=SETTINGS_LINKS value=$MODULE_MODEL->getSettingLinks()}
							{if !in_array($MODULE_NAME, $RESTRICTED_MODULES_LIST) && (count($SETTINGS_LINKS) > 0)}
								<span class="col-md-3">
									<span class="btn-group pull-right actions {if !$MODULE_ACTIVE}hide{/if}">
										<button class="btn dropdown-toggle btn-default" data-toggle="dropdown">
											<strong>{vtranslate('LBL_SETTINGS', $QUALIFIED_MODULE)}</strong>&nbsp;<i class="caret"></i>
										</button>
										<ul class="dropdown-menu pull-right">
											{foreach item=SETTINGS_LINK from=$SETTINGS_LINKS}
											<li>
												<a {if stripos($SETTINGS_LINK['linkurl'], 'javascript:')===0} onclick='{$SETTINGS_LINK['linkurl']|substr:strlen("javascript:")};'{else} onclick='window.location.href="{$SETTINGS_LINK['linkurl']}"'{/if}>{vtranslate($SETTINGS_LINK['linklabel'], $MODULE_NAME)}</a>
											</li>
											{/foreach}
										</ul>
									</span>
								</span>
							{/if}
						</div>
						{assign var=COUNTER value=$COUNTER+1}
					</td>
				{/foreach}
				</tr>
			</table>
		</div>
	</div>
{/strip}
