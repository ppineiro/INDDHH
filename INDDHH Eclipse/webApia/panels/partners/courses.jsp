<%@ page contentType="text/html; charset=iso-8859-1" language="java"%><%@page import="com.dogma.UserData"%><%@include file="../../components/scripts/server/startInc.jsp" %><%
	UserData usrData = BasicBeanStatic.getUserDataStatic(request);
	Integer ident = usrData.getLangId();
%><% if (ident==1){%><a class="skbServices" href="http://www.statum.org/ATutor/about.php?lang=es">Cursos de Apia</a><br><% }else if (ident==3){%><a class="skbServices" href="http://www.statum.org/ATutor/about.php?lang=en">Apia Courses</a><br><% }else if (ident==2){%><a class="skbServices" href="http://www.statum.org/ATutor/about.php?lang=pt-br">Cursos do Apia</a><br><% }%>
