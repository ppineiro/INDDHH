<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/administration/environments/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/images.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/documents.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/users.js"></script><script type="text/javascript" src="<system:util show="context" />/page/generic/documents.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX 	= '/apia.administration.EnvironmentsAction.run';		
	</script></head><body><div id="exec-blocker"></div><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="mnuAmb" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmEnv"/></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="tabDatGen" /></div><div class="contentTab"><div class="fieldGroup"><div class="title"><system:label show="tooltip" label="sbtDatAmb" /></div><div class="field fieldTwoFifths required"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:</label><input type="text" name="envName" id="envName" class="validate['required','~validName']" maxlength="50" value="<system:edit show="value" from="theEdition" field="envName"/>"></div><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblDes" />"><system:label show="text" label="lblDes" />:</label><textarea name="envDesc" id="envDesc" maxlength="255" cols=80 rows=3><system:edit show="value" from="theEdition" field="envDesc"/></textarea></div></div><div class="fieldGroup"><div class="field fieldOneThird required"><label title="<system:label show="tooltip" label="lblEti" />"><system:label show="text" label="lblEti" />:</label><select name="cmbLbl" id="cmbLbl" class="validate['required']" onchange="loadLanguages(this.value)"><option value=""></option><system:util show="prepareLabelSet" saveOn="labels" /><system:edit show="iteration" from="labels" saveOn="label"><option value="<system:edit show="value" from="label" field="lblSetId"/>"><system:edit show="value" from="label" field="lblSetName"/></option></system:edit></select></div><div class="field fieldOneThird required"><label title="<system:label show="tooltip" label="lblLen" />"><system:label show="text" label="lblLen" />:</label><select name="cmbLang" id="cmbLang" class="validate['required']"></select></div></div><div class="fieldGroup"><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblPubRSSEnv" />" class="label"><system:label show="text" label="lblPubRSSEnv" />:&nbsp;</label><input type="checkbox" id="flagPubRSS" name="flagPubRSS" <system:edit show="ifFlag" from="theEdition" field="0">checked</system:edit> /></div></div><div class="fieldGroup"><div class="title"><system:label show="tooltip" label="sbtDoc" /></div><%@include file="../../generic/documents.jsp" %></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><%@include file="../../modals/documents.jsp" %><jsp:include page="../../includes/footer.jsp" /></body></html>

