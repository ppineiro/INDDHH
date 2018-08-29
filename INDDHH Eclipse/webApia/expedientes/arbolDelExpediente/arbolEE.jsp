<%@page import="com.dogma.Parameters"%>

<html>
	
	<head>
	
		<%
		String tokenId = "";
		if (request.getParameter("tokenId")!=null){
			tokenId = request.getParameter("tokenId").toString();
		}
		String  tabId = "";
		if (request.getParameter("tabId")!=null){
			tabId = request.getParameter("tabId").toString();
		}
		String TAB_ID_REQUEST = "&tabId=" + tabId +"&tokenId=" + tokenId;
		String button = request.getParameter("button");
		
		String urlArbol = Parameters.ROOT_PATH + "/expedientes/arbolDelExpediente/arbolDelExpediente.jsp?ee=" + request.getParameter("nroEE") + TAB_ID_REQUEST;
		
		%>
		
		<script type="text/javascript">
			
			function showArbol() {
				document.getElementById('loadImg').style.display='none';
				document.getElementById('arbolFrame').style.display='block';
			}
			
		</script>
		
		<style type="text/css">
			#loadImg {
				width: 100%;
				height: 98%;			
			}
		
			#spinner {
				position: absolute;
				top: 46.5%;
				left: 46.5%;
			}
			
			#arbolFrame{
				width: 100%;
				height: 95%;
				display:none;
			}
			
		</style>
		
		
	</head>
	
	<body>
		<div id="loadImg"><div><img id="spinner" src="<%=Parameters.ROOT_PATH%>/css/documentum/img/spinner.gif"/></div></div>
		<iframe onload="showArbol()" id="arbolFrame" frameborder="0" class="tabContent" name="IFrameArbol123" src="<%=urlArbol%>">
		</iframe>
	</body>
	
</html>