<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%><%@page import="java.util.Date"%><%@page import="com.dogma.UserData"%><%@include file="../../components/scripts/server/startInc.jsp" %><%
	UserData usrData = BasicBeanStatic.getUserDataStatic(request);
	Integer ident = usrData.getLangId();
%><% if (ident==1){%><a class="skbServices" href="ViewItemAction.do?action=view&id=437">Manual de usuario de ApiaTester</a><br><% }else if (ident==3){%><a class="skbServices" href="ViewItemAction.do?action=view&id=437">ApiaTester user´s handbook</a><br><% }else if (ident==2){%><a class="skbServices" href="ViewItemAction.do?action=view&id=437">Manual do ApiaTester</a><br><% }%>
