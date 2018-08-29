<%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){
	response.setHeader("Pragma","public no-cache");
}else{
	if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}
}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1);
response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);

//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;

boolean envUsesEntities = false;
com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
}
out.clear();

out.print("lbl_attName=");out.print(LabelManager.getName(labelSet,langId,"flaNom"));//Nombre
out.print("&lbl_attLabel=");out.print(LabelManager.getName(labelSet,langId,"flaEti"));//label
out.print("&lbl_attType=");out.print(LabelManager.getName(labelSet,langId,"flaTip"));//type
out.print("&lbl_attMaxlength=");out.print(LabelManager.getName(labelSet,langId,"flaMax"));//max
out.print("&lbl_btnConfirm=");out.print(LabelManager.getName(labelSet,langId,"flaCon")); //Confirmar
out.print("&lblbtnCancel=");out.print(LabelManager.getName(labelSet,langId,"flaCan")); //Cancelar
out.print("&lab_eventBindingsAttributes=");out.print(LabelManager.getName(labelSet,langId,"flaProBndAtt")); //

out.print("&lbl_frmEntityTitle=");out.print(LabelManager.getName(labelSet,langId,"flaProBndEnt")); //Entity Forms
out.print("&lbl_BindProcess=");out.print(LabelManager.getName(labelSet,langId,"flaProBndPro")); //

out.print("&lbl_ConditionModalTitle=");out.print(LabelManager.getName(labelSet,langId, "flaProCndMod"));

out.print("&lblConditionRules=");out.print(com.st.util.StringUtil.replace(LabelManager.getName(labelSet,langId, "flaProCndRul")+LabelManager.getName(labelSet,langId, "flaProCndRul2")+LabelManager.getName(labelSet,langId, "flaProCndRul3"),"\r","")); //Con Rules

out.print("&rad_eventBindingsValue=");out.print(LabelManager.getName(labelSet,langId,"flaVal")); //
out.print("&rad_eventBindingsAttribute=");out.print(LabelManager.getName(labelSet,langId,"flaProBndAtt")); //
out.print("&lbl_BindParam=");out.print(LabelManager.getName(labelSet,langId,"flaProPar")); //
out.print("&lbl_BindType=");out.print(LabelManager.getName(labelSet,langId,"flaProBndTyp")); //
out.print("&lbl_BindValue=");out.print(LabelManager.getName(labelSet,langId,"flaProBndVal")); //
out.print("&lbl_BindAttribute=");out.print(LabelManager.getName(labelSet,langId,"flaProBndAtt")); //
out.print("&att_IO_label=");out.print(LabelManager.getName(labelSet,langId,"flaProInOut")); //
out.print("&lblbtnBind=");out.print(LabelManager.getName(labelSet,langId,"flaProBtnBnd")); //
out.print("&eventBindingsTitle=");out.print(LabelManager.getName(labelSet,langId,"flaProBnd")); //
out.print("&lbl_mapContext=");out.print(LabelManager.getName(labelSet,langId,"flaTitEvt")); //
out.print("&lbl_classes=");out.print(LabelManager.getName(labelSet,langId,"flaCla")); //
out.print("&lbl_events=");out.print(LabelManager.getName(labelSet,langId,"flaEve")); //
out.print("&lbl_condition=");out.print(LabelManager.getName(labelSet,langId,"flaProCndMod")); //

out.print("&lbl_StaTitle=");out.print(LabelManager.getName(labelSet,langId,"flaProStatus")); //
out.print("&lbl_EvtStaEvt=");out.print(LabelManager.getName(labelSet,langId,"flaProEvt")); //
out.print("&lbl_EvtStaSta=");out.print(LabelManager.getName(labelSet,langId,"flaProStatus")); //
out.print("&lbl_EvtStaCon=");out.print(LabelManager.getName(labelSet,langId,"flaProCndMod")); //
//out.print("&lbl_ConditionModalTitle=");out.print(LabelManager.getName(labelSet,langId,"flaProCndMod")); //
//out.print("&lbl_FormConditionModalTitle=");out.print(LabelManager.getName(labelSet,langId,"flaProCndMod")); //
//out.print("&lblbtnCond=");out.print(LabelManager.getName(labelSet,langId,"flaProCndMod")); //
out.print("&lblbtnCond=");out.print(LabelManager.getName(labelSet,langId,"flaProCndMod")); //out.print("Condición"); //
%>