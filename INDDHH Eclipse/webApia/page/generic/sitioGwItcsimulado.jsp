<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>GW itc</title>
</head>
<body>

<%

//String tabId = request.getParameter("tabId");
//String tokenId = request.getParameter("tokenId");
Double IdSol = Double.parseDouble(request.getParameter("IdSol"));
int IdTramite = Integer.parseInt(request.getParameter("IdTramite"));
int Cantidad = Integer.parseInt(request.getParameter("Cantidad"));
Double ImporteTasa1 = Double.valueOf(request.getParameter("ImporteTasa1"));
Double ImporteTasa2 = Double.valueOf(request.getParameter("ImporteTasa2"));
Double ImporteTasa3 = Double.valueOf(request.getParameter("ImporteTasa3"));
String TipoOperacion = request.getParameter("TipoOperacion");
String FechaVto = request.getParameter("FechaVto");
String CodsDesglose = request.getParameter("CodsDesglose");
String MontosDesglose = request.getParameter("MontosDesglose");
String Referencia = request.getParameter("Referencia");
String UsuarioPeu = request.getParameter("UsuarioPeu");
String ConsumidorFinal = request.getParameter("ConsumidorFinal");
String NumeroFactura = request.getParameter("NumeroFactura");
%>

<h1>Esta es la página de pagos de ITC.</h1>
<br/>

<form>
	
	<h3>Esto es lo que recibe el GW de ITC</h3>
		
		<label>IdSol</label>
		<input type="text" name="IdSol" value="<%=IdSol%>">
		<br>
		
		<label>IdTramite</label>
		<input type="text" name="IdTramite" value="<%=IdTramite%>">
		<br>
				
		<label>Cantidad</label>
		<input type="text" name="Cantidad" value="<%=Cantidad%>">
		<br>
				
		<label>ImporteTasa1</label>
		<input type="text" name="ImporteTasa1" value="<%=ImporteTasa1%>">
		<br>
				
		<label>ImporteTasa2</label>
		<input type="text" name="ImporteTasa2" value="<%=ImporteTasa2%>">
		<br>
				
		<label>ImporteTasa3</label>
		<input type="text" name="ImporteTasa3" value="<%=ImporteTasa3%>">
		<br>
				
		<label>TipoOperacion</label>
		<input type="text" name="TipoOperacion" value="<%=TipoOperacion%>">
		<br>
				
		<label>FechaVto</label>
		<input type="text" name="FechaVto" value="<%=FechaVto%>">
		<br>
				
		<label>CodsDesglose</label>
		<input type="text" name="CodsDesglose" value="<%=CodsDesglose%>">
		<br>
				
		<label>MontosDesglose</label>
		<input type="text" name="MontosDesglose" value="<%=MontosDesglose%>">
		<br>
		
		<label>Referencia</label>
		<input type="text" name="Referencia" value="<%=Referencia%>">
		<br>
				
		<label>UsuarioPeu</label>
		<input type="text" name="UsuarioPeu" value="<%=UsuarioPeu%>">
		<br>
				
		<label>ConsumidorFinal</label>
		<input type="text" name="ConsumidorFinal" value="<%=ConsumidorFinal%>">
		<br>
				
		<label>NumeroFactura</label>
		<input type="text" name="NumeroFactura" value="<%=NumeroFactura%>">
		<br>
		

