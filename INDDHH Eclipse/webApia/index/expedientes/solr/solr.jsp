<%@page
import="uy.com.st.adoc.expedientes.solr.Solr"
%><%
	String query = request.getParameter("q");
	String start = request.getParameter("s");
	out.print(Solr.globalQuery(query, Integer.valueOf(start)));
%>