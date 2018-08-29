<%@page import="com.dogma.*"%><%@page import="java.util.*"%><%@page import="com.dogma.test.*"%><%

	PerfTest.testFile(request.getParameter("Process"), this.getServletContext().getInitParameter("PathTestFile"),"1111", session);

	if ( ((com.dogma.bean.DogmaAbstractBean) session.getAttribute("dBean")).getHasException()) {
		throw new Exception("ERROR");
	}
%>