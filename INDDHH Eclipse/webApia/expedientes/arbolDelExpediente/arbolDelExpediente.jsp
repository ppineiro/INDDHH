<%@include file="../../page/includes/startInc.jsp" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="com.dogma.Parameters"%>
<%@ page import="uy.com.st.adoc.expedientes.arbolExpediente.ArbolExpediente"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<html>
	<head>
		<%
		String expediente = request.getParameter("ee");
		
		UserData uData = ThreadData.getUserData();
		int environmentId = uData.getEnvironmentId();
		int currentLanguage = uData.getLangId();
		
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
		
		<meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>">		
		<title>Árbol del expediente</title>
		
		<link rel="stylesheet" type="text/css" href="_styles.css" media="screen">
		<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/common/modal.css" rel="stylesheet" type="text/css">
		<link href= "<%=Parameters.ROOT_PATH%>/css/documentum/execution/generalExecution.css" rel="stylesheet" type="text/css">
		
		<style type="text/css">
			
			a { color: #0679b8; }			
			a:hover { color: #8ab9ff; }
			
			div.divNotaContainer {
				margin: 14px;
			}
			
			label.nota {
				position: relative;
				background: url(exclametion.png);
				background-size: 16px;
				background-repeat: no-repeat;
				width: 16px;
				height: 16px;
				margin-bottom: 29px;
				font-size: 14px;
				font-family: Verdana,Arial,Tahoma;
				padding-left: 24px;
			}
			
			label.print {
				position: absolute;
    			top: 0%;
    			left: 165px;
    			cursor: pointer;
				background: url(print_blue.png);
				background-size: 16px;
				background-repeat: no-repeat;
				width: 16px;
				height: 16px;
				margin-bottom: 29px;
				font-size: 14px;
				font-family: Verdana,Arial,Tahoma;
				padding-left: 24px;
			}
			
		</style>	
		
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/expedientes/js/CustomJS-EXP-ELEC.js"></script>	
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-core-1.4.5-full-compat.js"></script>
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-more-1.4.0.1-compat.js"></script>
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/modal.js"></script>
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/generics.js"></script>
		
		<script language="javascript">		
			var TAB_ID_REQUEST 	= "<%=TAB_ID_REQUEST%>";
			var CONTEXT 		= "<%=Parameters.ROOT_PATH%>";	
					
			var BTN_CONFIRM		= '<system:label show="text" label="btnCon" forHtml="true" forScript="true"/>';
			var BTN_CANCEL		= '<system:label show="text" label="btnCan" forHtml="true" forScript="true"/>';
			
			var BTN_CLOSE		= '<system:label show="text" label="btnCer" forHtml="true" forScript="true"/>';
			
			function imprimir(){
				
				// BACKUPEAMOS
				var backup = document.body.innerHTML;
				
				// IMPRIMIMOS
				var nota = document.getElementById("nota");
				nota.style.background = "none";
				nota.style.paddingLeft = "0px";
				
				var parent_print = document.getElementById("E_1042");
				var child_print = document.getElementById("print");
				parent_print.removeChild(child_print);
				
				var carpetas_backup = document.getElementsByClassName("folder");
				var carpetas = document.getElementsByClassName("folder");
				for(var i = 0 ; i < carpetas.length ; i++){
					var check = carpetas[i].childNodes[0];
					carpetas[i].removeChild(check);
				}
				window.print();
				
				// RESTAURAMOS
				document.body.innerHTML = backup;
				
			}
			
		</script>
			
	</head>
	
	<body>
			<table border="0" width="100%" align="center" valign="top">
			
				<tr>	
					<td>	
						<div id="E_1042" class="formContainer fieldGroup">
							<div class="collapseForm" style="margin-top: 5px;"></div>
							<div class="title form-title">Árbol del expediente</div>
							<label id="print" title="imprimir árbol" class='print' onclick="imprimir(); return false;">
												
						</div>	
					</td>				
				</tr>
				
				<tr>
					<td>
						<div id='divNotaContainer' class='divNotaContainer'>
							<label id="nota" class='nota'>
							<b>Nota:</b> aquellas actuaciones que no generan folio, no son parte del árbol y por lo tanto no son visibles en el mismo.
							</label>					
						</div>
					</td>
				</tr>
						
			</table>			
			
			<%
			out.write(ArbolExpediente.getArbolAsString(expediente, tabId, tokenId));
			%>
	
	</body>
</html>