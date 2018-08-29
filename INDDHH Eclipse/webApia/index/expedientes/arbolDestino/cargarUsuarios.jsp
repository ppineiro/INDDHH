
<%
	response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);
%>
<%@ page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Usr"%>
<%@page import="uy.com.st.adoc.log.LogDocumentum"%>
<%@page import="java.util.ArrayList;"%>


<%
	try {

		Helper h = new Helper();

		String unidad = request.getParameter("unidad").toString();
		String flag = request.getParameter("flag").toString();

		ArrayList<Usr> arrUsr = h.cargarUsuarios(unidad);

		Usr aux = null;
		try {
			for (int i = 0; i < arrUsr.size() - 2; i++) {
				for (int j = i + 1; j < arrUsr.size() - 1; j++) {
					if ((arrUsr.get(i).getUsrName() != null) && (arrUsr.get(j).getUsrName() != null)) {
						if ((arrUsr.get(i).getUsrName().toUpperCase()).compareTo(arrUsr.get(j).getUsrName().toUpperCase()) > 0) {
							aux = arrUsr.get(i);
							arrUsr.set(i, arrUsr.get(j));
							arrUsr.set(j, aux);
						}
					}
				}
			}
		} catch (Exception e) {
		}
		out.print("<table>");
		for (int i = 0; i < arrUsr.size(); i++) {

			out.print("<tr>");
			out.print("<td>");
			if (flag.equals("true")) {
				out
						.print("<input type='radio' onclick='desChequearUsuarios(this)' id='checkbox2' name='"
								+ arrUsr.get(i).getUsrLogin()
								+ "' value='"
								+ arrUsr.get(i).getUsrLogin() +"*"
								+ arrUsr.get(i).getUsrName().replace("'", "&rsquo;")+"'></td><td>");				
			}
			out
					.print("<font style='FONT-FAMILY: verdana; FONT-SIZE: 7pt;'><img src='images/user.gif' WIDTH='16' HEIGHT='16'>"
							+ arrUsr.get(i).getUsrName() + "</font>");
			out.print("</td>");
			out.print("</tr>");

		}

		out.print("<table>");

	} catch (Exception e) {
		LogDocumentum.debug("Ejecutando jsp ../arbolDestino/cargarUsuarios.jsp");
		LogDocumentum.error(e.getMessage(), e);
	}
%>
