<%@page import="com.st.util.labels.LabelManager"%><%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@ page isErrorPage="true" import="java.io.*"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.DogmaException"%><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/winSizer.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/util.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/scriptBehaviors.js"<%if(request.getHeader("User-Agent").indexOf("MSIE")>=0){ %> defer="true"<%}%>></script><%

String rootPath = Parameters.ROOT_PATH;
String strHeaderName = "";
for(java.util.Enumeration e = request.getHeaderNames();e.hasMoreElements() ;){
	String name=(String)e.nextElement();
  strHeaderName +="\n"+name +"="+request.getHeader(name)+" - ";
}

	System.out.println("DOGMA ERROR PAGE "+rootPath+" "+request.getHeader("url")+" "+strHeaderName) ;
	String str = request.getAttribute("javax.servlet.forward.request_uri").toString();
	if(str!=null){
		System.out.println("Requested URI:" + str); 
	}
	
	String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);
	String styleDirectory = "default";
	boolean envUsesEntities = false;
	Integer environmentId = null;
	com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
	Exception rootException = null;
	if (uData != null) {
		envUsesEntities = uData.isEnvUsesEntities();
		environmentId = uData.getEnvironmentId();
		labelSet = uData.getStrLabelSetId();
		styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
	}
%><script language="javascript">
var windowId        = "";
</script><script defer="true">
	try {
		hideResultFrame();
	} catch (e) {} 
