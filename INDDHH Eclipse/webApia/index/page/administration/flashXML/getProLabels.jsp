<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><%
if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	if(request.getHeader("User-Agent").indexOf("Firefox")<0){response.setHeader("Pragma","public no-cache");}else{	response.setHeader("Pragma","no-cache");}}
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
response.setCharacterEncoding("utf-8");
//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;

boolean envUsesEntities = false;
com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
}
out.clear();
out.print("lbl_startTask=");//start
out.print(LabelManager.getName(labelSet, langId, "flaProSta")); //Start
out.print("&lbl_endTask=");//end
out.print(LabelManager.getName(labelSet, langId, "flaProEnd")); //End
out.print("&lbl_taskContext1=");//forms
out.print(LabelManager.getName(labelSet, langId,"flaProTskCntFrm")); //Forms
out.print("&lbl_taskContext2=");//groups
out.print(LabelManager.getName(labelSet, langId,"flaProTskCntGrp")); //Groups
out.print("&lbl_taskContext3=");//events
out.print(LabelManager.getName(labelSet, langId,"flaProTskCntEvt")); //Events
out.print("&lbl_taskContext4=");//roles
out.print(LabelManager.getName(labelSet, langId,"flaProTskCntRol")); //Roles
out.print("&lbl_taskContext5=");//roles
out.print(LabelManager.getName(labelSet, langId,"flaProTskCntDelTsk")); //Roles
out.print("&lbl_taskContext6=");//roles
out.print(LabelManager.getName(labelSet, langId,"flaProTskCntTskPro")); //Roles
out.print("&lbl_endTaskContext1=");//roles
out.print(LabelManager.getName(labelSet, langId,"flaProTskCntEndTsk")); //Roles
out.print("&lbl_dependencyContext1=");//Name
out.print(LabelManager.getName(labelSet, langId,"flaProDepCntNam")); //Name
out.print("&lbl_dependencyContext2=");//Condition
out.print(LabelManager.getName(labelSet, langId,"flaProDepCntCnd")); //Condition
out.print("&lbl_dependencyContext3=");//Condition
out.print(LabelManager.getName(labelSet, langId,"flaProDepWiz")); //Condition
out.print("&lbl_dependencyContext4=");//Condition
out.print(LabelManager.getName(labelSet, langId,"flaProDepDel")); //Condition
out.print("&lbl_dependencyContext5=");//Condition
out.print(LabelManager.getName(labelSet, langId,"flaProDepLoopBack")); //Condition
out.print("&lbl_processContext1=");//Iterate
out.print(LabelManager.getName(labelSet, langId,"flaProProItr")); //Iterate
out.print("&lbl_processContext2=");//remove iteration
out.print(LabelManager.getName(labelSet, langId,"flaProRemIte")); //remove iteration
out.print("&lbl_processContext3=");//iterate condition
out.print(LabelManager.getName(labelSet, langId,"flaProIteCnd")); //iterate condition
out.print("&lbl_processContext4=");//iterate condition
out.print(LabelManager.getName(labelSet, langId,"flaProViePro")); //iterate condition
out.print("&lbl_processContext5=");//iterate condition
out.print(LabelManager.getName(labelSet, langId,"flaProDelPro")); //iterate condition
out.print("&lbl_processContext6=");//iterate condition
out.print(LabelManager.getName(labelSet, langId,"flaProTyp")); //iterate condition
out.print("&lbl_processContext7=");//iterate condition
out.print(LabelManager.getName(labelSet, langId,"flaProFrm")); //iterate condition
out.print("&lbl_processContext8=");//iterate condition
out.print(LabelManager.getName(labelSet, langId,"flaProMap")); //iterate condition
out.print("&lbl_processContext9=");//iterate condition
out.print(LabelManager.getName(labelSet, langId,"flaProAsc")); //iterate condition
out.print("&lbl_processContext10=");//iterate condition
out.print(LabelManager.getName(labelSet, langId,"flaProSyn")); //iterate condition
out.print("&lbl_processContext11=");//iterate condition
out.print(LabelManager.getName(labelSet, langId,"flaProAscSk")); //iterate condition
out.print("&lbl_processContext12=");//iterate condition
out.print(LabelManager.getName(labelSet, langId,"flaProSynSk")); //iterate condition
out.print("&lbl_processContext13=");//iterate condition
out.print(LabelManager.getName(labelSet, langId,"flaProPro")); //iterate condition
out.print("&lbl_opContext1=");//iterate condition
out.print(LabelManager.getName(labelSet, langId,"flaOpeDel")); //iterate condition
out.print("&lbl_delete=");//delete
out.print(LabelManager.getName(labelSet, langId,"flaProDel")); //delete
out.print("&lbl_formWin=");//Forms
out.print(LabelManager.getName(labelSet, langId,"flaProFrm")); //Forms
out.print("&lbl_eventWin=");//Events
out.print(LabelManager.getName(labelSet, langId,"flaProEvt")); //Events
out.print("&lbl_poolWin=");//Groups
out.print(LabelManager.getName(labelSet, langId,"flaProGrp")); //Groups
out.print("&lbl_finderTitleTask=");//Tareas
out.print(LabelManager.getName(labelSet, langId,"flaProTsk")); //Tareas
out.print("&lbl_NameModalTitle=");//Name
out.print(LabelManager.getName(labelSet, langId,"flaProNam")); //Name
out.print("&lbl_finderTitlePro=");//SubProcesos
out.print(LabelManager.getName(labelSet, langId,"flaProSubPro")); //SubProcesos
out.print("&lbl_RolModalTitle=");//Roles
out.print(LabelManager.getName(labelSet, langId,"flaProRol")); //Roles
out.print("&lbl_RolEmpty=");//No Role
out.print(LabelManager.getName(labelSet, langId,"flaProNoRol")); //No Role
out.print("&lbl_btnConfirm=");//Confirmar
out.print(LabelManager.getName(labelSet, langId,"flaCon")); //Confirmar
out.print("&lblbtnCancel=");//Cancelar
out.print(LabelManager.getName(labelSet, langId,"flaCan")); //Cancelar
out.print("&lbl_ConditionModalTitle=");//Condition
out.print(LabelManager.getName(labelSet, langId,"flaProCndMod")); //Condition
out.print("&lbl_mapContext=");//Process Events
out.print(LabelManager.getName(labelSet, langId,"flaProCntProEvt")); //Process Events
out.print("&lbl_mapContext2=");//Process WEBSERVICES
out.print(LabelManager.getName(labelSet, langId,"flaProWS")); //Process Events
out.print("&lblConditionRules=");//Cond Rules
out.print(com.st.util.StringUtil.replace(LabelManager.getName(labelSet, langId,"flaProCndRul")+LabelManager.getName(labelSet, langId,"flaProCndRul2")+LabelManager.getName(labelSet, langId,"flaProCndRul3"),"\r","")); //Con Rules
out.print("&lblbtnDocumentation=");//Cond Rules
out.print(LabelManager.getName(labelSet, langId,"lblbtnDocumentation")); //Documentation

