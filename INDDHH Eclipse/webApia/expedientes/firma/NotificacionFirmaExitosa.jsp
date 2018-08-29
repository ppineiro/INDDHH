<%@page import="uy.com.st.adoc.expedientes.firmaDSS.ResponseDSSController"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="java.util.Date"%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
%>
<% 
String path = Parameters.ROOT_PATH;
String idProceso = request.getParameter("idProceso");
String tsk = request.getParameter("tsk");
%>
<!DOCTYPE HTML>
<HTML>	
	<HEAD>
	<script>
	function closeCoesysSignWindow() {		
			window.returnValue = "OK";			
			setTimeout(function(){				
				var btn = parent.document.getElementById('btnConf');
				if(!btn) {
					btn = parent.document.getElementById('btnConf');
				} 
				
				btn.removeAttribute('disabled');
				btn.click();				
// 				window.close();
				frameElement.fireEvent('confirmModal');

			},200);		
	}
	
	
	function closeWindow() {			
// 			var btn = parent.document.getElementById("btnExit");
// 			if(!btn) {
// 				btn = parent.document.getElementById("btnExit");
// 			}
// 			btn.removeAttribute('disabled');
// 			btn.click();
// 			window.close();	
		frameElement.fireEvent('confirmModal');

	}
	
	</script>
	
	</HEAD>	
	<BODY>
		
		<!-- ARRANCA EL MENSAJE DE NOTIFICACIÓN-->
		<div style="
				border-color: #c1e0b4;
				background: #ecf6e8;
				width: 100%;
				box-sizing: border-box;
				border-width: 1px;
				border-style: solid;
				margin: 0 auto;
				margin-bottom: 25px;
				border-radius: 2px;">
            <div style="
					display: table-cell;
					vertical-align: middle;
					padding: 0 35px;
					padding-right: 30px;">
                <span>
                	<img src="expedientes/firma/NOTIFICACION.png" width=51px height=46px align="left">						
				</span>
            </div>
            <div style="
					display: table-cell;
					padding: 20px;
					padding-left: 0;">
                <span style="
					    display: block;
						font-weight: bold;
						font-size: 1.25em;
						margin-bottom: 5px;
						line-height: 1.1;">Documento firmado correctamente.</span>
                <p>Haga clic en Completar para firmar.</p>
            </div>
        </div>
		<!-- TERMINAR EL MENSAJE DE NOTIFICACIÓN-->		
        <!--<button style="display: block; float: right; margin: 5px 3px 0 3px; width: 160px; font: 13px Verdana, Arial, Helvetica, sans-serif; cursor: pointer; padding: 5px 5px; color: #fff; background: #0B72B5; border: 1px solid #0B72B5; border-radius: 3px; box-shadow: 0 2px 0 #1a2f5a; position: relative; text-align: center; text-decoration: none; text-shadow: 1px 1px 0px #02547F; transition: background 0.5s ease 0s;" id="Confirmar" onclick="closeCoesysSignWindow()">Completar</button>
        <button style="display: block; float: right; margin: 5px 3px 0 3px; width: 160px; font: 13px Verdana, Arial, Helvetica, sans-serif; cursor: pointer; padding: 5px 5px; color: #fff; background: #0B72B5; border: 1px solid #0B72B5; border-radius: 3px; box-shadow: 0 2px 0 #1a2f5a; position: relative; text-align: center; text-decoration: none; text-shadow: 1px 1px 0px #02547F; transition: background 0.5s ease 0s;" id="Close" onclick="closeWindow()">Salir</button>
		-->
		
		<td> <button style="display: block; position:absolute; bottom: 5px; right: 55px; margin: 5px 3px 0 3px; border: 1px solid; border-radius: 3px;" id="Confirmar" onclick="closeCoesysSignWindow()">Completar</button></td>
        <td> <button style="display: block; position:absolute; bottom: 5px; right: 10px; margin: 5px 3px 0 3px; border: 1px solid; border-radius: 3px;" id="Close" onclick="closeWindow()">Salir</button></td>

	</BODY>	
</HTML>