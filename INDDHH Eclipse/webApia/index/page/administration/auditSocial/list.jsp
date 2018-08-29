<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/administration/auditSocial/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.administration.AuditSocialAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;
	</script></head><body><div class="header"></div><div class="body" id="bodyDiv"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="mnuAuditSoc" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAuditSoc"/></div><div class="clear"></div></div></div><%@include file="../../includes/adminActions.jsp" %><div class="fncPanel buttons"><div class="title"><system:label show="tooltip" label="mnuOpc" /></div><div class="content"><div id="btnMsgView" class="button" title="<system:label show="tooltip" label="lblSocMsgView" />"><system:label show="text" label="lblSocMsgView" /></div></div></div><div class="fncPanel options lastOptions"><div class="title" title="<system:label show="tooltip" label="titAdmAdtFilter"/>"><system:label show="text" label="titAdmAdtFilter"/></div><div class="content"><div class="filter"><span><system:label show="text" label="lblDate" />:</span><input id="msgDteFromFilter" type="text" class="datePicker filterInputDate" format="d/m/Y" size="9" maxlength="10" value=""> 
						-
						<input id="msgDteToFilter" type="text" class="datePicker filterInputDate" format="d/m/Y" size="9" maxlength="10" value=""></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="gridHeader" id="gridHeader"><!-- Cabezal y filtros --><table cellpadding="0" cellspacing="0"><thead><tr id="trOrderBy" class="header"><th id="orderByObjType" class="allowSort sort<system:filter show="sortStyle" from="biz.statum.apia.vo.filter.SocialMessageChannelFilterVo" field="ORDER_CHANNEL_TYPE"/>" sortBy="<system:edit show="constant" from="biz.statum.apia.vo.filter.SocialMessageChannelFilterVo" field="ORDER_CHANNEL_TYPE"/>" title="<system:label show="tooltip" label="lblChnType" />"><div style="width: 120px"><system:label show="text" label="lblChnType"/></div></th><th id="orderByObjTitle" class="allowSort sort<system:filter show="sortStyle" from="biz.statum.apia.vo.filter.SocialMessageChannelFilterVo" field="ORDER_CHANNEL_TITLE"/>" sortBy="<system:edit show="constant" from="biz.statum.apia.vo.filter.SocialMessageChannelFilterVo" field="ORDER_CHANNEL_TITLE"/>" title="<system:label show="tooltip" label="lblChnTitle" />"><div style="width: 200px"><system:label show="text" label="lblChnTitle" /></div></th><th id="orderByMsgContent" class="allowSort sort<system:filter show="sortStyle" from="biz.statum.apia.vo.filter.SocialMessageChannelFilterVo" field="ORDER_MESSAGE"/>" sortBy="<system:edit show="constant" from="biz.statum.apia.vo.filter.SocialMessageChannelFilterVo" field="ORDER_MESSAGE"/>" title="<system:label show="text" label="lblSocMsg" />"><div style="width: 280px"><system:label show="text" label="lblSocMsg" /></div></th><th id="orderByMsgAuthor" class="allowSort sort<system:filter show="sortStyle" from="biz.statum.apia.vo.filter.SocialMessageChannelFilterVo" field="ORDER_AUTHOR"/>" sortBy="<system:edit show="constant" from="biz.statum.apia.vo.filter.SocialMessageChannelFilterVo" field="ORDER_AUTHOR"/>" title="<system:label show="tooltip" label="lblMsgAut" />"><div style="width: 120px"><system:label show="text" label="lblMsgAut" /></div></th><th id="orderByMsgDate" class="allowSort sort<system:filter show="sortStyle" from="biz.statum.apia.vo.filter.SocialMessageChannelFilterVo" field="ORDER_DATE"/>" sortBy="<system:edit show="constant" from="biz.statum.apia.vo.filter.SocialMessageChannelFilterVo" field="ORDER_DATE"/>" title="<system:label show="tooltip" label="lblDate" />"><div style="width: 120px"><system:label show="text" label="lblDate" /></div></th></tr><tr class="filter"><th title="<system:label show="text" label="lblChnType" />"><div style="width: 120px"><select name="objTypeFilter" id="objTypeFilter" onchange="onChangeObjType(this.value);"><option></option><option value="<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_ENVIRONMENT"/>"><system:label show="text" label="lblAmb" /></option><option value="<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_PROCESS"/>"><system:label show="text" label="lblPro" /></option><option value="<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_TASK"/>"><system:label show="text" label="lblTask" /></option><option value="<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_POOL"/>"><system:label show="text" label="lblProPool" /></option><option value="<system:edit show="constant" from="com.dogma.vo.SocMesChannelsVo" field="TYPE_USER"/>"><system:label show="text" label="lblUsu" /></option></select></div></th><th title="<system:label show="text" label="lblChnTitle" />"><div style="width: 200px"><select name="objTitleFilter" id="objTitleFilter" onchange="setFilter();"><option></option></select></div></th><th title="<system:label show="tooltip" label="lblSocMsg" />"><div style="width: 280px"><input id="msgContentFilter" type="text" value=""></div></th><th title="<system:label show="tooltip" label="lblMsgAut" />"><div style="width: 120px"><input id="msgAuthorFilter" type="text" value=""></div></th><th><div style="width: 120px"></div></th></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table cellpadding="0" cellspacing="0"><thead><tr><th width="120px"></th><th width="200px"></th><th width="280px"></th><th width="120px"></th><th width="120px"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div class="gridFooter"><%@include file="../../includes/navButtons.jsp" %></div><!-- MESSAGES --><div class="message hidden" id="messageContainer"></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="../../includes/footer.jsp" %></body></html>
