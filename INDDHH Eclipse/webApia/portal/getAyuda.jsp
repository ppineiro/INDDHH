<%@page import="st.access.tramites.TramiteDao"%>
<% 
String att = request.getParameter("att");
TramiteDao tdao = new TramiteDao();
String ayuda = "<p style=\"margin: 0px;\">";
ayuda += tdao.getAyudaAtt(att, 1);
ayuda += "</p>";
ayuda += "<span id=\"span_ayuda\" class=\"icn icn-arrow-left-sm arrow\"></span>";
// String ayuda = tdao.getAyudaAtt(att, 1);
// request.setAttribute("textoAyuda", ayuda);
%>
<%=ayuda%>