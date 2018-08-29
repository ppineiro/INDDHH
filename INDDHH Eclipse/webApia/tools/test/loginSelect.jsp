<%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.dogma.test.*"%><%

//System.out.println("ACA1");

	try {
	
    ServletContext myContext = this.getServletContext();
    HttpSession    mySession = request.getSession();
    
	String testUsrId = (String)mySession.getAttribute("TEST-USR-ID");
	String testPwdId = (String)mySession.getAttribute("TEST-PWD-ID");
	
//System.out.println("ACA2");
	
	if (testUsrId == null) {
		// Select a user id from the context. At least we will find one
		synchronized(myContext) {
			System.out.println("Searching for new user id");
			
			String[] ids = (String[])myContext.getAttribute("TEST-USERS");
			if (ids == null) {
				System.out.println("Creating user id array");
				
				ids = new String[20];
				for (int i = 0; i < ids.length; i++) {
					ids[i] = "usr" + (i + 1);
				}
				myContext.setAttribute("TEST-USERS", ids);
			}
			
			// Get a free id
			boolean found = false;
			for (int i = 0; i < ids.length && !found; i++) {
				if (ids[i] != null) {
					testUsrId = ids[i];
					testPwdId = "usr";
					
					ids[i] = null;
					found = true;
				}
			}
		}
		
		// store the id in the session to avoid 
	 	mySession.setAttribute("TEST-USR-ID", testUsrId);
	 	mySession.setAttribute("TEST-PWD-ID", testPwdId);
	}
	
//System.out.println("ACA3");
	
	System.out.println(">> testing (login/logout) cycle with: " + testUsrId + "/" + testPwdId);
	
	String url = "/Apia2.2/programs/login/security.LoginAction.do?txtUser=" + testUsrId + "&txtPwd=" + testPwdId + "&action=login&hidLangId=1&cmbEnv=1";

//System.out.println("ACA4");

  	try {
	    this.getServletContext().getRequestDispatcher(response.encodeURL(url)).forward(request, response);
	} catch (Exception e) {
		e.printStackTrace();
	}
	
//System.out.println("ACA5");
	
	com.dogma.bean.DogmaAbstractBean bLogin = ((com.dogma.bean.DogmaAbstractBean) session.getAttribute("bLogin"));
	if ( bLogin.getHasException() || (bLogin.getMessages() != null && bLogin.getMessages().size()>0)) {
		com.st.util.log.Log.error(bLogin.getMessagesAsXml(request));
	}
	
//System.out.println("ACA6");
	
	} catch (Throwable ex) {
		ex.printStackTrace();
	}
	
%>