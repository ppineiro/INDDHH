<%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.dogma.test.*"%><%!
	private static long counter = 0;
	
	private static synchronized long getNext() {
		counter++;
		return counter;
	}
%><%

		int qtd = Integer.parseInt(request.getParameter("usrQty"));
		int x = (int) (getNext() % qtd);
		x = x + 1;
		String user = request.getParameter("prefix");
		if (x<10) {
			user+="0"+x;
		} else {	
			user+=x;
		}
		
		System.out.println(user);
		
		String url = "/" + Parameters.ROOT_PATH + "/programs/login/security.LoginAction.do?txtUser="+ user +"&txtPwd=" + user + "&action=login&hidLangId=" + request.getParameter("hidLangId") + "&cmbEnv=" + request.getParameter("cmbEnv");
	  	try {
		    getServletConfig().getServletContext().getRequestDispatcher(response.encodeURL(url)).forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		com.dogma.bean.DogmaAbstractBean bLogin = ((com.dogma.bean.DogmaAbstractBean) session.getAttribute("bLogin"));
		if ( bLogin.getHasException() || (bLogin.getMessages() != null && bLogin.getMessages().size()>0)) {
			com.st.util.log.Log.error(bLogin.getMessagesAsXml(request));
		}
		
		UserData userData = (UserData) session.getAttribute(Parameters.SESSION_ATTRIBUTE);
		if (userData == null) {
			com.st.util.log.Log.error("USER NOT LOGGED IN : " + user);
			throw new ServletException("Session Null ... should never happen ");
		}
%>