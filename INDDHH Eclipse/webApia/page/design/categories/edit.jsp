<%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/design/categories/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/environments.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/profiles.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.design.CategoryAction.run';	
		var isAllEnvs = "true";
		var isGlobal = "true";
		var LBL_ALL_ENVS = '<system:label show="text" label="lblTodAmb" forScript="true" />';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = true;
		var msgExpRegFail			= '<system:label show="text" label="msgExpRegFal" forScript="true" />';
		var msgExpRegOk			= '<system:label show="text" label="msgExpRegOk" forScript="true" />';		
		var MSG_USE_PROY_PERMS = '<system:label show="text" label="msgUseProyPerms" forScript="true" />';
		var MSG_PERM_WILL_BE_LOST = '<system:label show="text" label="msgPermDefWillBeLost" forScript="true" />';
		
		var DATE_MASK	= "<system:edit show="value" from="theBean" field="dateMsk" avoidHtmlConvert="true"/>";
		var DATA_USED = "<system:edit show="value" from="theBean" field="dataUsed" avoidHtmlConvert="true"/>";
		var DATA_USED_QUERY = "<system:edit show="value" from="theBean" field="dataQueryUsed" avoidHtmlConvert="true"/>";
		var MSG_ERR_LENGTH = '<system:label show="text" label="msgMaxPer" forScript="true" />';
		var MSG_ERR_SMALLER_SIZE = '<system:label show="text" label="msgBigThan" forScript="true" />';
	</script></head><body><div id="exec-blocker"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="mnuCat" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmCat"/></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="tabDatGen" /></div><div class="contentTab"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtDat" /></div><div class="field required fieldTwoFifths"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:</label><input type="text" name="catName" id="catName" maxlength="50" class="validate['required','~validName']"  value="<system:edit show="value" from="theEdition" field="catName"/>"></div><div class="field required fieldTwoFifths"><label title="<system:label show="tooltip" label="lblTit" />"><system:label show="text" label="lblTit" />:</label><input type="text" name="catTitle" id="catTitle" maxlength="50" class="validate['required']"  value="<system:edit show="value" from="theEdition" field="catTitle"/>"></div><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblDes" />"><system:label show="text" label="lblDes" />:</label><textarea name="catDesc" id="catDesc" maxlength="255" cols=80 rows=3><system:edit show="value" from="theEdition" field="catDescription"/></textarea></div><div class="field fieldTwoFifths fieldLast"><label title="<system:label show="tooltip" label="lblUrl" />"><system:label show="text" label="lblUrl" />:</label><input type="text" name="catUrl" id="catUrl" value="<system:edit show="value" from="theEdition" field="catUrl"/>"></div><br><div class="field fieldTwoFifths"><label title="<system:label show="tooltip" label="lblPad" />"><system:label show="text" label="lblPad" />:</label><select name="catFather" id="catFather" ><option></option><system:util show="prepareCategories" saveOn="categories" /><system:edit show="iteration" from="categories" saveOn="category"><system:edit show="saveValue" from="category" field="catId" saveOn="catId"/><option value="<system:edit show="value" from="category" field="catId"/>" <system:edit show="ifValue" from="theEdition" field="catIdFather" value="with:catId">selected</system:edit>><system:edit show="value" from="category" field="catName"/></option></system:edit></select></div><div class="field required fieldOneFifths fieldLast"><label title="<system:label show="tooltip" label="lblOrd" />"><system:label show="text" label="lblOrd" />:</label><input type="number" min="0" name="catOrder" id="catOrder" maxlength="20" class="validate['required','~validName']"  value="<system:edit show="value" from="theEdition" field="catOrder"/>"></div></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><%@include file="../../includes/footer.jsp" %></body></html>