</form>
<%

	String estadoPago = "ok";
	
	IdSol = Double.parseDouble(request.getParameter("IdSol"));
	IdTramite = Integer.parseInt(request.getParameter("IdTramite"));
	Cantidad = Integer.parseInt(request.getParameter("Cantidad"));
	ImporteTasa1 = Double.valueOf(request.getParameter("ImporteTasa1"));
	ImporteTasa2 = Double.valueOf(request.getParameter("ImporteTasa2"));
	ImporteTasa3 = Double.valueOf(request.getParameter("ImporteTasa3"));
	TipoOperacion = request.getParameter("TipoOperacion");
	FechaVto = request.getParameter("FechaVto");
	CodsDesglose = request.getParameter("CodsDesglose");
	MontosDesglose = request.getParameter("MontosDesglose");
	Referencia = request.getParameter("Referencia");
	UsuarioPeu = request.getParameter("UsuarioPeu");
	ConsumidorFinal = request.getParameter("ConsumidorFinal");
	NumeroFactura = request.getParameter("NumeroFactura");
	//Texto plano: True12343004321Venta Aprobada38A1454345789051A1454345785819160201025936=
	//KeyComercio = Y8LpWzag8MliH0PSXwijck+rh2wwsCi8

	String urlResultado = "http://localhost:8882/Apia/";
	
	if(estadoPago.equals("ok"))
			urlResultado +=  "respuestaPagoAprobado";
	if(estadoPago.equals("error"))
			urlResultado +=  "respuestaPagoConError";
	if(estadoPago.equals("rechazo"))
			urlResultado +=  "respuestaPagoRechazado";
	if(estadoPago.equals("pendiente"))
			urlResultado +=  "respuestaPagoPendiente";
	
