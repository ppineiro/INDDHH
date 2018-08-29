<script type="text/javascript">
	var DOC_TYPE_TASK                   = '<system:edit show="constant" from="com.dogma.vo.DocumentVo" field="DOC_TYPE_TASK"/>';
	var DOC_TYPE_PROCESS                = '<system:edit show="constant" from="com.dogma.vo.DocumentVo" field="DOC_TYPE_PROCESS"/>';
	var DOC_TYPE_PROCESS_INST           = '<system:edit show="constant" from="com.dogma.vo.DocumentVo" field="DOC_TYPE_PROCESS_INST"/>';
	var DOC_TYPE_BUS_ENT                = '<system:edit show="constant" from="com.dogma.vo.DocumentVo" field="DOC_TYPE_BUS_ENT"/>';
	var DOC_TYPE_BUS_ENT_INST           = '<system:edit show="constant" from="com.dogma.vo.DocumentVo" field="DOC_TYPE_BUS_ENT_INST"/>';
	var DOC_TYPE_FORM                   = '<system:edit show="constant" from="com.dogma.vo.DocumentVo" field="DOC_TYPE_FORM"/>';
	var DOC_TYPE_BUS_ENT_INST_ATTRIBUTE = '<system:edit show="constant" from="com.dogma.vo.DocumentVo" field="DOC_TYPE_BUS_ENT_INST_ATTRIBUTE"/>';
	var DOC_TYPE_ENVIRONMENT            = '<system:edit show="constant" from="com.dogma.vo.DocumentVo" field="DOC_TYPE_ENVIRONMENT"/>';
	var DOC_TYPE_PRO_INST_ATTRIBUTE     = '<system:edit show="constant" from="com.dogma.vo.DocumentVo" field="DOC_TYPE_PRO_INST_ATTRIBUTE"/>';
	
	var MSG_LOST_FILTERS				= '<system:label show="text" label="msgLostFil" />';
	var PRIMARY_SEPARATOR				= new Element('div').set('html', '<system:edit show="constant" from="com.st.util.StringUtil" field="PRIMARY_SEPARATOR"/>').get('text');
