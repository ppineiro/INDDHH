<%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/administration/scheduler/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX 		= '/apia.administration.SchedulerAction.run';
		var TIME_SEPARATOR			= '<system:edit show="value" from="theBean" field="timeSeparator"/>';
		var MODE_CREATE				= toBoolean('<system:edit show="value" from="theBean" field="modeCreate"/>');
		var MSG_ERROR_DATE			= '<system:label show="tooltip" label="msgIniBefEnd" forScript="true" />';
		var NO_PARAM				= '<system:label show="text" label="lblBusClaNoPar" forScript="true" />';
		var NO_PARAM_TT				= '<system:label show="tooltip" label="lblBusClaNoPar" forScript="true" />';
		var VALID_HR				= '<system:label show="text" label="lblValidHr" forScript="true" />';
		
		var NOTIF_MAIL				= '<system:label show="text" label="sbtSchNotEmail" forScript="true" />';
		var NOTIF_MSG				= '<system:label show="text" label="sbtSchNotMsg" forScript="true" />';
		var MSG_REM_POOLS			= '<system:label show="text" label="msgRemovePools" forScript="true" />';
		var MSG_MUST_BE_ADD_POOLS	= '<system:label show="text" label="msgMustBeAddPool" forScript="true" />';
		var PRIMARY_SEPARATOR		= new Element('div').set('html', '<system:edit show="constant" from="com.st.util.StringUtil" field="PRIMARY_SEPARATOR"/>').get('text');
	</script></head><body><div id="exec-blocker"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="mnuSchAmb" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncSch"/></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><system:edit show="ifValue" from="theBean" field="modeCreate" value="false"><div class="fncPanel options"><div class="title"><system:label show="text" label="lblAddInfo"/></div><div class="content"><div><span><b><system:label show="text" label="lblUltEje"/>:</b></span><system:edit show="value" from="theEdition" field="lastExecution"/></div><div class="clear"></div><div><span><b><system:label show="text" label="lblSta"/>:</b></span><system:edit show="value" from="theEdition" field="lblStatus"/></div></div><div class="clear"></div></div></system:edit><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="tabDatGen" /></div><div class="contentTab"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtDatSch" /></div><!-- INIT: NAME --><!-- Create --><system:edit show="ifValue" from="theBean" field="modeCreate" value="true"><div class="field extendedSize required"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:</label><input type="text" name="schName" id="schName" class="validate['required','~validName']" maxlength="50" value="<system:edit show="value" from="theEdition" field="schName"/>"></div></system:edit><!-- Update --><system:edit show="ifValue" from="theBean" field="modeCreate" value="false"><div class="field fieldHalfMdl"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:</label><br><system:edit show="value" from="theEdition" field="schName"/></div></system:edit><!-- End: NAME --><!-- INIT: BUS CLASS --><!-- Create --><system:edit show="ifValue" from="theBean" field="modeCreate" value="true"><div class="field extendedSize required"><label title="<system:label show="tooltip" label="lblCla" />"><system:label show="text" label="lblCla" />:</label><select name="schBusClass" id="schBusClass" onchange="loadParameters(this);" ><option></option><system:util show="prepareSchBusClasses" saveOn="busClasses" /><system:edit show="iteration" from="busClasses" saveOn="busClass"><option value="<system:edit show="value" from="busClass" field="value"/>"><system:edit show="value" from="busClass" field="name"/></option></system:edit></select></div></system:edit><!-- Update --><system:edit show="ifValue" from="theBean" field="modeCreate" value="false"><div class="field fieldHalfMdl"><label title="<system:label show="tooltip" label="lblCla" />"><system:label show="text" label="lblCla" />:</label><br><system:edit show="value" from="theBean" field="busClaName"/><input type="hidden" id="schBusClass" value="<system:edit show="value" from="theEdition" field="busClaId"/>"></div></system:edit><!-- END: BUS CLASS --></div><div class="fieldGroup"><div class="field extendedSize required"><label title="<system:label show="tooltip" label="lblPeri" />"><system:label show="text" label="lblPeri" />:</label><select name="schPeriodicity" id="schPeriodicity" onchange="afterOtherSch(this);" class="validate['required']"><option></option><system:util show="prepareSchPeriodicities" saveOn="periodicities" /><system:edit show="iteration" from="periodicities" saveOn="periodicity"><system:edit show="saveValue" from="periodicity" field="value" saveOn="value"/><option value="<system:edit show="value" from="periodicity" field="value"/>"<system:edit show="ifValue" from="theEdition" field="periodicity" value="with:value">selected</system:edit>><system:edit show="value" from="periodicity" field="name"/></option></system:edit></select></div><div class="field extendedSize required" style="display: none" id="divSchPerAfterSch"><label title="<system:label show="tooltip" label="lblSchAfterSchSel" />"><system:label show="text" label="lblSchAfterSchSel" />:</label><select name="schPerAfterSch" id="schPerAfterSch"><option></option><system:util show="prepareSchedulers" saveOn="schedulers" /><system:edit show="iteration" from="schedulers" saveOn="scheduler"><system:edit show="saveValue" from="scheduler" field="value" saveOn="value"/><option value="<system:edit show="value" from="scheduler" field="value"/>"<system:edit show="ifValue" from="theEdition" field="schAfterSchId" value="with:value">selected</system:edit>><system:edit show="value" from="scheduler" field="name"/></option></system:edit></select></div></div><div class="fieldGroup splitTable"><div class="field required"><label title="<system:label show="tooltip" label="lblFchIni" />"><system:label show="text" label="lblFchIni" />:</label><input type="text" name="schDteStart" id="schDteStart" class="datePickerCustom filterInputDate validate['required']" style="width:120px" value="<system:edit show="value" from="theBean" field="firstExecutionDate"/>"></div><div class="field required"><label title="<system:label show="tooltip" label="lblHorIni" />"><system:label show="text" label="lblHorIni" />:</label><input type="text" name="schHrStart" id="schHrStart" class="validate['required','%hourMinute']" style="width: 35px !important;" maxlength="5" size="10px" value="<system:edit show="value" from="theBean" field="firstExecutionHrMin"/>"></div></div><div class="fieldGroup splitTable"><div class="field"><label title="<system:label show="tooltip" label="lblFchFin" />"><system:label show="text" label="lblFchFin" />:</label><input type="text" name="schDteEnd" id="schDteEnd" class="datePickerCustom filterInputDate" style="width:120px" value="<system:edit show="value" from="theBean" field="endExecutionDate"/>"></div><div class="field"><label title="<system:label show="tooltip" label="lblHorFin" />"><system:label show="text" label="lblHorFin" />:</label><input type="text" name="schHrEnd" id="schHrEnd" maxlength="5" class="validate['%hourMinute']" style="width: 35px !important;" value="<system:edit show="value" from="theBean" field="endExecutionHrMin"/>"></div></div><div class="clear"></div><div class="fieldGroup"><div class="field"><label title="<system:label show="tooltip" label="lblExeNode" />"><system:label show="text" label="lblExeNode" />:</label><select name="schNode" id="schNode" onchange="changeNode(this);"><system:util show="prepareSchNodes" saveOn="nodes" /><system:edit show="iteration" from="nodes" saveOn="node"><option value="<system:edit show="value" from="node" field="value"/>" <system:edit show="ifValue" from="theEdition" field="nodeValue" value="with:value">selected</system:edit>><system:edit show="value" from="node" field="name"/></option></system:edit></select></div><div class="field required" id="divSchNodeName" style="display: none;"><label title="<system:label show="tooltip" label="lblSpecNode" />"><system:label show="text" label="lblSpecNode" />:</label><input type="text" name="schNodeName" id="schNodeName" value="<system:edit show="value" from="theEdition" field="nodeName"/>"></div></div><div class="fieldGroup"><div class="field extendedSize"><label title="<system:label show="text" label="lblCurrentNode" />"><system:label show="text" label="lblCurrentNode" />: </label><br><system:edit show="constant" from="com.dogma.Configuration" field="NODE_NAME"/></div></div><div class="clear"></div><div class="fieldGroup" id="divParams" style="visibility: hidden;"><div class="title"><system:label show="text" label="sbtDatPar" /></div><div class="modalOptionsContainer" id="parametersContainter"></div><input type="hidden" name="strParameters" id="strParameters" value=""><div class="clear"></div></div></div></div><div class="aTab"><div class="tab"><system:label show="text" label="tabSchOnError" /></div><div class="contentTab"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtDatSch" /></div></div><div class="fieldGroup splitOneThird"><div class="field inOneLine"><label title="<system:label show="tooltip" label="lblSchOnErrorDis" />"><system:label show="text" label="lblSchOnErrorDis" />:</label><input type="checkbox" name="schErrDis" id="schErrDis" value="<system:edit show="value" from="theEdition" field="flagErrorDisabled"/>" onclick="chkValue(this);"></div></div><div class="clear"></div><div class="fieldGroup split"><div class="title"><system:label show="text" label="lblProNotMail" /></div><div class="field"><label title="<system:label show="tooltip" label="lblSchSendNotEmail" />" ><system:label show="text" label="lblSchSendNotEmail" />:</label><input type="checkbox" name="schErrSndMail" id="schErrSndMail" value="<system:edit show="value" from="theEdition" field="flagOnErrorSendEmail"/>" onclick="chkValue(this,true);"><input type="hidden" name="strPoolsMail" id="strPoolsMail" value=""></div><div class="modalOptionsContainer" id="mailPoolContainter"><div class="element" id="addPoolMail" data-helper="true"><div class="option optionAdd" title="<system:label show="tooltip" label="btnAgrGru"/>"><system:label show="text" label="btnAgr" /></div></div></div><div class="clear"></div></div><div class="fieldGroup split"><div class="title"><system:label show="text" label="lblProNotMes" /></div><div class="field"><label title="<system:label show="tooltip" label="lblSchSendNotMsg" />" ><system:label show="text" label="lblSchSendNotMsg" />:</label><input type="checkbox" name="schErrSndMsg" id="schErrSndMsg" value="<system:edit show="value" from="theEdition" field="flagOnErrorCreateMsg"/>" onclick="chkValue(this,false);"><input type="hidden" name="strPoolsMsg" id="strPoolsMsg" value=""></div><div class="modalOptionsContainer" id="msgPoolContainter"><div class="element" id="addPoolMsg" data-helper="true"><div class="option optionAdd" title="<system:label show="tooltip" label="btnAgrGru"/>"><system:label show="text" label="btnAgr" /></div></div></div><div class="clear"></div></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div><!-- MODALS --><%@include file="../../modals/pools.jsp" %></form></div><%@include file="../../includes/footer.jsp" %></body></html>

