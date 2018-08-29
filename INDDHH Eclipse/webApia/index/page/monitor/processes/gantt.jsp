<%@page import="com.st.util.labels.LabelManager"%><%@page import="biz.statum.apia.web.bean.monitor.ProcessesBean"%><%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/monitor/processes/task.js"></script><script type="text/javascript" src="<system:util show="context" />/page/monitor/processes/gantt.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.monitor.ProcessesAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;		
		var fromEntity = '<system:edit show="value" from="theBean" field="fromEntity" />';
		var NOT_SUBPROCESS = '<system:label show="text" label="msgNotSubProcess" forScript="true" />';
		var SHOW_TSK_GANTT = '<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="SHOW_TSK_GANTT" />';
		var GANTT_REAL_HOPED = '<system:edit show="constant" from="biz.statum.apia.web.bean.monitor.ProcessesBean" field="GANTT_REAL_HOPED" />';
		var GANTT_REAL = '<system:edit show="constant" from="biz.statum.apia.web.bean.monitor.ProcessesBean" field="GANTT_REAL" />';
		var GANTT_CMP_PATH = '<system:util show="context" />/page/monitor/processes/cmpGantt.jsp?';		
		var PRO_MAX_DUR = '<system:edit show="value" from="theBean" field="proMaxDur" />';
	</script><style type="text/css">
		#imgRH {
			display: block;
			margin-left: auto;
			margin-right: auto;
		}
		#imgR {
			display: block;
			margin-left: auto;
			margin-right: auto;
		}
		#gridBody {
			overflow: auto;
		}
	</style></head><body><div class="header"></div><div class="body" id="bodyDiv"><div class="optionsContainer" id="optionsContainer"><div class="fncPanel info"><div class="title"><span><system:label show="tooltip" label="sbtMonTsk" />: <system:edit show="value" from="theBean" field="vo.proTitle"/> (<system:edit show="value" from="theBean" field="vo.processIdentification"/>)</span><span class="panelPinShow" id="panelPinShow">&nbsp;</span><span class="panelPinHidde" id="panelPinHidde">&nbsp;</span></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncProcMon"/></div><div class="clear"></div></div></div><div class="fncPanel buttons"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><div id="btnExport" class="button"><system:label show="text" label="btnExport" /></div><div id="btnBackToList" class="button" title="<system:label show="tooltip" label="btnVol" />"><system:label show="text" label="btnVol" /></div><div id="btnBack" class="button" title="<system:label show="tooltip" label="btnAnt" />"><system:label show="text" label="btnAnt" /></div></div></div><%@include file="show_combo.jsp" %></div><div class="gridContainer" id="gridContainer"><div id="gridBody"><img id="img<system:edit show="constant" from="biz.statum.apia.web.bean.monitor.ProcessesBean" field="GANTT_REAL_HOPED" />" src='<system:util show="context" />/styles/<system:util show="currentStyle" />/images/btn_mod.gif'><br><br><br><img id="img<system:edit show="constant" from="biz.statum.apia.web.bean.monitor.ProcessesBean" field="GANTT_REAL" />" src='<system:util show="context" />/styles/<system:util show="currentStyle" />/images/btn_mod.gif'><!-- MESSAGES --><div class="message hidden" id="messageContainer"></div></div></div></div><%@include file="../../includes/footer.jsp" %></body></html>
