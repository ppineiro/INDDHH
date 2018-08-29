<script type="text/javascript">
	var PNL_PARAM_TYPE_TXT	= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_PARAM_TYPE_TXT" />';
	var PNL_PARAM_TYPE_NUM	= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_PARAM_TYPE_NUM" />';
	var PNL_PARAM_TYPE_DTE	= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_PARAM_TYPE_DTE" />';
		
	var PNL_PARAM_SRC_ADMIN	= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_PARAM_SRC_ADMIN" />';
	var PNL_PARAM_SRC_EXEC	= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_PARAM_SRC_EXEC" />';
	var PNL_PARAM_SRC_BOTH	= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_PARAM_SRC_BOTH" />';	
	
	var LBL_TXT				= '<system:label show="text" label="lblStr" forScript="true" />';
	var LBL_NUM				= '<system:label show="text" label="lblNum" forScript="true" />';
	var LBL_DTE				= '<system:label show="text" label="lblDate" forScript="true" />';
		
	var LBL_ADMIN			= '<system:label show="text" label="mnuAdm" forScript="true" />';
	var LBL_EXEC			= '<system:label show="text" label="lblExecution" forScript="true" />';
	var LBL_BOTH			= '<system:label show="text" label="lblAmbos" forScript="true" />';	
	
	var PNL_PARAM_VIEW_TYPE_INPUT		= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_VIEW_TYPE_INPUT" />';
	var PNL_PARAM_VIEW_TYPE_COMBOBOX	= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_VIEW_TYPE_COMBOBOX" />';
	var PNL_PARAM_VIEW_TYPE_CHECKBOX	= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_VIEW_TYPE_CHECKBOX" />';
	var PNL_PARAM_VIEW_TYPE_MDL_ENV		= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_VIEW_TYPE_MDL_ENVIRONMENT" />';
	var PNL_PARAM_VIEW_TYPE_MDL_PRO		= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_VIEW_TYPE_MDL_PROCESS" />';
	var PNL_PARAM_VIEW_TYPE_MDL_TSK		= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_VIEW_TYPE_MDL_TASK" />';
	var PNL_PARAM_VIEW_TYPE_MDL_ENT		= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_VIEW_TYPE_MDL_ENTITY" />';
	var PNL_PARAM_VIEW_TYPE_MDL_CAT		= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_VIEW_TYPE_MDL_CATEGORY" />';
	var PNL_PARAM_VIEW_TYPE_MDL_DSH		= '<system:edit show="constant" from="com.dogma.vo.PnlParameterVo" field="PNL_VIEW_TYPE_MDL_DASHBOARD" />';

	var LBL_INPUT		= '<system:label show="text" label="lblInput" forScript="true" />';
	var LBL_COMBOBOX	= '<system:label show="text" label="lblCombobox" forScript="true" />';
	var LBL_CHECKBOX	= '<system:label show="text" label="lblCheckbox" forScript="true" />';
	var LBL_MDL_ENV		= '<system:label show="text" label="lblMdlEnv" forScript="true" />';
	var LBL_MDL_PRO		= '<system:label show="text" label="lblMdlPro" forScript="true" />';
	var LBL_MDL_TSK		= '<system:label show="text" label="lblMdlTsk" forScript="true" />';
	var LBL_MDL_ENT		= '<system:label show="text" label="lblMdlEnt" forScript="true" />';
	var LBL_MDL_CAT		= '<system:label show="text" label="lblMdlCat" forScript="true" />';
	var LBL_MDL_DSH		= '<system:label show="text" label="lblMdlDsh" forScript="true" />';

	var PARAM_NAMES_EXIST	= '<system:label show="text" label="msgExistName" forScript="true" />';
	var PRIMARY_SEPARATOR		= new Element('div').set('html', '<system:edit show="constant" from="com.st.util.StringUtil" field="PRIMARY_SEPARATOR"/>').get('text');
</script><div class="aTab"><div class="tab" id="tabParameters"><system:label show="text" label="tabPar" /></div><div class="contentTab" id="contentTabParameters"><div><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtDatPar" /></div><div class="gridContainer" style="margin: 0px;"><div class="gridHeader"><table cellpadding="0" cellspacing="0"><thead><tr class="header"><th class="required" title="<system:label show="tooltip" label="lblNom" />"><div style="width: 165px"><system:label show="text" label="lblNom" /></div></th><th class="required" title="<system:label show="tooltip" label="lblTitle" />"><div style="width: 185px"><system:label show="text" label="lblTitle" /></div></th><th title="<system:label show="tooltip" label="lblDesc" />"><div style="width: 185px"><system:label show="text" label="lblDesc" /></div></th><th class="required" title="<system:label show="tooltip" label="lblTip" />"><div style="width: 75px"><system:label show="text" label="lblTip" /></div></th><th class="required" title="<system:label show="tooltip" label="lblOri" />"><div style="width: 100px"><system:label show="text" label="lblOri" /></div></th><th class="required" title="<system:label show="tooltip" label="sbtDisplay" />"><div style="width: 80px"><system:label show="text" label="sbtDisplay" /></div></th></tr></thead></table></div><div class="gridBody" id="gridParams"><table cellpadding="0" cellspacing="0"><thead><tr><th width="165"></th><th width="185"></th><th width="185"></th><th width="75"></th><th width="100"></th><th width="80"></th></tr></thead><tbody class="tableData" id="tableParams"><input type="hidden" id="strParams" name="strParams" value=""></tbody></table></div><div class="gridFooter"><div class="listActionButtons" id="gridFooter"><div class="listAddDelRight" ><div class="btnAdd navButton" id="btnAddParam"><system:label show="text" label="btnAgr" /></div><div class="actSeparator">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class="btnDelete navButton" id="btnDelParam"><system:label show="text" label="btnEli" /></div></div></div></div></div></div></div></div></div>