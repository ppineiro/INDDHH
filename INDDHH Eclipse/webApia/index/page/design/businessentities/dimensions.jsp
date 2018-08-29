<script type="text/javascript" src="<system:util show="context" />/page/modals/entities.js"></script><script type="text/javascript">
	var ATT_LABEL = '<system:label show="text" label="lblAtt" forScript="true" />'+ ': ';
	var FORM_LABEL = '<system:label show="text" label="lblForm" forScript="true" />'+ ': ';
	var PRO_LABEL = '<system:label show="text" label="lblPro" forScript="true" />'+ ': ';
	var SUB_PRO_LABEL = '<system:label show="text" label="lblSubPro" forScript="true" />'+ ': ';
	var TASK_LABEL = '<system:label show="text" label="lblTask" forScript="true" />'+ ': ';
	var DATE_LABEL = '<system:label show="text" label="lblDate" forScript="true" />';
	var NUMERIC_LABEL = '<system:label show="text" label="lblNum" forScript="true" />';
	var STRING_LABEL = '<system:label show="text" label="lblStr" forScript="true" />';
	var OBLIG_LABEL = '<system:label show="text" label="titObligatory" forScript="true" />'+ ': ';
	var MAP_ENTITY_LABEL = '<system:label show="text" label="lblMapEntity" forScript="true" />'+ ': ';
	var LBL_CON = '<system:label show="text" label="btnCon" forScript="true" />';
	var TYPE_LABEL = '<system:label show="text" label="lblTip" forScript="true" />' + ': ';
	var ENT_PRO_FORM_LABEL = '<system:label show="text" label="lblProEntFor" forScript="true" />';	
	var MSG_ALR_EXI_DIM = '<system:label show="text" label="msgAlrExiDim" forScript="true" />';
	var reBIAlphanumeric = /^[a-zA-Z0-9_]*$/;
</script><div id="gridDimensions"><div class="gridHeader"><!-- Cabezal y filtros --><table cellpadding="0" cellspacing="0"><thead><tr class="header"><th title="<system:label show="tooltip" label="lblAtt" />"><div style="width: 140px"><system:label show="text" label="lblAtt" /></div></th><th title="<system:label show="tooltip" label="lblTip" />"><div style="width: 80px"><system:label show="text" label="lblTip" /></div></th><th title="<system:label show="tooltip" label="lblNom" />"><div style="width: 750px"><system:label show="text" label="lblNom" /></div></th></tr></thead></table></div><div class="gridBody" id="gridBodyDimensions"><!-- Cuerpo de la tabla --><table cellpadding="0" cellspacing="0"><thead><tr><th width="140px"></th><th width="80px"></th><th width="750px"></th></tr></thead><tbody class="tableData" id="gridDims"></tbody></table></div><div class="gridFooter"><div class="listActionButtons" id="gridFooter"><div class="listAddDelRight" id="buttonsDim" <system:edit show="ifValue" from="theBean" field="hasCube" value="false" >style='display:none'</system:edit>><div class="btnAdd navButton" id="btnPropDim"><system:label show="text" label="btnProperties" /></div><div class="actSeparator">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class="btnAdd navButton" id="btnAddDim"><system:label show="text" label="btnAgr" /></div><div class="actSeparator">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class="btnDelete navButton" id="btnDeleteDim"><system:label show="text" label="btnEli" /></div><input type="hidden" id="txtHidAttIds" name="txtHidAttIds" value="<system:edit show="value" from="theBean" field="attIdsStr"></system:edit>"></div></div></div></div>