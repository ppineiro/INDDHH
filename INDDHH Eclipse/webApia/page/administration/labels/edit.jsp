<%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/base/pages/label/main.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/administration/labels/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX 	= '/apia.administration.LabelsAction.run';
		var TT_DEFAULT_LANG  	= '<system:label show="text" label="prmtDefaultLanguage" forScript="true" />';
		var TT_DOWNLOAD_LANG 	= '<system:label show="text" label="btnDow" forScript="true" />';
		var TIT_DOWNLOAD		= '<system:label show="text" label="titLblDown" forScript="true" />'; 
	</script></head><body><div id="exec-blocker"></div><div class="body" id="bodyDiv"><form id="frmData"><input type="hidden" id="defaultLang" name="defaultLang" value=""><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="mnuEti" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmEti"/></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="tabBusClaGen" /></div><div class="contentTab"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtDatEti" /></div><div class="field fieldTwoFifths required"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:</label><input type="text" name="lblName" id="lblName" maxlength="50" class="validate['required','~validNameLatin']" value="<system:edit show="value" from="theEdition" field="lblSetName"/>"></div><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblDes" />"><system:label show="text" label="lblDes" />:</label><textarea name="lblDesc" id="lblDesc" maxlength="255" cols=80 rows=3><system:edit show="value" from="theEdition" field="lblSetDesc"/></textarea></div><div class="subtitle"><system:label show="text" label="titLen" /></div><div class="modalOptionsContainer" id="languagesContainter"><div class="element" id="addLanguage" data-helper="true"><div class="option optionAdd" data-helper="true"><system:label show="text" label="btnAgr" /></div></div></div></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><%@include file="../../includes/footer.jsp" %></body></html>

