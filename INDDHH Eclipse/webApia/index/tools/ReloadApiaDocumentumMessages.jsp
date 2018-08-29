<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO;"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Reload ApiaDocumentum Messages</title>

<script type="text/javascript">
	function actualizarForm() {
		var updation = document.getElementById("updationInput").value="update!";
        return true;
     }
</script>       
</head>
<br>
<body>
<%
	MensajeDAO mDao = new MensajeDAO();
	Boolean OK = mDao.reCargarMensajesEstaticos(1001, 1);
	
	if(OK){
		out.print("<b>Mensajes recargados correctamente.</b>");
	}else{
		out.print("<b>Ha ocurrido un error.</b>");
	}
%>

<br>
<br>
<input type="submit" value="Actualizar" onclick="return actualizarForm();"/>
  <table class="subform-content">
    <tr><td><br><input type="hidden" id="updationInput" name="updation"/></td></tr>
	<tr><td><br></td></tr>            
  </table>
</body>
</html>