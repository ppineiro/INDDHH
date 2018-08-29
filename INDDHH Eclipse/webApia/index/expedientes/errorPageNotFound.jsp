<%@page import="java.util.ArrayList" %>
<%@page import="com.dogma.Parameters"%>


<HTML> 
<head>
<style type="text/css">
 table { 
    width: 40%; 
    height: 40%; 
    margin-left: 30%; 
    margin-right: 30%; 
    margin-top: 10%; 
    margin-bottom: 10%; 
    font-family: sans-serif; 
    text-align:left;
    color:navy;
    border:thick;
    border-top-style: double;
    border-bottom-style: double;
 } 

</style> 
</head>
<body class="listBody">
<div class="datagrid">
<table>

<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setDateHeader("Expires",-1); 
	int envId=1001;
%>
<img src="../images/uploaded/1671113615.png" width=25% height="auto">

 <tbody>
	<tr>
		<td></td>
		<%
			out.println("<tr><td>");
			out.println("<b>ERROR 404</b> <br><br>");
			out.println("Página no encontrada. <br><br><br>");
		%>
	<link href="<%=Parameters.ROOT_PATH%>/Apia/programs/login/login.jsp" rel="styleSheet" type="text/css" media="screen">
   	</tr>
	<tr>
		<td>
			<img src="../images/icn_atencion.jpg" width=75px height=75px align="right">
		</td>
	</tr>
  </tbody>
 </table>
</div>

</body>
</html>

	