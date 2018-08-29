<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/design/forms/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/generic/permissions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/generic/documents.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/documents.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/users.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.design.FormsAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA = false;
		var MSG_USE_PROY_PERMS = '<system:label show="text" label="msgUseProyPerms" forScript="true" />';
		var MSG_PERM_WILL_BE_LOST = '<system:label show="text" label="msgPermDefWillBeLost" forScript="true" />';
		var ATT_TAB_TITLE = '<system:label show="text" label="mnuDicDat" forScript="true" />';
	</script></head><body><div id="exec-blocker"></div><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer" id="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="mnuFor" /><%@include file="../../includes/adminFav.jsp" %></div><div class="hideThisSection" style="border-top: 0px; border-bottom: 0px;"><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmForms" /></div><div class="clear"></div></div></div></div><div class="hideThisSection" style="border-top: 0px;"><%@include file="../../includes/adminActionsEdition.jsp" %><!-- Datos Generales --><div class="fncPanel buttons" id="panelGenData" style="display:none;"><div class="title"><system:label show="tooltip" label="sbtGenData" /></div><div class="content"><span class="infoGenData"><b><system:label show="tooltip" label="lblNom" />:&nbsp;</b></span><span id="dataGenFrmName" class="infoGenData"><system:edit show="value" from="theEdition" field="frmName"/></span><br><span class="infoGenData"><b><system:label show="tooltip" label="docTit" />:&nbsp;</b></span><span id="dataGenFrmTitle" class="infoGenData"><system:edit show="value" from="theEdition" field="frmTitle"/></span><br></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="tabDatGen" /></div><div class="contentTab"><div class="fieldGroup"><div class="field fieldTwoFifths <system:edit show="ifNotExistsValue" from="theEdition" field="frmFather" >required</system:edit>"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:</label><system:edit show="ifExistsValue" from="theEdition" field="frmFather" ><system:edit show="value" from="theEdition" field="frmName" /><input type="hidden" name="txtName" id="txtName" value="<system:edit show="value" from="theEdition" field="frmName" />" /></system:edit><system:edit show="ifNotExistsValue" from="theEdition" field="frmFather" ><input type="text" name="txtName" id="txtName" class="validate['required','~validName']"  value="<system:edit show="value" from="theEdition" field="frmName"/>"></system:edit></div><div class="field fieldTwoFifths <system:edit show="ifNotExistsValue" from="theEdition" field="frmFather" >required</system:edit>"><label title="<system:label show="tooltip" label="lblTit" />"><system:label show="text" label="lblTit" />:</label><system:edit show="ifExistsValue" from="theEdition" field="frmFather" ><system:edit show="value" from="theEdition" field="frmTitle" /><input type="hidden" name="txtTitle" id="txtTitle" value="<system:edit show="value" from="theEdition" field="frmTitle" />" /></system:edit><system:edit show="ifNotExistsValue" from="theEdition" field="frmFather" ><input type="text" name="txtTitle" id="txtTitle" class="validate['required']" value="<system:edit show="value" from="theEdition" field="frmTitle"/>"></system:edit></div><div class="field fieldOneFifths fieldLast"><label title="<system:label show="tooltip" label="titPrj" />"><system:label show="text" label="titPrj" />:</label><input type=hidden name="txtPrj" value=""><system:edit show="ifExistsValue" from="theEdition" field="frmFather" ><system:edit show="value" from="theBean" field="hidPrjId" /><input type="hidden" name="selPrj" value="<system:edit show="value" from="theBean" field="hidPrjId" />" /></system:edit><system:edit show="ifNotExistsValue" from="theEdition" field="frmFather" ><select name="rolProject" id="cmbProject" ><option></option><system:util show="prepareProjects" saveOn="projects" /><system:edit show="iteration" from="projects" saveOn="project"><system:edit show="saveValue" from="project" field="prjId" saveOn="prjId"/><option value="<system:edit show="value" from="project" field="prjId"/>" <system:edit show="ifValue" from="theEdition" field="prjId" value="with:prjId">selected</system:edit>><system:edit show="value" from="project" field="prjName"/></option></system:edit></select></system:edit></div><div class="clearLeft"></div><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblDesc" />"><system:label show="text" label="lblDesc" />:</label><textarea name="txtDesc" id="txtDesc" maxlength="255" cols=80 rows=3><system:edit show="value" from="theEdition" field="frmDesc"/></textarea></div><br/><br/><div class="field"><label title="<system:label show="tooltip" label="lblFrmSign" />"><system:label show="text" label="lblFrmSign" />:</label><select name="cmbSign" id="cmbSign" ><option value="0" <system:edit show="ifNotFlag" from="theEdition" field="0">selected</system:edit>><system:label show="text" label="lblNo" /></option><option value="1" <system:edit show="ifFlag" from="theEdition" field="0">selected</system:edit>><system:label show="text" label="lblSi" /></option><option value="2" <system:edit show="ifFlag" from="theEdition" field="1">selected</system:edit>><system:label show="text" label="lblAllways" /></option></select></div><div class="field" ><label for="chkAllowTranslation" title="Permitir traducción de atributos de entidad" class="label" style="width:auto;">Permitir traducción:&nbsp;</label><br/><input type="checkbox" id="chkAllowTranslation" name="chkAllowTranslation" <system:edit show="ifFlag" from="theEdition" field="3" >checked</system:edit> ></div></div></div></div><div class="aTab flashContainer" style="height: 99%"><div class="tab" id="flashTab"><system:label show="tooltip" label="tabForLay" /></div><div class="contentTab"><div class="fieldFull offscreen" id="fDesignerContainer" class="offscreen" style="width:100%"><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" WIDTH="100%" 	HEIGHT="100%" id="fDesigner"><param name="allowScriptAccess" value="always" /><param name="movie" value="<system:util show="context" />/flash/form_designer2/bin/formdesigner.swf" /><param name="FlashVars" value="tabId=<system:util show="tabId"/>&tokenId=<system:util show="tokenId"/>&onLoaded=flashLoaded&utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&IN_APIA=true&att_url=outline_attributes.jsp&urlBase=<system:util show="context" />/flash/form_designer2/bin/&elementAtts=element_attributes.jsp" /><param name="quality" value="autohigh" /><param name="menu" value="false"/><param name="bgcolor" value="#efefef" /><param name="WMODE" value="transparent" /><param name="salign" value="tl" /><param name="scale" value="noscale" /><embed
										scale="noscale"
										wmode="transparent" 
										menu="false" 
										allowScriptAccess="always" 
										src="<system:util show="context" />/flash/form_designer2/bin/formdesigner.swf" 
										quality="autohigh"
										bgcolor="#efefef" 
										width="100%" 
										height="100%" 
										swLiveConnect="true" 
										id="fDesigner" 
										name="fDesigner" 
										salign="tl"
										type="application/x-shockwave-flash" 
										pluginspage="http://www.macromedia.com/go/getflashplayer" 
										flashVars="tabId=<system:util show="tabId"/>&tokenId=<system:util show="tokenId"/>&onLoaded=flashLoaded&utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&urlBase=<system:util show="context" />/flash/form_designer2/bin/&att_url=outline_attributes.jsp&elementAtts=element_attributes.jsp" /></object><button type="button" onclick="getSWFVersions()" style="display:none">getVersion</button><TEXTAREA name="txtMap" id="txtMap" cols="100" rows="30" style="display:none"><system:edit show="value" from="theEdition" field="generatedXML"/></TEXTAREA></div></div></div><div class="aTab"><div class="tab"><system:label show="tooltip" label="tabDocFor" /></div><div class="contentTab"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtDoc" /></div></div><%@include file="../../generic/documents.jsp" %></div></div><div class="aTab"><div class="tab"><system:label show="text" label="tabClaPer" /></div><div class="contentTab"><%@include file="../../generic/permissions.jsp" %></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><%@include file="../../modals/permissions.jsp" %><%@include file="../../modals/documents.jsp" %><%@include file="../../includes/footer.jsp" %></body></html>

