<%@page import="com.dogma.Configuration"%><%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

if(!"DISABLED".equals(Configuration.X_FRAME_OPTIONS))
	response.addHeader("x-frame-options", Configuration.X_FRAME_OPTIONS);

String defer=(request.getHeader("User-Agent").indexOf("MSIE")>=0)?" defer=\"true\"":"";
%><!DOCTYPE html>