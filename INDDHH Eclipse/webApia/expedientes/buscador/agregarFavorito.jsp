<%@page import="st.access.BusquedaDao"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.UserData"%>

<%
	BusquedaDao dao = new BusquedaDao();	
	UserData ud = ThreadData.getUserData();

	String nroExp = request.getParameter("nroExp");	
	String action = request.getParameter("action");
	String user = ud.getUserId();
	
	if (action.equals("marcar")){
		dao.insertarFavorito(nroExp, user);
	}
	
	if (action.equals("desmarcar")){
		dao.desmarcarFavorito(nroExp, user);
	}
%>