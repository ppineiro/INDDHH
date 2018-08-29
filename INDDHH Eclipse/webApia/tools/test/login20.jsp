<%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.dogma.test.*"%><%
		int x = (int) Math.floor(Math.random()* 20);
		String usr = "usr" + x;
		String pwd = "usr";
		
		System.out.println("TESTEANDO LOGIN PARA USUARIO: " + usr);
		
		String url = "/Apia2.2/programs/login/security.LoginAction.do?txtUser=" + usr + "&txtPwd=" + pwd + "&action=login&hidLangId=1&cmbEnv=1";

	  	try {
		    this.getServletContext().getRequestDispatcher(response.encodeURL(url)).forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
		com.dogma.bean.DogmaAbstractBean bLogin = ((com.dogma.bean.DogmaAbstractBean) session.getAttribute("bLogin"));
		if ( bLogin.getHasException() || (bLogin.getMessages() != null && bLogin.getMessages().size()>0)) {
			com.st.util.log.Log.error(bLogin.getMessagesAsXml(request));
		}
%>