<%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@include file="../../../../components/scripts/server/includeStart.jsp"%><%
	String strScriptLoad = "";
	String strScriptSubmit = "";
	com.dogma.bean.query.MonitorTasksBean aBean = (com.dogma.bean.query.MonitorTasksBean) session.getAttribute("dBean");
	Collection forms = null;
	if("E".equals(request.getParameter("frmParent"))){
		forms = aBean.getEntInstanceBean().getForms(request);
	} else {
		forms = aBean.getProInstanceBean().getForms(request);
	}
	if (forms!=null){
		Iterator it = forms.iterator();
		while(it.hasNext()){
			com.dogma.bean.execution.FormBean fBean = (com.dogma.bean.execution.FormBean)it.next();
			out.println("<BR>");
			try{
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