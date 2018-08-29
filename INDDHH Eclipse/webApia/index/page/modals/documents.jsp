<script type="text/javascript">
	var DEFAULT_DOC_TYPE_ID = '<system:edit show="constant" from="com.dogma.vo.DocTypeVo" field="DEFAULT_DOC_TYPE_ID"/>';
	var MSG_METADATA_TITLE_UNIQUE = '<system:label show="text" label="msgDocMetaUniq" forScript="true" />';
	var MSG_NO_UP_DOC_TYPE_DIS = '<system:label show="text" label="msgNoUpDocTypeDis" forScript="true" />';
	var MSG_NO_EXI_DOC_TYPE_ENA_AND_PER = '<system:label show="text" label="msgNoExiDocTypeEnaAndPer" forScript="true" />';
	var PRIMARY_SEPARATOR		= new Element('div').set('html', '<system:edit show="constant" from="com.st.util.StringUtil" field="PRIMARY_SEPARATOR"/>').get('text');
</script><system:edit show="ifModalNotLoaded" field="documents.jsp"><system:edit show="markModalAsLoaded" field="documents.jsp" /><div id="mdlDocumentContainer" class="mdlContainer hiddenModal"><div class="mdlHeader"><system:label show="text" label="titDoc" /></div><iframe style="display:none;" id="documentIframeUpload" name="documentIframeUpload"></iframe><form id="frmModalDocumentUpload" target="documentIframeUpload" enctype="multipart/form-data" method="post"><div class="mdlBody"><table><tbody><tr><td class="text"><system:label show="text" label="lblDocType" />:&nbsp;</td><td class="content"><select id="cmbDocType" name="cmbDocType" style="width: 100% !important;" class="validate['required']"></select><span id="spanDocType" style="display: none;"></span></td></tr><tr><td class="text"><system:label show="text" label="lblNueDoc" />:</td><td class="content"><input type="file" name="docFile" id="documentModalDocFile" size="40" maxlength="255" class="validate['required']"></td></tr><tr><td colspan="2"><div class="progressBarContainer" id="documentProgressBarContainer"><div class="progressBar" id="documentProgressBar"></div></div><div id="documentProgressMessages"></div></td></tr><tr><td class="text"><system:label show="text" label="lblDesc" />:</td><td class="content"><textarea name="docDesc" id="documentModalDocDesc" style="width: 350px"></textarea></td></tr><tr id="permission"><td class="text"><system:label show="text" label="sbtPerAccDoc" />:</td><td class="content"><div class="modalOptionsContainer" id="mdlDocumentPoolContainter"><span class="option" canDelete="false"><system:label show="text" label="lblTod" />: <select name="docAllowAllType" id="selDocAllPoolPerm"><option value="M" selected><system:label show="text" label="lblPerMod" /></option><option value="R"><system:label show="text" label="lblPerVer" /></option><option value=""></option></select></span><hr id="mdlDocumentPoolContainterDivider" style="clear: both;"><span class="option optionAdd" id="mdlDocumentAddPool" canDelete="false"><system:label show="text" label="btnAgrGru" /></span><span class="option optionAdd" id="mdlDocumentAddUser" canDelete="false"><system:label show="text" label="btnAgrUsu" /></span></div></td></tr></tbody></table><br><br><!-- METADATA --><div class="fieldGroup" id="metadata"><div class="title"><system:label show="tooltip" label="titMetadata" /></div><div class="gridContainer" style="margin: 0px;" id="gridMetadata"><div class="gridHeader" style="width: 100%;"><table cellpadding="0" cellspacing="0"><thead><tr class="header"><th title="<system:label show="tooltip" label="lblTit" />" style="width: 50%"><div style="width: 100%"><system:label show="text" label="lblTit" /></div></th><th title="<system:label show="tooltip" label="lblVal" />" style="width: 50%"><div style="width: 100%"><system:label show="text" label="lblVal" /></div></th></tr></thead></table></div><div class="gridBody" style="height: 135px; overflow: hidden !important;"><table cellpadding="0" cellspacing="0"><thead><tr><th width="49%"></th><th width="49%"></th></tr></thead><tbody class="tableData" id="tableMetadata"></tbody></table></div><div class="gridFooter listActionButtons" style="margin-top: 0px;"><div class="listAddDel" id="buttonsMetadata" ><div class="actSeparator">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class="btnAdd navButton" id="btnAddMeta" style="margin-top: 5px;"><system:label show="text" label="btnAgr" /></div><div class="actSeparator">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class="btnDelete navButton" id="btnDeleteMeta" style="margin-top: 5px;"><system:label show="text" label="btnEli" /></div></div></div></div></div></div><div class="mdlFooter"><div class="close" id="btnCloseDocumentModal"><system:label show="text" label="btnCer" /></div><div class="modalButton" id="btnConfirmDocumentModal"><system:label show="text" label="btnCon" /></div></div></form></div><div id="mdlDocumentInfo" class="mdlDocContainer mdlContainer hiddenModal"><div class="mdlHeader"><system:label show="text" label="lblInfo" /></div><div class="mdlBody"><!-- GENERAL INFO --><table class="generalInfo"><tbody ><tr><td class="text"><system:label show="text" label="lblDocType" />:&nbsp;</td><td class="content"><label id="docTypeTitle"></label></td></tr><tr><td class="text"><system:label show="text" label="lblNom" />:&nbsp;</td><td class="content"><label id="lblNom"></label></td></tr><tr><td class="text"><system:label show="text" label="lblDesc" />:&nbsp;</td><td class="content"><label id="docDesc"></label></td></tr></tbody></table><!-- HISTORY --><table class="history"><thead><tr><td><system:label show="text" label="lblVer" /></td><td><system:label show="text" label="lblUsu" /></td><td><system:label show="text" label="lblFecUpl" /></td></tr></thead><tbody id="tblDocHistory"></tbody></table></div><br><br><!-- METADATA --><div class="fieldGroup" id="metadataInfo"><div class="title"><system:label show="tooltip" label="titMetadata" /></div><div class="gridContainer" style="margin: 0px;" id="gridMetadataInfo"><div class="gridHeader"><table cellpadding="0" cellspacing="0"><thead><tr class="header"><th title="<system:label show="tooltip" label="lblTit" />" style="width: 50%"><div style="width: 100%"><system:label show="text" label="lblTit" /></div></th><th title="<system:label show="tooltip" label="lblVal" />" style="width: 50%"><div style="width: 100%"><system:label show="text" label="lblVal" /></div></th></tr></thead></table></div><div class="gridBody" style="height: 135px"><table cellpadding="0" cellspacing="0"><thead><tr><th width="49%"></th><th width="49%"></th></tr></thead><tbody class="tableData" id="tableMetadataInfo"></tbody></table></div><div class="gridFooter listActionButtons"></div></div></div><div class="mdlFooter"><div class="close" id="btnCloseDocumentInfo"><system:label show="text" label="btnCer" /></div></div></div></system:edit><%@include file="pools.jsp" %><%@include file="users.jsp" %>
