<%@ page contentType="text/html; charset=iso-8859-1" language="java"%><%@page import="com.dogma.UserData"%><%@include file="../../components/scripts/server/startInc.jsp" %><%
	UserData usrData = BasicBeanStatic.getUserDataStatic(request);
	Integer ident = usrData.getLangId();
%><% if (ident==1){%><a class="skbServices" href="http://www.statum.info/ViewItemAction.do?action=view&id=1238&langId=1">Manual de Apia Configuration Manager</a><br><% }else if (ident==3){%><a class="skbServices" href="http://www.statum.info/ViewItemAction.do?action=view&id=1238&langId=2">Apia Configuration Manager handbook</a><br><% }else if (ident==2){%><a class="skbServices" href="http://www.statum.info/ViewItemAction.do?action=view&id=1238&langId=3">Manual de Apia Configuration Manager</a><br><% }%>