out.print("&lbl_frmEntityTitle=");
out.print(LabelManager.getName(labelSet, langId,"flaProEntFor")); //Entity Forms
out.print("&lbl_frmProcessTitle=");
out.print(LabelManager.getName(labelSet, langId,"flaProProFor")); //Process Forms

out.print("&lbl_elementPanelTit=");
out.print(LabelManager.getName(labelSet, langId,"flaProPanEle")); //Process Forms
out.print("&lbl_tasksPanelTit=");
out.print(LabelManager.getName(labelSet, langId,"flaProPanTsk")); //Process Forms
out.print("&lbl_subProPanelTit=");
out.print(LabelManager.getName(labelSet, langId,"flaProPanSub")); //Process Forms
out.print("&lbl_subRolePanelTit=");
out.print(LabelManager.getName(labelSet, langId,"flaProPanRol")); //Process Forms

out.print("&lbl_untitledElement=");
out.print(LabelManager.getName(labelSet, langId,"flaUntitled")); //Untitled

//--------------------------

out.print("&lbl_FormConditionModalTitle=");
out.print(LabelManager.getName(labelSet, langId,"flaProCnd")); //Untitled

out.print("&lblbtnBind=");
out.print(LabelManager.getName(labelSet, langId,"flaProBtnBnd")); //Untitled

out.print("&attributesModalTitle=");
out.print(LabelManager.getName(labelSet, langId,"flaProAtt")); //Untitled

out.print("&eventBindingsTitle=");
out.print(LabelManager.getName(labelSet, langId,"flaProBnd")); //Untitled

out.print("&lab_eventBindingsValue=");
out.print(LabelManager.getName(labelSet, langId,"flaProBndVal")); //Untitled

out.print("&lab_eventBindingsAttributes=");
out.print(LabelManager.getName(labelSet, langId,"flaProBndAtt")); //Untitled

out.print("&rad_eventBindingsValue=");
out.print(LabelManager.getName(labelSet, langId,"flaProBndVal")); //Untitled

