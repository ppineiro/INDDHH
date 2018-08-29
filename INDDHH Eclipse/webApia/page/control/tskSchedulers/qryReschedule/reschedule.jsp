<%@include file="../../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/base/modules/schedulerAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/control/tskSchedulers/qryReschedule/reschedule.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/control/tskSchedulers/qryReschedule/tskSchedulerResched.js"></script><script type="text/javascript">
			var URL_REQUEST_AJAX = '/apia.control.QryRescheduleTskSchedulerAction.run';
			
			var TSK_DAY_MON = '<system:label show="text" label="lblTskDayMon" forScript="true" />';
			var TSK_DAY_TUE = '<system:label show="text" label="lblTskDayTue" forScript="true" />';
			var TSK_DAY_WED = '<system:label show="text" label="lblTskDayWed" forScript="true" />';
			var TSK_DAY_THU = '<system:label show="text" label="lblTskDayThu" forScript="true" />';
			var TSK_DAY_FRI = '<system:label show="text" label="lblTskDayFri" forScript="true" />';
			var TSK_DAY_SAT = '<system:label show="text" label="lblTskDaySat" forScript="true" />';
			var TSK_DAY_SUN = '<system:label show="text" label="lblTskDaySun" forScript="true" />';
			
			var TSK_MONT_JAN = '<system:label show="text" label="lblEnero" forScript="true" />';
			var TSK_MONT_FEB = '<system:label show="text" label="lblFebrero" forScript="true" />';
			var TSK_MONT_MAR = '<system:label show="text" label="lblMarzo" forScript="true" />';
			var TSK_MONT_APR = '<system:label show="text" label="lblAbril" forScript="true" />';
			var TSK_MONT_MAY = '<system:label show="text" label="lblMayo" forScript="true" />';
			var TSK_MONT_JUN = '<system:label show="text" label="lblJunio" forScript="true" />';
			var TSK_MONT_JUL = '<system:label show="text" label="lblJulio" forScript="true" />';
			var TSK_MONT_AUG = '<system:label show="text" label="lblAgosto" forScript="true" />';
			var TSK_MONT_SEP = '<system:label show="text" label="lblSetiembre" forScript="true" />';
			var TSK_MONT_OCT = '<system:label show="text" label="lblOctubre" forScript="true" />';
			var TSK_MONT_NOV = '<system:label show="text" label="lblNoviembre" forScript="true" />';
			var TSK_MONT_DEC = '<system:label show="text" label="lblDiciembre" forScript="true" />';
			
			var LBL_TODAY 				= '<system:label show="text" label="lblToday" forScript="true" />';
			var LBL_SCHED_FORM_TITLE	= '<system:label show="text" label="titTabSchTask" forScript="true" />';
			
			var LBL_SCHED_OF 					= '<system:label show="text" label="lblTskSchedOf" forScript="true" />';
			var LBL_SCHED_WEEK_NOT_CONFIGURED 	= '<system:label show="text" label="msgTskSchWeekNotConfig" forScript="true" />';
			
			var WEEKDAY_SELECTED 	= '<system:edit show="value" from="theBean" field="tskSchNumDte"  />';
			var DAY_NUMBER_SELECTED = '<system:edit show="value" from="theBean" field="tskSchNumDay"  />';
			var HOUR_SELECTED 		= '<system:edit show="value" from="theBean" field="tskSchNumHor"  />';
			
			var SCH_ID 				= '<system:edit show="value" from="theBean" field="tskSchedulerId"  />';
			var PRO_ID 				= '<system:edit show="value" from="theBean" field="tskSchNumberVoProId"  />';
			var PRO_VER_ID 			= '<system:edit show="value" from="theBean" field="tskSchNumberVoProVerId"  />';
			var TSK_ID 				= '<system:edit show="value" from="theBean" field="tskSchNumberVoTskId"  />';
			var SHOW_DISPONIBILITY 	= true;
		</script></head><body><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><div class="fncPanel info"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="title"><system:label show="text" label="mnuConTskSchQueryResch" /><%@include file="../../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncTskSchQrySched" /></div><div class="clear"></div></div></div><div class="fncPanel buttons" ><div class="title"><system:label show="text" label="titActions" /></div><div class="content"><div id="btnConf" class="button suggestedAction" title="<system:label show="tooltip" label="btnCon" />"><system:label show="text" label="btnCon" /></div><div id="btnBack" class="button" title="<system:label show="tooltip" label="btnVol" />" ><system:label show="text" label="btnVol" /></div><div id="btnCloseTab" class="button" title="<system:label show="tooltip" label="btnClose" />"><system:label show="text" label="btnClose" /></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="titTskScheduler" /></div><div class="contentTab" ><div><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtDatTskSch" /></div><div id="schedContainer"><div id="toolsDiv"><div align="center"><div class="schedNavButton" id="btnGoToToday"><system:label show="text" label="lblToday"/></div><div class="schedNavButton" id="btnGoToPrev">&lt;</div><input id="navDate" type="text" style="border: 0px; width: 0px; height: 0px; visibility: hidden;"/><div type="button" class="schedNavButton" id="navBtn"></div><div class="schedNavButton" id="btnGoToNext">&gt;</div></div></div><div id="schedulerDiv"><div id="schedTableContainer"></div></div></div></div></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><!-- MODALS --><%@include file="../../../includes/footer.jsp" %></body></html>

