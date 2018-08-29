<%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/administration/customParameters/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX	= '/apia.administration.CustomParametersAction.run';	
		var TYPE_STRING			= '<system:edit show="constant" from="com.dogma.vo.CustomParametersVo" field="CUS_PAR_STRING"/>';		
		var TYPE_INTEGER		= '<system:edit show="constant" from="com.dogma.vo.CustomParametersVo" field="CUS_PAR_INTEGER"/>';
		var TYPE_DATE			= '<system:edit show="constant" from="com.dogma.vo.CustomParametersVo" field="CUS_PAR_DATE"/>';
		var TYPE_BOOL_COMBO		= '<system:edit show="constant" from="com.dogma.vo.CustomParametersVo" field="CUS_PAR_BOOL_CMB"/>';
		var TYPE_CHECKBOX		= '<system:edit show="constant" from="com.dogma.vo.CustomParametersVo" field="CUS_PAR_CHECKBOX"/>';
	</script></head><body><div id="exec-blocker"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="mnuAdmCustParam" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmCustParam"/></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><!-- TAB DATOS GENERALES --><div class="aTab"><div class="tab" id="tabGenData"><system:label show="text" label="tabDatGen" /></div><div class="contentTab" id="contentTabGenData"><div><!--  DATOS GENERALES --><div class="fieldGroup"><div class="field fieldTwoFifths required"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:&nbsp;</label><input type="text" name="parName" id="parName" class="validate['required','~validName']" maxlength="50" value="<system:edit show="value" from="theEdition" field="parName"/>"></div><div class="field fieldTwoFifths required"><label title="<system:label show="tooltip" label="lblLab" />"><system:label show="text" label="lblLab" />:&nbsp;</label><input type="text" name="parLabel" id="parLabel" class="validate['required']" maxlength="255" value="<system:edit show="value" from="theEdition" field="parLabel"/>"></div><div class="field fieldOneFifths fieldLast"><label title="<system:label show="tooltip" label="titPrj" />"><system:label show="text" label="titPrj" />:</label><select name="prjId" id="prjId" ><option></option><system:util show="prepareProjects" saveOn="projects" /><system:edit show="iteration" from="projects" saveOn="project"><system:edit show="saveValue" from="project" field="prjId" saveOn="prjId"/><option value="<system:edit show="value" from="project" field="prjId"/>" <system:edit show="ifValue" from="theEdition" field="prjId" value="with:prjId">selected</system:edit>><system:edit show="value" from="project" field="prjTitle"/></option></system:edit></select></div><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblDes" />"><system:label show="text" label="lblDes" />:&nbsp;</label><textarea name="parDesc" id="parDesc" cols="80" rows="3" maxlength="255"><system:edit show="value" from="theEdition" field="parDesc"/></textarea></div></div><div class="fieldGroup"><div class="field"><label title="<system:label show="tooltip" label="lblTip" />"><system:label show="text" label="lblTip" />:&nbsp;</label><select name="parType" id="parType" onchange="parTypeOnChange(this);"><option value="S" <system:edit show="ifValue" from="theEdition" field="parType" value="S">selected</system:edit>><system:label show="text" label="lblStr" /></option><option value="I" <system:edit show="ifValue" from="theEdition" field="parType" value="I">selected</system:edit>><system:label show="text" label="lblInt" /></option><option value="D" <system:edit show="ifValue" from="theEdition" field="parType" value="D">selected</system:edit>><system:label show="text" label="lblFec" /></option><option value="B" <system:edit show="ifValue" from="theEdition" field="parType" value="B">selected</system:edit>><system:label show="text" label="lblCombobox" /></option><option value="C" <system:edit show="ifValue" from="theEdition" field="parType" value="C">selected</system:edit>><system:label show="text" label="lblCheckbox" /></option></select></div><div class="field" id="fieldValue"><label title="<system:label show="tooltip" label="lblVal" />"><system:label show="text" label="lblVal" />:&nbsp;</label><input name="parValStr" id="parValStr" maxlength="255" cusParType='S' class="validate['~cusParRequired']" value="<system:edit show="value" from="theEdition" field="parValStr"/>" <system:edit show="ifNotValue" from="theEdition" field="parType" value="S">style="display:none;"</system:edit>><input name="parValNum" id="parValNum" cusParType='I' class="validate['~cusParRequired','digit']" value="<system:edit show="value" from="theEdition" field="parValNum"/>" <system:edit show="ifNotValue" from="theEdition" field="parType" value="I">style="display:none;"</system:edit>><input name="parValDte" id="parValDte" type="text" cusParType='D' cusPar_id="parValDte" class='datePicker filterInputDate validate["~cusParRequired","target:parValDte_d"]' value="<system:edit show="value" from="theEdition" field="parValDte"/>" style="width:80%;<system:edit show="ifNotValue" from="theEdition" field="parType" value="D">display:none;</system:edit>"><select name="parValCmb" id="parValCmb" <system:edit show="ifNotValue" from="theEdition" field="parType" value="B">style="display:none;"</system:edit>><option value="true" <system:edit show="ifValue" from="theEdition" field="parValStr" value="true">selected</system:edit>><system:label show="text" label="lblSi" /></option><option value="false" <system:edit show="ifNotValue" from="theEdition" field="parValStr" value="true">selected</system:edit>><system:label show="text" label="lblNo" /></option></select><input name="parValChk" id="parValChk" type="checkbox" <system:edit show="ifValue" from="theEdition" field="parValStr" value="true">checked="checked"</system:edit> style="width:66%;<system:edit show="ifNotValue" from="theEdition" field="parType" value="C">display:none;</system:edit>"></div></div><div class="fieldGroup"><div class="field"><label title="<system:label show="tooltip" label="lblReq" />"><system:label show="text" label="lblReq" />:&nbsp;</label><input name="parFlagRequired" id="parFlagRequired" type="checkbox" onchange="onChangeFlagReq(this);" <system:edit show="ifFlag" from="theEdition" field="0" >checked</system:edit>></div><div class="field"><label title="<system:label show="tooltip" label="lblReadOnly" />"><system:label show="text" label="lblReadOnly" />:&nbsp;</label><input name="parFlagReadonly" id="parFlagReadonly" type="checkbox" <system:edit show="ifFlag" from="theEdition" field="1" >checked</system:edit>></div></div></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><jsp:include page="../../includes/footer.jsp" /></body></html>