out.print("&rad_eventBindingsAttribute=");
out.print(LabelManager.getName(labelSet, langId,"flaProBndAtt")); //Untitled

out.print("&lbl_Loader=");
out.print(LabelManager.getName(labelSet, langId,"flaProCarg")); //Untitled

out.print("&lblbtnCond=");
out.print(LabelManager.getName(labelSet, langId,"flaProCnd")); //Untitled

out.print("&lbl_taskContext7=");
out.print(LabelManager.getName(labelSet, langId,"flaProTskCntSta")); //Untitled

out.print("&lbl_taskContext8=");
out.print(LabelManager.getName(labelSet, langId,"flaProTskCntCla")); //Untitled

out.print("&lbl_taskContext9=");
out.print(LabelManager.getName(labelSet, langId,"flaProTskWS")); //Untitled

out.print("&lbl_taskContext10=");
out.print(LabelManager.getName(labelSet, langId,"flaProTskHC")); //Untitled

out.print("&lbl_taskContext11=");
out.print(LabelManager.getName(labelSet, langId,"lblScheduler")); //Untitled

out.print("&lbl_eventStateWin=");
out.print(LabelManager.getName(labelSet, langId,"flaProEvtSta")); //Untitled

out.print("&att_IO_label=");
out.print(LabelManager.getName(labelSet, langId,"flaProInOut")); //Untitled

out.print("&lbl_EvtStaEvt=");
out.print(LabelManager.getName(labelSet, langId,"flaEve")); //Untitled

out.print("&lbl_EvtStaSta=");
out.print(LabelManager.getName(labelSet, langId,"flaProStatus")); //Untitled

out.print("&lbl_EvtStaCon=");
out.print(LabelManager.getName(labelSet, langId,"flaProCnd")); //Untitled

out.print("&lbl_EvtStaCon=");
out.print(LabelManager.getName(labelSet, langId,"flaProCnd")); //Untitled

out.print("&lbl_BindProcess=");
out.print(LabelManager.getName(labelSet, langId,"flaProBndPro")); //Untitled

out.print("&lbl_BindEntity=");
out.print(LabelManager.getName(labelSet, langId,"flaProBndEnt")); //Untitled

out.print("&lbl_BindParam=");
out.print(LabelManager.getName(labelSet, langId,"flaProPar")); //Untitled

out.print("&lbl_BindType=");
out.print(LabelManager.getName(labelSet, langId,"flaProBndTyp")); //Untitled

out.print("&lbl_BindValue=");
out.print(LabelManager.getName(labelSet, langId,"flaProBndVal")); //Untitled

out.print("&lbl_BindAttribute=");
out.print(LabelManager.getName(labelSet, langId,"flaProBndAtt")); //Untitled

out.print("&lbl_printProcess=");
out.print(LabelManager.getName(labelSet, langId,"flaProPrint")); //Untitled

out.print("&lbl_tskMulti=");
out.print(LabelManager.getName(labelSet, langId,"flaAttMult")); //Untitled

out.print("&lbl_procEntities=");
out.print(LabelManager.getName(labelSet, langId,"flaAttSubPro")); //Untitled

out.print("&lbl_cleanProcess=");
out.print(LabelManager.getName(labelSet, langId,"btnIni")); //Untitled

out.print("&lbl_PrcInitQ=");
out.print(LabelManager.getName(labelSet, langId,"msgPrcInitQ")); //Untitled

out.print("&lbl_wsBusEntAtt=");
out.print(LabelManager.getName(labelSet, langId,"lblwsBusEntAtt")); //Untitled

out.print("&lblWSName=");
out.print(LabelManager.getName(labelSet, langId,"lblWSName")); //Untitled

out.print("&lbl_wsBusProAtt=");
out.print(LabelManager.getName(labelSet, langId,"lblwsBusProAtt")); //Untitled

out.print("&lbl_presetTasksPanelTit=");
out.print(LabelManager.getName(labelSet, langId,"lblpresetTasksPanelTit")); //CUSTOM TASKS

out.print("&lbl_calendars=");
out.print(LabelManager.getName(labelSet, langId,"lblScheduler")); //TASK SCHEDULER

out.print("&lbl_asignTypes=");
out.print(LabelManager.getName(labelSet, langId,"lblTskSchAsgnType")); //SCHEDULER TYPE

out.print("&lbl_taskToSch=");
out.print(LabelManager.getName(labelSet, langId,"lblTskSchToSch")); //SCHEDULER TYPE

out.print("&lbl_taskContext12=");
out.print(LabelManager.getName(labelSet, langId,"lblSkipCondition")); //SKIP CONDITION
%>