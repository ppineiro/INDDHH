<%@ page contentType="text/html; charset=iso-8859-1" language="java"%><%@page import="com.dogma.UserData"%><%@include file="../../components/scripts/server/startInc.jsp" %><%
	UserData usrData = BasicBeanStatic.getUserDataStatic(request);
	Integer ident = usrData.getLangId();
%><% if (ident==1){%><a class="skbServices" href="http://www.statum.info/ViewItemAction.do?action=view&id=829&langId=1">ApiaMonitor</a><br><a class="skbServices" href="http://www.statum.info/ViewItemAction.do?action=view&id=518&langId=1">Instalación de ApiaMonitor</a><br><a class="skbServices" href="http://www.statum.info/ViewItemAction.do?action=view&id=763&langId=1">Configuración de ApiaMonitor</a><% }else if (ident==3){%><a class="skbServices" href="http://www.statum.info/ViewItemAction.do?action=view&id=829&langId=2">ApiaMonitor</a><br><a class="skbServices" href="http://www.statum.info/ViewItemAction.do?action=view&id=518&langId=2">Installation of ApiaMonitor</a><br><a class="skbServices" href="http://www.statum.info/ViewItemAction.do?action=view&id=763&langId=2">Configuration of ApiaMonitor</a><br><% }else if (ident==2){%><a class="skbServices" href="http://www.statum.info/ViewItemAction.do?action=view&id=829&langId=3">ApiaMonitor</a><br><a class="skbServices" href="http://www.statum.info/ViewItemAction.do?action=view&id=518&langId=3">Instalação do ApiaMonitor</a><br><a class="skbServices" href="http://www.statum.info/ViewItemAction.do?action=view&id=763&langId=3">Configuração do ApiaMonitor</a><br><% }%>
