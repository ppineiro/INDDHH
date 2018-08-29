<%@page import="com.dogma.*"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="com.dogma.test.*"%><%

	UserData userData = (UserData) session.getAttribute(Parameters.SESSION_ATTRIBUTE);

	if (userData == null) {
		com.st.util.log.Log.error("SESSION NULL");
		throw new ServletException("Session Null ... should never happen");
	}

	String taskName = (String) session.getAttribute("TEST_TASK_NAME");

	if (taskName != null) { 

		PerfTest.testFile(taskName, this.getServletContext().getInitParameter("PathTestFile"),"1111", session);
		
		if ( ((com.dogma.bean.DogmaAbstractBean) session.getAttribute("dBean")).getHasException()) {
			throw new Exception("ERROR");
		}
	}

%>