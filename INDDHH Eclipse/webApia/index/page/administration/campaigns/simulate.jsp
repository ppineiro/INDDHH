<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/administration/campaigns/simulate.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/environments.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/profiles.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/users.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/profiles.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/processes.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/tasks.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/functionalities.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.administration.CampaignsAction.run';
		var LBL_AND = '<system:label show="text" label="lblAnd" forScript="true" />';
		var LBL_OR = '<system:label show="text" label="lblOr" forScript="true" />';
		var LBL_TRUE = '<system:label show="text" label="lblTrue" forScript="true" />';
		var LBL_FALSE = '<system:label show="text" label="lblFalse" forScript="true" />';
		var ADDITIONAL_INFO_IN_TABLE_DATA = false;
	</script></head><body><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="mnuCmp" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmCmp" /></div><div class="clear"></div></div></div><div id="divAdminActEdit" class="fncPanel buttons"><div class="title"><system:label show="text" label="titOptions"/></div><div class="content"><div id="optionSimulate" class="button suggestedAction"><system:label show="text" label="btnSimulate"/></div><div id="btnBackToList" class="button" title="<system:label show="tooltip" label="btnVol" />"><system:label show="text" label="btnVol" /></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="tabDatGen" /></div><div class="contentTab"><div clasS="fieldGroup"><div class="field fieldHalf"><div class="subtitle"><system:label show="text" label="lblCmpDates" /></div><div class="subtitle"><select name="cmpCondition0" id="cmpCondition0" class="validate['~validateConditionActive']" conditionContainer="datesContainer"><option value="0" ><system:label show="text" label="lblDoNotApply" /></option><option value="1" ><system:label show="text" label="lblAnd" /></option></select></div><div class="modalOptionsContainer hidden" id="datesContainer"><input type="text" class="datePicker notFull" id="dateFrom" format="d/m/Y" size=10></div><div class="clear"></div></div><div class="field fieldHalf fieldLast"><div class="subtitle"><system:label show="text" label="lblCmpTimes" /></div><div class="subtitle"><select name="cmpCondition1" id="cmpCondition1" class="validate['~validateConditionActive']" conditionContainer="timesContainer"><option value="0" ><system:label show="text" label="lblDoNotApply" /></option><option value="1" ><system:label show="text" label="lblAnd" /></option></select></div><div class="modalOptionsContainer hidden" id="timesContainer"><input type="text" class="notFull" id="timeFrom" size=5></div><div class="clear"></div></div></div><div clasS="fieldGroup"><div class="field fieldFull"><div class="subtitle"><system:label show="text" label="sbtCmpWeekDay" /></div><div class="subtitle"><select name="cmpCondition2" id="cmpCondition2" class="validate['~validateConditionActive']" conditionContainer="weekdayContainer"><option value="0" ><system:label show="text" label="lblDoNotApply" /></option><option value="1" ><system:label show="text" label="lblAnd" /></option></select></div><div class="modalOptionsContainer hidden" id="weekdayContainer" helper="true"><div class="option"><system:label show="text" label="lblCmpDateCurrent" /><input type="radio" class="notFull" name="cmpWeekday" value="" checked></div><div class="option"><system:label show="text" label="lblDomingo" /><input type="radio" class="notFull" name="cmpWeekday" value="0" id="cmpWeekDay0"></div><div class="option"><system:label show="text" label="lblLunes" /><input type="radio" class="notFull" name="cmpWeekday" value="1" id="cmpWeekDay1"></div><div class="option"><system:label show="text" label="lblMartes" /><input type="radio" class="notFull" name="cmpWeekday" value="2" id="cmpWeekDay2"></div><div class="option"><system:label show="text" label="lblMiercoles" /><input type="radio" class="notFull" name="cmpWeekday" value="3" id="cmpWeekDay3"></div><div class="option"><system:label show="text" label="lblJueves" /><input type="radio" class="notFull" name="cmpWeekday" value="4" id="cmpWeekDay4"></div><div class="option"><system:label show="text" label="lblViernes" /><input type="radio" class="notFull" name="cmpWeekday" value="5" id="cmpWeekDay5"></div><div class="option"><system:label show="text" label="lblSabado" /><input type="radio" class="notFull" name="cmpWeekday" value="6" id="cmpWeekDay6"></div></div><div class="clear"></div></div></div><div clasS="fieldGroup"><div class="field fieldHalf"><div class="subtitle"><system:label show="text" label="lblCmpIps" /></div><div class="subtitle"><select name="cmpCondition3" id="cmpCondition3" class="validate['~validateConditionActive']" conditionContainer="ipsContainer"><option value="0" ><system:label show="text" label="lblDoNotApply" /></option><option value="1" ><system:label show="text" label="lblAnd" /></option></select></div><div class="modalOptionsContainer hidden" id="ipsContainer"><div class="element" id="addIp" helper="true"><input type="text" id="ipFrom" class=""></div></div><div class="clear"></div></div><div class="field fieldHalf fieldLast"><div class="subtitle"><system:label show="text" label="lblCmpNodes" /></div><div class="subtitle"><select name="cmpCondition4" id="cmpCondition4" class="validate['~validateConditionActive']" conditionContainer="nodesContainer"><option value="0" ><system:label show="text" label="lblDoNotApply" /></option><option value="1" ><system:label show="text" label="lblAnd" /></option></select></div><div class="modalOptionsContainer hidden" id="nodesContainer"><div class="element" id="addNode" helper="true"><input type="text" id="cmpNode"></div></div><div class="clear"></div></div></div><div class="fieldGroup"><div class="field fieldHalf"><div class="subtitle"><system:label show="text" label="sbtCmpUser" /></div><div class="subtitle"><select name="cmpCondition5" id="cmpCondition5" class="validate['~validateConditionActive']" conditionContainer="usersContainer"><option value="0" ><system:label show="text" label="lblDoNotApply" /></option><option value="1" ><system:label show="text" label="lblAnd" /></option></select></div><div class="modalOptionsContainer hidden" id="usersContainer"><div class="option optionAdd" id="addUser" helper="true"><system:label show="text" label="btnAgr" /></div></div><div class="clear"></div></div><div class="field fieldHalf fieldLast"><div class="subtitle"><system:label show="text" label="sbtCmpPool" /></div><div class="subtitle"><select name="cmpCondition6" id="cmpCondition6" class="validate['~validateConditionActive']" conditionContainer="poolsContainer"><option value="0" ><system:label show="text" label="lblDoNotApply" /></option><option value="1" ><system:label show="text" label="lblAnd" /></option></select></div><div class="modalOptionsContainer hidden" id="poolsContainer"><div class="option optionAdd" id="addPool" helper="true"><system:label show="text" label="btnAgr" /></div></div><div class="clear"></div></div></div><div class="fieldGroup"><div class="field fieldHalf"><div class="subtitle"><system:label show="text" label="sbtCmpPrf" /></div><div class="subtitle"><select name="cmpCondition7" id="cmpCondition7" class="validate['~validateConditionActive']" conditionContainer="profilesContainer"><option value="0" ><system:label show="text" label="lblDoNotApply" /></option><option value="1" ><system:label show="text" label="lblAnd" /></option></select></div><div class="modalOptionsContainer hidden" id="profilesContainer"><div class="option optionAdd" id="addProfile" helper="true"><system:label show="text" label="btnAgr" /></div></div><div class="clear"></div></div><div class="field fieldHalf fieldLast"><div class="subtitle"><system:label show="text" label="sbtCmpFunctionality" /></div><div class="subtitle"><select name="cmpCondition8" id="cmpCondition8" class="validate['~validateConditionActive']" conditionContainer="functionalitiesContainer"><option value="0" ><system:label show="text" label="lblDoNotApply" /></option><option value="1" ><system:label show="text" label="lblAnd" /></option></select></div><div class="modalOptionsContainer hidden" id="functionalitiesContainer"><div class="option optionAdd" id="addFunctionality" helper="true"><system:label show="text" label="btnAgr" /></div></div><div class="clear"></div></div></div><div clasS="fieldGroup"><div class="field fieldHalf"><div class="subtitle"><system:label show="text" label="sbtCmpProcces" /></div><div class="subtitle"><select name="cmpCondition9" id="cmpCondition9" class="validate['~validateConditionActive']" conditionContainer="processesContainer"><option value="0" ><system:label show="text" label="lblDoNotApply" /></option><option value="1" ><system:label show="text" label="lblAnd" /></option></select></div><div class="modalOptionsContainer hidden" id="processesContainer"><div class="option optionAdd" id="addProcess" helper="true"><system:label show="text" label="btnAgr" /></div></div><div class="clear"></div></div><div class="field fieldHalf fieldLast"><div class="subtitle"><system:label show="text" label="sbtCmpTask" /></div><div class="subtitle"><select name="cmpCondition10" id="cmpCondition10" class="validate['~validateConditionActive']" conditionContainer="tasksContainer"><option value="0" ><system:label show="text" label="lblDoNotApply" /></option><option value="1" ><system:label show="text" label="lblAnd" /></option></select></div><div class="modalOptionsContainer hidden" id="tasksContainer"><div class="option optionAdd" id="addTask" helper="true"><system:label show="text" label="btnAgr" /></div></div><div class="clear"></div></div></div><div clasS="fieldGroup"><div class="field fieldFull"><div class="subtitle"><system:label show="text" label="sbtCmpModule" /></div><div class="subtitle"><select name="cmpCondition11" id="cmpCondition11" class="validate['~validateConditionActive']" conditionContainer="modulesContainer"><option value="0" ><system:label show="text" label="lblDoNotApply" /></option><option value="1" ><system:label show="text" label="lblAnd" /></option></select></div><div class="modalOptionsContainer hidden" id="modulesContainer" helper="true"><div class="option" ><system:label show="text" label="lblModuleExec" /><input type="radio" class="notFull" name="cmpModule" value="0" id="cmpModule0"></div><div class="option" ><system:label show="text" label="lblModuleAdmin" /><input type="radio" class="notFull" name="cmpModule" value="1" id="cmpModule1"></div><div class="option" ><system:label show="text" label="lblModuleDesg" /><input type="radio" class="notFull" name="cmpModule" value="2" id="cmpModule2"></div><div class="option" ><system:label show="text" label="lblModuleQry" /><input type="radio" class="notFull" name="cmpModule" value="3" id="cmpModule3"></div><div class="option" ><system:label show="text" label="lblModuleBI" /><input type="radio" class="notFull" name="cmpModule" value="4" id="cmpModule4"></div><div class="option" ><system:label show="text" label="lblModuleMont" /><input type="radio" class="notFull" name="cmpModule" value="5" id="cmpModule5"></div><div class="option" ><system:label show="text" label="lblModuleCtrl" /><input type="radio" class="notFull" name="cmpModule" value="6" id="cmpModule6"></div></div><div class="clear"></div></div></div><div class="fieldGroup"><div class="field"><label title="<system:label show="tooltip" label="lblCmpShowInSplash" />"><system:label show="text" label="lblCmpShowInSplash" />:</label><input type="checkbox" name="cmpFlag5" id="cmpFlag5" value="true" <system:edit show="ifFlag" from="theEdition" field="5"> checked </system:edit>></div></div></div></div><div class="aTab"><div class="tab"><system:label show="text" label="tabCmpSimResult" /></div><div class="contentTab"><div clasS="fieldGroup"><div class="field fieldHalf"><div class="subtitle"><system:label show="text" label="sbtCmpSimActive" /></div><div class="modalOptionsContainer" id="campaignsActive"></div></div><div class="field fieldHalf fieldLast"><div class="subtitle"><system:label show="text" label="sbtCmpSimInactive" /></div><div class="modalOptionsContainer" id="campaignsNotActive"></div></div></div><div clasS="fieldGroup"><div class="field fieldHalf"><div class="subtitle"><system:label show="text" label="sbtCmpSimActiveWhy" /></div><div class="modalOptionsContainer" id="campaignsActiveElements"><div id="cmpActiveElement0" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisDate" />: <span id="cmpActiveType0"></span><span id="cmpActive0"></span></div><div id="cmpActiveElement1" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisTime" />: <span id="cmpActiveType1"></span><span id="cmpActive1"></span></div><div id="cmpActiveElement2" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisWeekDay" />: <span id="cmpActiveType2"></span><span id="cmpActive2"></span></div><div id="cmpActiveElement3" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisIp" />: <span id="cmpActiveType3"></span><span id="cmpActive3"></span></div><div id="cmpActiveElement4" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisNode" />: <span id="cmpActiveType4"></span><span id="cmpActive4"></span></div><div id="cmpActiveElement5" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisUser" />: <span id="cmpActiveType5"></span><span id="cmpActive5"></span></div><div id="cmpActiveElement6" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisGroup" />: <span id="cmpActiveType6"></span><span id="cmpActive6"></span></div><div id="cmpActiveElement7" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisProfile" />: <span id="cmpActiveType7"></span><span id="cmpActive7"></span></div><div id="cmpActiveElement8" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisFunctionality" />: <span id="cmpActiveType8"></span><span id="cmpActive8"></span></div><div id="cmpActiveElement9" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisProcess" />: <span id="cmpActiveType9"></span><span id="cmpActive9"></span></div><div id="cmpActiveElement10" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisTask" />: <span id="cmpActiveType10"></span><span id="cmpActive10"></span></div><div id="cmpActiveElement11" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisModule" />: <span id="cmpActiveType11"></span><span id="cmpActive11"></span></div></div></div><div class="field fieldHalf fieldLast"><div class="subtitle"><system:label show="text" label="sbtCmpSimInactiveWhy" /></div><div class="modalOptionsContainer" id="campaignsNotActiveElements"><div id="cmpNotActiveElement0" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisDate" />: <span id="cmpNotActiveType0"></span><span id="cmpNotActive0"></span></div><div id="cmpNotActiveElement1" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisTime" />: <span id="cmpNotActiveType1"></span><span id="cmpNotActive1"></span></div><div id="cmpNotActiveElement2" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisWeekDay" />: <span id="cmpNotActiveType2"></span><span id="cmpNotActive2"></span></div><div id="cmpNotActiveElement3" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisIp" />: <span id="cmpNotActiveType3"></span><span id="cmpNotActive3"></span></div><div id="cmpNotActiveElement4" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisNode" />: <span id="cmpNotActiveType4"></span><span id="cmpNotActive4"></span></div><div id="cmpNotActiveElement5" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisUser" />: <span id="cmpNotActiveType5"></span><span id="cmpNotActive5"></span></div><div id="cmpNotActiveElement6" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisGroup" />: <span id="cmpNotActiveType6"></span><span id="cmpNotActive6"></span></div><div id="cmpNotActiveElement7" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisProfile" />: <span id="cmpNotActiveType7"></span><span id="cmpNotActive7"></span></div><div id="cmpNotActiveElement8" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisFunctionality" />: <span id="cmpNotActiveType8"></span><span id="cmpNotActive8"></span></div><div id="cmpNotActiveElement9" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisProcess" />: <span id="cmpNotActiveType9"></span><span id="cmpNotActive9"></span></div><div id="cmpNotActiveElement10" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisTask" />: <span id="cmpNotActiveType10"></span><span id="cmpNotActive10"></span></div><div id="cmpNotActiveElement11" class="option optionMiddle"><system:label show="text" label="lblCmpSimVisModule" />: <span id="cmpNotActiveType11"></span><span id="cmpNotActive11"></span></div></div></div></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><!-- MODALS --><%@include file="../../modals/users.jsp" %><%@include file="../../modals/pools.jsp" %><%@include file="../../modals/profiles.jsp" %><%@include file="../../modals/processes.jsp" %><%@include file="../../modals/tasks.jsp" %><%@include file="../../modals/functionalities.jsp" %><%@include file="../../includes/footer.jsp" %></body></html>

