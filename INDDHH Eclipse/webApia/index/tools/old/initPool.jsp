<%@ page language="java" %><%@ page import="com.dogma.business.*" %><%@ page import="com.st.db.dataAccess.*" %><%@ page import="com.dogma.dataAccess.*" %><%@ page import="com.dogma.vo.*" %><%@ page import="com.dogma.vo.gen.*" %><%@ page import="com.dogma.dao.*" %><%@ page import="java.util.*" %><%@ page import="java.sql.*" %><%@ page import="java.io.*" %><%@ page import="com.dogma.DogmaException"%><%! 
protected class Test extends DBAdmin {
	public void init(String name) {
		managersMap.remove(name);
	}
	public Iterator getKeys() {
		return managersMap.keySet().iterator();
	}
}

%><%
Test test = new Test();
test.init(request.getParameter("managerId"));

for (Iterator it = test.getKeys(); it.hasNext(); ) { 
	Object obj = it.next(); 
	if (! "DOGMA_MANAGER".equals(obj)) { %>
		Pool: <%= obj %> (<a href="?managerId=<%= obj %>">init</a>)<br><%
	}
}

%>