<jsp:useBean id="bTest"  
			 class="com.dogma.testing.web.controller.TestBean"      
			 scope="session"/><%
	String xml = bTest.getTestXML("REQ",request.getParameter("fileName"));
	out.clear();
	out.print(xml);
%>


