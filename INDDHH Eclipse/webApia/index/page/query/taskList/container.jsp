<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/query/taskList/container.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.query.TaskListAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;
		
		var URL_ACQUIRED = "<system:util show="context" />/apia.query.TaskListAction.run?action=viewList<system:util show="tabIdRequest" />&workingMode=I";
		var URL_READY = "<system:util show="context" />/apia.query.TaskListAction.run?action=viewList<system:util show="tabIdRequest" />&workingMode=R";
		
	</script></head><body><div class="header"></div><div class="body" id="bodyDiv"><div class='tabComponent' id="tabComponent"  style="margin-right: 0px;"><div class="aTab"><div class="tab" id="tabAcquired"><system:label show="text" label="tabEjeMisTar" /></div><div class="contentTab" style="margin-right: 0px;"><iframe src="" id="iframeAcquired" width="100%" height="100%" style="border: 0px"></iframe></div></div><div class="aTab"><div class="tab" id="tabReady"><system:label show="text" label="tabEjeTarLib" /></div><div class="contentTab" style="margin-right: 0px;"><iframe src="" id="iframeReady" width="100%" height="100%" style="border: 0px"></iframe></div></div></div></div><%@include file="../../includes/footer.jsp" %></body></html>
