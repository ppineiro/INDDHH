<%@page import="com.dogma.DogmaException"%><%@page import="com.apia.core.CoreFacade"%><%@page import="java.util.ArrayList"%><%@page import="com.dogma.vo.LanguageVo"%><%@page import="com.dogma.vo.TskLanguagesVo"%><%@page import="java.util.Collection"%><%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><div class="tabContent"><%

com.dogma.UserData userData = BasicBeanStatic.getUserDataStatic(request);
String strScriptLoad = "";
String strScriptSubmit = "";
String strScriptBeforePrint = "";
String strScriptAfterPrint = "";

String afterName  = ""; //esto es para el monitor de entidades
if(request.getParameter("frmSource")!=null){
	afterName= request.getParameter("frmSource");
}

boolean lastStep = true;
Integer currentStep = new Integer(1);

biz.statum.apia.web.bean.BasicBean basicBean = null;
boolean isTask = "true".equals(request.getAttribute("isTask"));
if(!isTask) {
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_ADMIN_NAME);
} else {
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_EXEC_NAME);
}

biz.statum.apia.web.bean.execution.ExecutionBean aBean = null;

Collection<LanguageVo> tradLang = null;

if(basicBean instanceof biz.statum.apia.web.bean.execution.EntInstanceListBean){
	aBean = ((biz.statum.apia.web.bean.execution.EntInstanceListBean)basicBean).getEntInstanceBean();
	
// 	try {
// 		tradLang = CoreFacade.getInstance().getAllLanguages();
// 	} catch(DogmaException e) {}
	
	Object tskTradLang = request.getAttribute("tskTradLang");
	if(tskTradLang != null)
		tradLang = (Collection<LanguageVo>)tskTradLang;
	
} else if (basicBean instanceof biz.statum.apia.web.bean.execution.TaskBean){
	biz.statum.apia.web.bean.execution.TaskBean taskBean = (biz.statum.apia.web.bean.execution.TaskBean)basicBean;
	aBean = taskBean;
	
// 	if(taskBean.getTaskVo() != null && taskBean.getTaskVo().getTskLanguages() != null) {
// 		tradLang = new ArrayList<LanguageVo>();
// 		for(TskLanguagesVo lang : taskBean.getTaskVo().getTskLanguages()) {
// 			LanguageVo langVo = new LanguageVo();
// 			langVo.setLangId(lang.getLangId());
// 			langVo.setLangName(lang.getLangName());
// 			tradLang.add(langVo);
// 		}
// 	}

	Object tskTradLang = request.getAttribute("tskTradLang");
	if(tskTradLang != null)
		tradLang = (Collection<LanguageVo>)tskTradLang;
	
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.EntitiesBean){
	aBean = (biz.statum.apia.web.bean.monitor.EntitiesBean)basicBean;
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.BusinessBean){
	aBean = (biz.statum.apia.web.bean.monitor.BusinessBean)basicBean;
}

biz.statum.apia.web.bean.execution.TaskBean tBean = null;
if (aBean instanceof biz.statum.apia.web.bean.execution.TaskBean) {
	tBean = (biz.statum.apia.web.bean.execution.TaskBean) aBean;
	currentStep = tBean.getCurrentStep();
}

if(aBean instanceof biz.statum.apia.web.bean.execution.TaskBean){ 
	if (tBean !=null && tBean.getStepQty().intValue() > tBean.getCurrentStep().intValue()) {
		lastStep = false;
	}
}


