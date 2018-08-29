<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

String defer=(request.getHeader("User-Agent").indexOf("MSIE")>=0)?" defer=\"true\"":"";
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">