<%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.monitor.BusinessAction"%><%@page import="biz.statum.apia.web.bean.monitor.BusinessBean"%><%@include file="../../includes/startInc.jsp" %><html class="full-height"><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.monitor.BusinessAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;
		
		function initPage(){
			initAdminFav();
			var pinHide = $('panelPinHidde').addEvent('click', function() {
// 				this.setStyle('display', 'none');
// 				pinShow.setStyle('display', 'block');
				closeOptionsContainer();
			})
			var pinShow = $('panelPinShow').addEvent('click', function() {
				this.setStyle('display', 'none');
				pinHide.setStyle('display', 'block');
				openOptionsContainer();
			})
		}
		
		function closeOptionsContainer() {
			var divs = $('optionsContainer').setStyles({
				width:	30,
				height:	20
			}).getChildren()[0].getChildren();
			divs[0].setStyle('border-bottom', 'none').getChildren().each(function(ele) {
				if(ele.get('id') == 'panelPinShow')
					ele.setStyle('display', 'block');
				else
					ele.setStyle('display', 'none');
			});
			divs[1].setStyle('display', 'none');
			$('gridContainer').setStyle('margin-right', '15px');
		}
		
		function openOptionsContainer() {
			var divs = $('optionsContainer').setStyles({
				width:	'',
				height:	'' 
			}).getChildren()[0].getChildren();
			divs[0].setStyle('border-bottom', '').getChildren().each(function(ele) {
				if(ele.get('id') == 'panelPinShow')
					ele.setStyle('display', 'none');
				else
					ele.setStyle('display', '');
			});
			divs[1].setStyle('display', '');
			$('gridContainer').setStyle('margin-right', '');
		}
		
		function openDetailsModal(type,id) {
			//console.log("openDetailsModal " + type + " " + id);
			if (type == "<%= com.apia.query.extractors.MainExtractor.TYPE_PROCESS_INSTANCE%>") {
				//var rets = openModal("/query.MonitorBusinessAction.do?action=details&proInstId=" + id + "&type=" + type,640,480);
				ModalController.openWinModal(CONTEXT + "/apia.monitor.BusinessAction.run?action=details&id=" + id + "&type=" + type  + TAB_ID_REQUEST, 800, 650, null, null, false, true, true);
			} else {
				//var rets = openModal("/query.MonitorBusinessAction.do?action=details&busEntInstId=" + id + "&type=" + type,640,480);
				ModalController.openWinModal(CONTEXT + "/apia.monitor.BusinessAction.run?action=details&busEntInstId=" + id + "&type=" + type  + TAB_ID_REQUEST, 800, 650, null, null, false, true, true);
			}
		}
		
		function openTasksModal(type,id) {
			//console.log("openTasksModal " + type + " " + id);
			//var rets = openModal("/query.MonitorBusinessAction.do?action=tasks&proInstId=" + id + "&type=" + type,640,480);
			//ModalController.openWinModal(CONTEXT + "/apia.monitor.BusinessAction.run?action=tasks&id=" + id + "&type=" + type  + TAB_ID_REQUEST, 800, 600, null, null, false, true, true);
			ModalController.openWinModal(CONTEXT + "/apia.monitor.ProcessesAction.run?action=task&id=" + id + TAB_ID_REQUEST, 850, 650, null, null, false, true, true);
		}
	</script></head><body><div class="header"></div><div class="body" id="bodyDiv"><form id="queryForm" action="<system:util show="context" />/apia.monitor.BusinessAction.run?<system:util show="tabIdRequest" />" method="post"><input type="hidden" name="action" value="" id="setFilters"><div class="optionsContainer" id="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><span><system:label show="text" label="sbtDatMonBusiness"/></span><span class="panelPinShow" id="panelPinShow">&nbsp;</span><span class="panelPinHidde" id="panelPinHidde">&nbsp;</span><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><%
							BusinessBean bBean = BusinessAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));
							if(bBean.getFncTooltip() != null) {
								out.print(bBean.getFncTooltip());
							} else { 
								%><system:label show="tooltip" label="sbtDatMonBusiness"/><%
							}
						%></div><div class="clear"></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer" id="gridContainer"><!--<system:campaign inLogin="false" inSplash="false" location="horizontalUp" />--><div style="height:100%;"><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"  
					 codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" 
						WIDTH="100%" 
						HEIGHT="100%" 
						style="height:100%;/*border:1px solid black*/"
						id="shell" ALIGN="center" VALIGN="middle"><param name="allowScriptAccess" value="sameDomain" /><param name="movie" value="<system:util show="context" />/flash/Monitor/bin/Monitor.swf" /><param name="FlashVars" value="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&SWF_URL=<system:util show="context" />/flash/Monitor/bin/&TAB_ID_REQUEST=%26tabId=<system:util show="tabId" />%26tokenId=<system:util show="tokenId" />&LBL_URL=<system:util show="context" />/page/monitor/business/labels.jsp&DEFAULT_VISUALIZATION=<system:edit show="value" from="theBean" field="defaultVisualization" />&DEFAULT_SHOW_RELATED_ENTITIES=<system:edit show="value" from="theBean" field="defaultShowRelatedEntities" />&DEFAULT_SHOW_RELATED_PROCESS=<system:edit show="value" from="theBean" field="defaultShowRelatedProcess" />&DEFAULT_SHOW_RELATED_TASKS=<system:edit show="value" from="theBean" field="defaultShowRelatedTasks" />&DEFAULT_GROUP_ENTITY_INSTANCES=<system:edit show="value" from="theBean" field="defaultGroupEntityInstnaces" />&DEFAULT_GROUP_PROCESS_INSTANCES=<system:edit show="value" from="theBean" field="defaultGroupProcessInstnaces" />&SHOW_HISTORY=<system:edit show="value" from="theBean" field="showHistory" />&SHOW_INSTANCES=<system:edit show="value" from="theBean" field="showInstances" />&SHOW_VISUALIZATION=<system:edit show="value" from="theBean" field="showVisualization" />" /><param name="quality" value="high" /><param name="menu" value="false"/><param name="bgcolor" value="#efefef" /><param name="WMODE" value="transparent" /><embed style="height:100%;" wmode="transparent" menu="false" allowScriptAccess="sameDomain" src="<system:util show="context" />/flash/Monitor/bin/Monitor.swf" quality="high" bgcolor="#efefef" width="100%" height="100%" swLiveConnect="true" id="shell" name="shell" align="middle" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" flashVars="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&SWF_URL=<system:util show="context" />/flash/Monitor/bin/&TAB_ID_REQUEST=%26tabId=<system:util show="tabId" />%26tokenId=<system:util show="tokenId" />&LBL_URL=<system:util show="context" />/page/monitor/business/labels.jsp&DEFAULT_VISUALIZATION=<system:edit show="value" from="theBean" field="defaultVisualization" />&DEFAULT_SHOW_RELATED_ENTITIES=<system:edit show="value" from="theBean" field="defaultShowRelatedEntities" />&DEFAULT_SHOW_RELATED_PROCESS=<system:edit show="value" from="theBean" field="defaultShowRelatedProcess" />&DEFAULT_SHOW_RELATED_TASKS=<system:edit show="value" from="theBean" field="defaultShowRelatedTasks" />&DEFAULT_GROUP_ENTITY_INSTANCES=<system:edit show="value" from="theBean" field="defaultGroupEntityInstnaces" />&DEFAULT_GROUP_PROCESS_INSTANCES=<system:edit show="value" from="theBean" field="defaultGroupProcessInstnaces" />&SHOW_HISTORY=<system:edit show="value" from="theBean" field="showHistory" />&SHOW_INSTANCES=<system:edit show="value" from="theBean" field="showInstances" />&SHOW_VISUALIZATION=<system:edit show="value" from="theBean" field="showVisualization" />" /></object></div><!--<system:campaign inLogin="false" inSplash="false" location="horizontalDown" />--></div></form></div><%@include file="../../includes/footer.jsp" %></body></html>