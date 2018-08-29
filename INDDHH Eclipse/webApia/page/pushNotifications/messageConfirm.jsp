<%
//1 recibido
//2 leido
//3 borrado
//4 borrado sin ser leido
System.out.println("Accion sobre mensaje " + request.getParameter("idMensaje") + ": " + request.getParameter("estado"));
%>