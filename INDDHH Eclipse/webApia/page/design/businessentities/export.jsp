<system:edit show="ifModalNotLoaded" field="export.jsp"><script type="text/javascript">
		var TT_FORMS 		= '<system:label show="tooltip" label="titRecAllAtts" forScript="true" />';
		var MSG_NOT_CONFIRM	= '<system:label show="text" label="msgEntExpMisData" forScript="true" />';
	</script><script type="text/javascript" src="<system:util show="context" />/page/modals/attributes.js"></script><system:edit show="markModalAsLoaded" field="export.jsp" /><div id="mdlExportContainer" class="mdlContainer hiddenModal"><div class="mdlHeader"><system:label show="text" label="titExport" /></div><form id="frmModalExport" target="frmModalExport" enctype="multipart/form-data" method="post"><div class="mdlBody"><table><tbody><!-- Format --><tr><td class="text"><system:label show="text" label="lblExpTo" /></td><td class="content"><input type="radio" id="type1" name="exportType" value="1" checked="checked"><system:label show="text" label="lblExcel"/></td></tr><tr><td></td><td class="content"><input type="radio" id="type2" name="exportType" value="2"><system:label show="text" label="lblCsv"/></td></tr><tr><td></td><td class="content"><input type="radio" id="type3" name="exportType" value="3"><system:label show="text" label="lblXml"/></td></tr><tr><td colspan="2"><hr style="clear: both;"></td></tr><!-- Forms --><tr><td class="text"><system:label show="text" label="sbtForEnt"/></td></tr><tr><td class="content" colspan="2"><div class="modalOptionsContainer" id="mdlExportFormsContainer"></div></td></tr><tr><td colspan="2"><hr style="clear: both;"></td></tr><!-- Attributes --><tr><td class="text"><system:label show="text" label="sbtAttEntNeg"/></td></tr><tr><td class="content" colspan="2"><div class="modalOptionsContainer" id="mdlExportAttContainer"><span class="option optionAdd" id="mdlExportAddAtt"><system:label show="text" label="btnAgr" /></span></div></td></tr><!--  Languages --><tr><td class="text"><system:label show="text" label="lblLan"/></td></tr><tr><td class="content" colspan="2"><div class="modalOptionsContainer" id="mdlExportLangContainer"><system:util show="prepareLanguages" saveOn="languages" /><system:util show="prepareUserLanguage" saveOn="usrLanguage" /><select id="selectedLanguage" name="selectedLanguage"><option value="0"></option><system:edit show="iteration" from="languages" saveOn="language"><option value="<system:edit show="value" from="language" field="langId" />"><system:edit show="value" from="language" field="langName" /></option></system:edit></select></div></td></tr><tr><td colspan="2"><hr style="clear: both;"></td></tr><!--  Visibilities, Categories & Associations  --><tr><td colspan="2"><input type="checkbox" id="chkVis" name="chkVis"><system:label show="text" label="sbtEjeEntVis" /></td></tr><tr><td colspan="2"><input type="checkbox" id="chkCat" name="chkCat"><system:label show="text" label="sbtEjeEntCat" /></td></tr><tr><td colspan="2"><input type="checkbox" id="chkAsoc" name="chkAsoc"><system:label show="text" label="sbtEjeEntAsoc" /></td></tr></tbody></table></div><div class="mdlFooter"><div class="modalButton" id="btnConfirmExportModal" title="<system:label show="text" label="btnCon" />"><system:label show="text" label="btnCon" /></div><div class="close" id="btnCloseExportModal" title="<system:label show="text" label="btnCer" />"><system:label show="text" label="btnCer" /></div></div></form></div><!-- MODALS --><%@include file="../../modals/attributes.jsp" %></system:edit>
	
