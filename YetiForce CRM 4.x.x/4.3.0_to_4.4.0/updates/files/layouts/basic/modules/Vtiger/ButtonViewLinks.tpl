{*<!-- {[The file is published on the basis of YetiForce Public License 3.0 that can be found in the following directory: licenses/LicenseEN.txt or yetiforce.com]} -->*}
{strip}
	{if count($LINKS) gt 0}
		{if !$BTN_ICON && !$TEXT_HOLDER}
			{assign var=TEXT_HOLDER value=''}
			{foreach item=LINK from=$LINKS}
				{assign var=LINK_PARAMS value=vtlib\Functions::getQueryParams($LINK->getUrl())}
				{if \App\Request::_getModule() == $LINK_PARAMS['module'] && \App\Request::_get('view') == $LINK_PARAMS['view']}
					{assign var=TEXT_HOLDER value=$LINK->getLabel()}
					{if $LINK->get('linkicon') neq ''}
						{assign var=BTN_ICON value=$LINK->get('linkicon')}
					{/if}
				{/if}
			{/foreach}
		{/if}
		<div class="d-inline-block {if isset($CLASS)}{$CLASS}{/if}">
			<button class="btn {if isset($BTN_CLASS)}{$BTN_CLASS}{else}btn-light{/if} dropdown-toggle" data-toggle="dropdown">
				{if $BTN_ICON}
					<span class="{$BTN_ICON}"></span>
				{else}
					<span class="fas fa-list"></span>
				{/if}
				&nbsp;
				<span class="textHolder">{\App\Language::translate($TEXT_HOLDER, $MODULE_NAME)}</span>
				&nbsp;<span class="caret"></span>
			</button>
			<div class="dropdown-menu">
				{foreach item=LINK from=$LINKS}
					{if $LINK_TYPE && $LINK_TYPE neq $LINK->getType()}
						<li class="dropdown-divider"></li>
					{/if}
					{assign var="LINK_TYPE" value=$LINK->getType()}
					{assign var="LINK_URL" value=$LINK->getUrl()}
					<a class="dropdown-item quickLinks {$LINK->getClassName()}"
							{if $LINK->get('linkdata') neq ''}
								{foreach from=$LINK->get('linkdata') key=NAME item=DATA}
									{' '}data-{$NAME}="{$DATA}"
								{/foreach}
							{/if}
							{' '}
							{if $LINK_URL && stripos($LINK_URL, 'javascript:') === false}
								href="{$LINK_URL}"
							{elseif $LINK_URL}
								href="#"
								onclick='{$LINK_URL|substr:strlen("javascript:")}'
							{else}
								href="#"
							{/if}
							{if $LINK->get('dataUrl')}
								{' '}data-url="{$LINK->get('dataUrl')}"
							{/if}
							{if $LINK->get('style')}
							{' '}style="{$LINK->get('style')}"
							{/if}>
						{if $LINK->get('linkicon') neq ''}
							<span class="{$LINK->get('linkicon')}"></span>
							&nbsp;&nbsp;
						{/if}
						{\App\Language::translate($LINK->getLabel(), $MODULE_NAME)}
					</a>
				{/foreach}
			</div>
		</div>
	{/if}
{/strip}
