<%@ page
  session="true"
  contentType="text/html; charset=ISO-8859-1"
%><%@include file="../../../components/scripts/server/startInc.jsp"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><%@page import="com.dogma.Parameters"%><%
boolean widgetBusy=((Boolean)(  (request.getSession().getAttribute("widgetBusy")!=null?request.getSession().getAttribute("widgetBusy"):new Boolean(false)))).booleanValue();
%><html><head><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/workArea.css" rel="styleSheet" type="text/css" media="screen"><title>JPivot is busy ...</title><meta http-equiv="refresh" content="1; URL=<c:out value="${requestSynchronizer.resultURI}"/><%="?" + request.getQueryString()%>"></head><body style="align:center;vertical-align:middle"><table style="width:475px;height:320px"><tr><td valign="middle"><p align="center"><%if (!widgetBusy){ %><img src="<%=Parameters.ROOT_PATH%>/jpivot/toolbar/wait.gif" alt="Wait" width="90px" height="60px"><%} %></p></td></tr></table></body></html>
