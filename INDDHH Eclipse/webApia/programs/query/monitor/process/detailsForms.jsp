<%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@include file="../../../../components/scripts/server/includeStart.jsp"%><%
	String strScriptLoad = "";
	String strScriptSubmit = "";
	Object dBean = session.getAttribute("dBean");
	com.dogma.bean.query.MonitorProcessesBean aBean = (dBean instanceof com.dogma.bean.query.MonitorProcessesBean) ? ((com.dogma.bean.query.MonitorProcessesBean) dBean) : ((com.dogma.bean.query.MonitorBusinessBean) dBean).getMonitorProcessesBean();
	Collection formsToProcess = null;
	if("E".equals(request.getParameter("frmParent"))){
		formsToProcess = aBean.getEntInstanceBean().getForms(request);
	} else {
		formsToProcess = aBean.getProInstanceBean().getForms(request);
	}
	
 
	
			boolean stop = false;
			while(!stop){
				com.dogma.bean.execution.FormBean fBean = null;
				if("E".equals(request.getParameter("frmParent"))){
					fBean = aBean.getEntInstanceBean().getNextUnprocessedForm(request);
				} else {
					fBean = aBean.getProInstanceBean().getNextUnprocessedForm(request);
				}
				if(fBean == null){
					stop = true;
					continue;
				}
				//com.dogma.bean.execution.FormBean fBean = (com.dogma.bean.execution.FormBean)it.next();
				out.println("<BR>");
				try{
					fBean.setFromMonitor(true);
					out.println(fBean.getForm(request));
					
					if(fBean.hasOnload && fBean.firstLoad){
						strScriptLoad +=  fBean.getOnLoadName() + ";\n";
					}
					
					if(fBean.hasOnReload && !fBean.firstLoad){
						strScriptLoad +=  fBean.getOnReloadName() + ";\n";
					}
					
					if(fBean.hasOnSubmit){
						strScriptSubmit += "boolContinue = boolContinue & " + fBean.getOnSubmitName() + ";\n";
					}
					fBean.firstLoad = false;
				} catch (Exception e) {
					out.println("***** ERROR FORM NOT LOADED ****" );
					out.println("<BR>" + e.getMessage() + "<BR>");			
					out.println(" View standard output for more information " );	
					e.printStackTrace();
				}
			}

			if("E".equals(request.getParameter("frmParent"))){
				aBean.getEntInstanceBean().clearProcessedForms(request);
			} else {
				aBean.getProInstanceBean().clearProcessedForms(request);
			}

	String strScript = (String)request.getAttribute("FORM_SCRIPTS");

	if(strScript==null){
		strScript="";
	}
	
	StringBuffer strBuf = new StringBuffer(strScript);

	strBuf.append("\n<script language=\"javascript\" defer=\"true\">\n");
	strBuf.append("window.onload=function(){\n");
	
	strBuf.append(strScriptLoad);
	strBuf.append("}\n");
	if("E".equals(request.getParameter("frmParent"))){
		strBuf.append("function submitFormsData_E(){\n");
	} else {
		strBuf.append("function submitFormsData_P(){\n");
	}
	strBuf.append("var boolContinue = true;\n");
	strBuf.append(strScriptSubmit);
	strBuf.append("if(boolContinue){\n");
	strBuf.append("return true;\n");
	strBuf.append("} else {\n");
	strBuf.append("return false;\n");
	strBuf.append("}\n");
	strBuf.append("}\n");
	strBuf.append("</script>\n");
	//request.setAttribute("FORM_SCRIPTS",strBuf.toString());
	out.print(strBuf.toString());
%><%@include file="../../../../components/scripts/server/includeEnd.jsp"%>