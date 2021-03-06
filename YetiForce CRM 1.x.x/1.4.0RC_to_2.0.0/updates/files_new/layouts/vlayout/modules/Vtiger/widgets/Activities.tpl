<div  class="summaryWidgetContainer activityWidgetContainer">
	<div class="widget_header row-fluid">
		<span class="span4"><h4 class="textOverflowEllipsis">{vtranslate('LBL_ACTIVITIES',$MODULE_NAME)}</h4></span>
		<span class="span5">
			<span class="pull-right">
				<input class="switchBtn" title="{vtranslate('LBL_CHANGE_ACTIVITY_TYPE')}" type="checkbox" checked data-size="small" data-label-width="5" data-handle-width="100" data-on-text="{vtranslate('LBL_TO_REALIZE')}" data-off-text="{vtranslate('LBL_HISTORY')}">
			</span>
		</span>
		<span class="span3"><button class="btn pull-right addButton createActivity" data-url="sourceModule={$RECORD->getModuleName()}&sourceRecord={$RECORD->getId()}&relationOperation=true" type="button"><strong>{vtranslate('LBL_ADD',$MODULE_NAME)}</strong></button></span>
	</div>
	<div class="widgetContainer_{$key} widgetContentBlock" data-url="{$WIDGET['url']}" data-name="{$WIDGET['label']}">
		<div class="widget_contents">
		</div>
	</div>
</div>