%>



	<form method="POST" action="<%=urlResultado%>">
		
		<h3>Esto es lo que devuelve el GW de ITC en las urls de ok, rechazo, cancelado o pendiente </h3>

		<label>Estado del pago</label>
		<input type="text" name="estadoPago" value="<%=estadoPago%>">
		<br>
		
		<label>IdSol</label>
		<input type="text" name="IdSol" value="<%=IdSol%>">
		<br>
		
		<label>IdTramite</label>
		<input type="text" name="IdTramite" value="<%=IdTramite%>">
		<br>
				
		<label>Cantidad</label>
		<input type="text" name="Cantidad" value="<%=Cantidad%>">
		<br>
				
		<label>ImporteTasa1</label>
		<input type="text" name="ImporteTasa1" value="<%=ImporteTasa1%>">
		<br>
				
		<label>ImporteTasa2</label>
		<input type="text" name="ImporteTasa2" value="<%=ImporteTasa2%>">
		<br>
				
		<label>ImporteTasa3</label>
		<input type="text" name="ImporteTasa3" value="<%=ImporteTasa3%>">
		<br>
				
		<label>TipoOperacion</label>
		<input type="text" name="TipoOperacion" value="<%=TipoOperacion%>">
		<br>
				
		<label>FechaVto</label>
		<input type="text" name="FechaVto" value="<%=FechaVto%>">
		<br>
				
		<label>CodsDesglose</label>
		<input type="text" name="CodsDesglose" value="<%=CodsDesglose%>">
		<br>
				
		<label>MontosDesglose</label>
		<input type="text" name="MontosDesglose" value="<%=MontosDesglose%>">
		<br>
		
		<label>Referencia</label>
		<input type="text" name="Referencia" value="<%=Referencia%>">
		<br>
				
		<label>UsuarioPeu</label>
		<input type="text" name="UsuarioPeu" value="<%=UsuarioPeu%>">
		<br>
				
		<label>ConsumidorFinal</label>
		<input type="text" name="ConsumidorFinal" value="<%=ConsumidorFinal%>">
		<br>
				
		<label>NumeroFactura</label>
		<input type="text" name="NumeroFactura" value="<%=NumeroFactura%>">
		<br>
		
		<% if(estadoPago.equals("ok")){%>
			
			<h4>Solo por estado "ok"</h4>
			
			<label>IdFormaPago</label>
			<input type="text" name="IdFormaPago">
			<br>	
			<label>MontoTotal</label>
			<input type="text" name="MontoTotal">
			<br>
			<label>CodAutorizacion</label>
			<input type="text" name="CodAutorizacion">
			<br>
			<label>IdTasa</label>
			<input type="text" name="IdTasa">
			<br>
			<label>ValorTasa</label>
			<input type="text" name="ValorTasa">
			<br>
			<label>MontosDescuentoIVA</label>
			<input type="text" name="MontosDescuentoIVA">
			<br>
			<label>NumeroFactura</label>
			<input type="text" name="NumeroFactura">
			<br>
		 
		<%} if(estadoPago.equals("error")) {%>
		
			<h4>Solo por estado "error"</h4>
				
			<label>CodError</label>
			<input type="text" name="MontosDescuentoIVA">
			<br>
			<label>DesError</label>
			<input type="textarea" name="NumeroFactura">
			<br>
		<%} if(estadoPago.equals("rechazo")) {%>
				
			<h4>Solo por estado "rechazo"</h4>
					
			<label>DesRechazo</label>
			<input type="textarea" name="DesRechazo">
			<br>	
			<label>MontoTotal</label>
			<input type="text" name="MontoTotal">
			<br>
				
		<%} if(estadoPago.equals("pendiente")) {%>
			
			<h4>Solo por estado "pendiente"</h4>
				
			<label>IdFormaPago</label>
			<input type="textarea" name="IdFormaPago">
			<br>	
			<label>MontoTotal</label>
			<input type="text" name="MontoTotal">
			<br>
			<label>IdTasa</label>
			<input type="textarea" name="IdTasa">
			<br>
			<label>ValorTasa</label>
			<input type="text" name="ValorTasa">
			<br>
			<label>Ventanilla</label>
			<input type="textarea" name="Ventanilla">
			<br>			
			
		<%}%>

		<input type="submit" value="Enviar">
		<br>	<br>	<br>	
	</form>

	<form method="POST" action="http://localhost:8882/Apia/respuestaDeControl" target="_parent">
		
		<h3>Esto es lo que devuelve el GW de ITC en la URL de control (que hace la redireccion al navegador) </h3>

		<label>Estado del pago</label>
		<input type="text" name="estadoPago" value="<%=estadoPago%>">
		<br>
		
		<label>IdSol</label>
		<input type="text" name="IdSol" value="<%=IdSol%>">
		<br>
		
		<label>IdTramite</label>
		<input type="text" name="IdTramite" value="<%=IdTramite%>">
		<br>
				
		<label>Cantidad</label>
		<input type="text" name="Cantidad" value="<%=Cantidad%>">
		<br>
				
		<label>ImporteTasa1</label>
		<input type="text" name="ImporteTasa1" value="<%=ImporteTasa1%>">
		<br>
				
		<label>ImporteTasa2</label>
		<input type="text" name="ImporteTasa2" value="<%=ImporteTasa2%>">
		<br>
				
		<label>ImporteTasa3</label>
		<input type="text" name="ImporteTasa3" value="<%=ImporteTasa3%>">
		<br>
				
		<label>TipoOperacion</label>
		<input type="text" name="TipoOperacion" value="<%=TipoOperacion%>">
		<br>
				
		<label>FechaVto</label>
		<input type="text" name="FechaVto" value="<%=FechaVto%>">
		<br>
				
		<label>CodsDesglose</label>
		<input type="text" name="CodsDesglose" value="<%=CodsDesglose%>">
		<br>
				
		<label>MontosDesglose</label>
		<input type="text" name="MontosDesglose" value="<%=MontosDesglose%>">
		<br>
		
		<label>Referencia</label>
		<input type="text" name="Referencia" value="<%=Referencia%>">
		<br>
				
		<label>UsuarioPeu</label>
		<input type="text" name="UsuarioPeu" value="<%=UsuarioPeu%>">
		<br>
				
		<label>ConsumidorFinal</label>
		<input type="text" name="ConsumidorFinal" value="<%=ConsumidorFinal%>">
		<br>
				
		<label>NumeroFactura</label>
		<input type="text" name="NumeroFactura" value="<%=NumeroFactura%>">
		<br>
		<input type="submit" value="Enviar">
		
	</form>
		


</form>

</body>
</html>