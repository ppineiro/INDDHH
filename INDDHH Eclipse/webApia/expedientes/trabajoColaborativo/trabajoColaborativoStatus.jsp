<%@page
import="uy.com.st.adoc.expedientes.trabajoColaborativo.obj.Labels"
import="uy.com.st.adoc.expedientes.trabajoColaborativo.obj.Helper"
%><%
	String strAux = request.getParameter(Labels.PARAM_AUX);
	out.print(Helper.hayCambios(strAux));
%>