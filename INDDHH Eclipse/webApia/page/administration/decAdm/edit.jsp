<%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/administration/decAdm/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/environments.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/profiles.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/users.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/orgRoles.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/styles.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.administration.DecentralizedAdministrationAction.run';
		var isAllEnvs = <system:edit show="ifFlag" from="theEdition" field="2">true</system:edit><system:edit show="ifNotFlag" from="theEdition" field="2">false</system:edit>;
		var isCreate = <system:edit show="ifValue" from="theBean" field="modeCreate" value="true">true</system:edit><system:edit show="ifValue" from="theBean" field="modeCreate" value="false">false</system:edit>;
		var currentEnvId = "<system:edit show="value" from="theBean" field="currentEnvironmentId"/>";
		var currentEnvName = '<system:util show="currentEnvironmentName" />';
		var isGlobal = <system:edit show="ifValue" from="theBean" field="modeGlobal" value="true">true</system:edit><system:edit show="ifValue" from="theBean" field="modeGlobal" value="false">false</system:edit>;
		var LBL_ALL_ENVS = '<system:label show="text" label="lblTodAmb" forScript="true" />';
		var LBL_REG_EXP_FAIL = '<system:label show="text" label="msgInvRegExpPwd" forScript="true" />';
		var LBL_DEFAULT_STYLE = '<system:label show="text" label="lblUsrStyleDef" forScript="true" />';		
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;
		var PWD_REG_EXP = "<system:edit show="constant" from="com.dogma.Parameters" field="PWD_REG_EXP"/>";
		var AUTH_METHOD = "<system:edit show="constant" from="com.dogma.Parameters" field="AUTHENTICATION_METHOD"/>";	
		var LDAP_METHOD = "<system:edit show="constant" from="com.dogma.Parameters" field="AUTHENTICATION_LDAP"/>";
		var AUTH_FULL = "<system:edit show="constant" from="com.dogma.Parameters" field="AUTHENTICATION_FULL"/>";
		var LBL_MODIFY_PWD = '<system:label show="text" label="lblModPwd" forScript="true" forHtml="true"/>';
		
	</script></head><body><div id="exec-blocker"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="mnuDecAdm" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><system:edit show="ifValue" from="theBean" field="modeGlobal" value="true"><div id="fncDescriptionText"><system:label show="text" label="dscFncDecAdm" /></div></system:edit><!-- ENVIRONMENT --><system:edit show="ifValue" from="theBean" field="modeGlobal" value="false"><div id="fncDescriptionText"><system:label show="text" label="dscFncDecAdm" /></div></system:edit><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><div id="divAdminActEdit" class="fncPanel buttons"><div class="title"><system:label show="text" label="mnuOpc"/></div><div class="content"><div id="optionDeleteDateLastLogin" class="button" title="<system:label show="tooltip" label="btnRes"/>"><system:label show="text" label="btnRes"/></div><div id="optionUploadImage" class="button" title="<system:label show="tooltip" label="btnUploadUsrImage"/>"><system:label show="text" label="btnUploadUsrImage"/></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="tabDatGen" /></div><div class="contentTab"><div class="fieldGroup"><div class="field fieldOneThird required"><label title="<system:label show="tooltip" label="lblLog" />"><system:label show="text" label="lblLog" />:</label><input maxlength="20" type="text" name="usrLogin" id="usrLogin" class="validate['required','~validName'] <system:edit show="ifValue" from="theBean" field="modeCreate" value="false">readonly</system:edit>" value="<system:edit show="value" from="theEdition" field="usrLogin"/>" <system:edit show="ifValue" from="theBean" field="modeCreate" value="false">readonly</system:edit> ><img id="imgSearchExt" class="hidden" src="<system:util show="context" />/css/base/img/btnQuery.gif"></div><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblPwd" />"><system:label show="text" label="lblPwd" />:</label><input type="password" name="usrPwd" id="password" regExp="<c:out value="${passwordRegExp}"/>" regExpMessage="mensaje de exp regular" title="<system:label show="text" label="lblPwd" />"></div><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblConPwd" />"><system:label show="text" label="lblConPwd" />:</label><input type="password" name="passwordConf" id="passwordConf"></div></div><div class="fieldGroup"><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblAltLogin" />"><system:label show="text" label="lblAltLogin" />:</label><input maxlength="255" size="255" type="text" name="usrLongLogin" id="usrLongLogin" value="<system:edit show="value" from="theEdition" field="usrLongLogin"/>" ></div></div><div class="fieldGroup"><div class="field fieldOneThird required"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:</label><input type="text" name="usrName" id="usrName" class="validate['required']" value="<system:edit show="value" from="theEdition" field="usrName"/>"></div><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblEma" />"><system:label show="text" label="lblEma" />:</label><input type="text" name="usrEmail" id="usrEmail" class="validate['email']" value="<system:edit show="value" from="theEdition" field="usrEmail"/>"></div><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblLastLogin" />"><system:label show="text" label="lblLastLogin" />:</label><input type="text" name="usrLastLogin" id="usrLastLogin" value="<system:edit show="value" from="theEdition" field="usrLastUsrLogin"/>" readonly="true" class="readonly"><input type="hidden" name="chkResetLastLogin" id="chkResetLastLogin"></div></div><div class="fieldGroup"><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblCom" />"><system:label show="text" label="lblCom" />:</label><textarea name="usrComments" id="usrComments" cols=80 rows=3><system:edit show="value" from="theEdition" field="usrComments"/></textarea></div></div><div class="fieldGroup"><div class="field extendedSize"><label title="<system:label show="tooltip" label="lblCertId" />"><system:label show="text" label="lblCertId" />:</label><input type="text" name="usrCertId" id="usrCertId" value="<system:edit show="value" from="theEdition" field="usrCertId"/>"></div></div><div class="fieldGroup"><div class="field "><label class="label" title="<system:label show="tooltip" label="lblNotAct" />"><system:label show="text" label="lblNotAct" />:</label><input type="checkbox" name="usrNotAct" id="usrNotAct" <system:edit show="ifFlag" from="theEdition" field="1"> checked </system:edit><system:edit show="ifFlag" from="theEdition" field="9"> checked </system:edit>></div><div class="field fieldTwoFifths" id="divUsrDescBlock"><label title="<system:label show="tooltip" label="lblDescNotAct" />"><system:label show="text" label="lblDescNotAct" />:</label><input type="text" name="usrDescBlock" id="usrDescBlock" value="<system:edit show="value" from="theEdition" field="usrBlockDesc"/>" <system:edit show="ifNotFlag" from="theEdition" field="1"> class="readonly" </system:edit>></div></div><div class="fieldGroup"><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblPubRSSUsr" />" class="label"><system:label show="text" label="lblPubRSSUsr" />:&nbsp;</label><input type="checkbox" id="flagPubRSS" name="flagPubRSS" <system:edit show="ifFlag" from="theEdition" field="6">checked</system:edit> /></div></div><div class="fieldGroup"><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblUsrAvoidChatAcc" />" class="label"><system:label show="text" label="lblUsrAvoidChatAcc" />:&nbsp;</label><input type="checkbox" id="flagAvoidChatAccess" name="flagAvoidChatAccess" <system:edit show="ifFlag" from="theEdition" field="7">checked</system:edit> /></div></div><div class="fieldGroup"><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="prpImg" />" class="label"><system:label show="text" label="prpImg" />:&nbsp;</label><img id="imgUsrImage"  height="24" width="24"></div></div></div></div><div class="aTab"><div class="tab"><system:label show="text" label="tabSecurity" /></div><div class="contentTab"><div class="fieldGroup"><div class="field fieldFull"><div class="subtitle"><system:label show="text" label="sbtOrgRole" /></div><div class="modalOptionsContainer" id="orgRolesContainter" data-helper="true"><div class="element" id="addOrgRole"><div class="option optionAdd"><system:label show="text" label="btnAgr" /></div></div></div><div class="clear"></div></div><br/><br/><system:edit show="ifValue" from="theBean" field="modeGlobal" value="true"><div class="field fieldFull"><div class="subtitle"><system:label show="text" label="sbtUsuEnv" /></div><div class="modalOptionsContainer" id="environmentsContainter"><div class="element" id="addEnvironment" data-helper="true"><div class="option optionAdd"><system:label show="text" label="btnAgr" /></div></div></div><div class="clear"></div></div><br/><br/></system:edit><div class="field fieldFull" style="display: none;"><div class="subtitle"><system:label show="text" label="sbtUsuPoo" /></div><div class="modalOptionsContainer" id="poolsContainter"></div><div class="clear"></div></div><div class="field fieldFull"><div class="subtitle"><system:label show="text" label="sbtUsuHiePoo" /></div><div class="modalOptionsContainer" id="hiePoolsContainter"><div class="element" id="addHiePool" data-helper="true"><div class="option optionAdd"><system:label show="text" label="btnAgr" /></div></div></div><div class="clear"></div></div><br/><br/><div class="field fieldFull" style="display: none;"><div class="subtitle"><system:label show="text" label="sbtUsuPrf" /></div><div class="modalOptionsContainer" id="profilesContainter" data-helper="true"></div><div class="clear"></div></div></div></div></div><div class="aTab"><div class="tab"><system:label show="text" label="mnuOpc" /></div><div class="contentTab"><div class="fieldGroup"><div class="field fieldFull"><div class="field full-width"><label title="<system:label show="tooltip" label="lblResPwd" />"><system:label show="text" label="lblResPwd" />:</label><input type="checkbox" name="usrResetPwd" id="usrResetPwd" <system:edit show="ifFlag" from="theEdition" field="3"> checked </system:edit>></div><div class="field full-width"><label title="<system:label show="tooltip" label="lblPwdNevExp" />"><system:label show="text" label="lblPwdNevExp" />:</label><input type="checkbox" name="usrPwdNevExp" id="usrPwdNevExp" <system:edit show="ifFlag" from="theEdition" field="4"> checked </system:edit>></div><div class="field full-width"><label title="<system:label show="tooltip" label="lblWSUser" />"><system:label show="text" label="lblWSUser" />:</label><input type="checkbox" name="usrWS" id="usrWS" <system:edit show="ifFlag" from="theEdition" field="5"> checked </system:edit>></div><div class="clear"></div></div><br/><br/><div class="field fieldFull"><div class="subtitle"><system:label show="text" label="sbtUsuSty" /></div><div class="modalOptionsContainer" id="envStylesContainter" data-helper="true"><div class="element" id="addEnvUsrStyle"><div class="option optionAdd"><system:label show="text" label="btnAgr" /></div></div></div><div class="clear"></div></div><select id="usrStyles" style="display:none;"><system:util show="prepareStyles" saveOn="styles" /><system:edit show="iteration" from="styles" saveOn="style"><system:edit show="saveValue" from="style" field="styleName" saveOn="styleName"/><option value="<system:edit show="value" from="style" field="styleName"/>" <system:edit show="ifValue" from="theEdition" field="usrStyle" value="with:styleName">selected</system:edit>><system:edit show="value" from="style" field="styleName"/></option></system:edit></select></div></div></div><div class="aTab"><div class="tab"><system:label show="text" label="sbtSimData" /></div><div class="contentTab"><div class="fieldGroup"><div class="field"><label title="<system:label show="tooltip" label="lblSimPoolType" />"><system:label show="text" label="lblSimPoolType" />:</label><input type="hidden" name="usrSimPoolType" id="usrSimPoolType" value="<system:edit show="constant" from="com.dogma.vo.PoolVo" field="SIM_TYPE_HUMAN"/>"><input type="text" id="usrSimPoolTypeText" class="disabled readonly" value="<system:label show="text" label="lblSimPoolTypeH" />"></div><div class="field"><label title="<system:label show="tooltip" label="lblSimPoolCal" />"><system:label show="text" label="lblSimPoolCal" />:</label><select name="usrSimCal" id="usrSimCal"><option></option><system:util show="prepareCalendars" saveOn="calendars" /><system:edit show="iteration" from="calendars" saveOn="calendar"><system:edit show="saveValue" from="calendar" field="calendarId" saveOn="calId"/><option value="<system:edit show="value" from="calendar" field="calendarId"/>" <system:edit show="ifValue" from="theEdition" field="autoPoolVo.poolSimCalId" value="with:calId">selected</system:edit> ><system:edit show="value" from="calendar" field="calendarName"/></option></system:edit></select></div><div class="field"><label title="<system:label show="tooltip" label="lblSimPoolCostH" />"><system:label show="text" label="lblSimPoolCostH" />:</label><input type="text" name="usrSimPoolCostH" id="usrSimPoolCostH"  ></div><div class="field"><label title="<system:label show="tooltip" label="lblSimPoolCostF" />"><system:label show="text" label="lblSimPoolCostF" />:</label><input type="text" name="usrSimPoolCostF" id="usrSimPoolCostF"  ></div></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><!-- MODALS --><%@include file="../../modals/users.jsp" %><%@include file="../../modals/environments.jsp" %><%@include file="../../modals/pools.jsp" %><%@include file="../../modals/profiles.jsp" %><%@include file="../../modals/orgRoles.jsp" %><%@include file="../../modals/styles.jsp" %><%@include file="../../includes/footer.jsp" %></body></html>

