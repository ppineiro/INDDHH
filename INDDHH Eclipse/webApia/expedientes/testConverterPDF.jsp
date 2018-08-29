<?xml version="1.0" ?>
<%@page import="java.util.*"%>
<%@page import="java.net.*"%>
<%@page import="uy.com.st.ConverterPDF.*"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="style.css" title="Style"/>
        <title>ApiaDocumentum Parameter Manager</title>   
        <script type="text/javascript">
			function checkForm() {
				var updation = document.getElementById("updationInput").value="update!";
                return true;
            }
        </script>
    </head>
    <body>
        <div id="converter-header"><h1>Test Converter PDF</h1></div> 
        <form action="" method="post" >    
	        <%
			if (!(new TestDisponibilidadWsPdf().test(1001,1))){
				out.print("<b> El servidor de PDF no se encuentra disponible. Cont\u00E1ctese con el administrador del sistema. ");
			}else{
				out.print("<b> El servidor de PDF funciona correctamente!");
			}
			%>
                <table class="subform-content">
                	<tr><td><br><input type="hidden" id="updationInput" name="updation"/></td></tr>
					<tr><td><br></td></tr>            
                </table>
			<input type="submit" value="Actualizar" onclick="return checkForm();"/>
        </form>
    </body>    
</html>
<%
//	}
%>
