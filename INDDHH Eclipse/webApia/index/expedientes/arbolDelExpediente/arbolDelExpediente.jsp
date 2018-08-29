<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="uy.com.st.adoc.expedientes.arbolExpediente.ArbolExpediente"%>

<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1);

String expediente = request.getParameter("ee");

int environmentId = 1001;
int currentLanguage = 1;

	String tokenId = "";
	if (request.getParameter("tokenId")!=null){
		tokenId = request.getParameter("tokenId").toString();
	}
	String  tabId = "";
	if (request.getParameter("tabId")!=null){
		tabId = request.getParameter("tabId").toString();
	}
	String TAB_ID_REQUEST = "&tabId=" + tabId +"&tokenId=" + tokenId;

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" type="text/css" href="_styles.css" media="screen">
	<title>Árbol del expediente</title>
	
	
	<script language="javascript">
		var tokenId = "";
		<%if(tokenId != null){%>
			tokenId = "<%=tokenId%>";
		<%}%>
		var tabId = "";
		<%if(tabId != null){%>
			tabId = "<%=tabId%>";
		<%}%>
		var TAB_ID_REQUEST = "&tabId=" + tabId +"&tokenId=" + tokenId;
		var CONTEXT = "<%=com.dogma.Parameters.ROOT_PATH%>";	
				
	</script>			
	<link href="/Apia/css/documentum/generalExecution.css" rel="stylesheet" type="text/css">	
	<script type="text/javascript" src="../js/CustomJS-EXP-ELEC.js"></script>
	<script type="text/javascript" src="/Apia/js/mootools-core-1.4.5-full-compat.js"></script>
	<script type="text/javascript" src="/Apia/js/mootools-more-1.4.0.1-compat.js"></script>
</head>
<body>
		<table border="0" width="100%" align="center" valign="top">
		<tr>	
			<td>	
				<div id="E_1042" class="formContainer fieldGroup">
					<div class="collapseForm"></div>
					<div class="title form-title">Árbol del expediente</div>					
				</div>	
			</td>
		</tr>
		</table>
<%
out.write(ArbolExpediente.getArbolAsString(expediente, tabId, tokenId));
%>

</body>
</html>