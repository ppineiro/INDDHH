<%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><%!

void writeLabel(String lbl,String lblName,JspWriter out,Integer labelSet,Integer langId,String end){
	try{
	out.print(lbl+"=");
	out.print(LabelManager.getName(labelSet, langId, lblName));
	out.print(end);
	}
	catch(Exception e){}
}

%><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;

boolean envUsesEntities = false;
//com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
com.dogma.UserData uData = biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
}
out.clear();writeLabel("lbl_elementproperties","lblElementProperties",out,labelSet,langId,"&");
writeLabel("lbl_toolbar","lblToolBar",out,labelSet,langId,"&");
writeLabel("lbl_ok","btnCon",out,labelSet,langId,"&");
writeLabel("lbl_cancel","btnCan",out,labelSet,langId,"&");
writeLabel("lbl_threadMonitor","lblThreadMonitor",out,labelSet,langId,"&");
writeLabel("lbl_debugProperties","lblDebugProperties",out,labelSet,langId,"&");
writeLabel("lbl_generate_rtf","lblGenerateRtf",out,labelSet,langId,"&");
writeLabel("lbl_roles","flaProPanRol",out,labelSet,langId,"&");
writeLabel("lbl_attributes","flaAtr",out,labelSet,langId,"&");
writeLabel("lbl_groups","flaProGrp",out,labelSet,langId,"&");
writeLabel("lbl_status","flaProStatus",out,labelSet,langId,"&");
writeLabel("lbl_roles","flaProPanRol",out,labelSet,langId,"&");
writeLabel("lbl_role","flaProTskCntRol",out,labelSet,langId,"&");
writeLabel("lbl_name","flaDwDimName",out,labelSet,langId,"&");
writeLabel("lbl_from","lblFrom",out,labelSet,langId,"&");
writeLabel("lbl_type","flaProBndTyp",out,labelSet,langId,"&");
writeLabel("lbl_value","flaBinAttVal",out,labelSet,langId,"&");
writeLabel("lbl_change","lbl_changeElement",out,labelSet,langId,"&");
writeLabel("lbl_current","lbl_current",out,labelSet,langId,"&");
writeLabel("lbl_group","lblProPool",out,labelSet,langId,"&");
writeLabel("lbl_quantity","lbl_quantity",out,labelSet,langId,"&");
/*writeLabel("lbl_value","flaVal",out,labelSet,langId,"&");*/
writeLabel("lbl_frmproperties","lblObjDesFrmProperty",out,labelSet,langId,"&");
writeLabel("lbl_attribute","flaAtt",out,labelSet,langId,"&");
writeLabel("lbl_entity","flaBinAttEnt",out,labelSet,langId,"&");
writeLabel("lbl_process","flaBinAttPro",out,labelSet,langId,"&");
writeLabel("flaGridFields","flaGridFields",out,labelSet,langId,"&");
writeLabel("btnUp","btnUp",out,labelSet,langId,"&");
writeLabel("btnDown","btnDown",out,labelSet,langId,"&");
writeLabel("btnAgr","btnAgr",out,labelSet,langId,"&");
writeLabel("btnDel","btnDel",out,labelSet,langId,"&");
writeLabel("prpName", "prpName", out, labelSet, langId, "&");

writeLabel("lbl_property", "flaPro", out, labelSet, langId, "&");
writeLabel("lbl_condition_title", "lblCondition", out, labelSet, langId, "&");
writeLabel("lbl_datafinder_att_title", "flaAtr", out, labelSet, langId, "&");
writeLabel("lbl_datafinder_ent_title", "lblObjDesBusEntity", out, labelSet, langId, "&");
writeLabel("lbl_datafinder_qry_title", "lblObjDesQuery", out, labelSet, langId, "&");
writeLabel("lbl_datafinder_mdl_title", "flaModals", out, labelSet, langId, "&");
writeLabel("lbl_datafinder_img_title", "lblObjDesImages", out, labelSet, langId, "&");
writeLabel("lbl_datafinder_frm_title", "titFrm", out, labelSet, langId, "&");


writeLabel("lbl_events", "flaEvtForBusCla", out, labelSet, langId, "&");
writeLabel("lbl_outline", "flaOutline", out, labelSet, langId, "&");
writeLabel("lbl_gridorder_title", "flaTableOrderTitle", out, labelSet, langId, "&");
writeLabel("lbl_confirm_clear_title", "flaClearForm", out, labelSet, langId, "&");
writeLabel("lbl_confirm_clear_text", "flaClearFormText", out, labelSet, langId, "&");
writeLabel("lbl_max_col_reached", "flaMaxCol", out, labelSet, langId, "&");
writeLabel("lbl_cell_ocupied", "flaCellOcupied", out, labelSet, langId, "&");
writeLabel("lbl_out_of_bounds", "flaOutOfBounds", out, labelSet, langId, "&");
writeLabel("lbl_min_size", "flaMinSizeNotReached", out, labelSet, langId, "&");

writeLabel("lbl_min_size", "flaMinSizeNotReached", out, labelSet, langId, "&");
writeLabel("lbl_fields", "flaFields", out, labelSet, langId, "&");
writeLabel("lbl_use", "flaUse", out, labelSet, langId, "&");
writeLabel("lbl_use_name", "lblNomAtt", out, labelSet, langId, "&");
writeLabel("lbl_use_label", "flaAttLabel", out, labelSet, langId, "&");
writeLabel("lbl_add_str_att", "flaAddStrAtts", out, labelSet, langId, "&");
writeLabel("lbl_add_num_att", "flaAddNumAtts", out, labelSet, langId, "&");
writeLabel("lbl_add_dte_att", "flaAddDteAtts", out, labelSet, langId, "&");
writeLabel("lbl_add_all_att", "flaAddAllAtts", out, labelSet, langId, "&");

writeLabel("lbl_att_info", "flaAttInfo", out, labelSet, langId, "&");
writeLabel("lbl_length", "lblLar", out, labelSet, langId, "&");
writeLabel("lbl_min_width_reached", "flaMinWidthReached", out, labelSet, langId, "&");
writeLabel("lbl_col_width_fields", "flaColWithFields", out, labelSet, langId, "&");
writeLabel("lbl_order_in_table", "flaOrderInTable", out, labelSet, langId, "&");

writeLabel("lbl_true", "flaTrue", out, labelSet, langId, "&");
writeLabel("lbl_false", "flaFalse", out, labelSet, langId, "&");


writeLabel("prpEntity", "prpEntity", out, labelSet, langId, "&");
writeLabel("prpDocType", "prpDocType", out, labelSet, langId, "&");

writeLabel("lbl_properties", "lblProps", out, labelSet, langId, "");
%>