</script><div class="aTab"><div class="tab" id="tabFilters"><system:label show="text" label="sbtFilters" /></div><div class="contentTab" id="contentTabFilters"><div><div class="fieldGroup"><div class="title"><system:label show="text" label="titFilAva" /></div></div><!-- DOC TYPE --><div class="fieldGroup splitTable" style="vertical-align: top;"><div class="subtitle"><system:label show="text" label="lblDocType" /></div><div class="field extendedSize"><label title="<system:label show="tooltip" label="lblCanFil" />"><system:label show="text" label="lblCanFil" />:&nbsp;</label><input type="checkbox" name="flagFilDocType" id="flagFilDocType" <system:edit show="ifFlag" from="theEdition" field="0" defaultValue="monDocFilterFlags">checked</system:edit> ></div><div class="modalOptionsContainer" id="containerDocType"><div class="option optionRemoveNoImg" id="allFilDocType" style="height: 20px; cursor: auto;"><system:label show="text" label="lblTod" /></div><div class="option optionAdd" id="addFilDocType" helper="true" style="height: 18px"><system:label show="text" label="btnAgr" /></div></div><input type="hidden" id="filtersDocType" name="filtersDocType" value=""></div><!-- SIZE --><div class="fieldGroup splitTable" style="vertical-align: top;"><div class="subtitle"><system:label show="text" label="lblTam" />&nbsp;(B)</div><div class="field extendedSize"><label title="<system:label show="tooltip" label="lblCanFil" />"><system:label show="text" label="lblCanFil" />:&nbsp;</label><input type="checkbox" name="flagFilSize" id="flagFilSize" <system:edit show="ifFlag" from="theEdition" field="2" defaultValue="monDocFilterFlags">checked</system:edit> ></div><div class="modalOptionsContainer" id="containerSize"></div><input type="hidden" id="filtersSize" name="filtersSize" value=""></div><br><div class="clear"></div><br><!-- NAME --><div class="fieldGroup splitTable" style="vertical-align: top;"><div class="subtitle"><system:label show="text" label="lblName" /></div><div class="field extendedSize"><label title="<system:label show="tooltip" label="lblCanFil" />"><system:label show="text" label="lblCanFil" />:&nbsp;</label><input type="checkbox" name="flagFilName" id="flagFilName" <system:edit show="ifFlag" from="theEdition" field="1" defaultValue="monDocFilterFlags">checked</system:edit> ></div></div><!-- DESCRIPTION --><div class="fieldGroup splitTable" style="vertical-align: top;"><div class="subtitle"><system:label show="text" label="lblDesc" /></div><div class="field extendedSize"><label title="<system:label show="tooltip" label="lblCanFil" />"><system:label show="text" label="lblCanFil" />:&nbsp;</label><input type="checkbox" name="flagFilDesc" id="flagFilDesc" <system:edit show="ifFlag" from="theEdition" field="5" defaultValue="monDocFilterFlags">checked</system:edit> ></div></div><br><div class="clear"></div><br><!-- DATE --><div class="fieldGroup splitTable" style="vertical-align: top;"><div class="subtitle"><system:label show="text" label="lblFecUltMod" /></div><div class="field extendedSize"><label title="<system:label show="tooltip" label="lblCanFil" />"><system:label show="text" label="lblCanFil" />:&nbsp;</label><input type="checkbox" name="flagFilRegDate" id="flagFilRegDate" <system:edit show="ifFlag" from="theEdition" field="4" defaultValue="monDocFilterFlags">checked</system:edit> ></div><div class="modalOptionsContainer" id="containerDate"></div><input type="hidden" id="filtersDate" name="filtersDate" value=""></div><!-- USER --><div class="fieldGroup splitTable" style="vertical-align: top;"><div class="subtitle"><system:label show="text" label="lblUsu" /></div><div class="field extendedSize"><label title="<system:label show="tooltip" label="lblCanFil" />"><system:label show="text" label="lblCanFil" />:&nbsp;</label><input type="checkbox" name="flagFilRegUser" id="flagFilRegUser" <system:edit show="ifFlag" from="theEdition" field="3" defaultValue="monDocFilterFlags">checked</system:edit> ></div><div class="modalOptionsContainer" id="containerUser"><div class="option optionRemoveNoImg" id="allFilUser" style="height: 20px; cursor: auto;"><system:label show="text" label="lblTod" /></div><div class="option optionAdd" id="addFilUser" helper="true" style="height: 18px"><system:label show="text" label="btnAgr" /></div></div><input type="hidden" id="filtersUser" name="filtersUser" value=""></div><br><div class="clear"></div><br><!-- SOURCE --><div class="fieldGroup splitTable" style="vertical-align: top;"><div class="subtitle"><system:label show="text" label="lblDocSrc" /></div><div class="field extendedSize"><label title="<system:label show="tooltip" label="lblCanFil" />"><system:label show="text" label="lblCanFil" />:&nbsp;</label><input type="checkbox" name="flagFilSrc" id="flagFilSrc" <system:edit show="ifFlag" from="theEdition" field="6" defaultValue="monDocFilterFlags">checked</system:edit> ><select id="cmbFilSrc" onchange="onChangeCmbFilSrc(this,true);" name="cmbFilSrc" value="<system:edit show="value" from="theEdition" field="docSrc" />"><option></option><system:util show="prepareDocumentsDocType" saveOn="docType" /><system:edit show="iteration" from="docType" saveOn="docType_save"><system:edit show="saveValue" from="docType_save" field="docType" saveOn="docType"/><option value="<system:edit show="value" from="docType_save" field="docType"/>" <system:edit show="ifValue" from="theEdition" field="docSrc" value="with:docType">selected</system:edit> ><system:edit show="value" from="docType_save" field="docTypeName"/></option></system:edit></select></div><br><!-- REG INSTANCE --><div class="subtitle"><system:label show="text" label="lblMonInstProNroReg" /></div><div class="field extendedSize"><label title="<system:label show="tooltip" label="lblCanFil" />"><system:label show="text" label="lblCanFil" />:&nbsp;</label><input type="checkbox" name="flagFilRegInst" id="flagFilRegInst" <system:edit show="ifFlag" from="theEdition" field="8" defaultValue="monDocFilterFlags">checked</system:edit> ></div><div class="modalOptionsContainer" id="containerRegInst" style="display: none;"></div><input type="hidden" id="filtersRegInst" name="filtersRegInst" value=""></div><!-- SOURCE TITLE --><div class="fieldGroup splitTable" id="divSrcTit" style="vertical-align: top;"><div class="subtitle"><system:label show="text" label="lblSrcTit" /></div><div class="field extendedSize"><label title="<system:label show="tooltip" label="lblCanFil" />"><system:label show="text" label="lblCanFil" />:&nbsp;</label><input type="checkbox" name="flagFilTitSrc" id="flagFilTitSrc" <system:edit show="ifFlag" from="theEdition" field="7" defaultValue="monDocFilterFlags">checked</system:edit> ></div><!-- tareas --><div class="modalOptionsContainer" id="containerSrcTit_tsk" style="display: none;"><label style="float: left;"><system:label show="text" label="sbtMonTsk" />:&nbsp;</label><br><div class="option optionRemoveNoImg" id="allFilSrcTit_tsk" style="height: 20px; cursor: auto;"><system:label show="text" label="lblTod" /></div><div class="option optionAdd" id="addFilSrcTit_tsk" helper="true" style="height: 18px"><system:label show="text" label="btnAgr" /></div></div><div class="clear"></div><!-- procesos --><div class="modalOptionsContainer" id="containerSrcTit_pro" style="display: none;"><label style="float: left;"><system:label show="text" label="sbtProcess" />:&nbsp;</label><br><div class="option optionRemoveNoImg" id="allFilSrcTit_pro" style="height: 20px; cursor: auto;"><system:label show="text" label="lblTod" /></div><div class="option optionAdd" id="addFilSrcTit_pro" helper="true" style="height: 18px"><system:label show="text" label="btnAgr" /></div></div><div class="clear"></div><!-- entidades --><div class="modalOptionsContainer" id="containerSrcTit_ent" style="display: none;"><label style="float: left;"><system:label show="text" label="titEjeEnt" />:&nbsp;</label><br><div class="option optionRemoveNoImg" id="allFilSrcTit_ent" style="height: 20px; cursor: auto;"><system:label show="text" label="lblTod" /></div><div class="option optionAdd" id="addFilSrcTit_ent" helper="true" style="height: 18px"><system:label show="text" label="btnAgr" /></div></div><div class="clear"></div><!-- atributos --><div class="modalOptionsContainer" id="containerSrcTit_att" style="display: none;"><label style="float: left;"><system:label show="text" label="titAtr" />:&nbsp;</label><br><div class="option optionRemoveNoImg" id="allFilSrcTit_att" style="height: 20px; cursor: auto;"><system:label show="text" label="lblTod" /></div><div class="option optionAdd" id="addFilSrcTit_att" helper="true" style="height: 18px"><system:label show="text" label="btnAgr" /></div></div><div class="clear"></div><!-- formularios --><div class="modalOptionsContainer" id="containerSrcTit_frm" style="display: none;"><label style="float: left;"><system:label show="text" label="titFor" />:&nbsp;</label><br><div class="option optionRemoveNoImg" id="allFilSrcTit_frm" style="height: 20px; cursor: auto;"><system:label show="text" label="lblTod" /></div><div class="option optionAdd" id="addFilSrcTit_frm" helper="true" style="height: 18px"><system:label show="text" label="btnAgr" /></div></div><input type="hidden" id="filtersSrcTit" name="filtersSrcTit" value=""></div><br><div class="clear"></div><br><!-- CONTENT --><system:edit show="ifValue" from="theBean" field="docIndexActive" value="true"><div class="fieldGroup splitTable" style="vertical-align: top;"><div class="subtitle"><system:label show="text" label="lblContent" /></div><div class="field extendedSize"><label title="<system:label show="tooltip" label="lblCanFil" />"><system:label show="text" label="lblCanFil" />:&nbsp;</label><input type="checkbox" name="flagFilCont" id="flagFilCont" <system:edit show="ifFlag" from="theEdition" field="9" defaultValue="monDocFilterFlags">checked</system:edit> ></div></div></system:edit></div></div></div>