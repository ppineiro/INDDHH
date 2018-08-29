<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<%

//String tabId = request.getParameter("tabId");
//String tokenId = request.getParameter("tokenId");
int idCliente = Integer.parseInt(request.getParameter("idCliente"));
int idTarjetaCredito = Integer.parseInt(request.getParameter("idTarjetaCredito"));
String primerNombre = request.getParameter("primerNombre");
String primerApellido = request.getParameter("primerApellido");
String segundoNombre = request.getParameter("segundoNombre");
String segundoApellido = request.getParameter("segundoApellido");
String cedula = request.getParameter("cedula");
String email = request.getParameter("email");
String telefono = request.getParameter("telefono");
String direccionEnvio = request.getParameter("direccionEnvio");
int valorTransaccion = Integer.parseInt(request.getParameter("valorTransaccion"));
int cantidadCuotas = Integer.parseInt(request.getParameter("cantidadCuotas")) ;
int moneda= Integer.parseInt(request.getParameter("moneda"));
String numeroOrden = request.getParameter("numeroOrden");
String version = request.getParameter("version");
String plan = request.getParameter("plan");
String plazoEntrega = request.getParameter("plazoEntrega");
String fecha = request.getParameter("fecha");
String consumidorFinal = request.getParameter("consumidorFinal");//Integer.parseInt(request.getParameter("consumidorFinal"));
int importeGravado = Integer.parseInt(request.getParameter("importeGravado"));
int numeroFactura = Integer.parseInt(request.getParameter("numeroFactura"));
int tipoDocumento = Integer.parseInt(request.getParameter("tipoDocumento"));
String transactionSecurityToken = request.getParameter("transactionSecurityToken");

/*String[] numOrdSplit = numeroOrden.split("A");
String tabId = numOrdSplit[1];
String tokenId = numOrdSplit[2];*/

%>
<h1>Esta es la página de pagos.</h1>
<br/>

<form>
	
	<h3>Esto es lo que recibe PagosWeb</h3>
		
		<label>idCliente</label>
		<input type="text" name="idCliente" value="<%=idCliente%>">
		</br>
		<label>idTarjetaCredito</label>
		<input type="text" name="idTarjetaCredito" value="<%=idTarjetaCredito%>">
		</br>
		<label>primerNombre</label>
		<input type="text" name="primerNombre" value="<%=primerNombre%>">
		</br>
		<label>primerApellido</label>
		<input type="text" name="primerApellido" value="<%=primerApellido%>">
		</br>
		<label>segundoNombre</label>
		<input type="text" name="segundoNombre" value="<%=segundoNombre%>">
		</br>
		<label>segundoApellido</label>
		<input type="text" name="segundoApellido" value="<%=segundoApellido%>">
		</br>
		<label>cedula</label>
		<input type="text" name="cedula" value="<%=cedula%>">
		</br>
		<label>email</label>
		<input type="text" name="email" value="<%=email%>">
		</br>
		<label>telefono</label>
		<input type="text" name="telefono" value="<%=telefono%>">
		</br>
		<label>direccionEnvio</label>
		<input type="text" name="direccionEnvio" value="<%=direccionEnvio%>">
		</br>
		<label>valorTransaccion</label>
		<input type="text" name="valorTransaccion" value="<%=valorTransaccion%>">
		</br>
		<label>cantidadCuotas</label>
		<input type="text" name="cantidadCuotas" value="<%=cantidadCuotas%>">
		</br>
		<label>moneda</label>
		<input type="text" name="moneda" value="<%=moneda%>">
		</br>
		<label>numeroOrden</label>
		<input type="text" name="numeroOrden" value="<%=numeroOrden%>">
		</br>
		<label>version</label>
		<input type="text" name="version" value="<%=version%>">
		</br>
		<label>plan</label>
		<input type="text" name="plan" value="<%=plan%>">
		</br>
		<label>plazoEntrega</label>
		<input type="text" name="plazoEntrega" value="<%=plazoEntrega%>">
		</br>
		<label>fecha</label>
		<input type="text" name="fecha" value="<%=fecha%>">
		</br>
		<label>consumidorFinal</label>
		<input type="text" name="consumidorFinal" value="<%=consumidorFinal%>">
		</br>
		<label>importeGravado</label>
		<input type="text" name="importeGravado" value="<%=importeGravado%>">
		</br>
		<label>numeroFactura</label>
		<input type="text" name="numeroFactura" value="<%=numeroFactura%>">
		</br>
		<label>transactionSecurityToken</label>
		<input type="text" name="transactionSecurityToken" value="<%=transactionSecurityToken%>">
		</br>
		<label>tipoDocumento</label>
		<input type="text" name="tokenId" value="<%=tipoDocumento%>">
		</br>
		
		


</form>
<%

	String ventaAprobada = "True";
	String numeroTransaccion = "1234";
	String monto = "300";
	String codigoAutorizacion = "4321";
	String mensaje = "Venta Aprobada";
	String Fecha = "2016-02-0102:59:36";
	String responseSecurityToken = "KDMkSR5HZ2AgeNzRkQofl8tY6SIPRHJT93gr11CJJPZKX1SsQ18Ep8r3WNlZkuJOpqkrrmOCFT1P+E9jJs8a8xV6boi9WPMguc+6TVdHu4E=";
	//Texto plano: True12343004321Venta Aprobada38A1454345789051A1454345785819160201025936=
	//KeyComercio = Y8LpWzag8MliH0PSXwijck+rh2wwsCi8

	String urlResultado = "http://localhost:8881/Apia/";

	if(mensaje.equals("Venta Aprobada"))
			urlResultado +=  "responsePagosWebServletCompraAprobada";
	if(mensaje.equals("Venta Cancelada"))
			urlResultado +=  "responsePagosWebServletCompraCancelada";
	if(mensaje.equals("Venta Rechazada"))
			urlResultado +=  "responsePagosWebServletCompraRechazada";
	if(mensaje.equals("Notificación OffLine"))
			urlResultado +=  "responsePagosWebServletNotificacionOffLine";
	
%>



<form method="POST" action="<%=urlResultado%>">
	<h3>Esto es lo que devuelve PagosWeb</h3>

	<label>ventaAprobada</label>
	<input type="text" name="ventaAprobada" value="<%=ventaAprobada%>">
	</br>
	<label>codigoAutorizacion</label>
	<input type="text" name="codigoAutorizacion" value="<%=codigoAutorizacion%>">
	</br>
	<label>numeroTransaccion</label>
	<input type="text" name="numeroTransaccion" value="<%=numeroTransaccion%>">
	</br>
	<label>monto</label>
	<input type="text" name="monto" value="<%=monto%>">
	</br>
	<label>mensaje</label>
	<input type="text" name="mensaje" value="<%=mensaje%>">
	</br>
	<label>numeroOrden</label>
	<input type="text" name="numeroOrden" value="<%=numeroOrden%>">
	</br>
	<label>idCliente</label>
	<input type="text" name="idCliente" value="<%=idCliente%>">
	</br>
	<label>Fecha</label>
	<input type="text" name="Fecha" value="<%=Fecha%>">
	</br>
	<label>cantidadCuotas</label>
	<input type="text" name="cantidadCuotas" value="<%=cantidadCuotas%>">
	</br>
	<label>responseSecurityToken</label>
	<input type="text" name="responseSecurityToken" value="<%=responseSecurityToken%>">
	</br>
	
<input type="submit">

</form>
</body>
</html>