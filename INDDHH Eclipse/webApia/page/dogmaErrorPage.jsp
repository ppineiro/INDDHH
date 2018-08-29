<%@page import="com.st.util.StringUtil"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.UserData"%><%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@ page isErrorPage="true" import="java.io.*"%><%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@page import="com.dogma.Configuration"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.DogmaException"%><%

String rootPath = Parameters.ROOT_PATH;
String strHeaderName = "";

for(java.util.Enumeration e = request.getHeaderNames();e.hasMoreElements() ;){
	String name=(String)e.nextElement();
  strHeaderName +="\n"+name +"="+request.getHeader(name)+" - ";
}

System.out.println("DOGMA ERROR PAGE "+rootPath+" "+request.getHeader("url")+" "+strHeaderName) ;
Object obj = request.getAttribute("javax.servlet.forward.request_uri");
String str = (obj == null) ? null : obj.toString();

if(str!=null){
	System.out.println("Requested URI:" + str); 
}
	
String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);
String styleDirectory = "default";
boolean envUsesEntities = false;
Integer environmentId = null;
UserData uData = BasicBeanStatic.getUserDataStatic(request);
Exception rootException = null;
if (uData != null) {
	envUsesEntities = uData.isEnvUsesEntities();
	environmentId = uData.getEnvironmentId();
	labelSet = uData.getStrLabelSetId();
	styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
}
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><link href="<system:util show="context" />/css/base/pages/error/main.css" rel="stylesheet" type="text/css" /><style type="text/css">
			.message{
				background-color: rgb(249, 237, 184);
			    border: 1px solid rgb(237, 201, 103);
		    	color: #707070;
		    	padding: 5px 20px;
		    	width: 68%;
		    	margin-left: 10%;
		    	text-align: center;
    		}
			.outer {
			    display: table;
			    position: absolute;
			    height: 100%;
			    width: 100%;
			}
			.middle {
			    display: table-cell;
			    vertical-align: middle;
			}
			.inner {
			    margin-left: auto;
			    margin-right: auto; 
			    width: /*whatever width you want*/;
			}
	
		</style></head><body><%if(Configuration.SERVER_MODE){ %><div id="bodyDiv"><div class="outer"><div class="middle"><div class="inner"><div class="message"><%=LabelManager.getName(labelSet,"msgDogmaErrorPageText") %></div></div></div></div></div><%}else{ %><div class="divContent"><div class="subTit">EXCEPTION</div><div class="section"><div class="dataTit">Apia Version:</div><div class="data"><%=com.dogma.DogmaConstants.APIA_VERSION%></div></div><% if (exception != null) { %><div class="section"><div class="dataTit">Exception:</div><div class="data"><%=exception.getClass().getName()%></div></div><%
					if (exception instanceof ServletException) {
						if( ((ServletException)exception).getRootCause() instanceof Exception ){
							rootException = (Exception) ((ServletException)exception).getRootCause();
						} 
					} else if (exception instanceof Throwable) {
							rootException = new Exception((Throwable) exception.getCause()); 
					}
					%><% } else { %><div class="section"><div class="dataTit">Exception:</div><div class="data">No Exception</div></div><% } %><% if (rootException != null) { %><div class="section"><div class="dataTit">Root Exception:</div><div class="data"><%=rootException.getClass().getName()%></div></div><% } else { %><div class="section"><div class="dataTit">Root Exception:</div><div class="data">No Root Exception</div></div><% } %><div class="section"><div class="dataTit">URL:</div><div class="data"><%=request.getRequestURI().toString()%></div></div><div class="section"><div class="dataTit">Original URL:</div><div class="data"><%=request.getAttribute("apia.original.url")%></div></div><div class="section"><div class="dataTit">QueryString:</div><div class="data"><%=StringUtil.escapeHTML(request.getQueryString())%></div></div><div class="section"><div class="dataTit">Type:</div><div class="data"><%if (request.getAttribute("CONTROLER") == null) {%>JSP<%} else {%>SUBMIT<%}%></div></div><% if (exception != null) { %><div class="section"><div class="dataTit">Message:</div><div class="data"><%=StringUtil.escapeHTML(rootException==null?exception.getMessage():rootException.getMessage())%></div></div><div class="section"><div class="dataTit">Localized Message:</div><div class="data"><%=StringUtil.escapeHTML(rootException==null?exception.getLocalizedMessage():rootException.getLocalizedMessage())%></div></div><% } else { %><div class="section"><div class="dataTit">Class:</div><div class="data">No Message</div></div><% } %><% if (rootException != null) {%><div class="subTit">ROOT CAUSE STACK TRACE</div><div class="stack"><%
						if (rootException != null) {
							if (rootException instanceof DogmaException) {
								DogmaException e = (DogmaException) rootException;
								com.dogma.bean.DogmaAbstractBean.logError(request, e.getCompleteStackTrace());
								out.print(StringUtil.escapeHTML(e.getCompleteStackTrace()));
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
								} 
								printWriter.flush();
								out.print(StringUtil.escapeHTML(byteArrayOut.toString()));
								com.dogma.bean.DogmaAbstractBean.logError(request, byteArrayOut.toString());
							}
						}
					%></div><%}%><div class="subTit">STACK TRACE</div><div class="stack"><%
						if (exception != null) {
							if (exception instanceof DogmaException) {
								DogmaException e = (DogmaException) exception;
								com.dogma.bean.DogmaAbstractBean.logError(request, e.getCompleteStackTrace());
								out.print(StringUtil.escapeHTML(e.getCompleteStackTrace()));
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
								}
								printWriter.flush();
								out.print(StringUtil.escapeHTML(byteArrayOut.toString()));
								if (rootException == null) {
									com.dogma.bean.DogmaAbstractBean.logError(request, byteArrayOut.toString());
								}
							}
						}
					%></div><%
					if (session.getAttribute("dBean") != null) {
						com.dogma.bean.DogmaAbstractBean absBean = (com.dogma.bean.DogmaAbstractBean) session.getAttribute("dBean");
						if (absBean.getDogmaException() != null) {
				%><div class="subTit">Bean Exception</div><div class="stack"><%=absBean.getDogmaException().getCompleteStackTrace()%></div><div class="stack"><%
							com.dogma.bean.DogmaAbstractBean.logError(request, absBean.getDogmaException().getCompleteStackTrace());
				%></div><%
						}
					}	
				%></div><%}%></body></html>