</script><%@page import="com.dogma.Configuration"%><HTML><head><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/workArea.css" rel="styleSheet" type="text/css" media="screen"></head><body <% if (request.getParameter("mdlTarget") != null) {%> style="BORDER:2px groove white;" <% } %>><%if(Configuration.SERVER_MODE){ %><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Error</TD><TD></TD></TR></TABLE><div class="divContent" id="divContent"><table width="98%" class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td colspan=2><DIV class="subTit"><%=LabelManager.getName(labelSet,"msgDogmaErrorPageText") %></DIV></td><td colspan=2></td></tr><tr><td colspan=2><a href="#" onclick="goLogin()">Login</a></td><td colspan=2></td></tr></table></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" accesskey="Sair" title="Sair" onclick="splash()">Salir</button></TD></TR></TABLE><%}else{ %><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Error</TD><TD></TD></TR></TABLE><div class="divContent" id="divContent"><table width="98%" class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td colspan=2><DIV class="subTit">EXCEPTION</DIV></td></tr><tr><td class="readOnly">Apia Version:</td><td colspan=3><%=com.dogma.DogmaConstants.APIA_VERSION%></td></tr><% if (exception != null) { %><tr><td class="readOnly">Exception:</td><td colspan=3><%=exception.getClass().getName()%></td></tr><%
				if (exception instanceof ServletException) {
					if( ((ServletException)exception).getRootCause() instanceof Exception ){
						rootException = (Exception) ((ServletException)exception).getRootCause();
					} 
				} else if (exception instanceof Throwable) {
						rootException = new Exception((Throwable) exception.getCause()); 
				}
				%><% } else { %><tr><td class="readOnly">Exception:</td><td colspan=3>No Exception</td></tr><% } %><% if (rootException != null) { %><tr><td class="readOnly">Root Exception:</td><td colspan=3><%=rootException.getClass().getName()%></td></tr><% } else { %><tr><td class="readOnly">Root Exception:</td><td colspan=3>No Root Exception</td></tr><% } %><tr><td class="readOnly">URL:</td><td colspan=3><%=request.getRequestURI().toString()%></td></tr><tr><td class="readOnly">Original URL:</td><td colspan=3><%=request.getAttribute("apia.original.url")%></td></tr><tr><td class="readOnly">QueryString:</td><td colspan=3><%=request.getQueryString()%></td></tr><tr><td class="readOnly">Type:</td><td colspan=3><%if (request.getAttribute("CONTROLER") == null) {%>JSP<%} else {%>SUBMIT<%}%></td></tr><% if (exception != null) { %><tr><td class="readOnly">Message:</td><td colspan=3><%=rootException==null?exception.getMessage():rootException.getMessage()%></td></tr><tr><td class="readOnly">Localized Message:</td><td colspan=3><%=rootException==null?exception.getLocalizedMessage():rootException.getLocalizedMessage()%></td></tr><% } else { %><tr><td class="readOnly">Class:</td><td colspan=3>No Message</td></tr><% } %><% if (rootException != null) {%><tr><td colspan=2><DIV class="subTit">ROOT CAUSE STACK TRACE</DIV></td></tr></table><table><tr><td style="FONT-FAMILY:Tahoma, Verdana, Arial;FONT-SIZE:8pt;"><pre><%
					if (rootException != null) {
						if (rootException instanceof DogmaException) {
							DogmaException e = (DogmaException) rootException;
							com.dogma.bean.DogmaAbstractBean.logError(request, e.getCompleteStackTrace());
							out.print(e.getCompleteStackTrace());
					  	} else {
							ByteArrayOutputStream byteArrayOut = new ByteArrayOutputStream();
							PrintWriter printWriter = new PrintWriter(byteArrayOut);
							rootException.printStackTrace(printWriter);
							//para que ande en jdk 1.3 (iplanet) lo tuve que sacar
							if (rootException.getCause() != null) {
								printWriter.println();
								printWriter.print("\n\n");
								printWriter.println("NATIVE_MSG\n");
								rootException.getCause().printStackTrace(printWriter);
							} /* else if (exception instanceof org.apache.jasper.JasperException) {
									if (((org.apache.jasper.JasperException)rootException).getRootCause() != null) {
										printWriter.println();
										printWriter.print("\n\n");
										printWriter.println("ROOT_MSG\n");
										((org.apache.jasper.JasperException)exception).getRootCause().printStackTrace(printWriter);
									}
								} */ else {
							}
							printWriter.flush();
							out.print(byteArrayOut.toString());
							com.dogma.bean.DogmaAbstractBean.logError(request, byteArrayOut.toString());
						}
					}
				%></pre></table><table width="100%" class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%}%><tr><td colspan=2><DIV class="subTit">STACK TRACE</DIV></td></tr></table><table><tr><td style="FONT-FAMILY:Tahoma, Verdana, Arial;FONT-SIZE:8pt;"><pre><%
					if (exception != null) {
						if (exception instanceof DogmaException) {
							DogmaException e = (DogmaException) exception;
							com.dogma.bean.DogmaAbstractBean.logError(request, e.getCompleteStackTrace());
							out.print(e.getCompleteStackTrace());
					  	} else {
							ByteArrayOutputStream byteArrayOut = new ByteArrayOutputStream();
							PrintWriter printWriter = new PrintWriter(byteArrayOut);
							exception.printStackTrace(printWriter);
							//para que ande en jdk 1.3 (iplanet) lo tuve que sacar
							if (exception.getCause() != null) {
								printWriter.println();
								printWriter.print("\n\n");
								printWriter.println("NATIVE_MSG\n");
								exception.getCause().printStackTrace(printWriter);
							} /* else if (exception instanceof org.apache.jasper.JasperException) {
									if (((org.apache.jasper.JasperException)exception).getRootCause() != null) {
										printWriter.println();
										printWriter.print("\n\n");
										printWriter.println("ROOT_MSG\n");
										((org.apache.jasper.JasperException)exception).getRootCause().printStackTrace(printWriter);
									}
								} */ else {
							}
							printWriter.flush();
							out.print(byteArrayOut.toString());
							if (rootException == null) {
								com.dogma.bean.DogmaAbstractBean.logError(request, byteArrayOut.toString());
							}
						}
					}
				%></pre></td></tr><%
				if (session.getAttribute("dBean") != null) {
					com.dogma.bean.DogmaAbstractBean absBean = (com.dogma.bean.DogmaAbstractBean) session.getAttribute("dBean");
					if (absBean.getDogmaException() != null) {
			%><tr><td><DIV class="subTit">Bean Exception</div></td></tr><tr><td  style="FONT-FAMILY:Tahoma, Verdana, Arial;FONT-SIZE:8pt;"><pre><%=absBean.getDogmaException().getCompleteStackTrace()%></pre></td></tr><%
						com.dogma.bean.DogmaAbstractBean.logError(request, absBean.getDogmaException().getCompleteStackTrace());
					}
				}	
			%></table></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" accesskey="Sair" title="Sair" onclick="splash()">Salir</button></TD></TR></TABLE><%}%></body></html><script defer=true>
	try {
		hideResultFrame();
	} catch (e) {} 
</script><script language="javascript"><% if (request.getParameter("mdlTarget") != null) { %>
	window.parent.document.getElementById("iframeMessages").hideResultFrame();
	window.parent.document.getElementById("iframeResult").showResultFrame(window.parent.document.getElementById("iframeMessages").getBody());
	function splash() {
		window.parent.document.getElementById("iframeResult").hideResultFrame()
	}
	<% } %>

	function goLogin(){
		window.top.location.href= "<%=rootPath%>/programs/login/login.jsp";	
	}
</script>
