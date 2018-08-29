<%@page import="com.dogma.vo.TskLanguagesVo"%><%@page import="java.util.ArrayList"%><%@page import="com.dogma.vo.LanguageVo"%><%@page import="java.util.Collection"%><%@page import="com.dogma.vo.TaskVo"%><%@page import="biz.statum.apia.web.bean.monitor.TasksBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.monitor.TasksAction"%><div class="tabContent"><%


String strScriptLoad = "";
String strScriptBeforePrint = "";
String strScriptAfterPrint = "";

HttpServletRequestResponse http = new HttpServletRequestResponse(request, response);
TasksBean tBean = TasksAction.staticRetrieveBean(http);

// TaskVo taskVo = tBean.getTaskVo();
// Collection<LanguageVo> tskTradLang = null;
// if(taskVo != null && taskVo.getTskLanguages() != null) {
// 	tskTradLang = new ArrayList<LanguageVo>();
// 	for(TskLanguagesVo lang : taskVo.getTskLanguages()) {
// 		LanguageVo langVo = new LanguageVo();
// 		langVo.setLangId(lang.getLangId());
// 		langVo.setLangName(lang.getLangName());
// 		tskTradLang.add(langVo);
// 	}
// }

// request.setAttribute("tskTradLang", tskTradLang);
// System.out.println("Escribiendo los tskTradLang en detailsForms.jsp");

Object tskTradLangObj = request.getAttribute("tskTradLang");
Collection<LanguageVo> tskTradLang = null;
if(tskTradLangObj != null)
	tskTradLang = (Collection<LanguageVo>)tskTradLangObj;


boolean hasReqSign = false;
boolean stop = false;
while(!stop){
 
	 biz.statum.apia.web.bean.execution.FormBean fBean = tBean.getNextUnprocessedForm(http);
 
 	if(fBean == null){
 		stop = true;
 		continue;
 	}
 	
		
	if(fBean.getFormDefinition().getFlagValue(com.dogma.vo.FormVo.FLAG_SIGNABLE_REQ) && !fBean.onlyVerifySignature()){
		hasReqSign = true;	
	}
	
	%><div id="<%=request.getParameter("frmParent")%>_<%=fBean.getFormDefinition().getFrmId()%>" class="formContainer" xml="<%out.print(fBean.getFullXML(request, response, tskTradLang));%>"></div><%
	
	if(fBean.hasOnload && fBean.firstLoad){
		strScriptLoad +=  fBean.getOnLoadName() + ";\n";
	}
	
	if(fBean.hasOnReload && !fBean.firstLoad){
		strScriptLoad +=  fBean.getOnReloadName() + ";\n";
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

tBean.clearProcessedForms(http);

String strScript = (String)request.getAttribute("FRM_SCRIPT");

if(strScript==null){
	strScript="";
}

StringBuffer strBuf = new StringBuffer(strScript);

strBuf.append("\n<script language=\"javascript\">\n");
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
	strBuf.append("if(!getRequiredToSignFields_E()){return false;}\n");
} else {
	strBuf.append("function submitFormsData_P(){\n");
	strBuf.append("if(saving){return true;}");
	strBuf.append("if(!getRequiredToSignFields_P()){return false;}\n");
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