boolean hasReqSign = false;
boolean stop = false;
while(!stop){
 
	 biz.statum.apia.web.bean.execution.FormBean fBean = aBean.getNextUnprocessedForm(request);
 
 	if(fBean == null){
 		stop = true;
 		continue;
 	}
 	if (currentStep == null || fBean.getFormStepId() == null || currentStep.equals(fBean.getFormStepId())) {
		if (tBean == null || tBean.evaluateFormCondition(fBean.getFormDefinition(),userData)) {
			
			//Formulario invisible no debe ser cargado
			if(fBean.hasProperty(com.dogma.vo.IProperty.PROPERTY_FORM_INVISIBLE)) {
				if(!fBean.hasProperty(com.dogma.vo.IProperty.PROPERTY_DONT_FIRE_EVENTS_WHEN_INVISIBLE))
					fBean.handleFormEvents(request,response);
				continue;
			}	
			
			if(fBean.getFormDefinition().getFlagValue(com.dogma.vo.FormVo.FLAG_SIGNABLE_REQ) && !fBean.onlyVerifySignature()){
				hasReqSign = true;	
			}
			
			%><div id="<%=afterName%><%=request.getParameter("frmParent")%>_<%=fBean.getFormDefinition().getFrmId()%>" class="formContainer" xml="<%out.print(fBean.getFullXML(request, response, tradLang));%>"></div><%
 			
 			if(fBean.hasOnload && fBean.firstLoad){
				strScriptLoad +=  fBean.getOnLoadName() + ";\n";
			}
			
			if(fBean.hasOnReload && !fBean.firstLoad){
				strScriptLoad +=  fBean.getOnReloadName() + ";\n";
			}
			
			if(fBean.hasOnSubmit){
				strScriptSubmit += "boolContinue = boolContinue & " + fBean.getOnSubmitName() + ";\n";
			}
			
			
			if(fBean.hasOnBeforePrint){
				strScriptBeforePrint += "boolContinue = boolContinue & " + fBean.getOnBeforePrintName() + ";\n";
			}
			if(fBean.hasOnAfterPrint){
				strScriptAfterPrint += "boolContinue = boolContinue & " + fBean.getOnAfterPrintName() + ";\n";
			}
			

			fBean.firstLoad = false;
 			
 			//-guardar los scriptings en una variable de sesion para que sean cargados todos juntos
 			String script = (String)request.getAttribute("FRM_SCRIPT")!=null?(String)request.getAttribute("FRM_SCRIPT"):"";
 			script += fBean.getScript();
 			request.setAttribute("FRM_SCRIPT",script);
 			
 		}
 	}
 	

}

aBean.clearProcessedForms(request);

String strScript = (String)request.getAttribute("FRM_SCRIPT");

if(strScript==null){
	strScript="";
}

StringBuffer strBuf = new StringBuffer(strScript);

strBuf.append("\n<script language=\"javascript\" DEFER>\n");
strBuf.append("\nvar saving = false;\n");
if("E".equals(request.getParameter("frmParent"))){
	strBuf.append("function frmOnloadE(){\n");
} else {
	strBuf.append("function frmOnloadP(){\n");
}
strBuf.append(strScriptLoad);
strBuf.append("}\n");
if("E".equals(request.getParameter("frmParent"))){
	strBuf.append("function submitFormsData_E(){\n");
	strBuf.append("if(saving){return true;}");
// 	strBuf.append("if(!getRequiredToSignFields_E()){return false;}\n");
} else {
	strBuf.append("function submitFormsData_P(){\n");
	strBuf.append("if(saving){return true;}");
// 	strBuf.append("if(!getRequiredToSignFields_P()){return false;}\n");
}
strBuf.append("var boolContinue = true;\n");
strBuf.append(strScriptSubmit);
strBuf.append("if(boolContinue){\n");
strBuf.append("return true;\n");
strBuf.append("} else {\n");
strBuf.append("return false;\n");
strBuf.append("}\n");
strBuf.append("}\n");//end function


if("E".equals(request.getParameter("frmParent"))){
	strBuf.append("function beforePrintFormsData_E(){\n");
} else {
	strBuf.append("function beforePrintFormsData_P(){\n");
}
strBuf.append("var boolContinue = true;\n");
strBuf.append(strScriptBeforePrint);
strBuf.append("if(boolContinue){\n");
strBuf.append("return true;\n");
strBuf.append("} else {\n");
strBuf.append("return false;\n");
strBuf.append("}\n");
strBuf.append("}\n");//end function

if("E".equals(request.getParameter("frmParent"))){
	strBuf.append("function afterPrintFormsData_E(){\n");
} else {
	strBuf.append("function afterPrintFormsData_P(){\n");
}
strBuf.append("var boolContinue = true;\n");
strBuf.append(strScriptAfterPrint);
strBuf.append("if(boolContinue){\n");
strBuf.append("return true;\n");
strBuf.append("} else {\n");
strBuf.append("return false;\n");
strBuf.append("}\n");
strBuf.append("}\n");//end function


if("E".equals(request.getParameter("frmParent"))){
	strBuf.append("function getRequiredToSignFields_E(){\n");
}else{
	strBuf.append("function getRequiredToSignFields_P(){\n");
}
if(hasReqSign){
strBuf.append("if(signedOK!='true'){showMessage(MSG_REQ_SIGNATURE_FORM, GNR_TIT_WARNING, 'modalWarning'); return false;} else {return true;}");
}else{
	strBuf.append("return true;");
}
strBuf.append("}\n"); //end function
	
strBuf.append("</script>\n");

request.setAttribute("FRM_SCRIPT",strBuf.toString());
%></div>