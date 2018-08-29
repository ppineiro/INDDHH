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
writeLabel("lbl_message","lblMessage",out,labelSet,langId,"&");
writeLabel("lbl_ok","btnCon",out,labelSet,langId,"&");
writeLabel("lbl_cancel","btnCan",out,labelSet,langId,"&");
writeLabel("lbl_threadMonitor","lblThreadMonitor",out,labelSet,langId,"&");
writeLabel("lbl_debugProperties","lblDebugProperties",out,labelSet,langId,"&");
writeLabel("lbl_generate_rtf","lblGenerateRtf",out,labelSet,langId,"&");
writeLabel("lbl_roles","flaProPanRol",out,labelSet,langId,"&");
writeLabel("lbl_attributes","flaAtr",out,labelSet,langId,"&");
writeLabel("lbl_groups","flaProGrp",out,labelSet,langId,"&");
writeLabel("lbl_status","flaProStatus",out,labelSet,langId,"&");
//writeLabel("lbl_roles","flaProPanRol",out,labelSet,langId,"&");
writeLabel("lbl_role","flaProTskCntRol",out,labelSet,langId,"&");
writeLabel("lbl_name","flaDwDimName",out,labelSet,langId,"&");
writeLabel("lbl_from","lblFrom",out,labelSet,langId,"&");
writeLabel("lbl_type","flaProBndTyp",out,labelSet,langId,"&");
writeLabel("lbl_value","flaBinAttVal",out,labelSet,langId,"&");
writeLabel("lbl_change","lbl_changeElement",out,labelSet,langId,"&");
writeLabel("lbl_current","lbl_current",out,labelSet,langId,"&");
writeLabel("lbl_group","lblProPool",out,labelSet,langId,"&");
writeLabel("lbl_quantity","lbl_quantity",out,labelSet,langId,"&");
writeLabel("lbl_attribute","flaProBndAtt",out,labelSet,langId,"&");
writeLabel("lbl_entity","flaProBndEnt",out,labelSet,langId,"&");
writeLabel("lbl_doc_ready","lblDocReady",out,labelSet,langId,"&");
//writeLabel("lbl_value","flaVal",out,labelSet,langId,"&");
writeLabel("lbl_process","flaProBndPro",out,labelSet,langId,"");

%>