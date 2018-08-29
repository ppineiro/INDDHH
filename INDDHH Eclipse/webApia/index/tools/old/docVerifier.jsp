<%@ page language="java" %><%@ page import="com.dogma.business.querys.*" %><%@ page import="com.dogma.business.*" %><%@ page import="com.st.db.dataAccess.*" %><%@ page import="com.dogma.dataAccess.*" %><%@ page import="com.dogma.vo.*" %><%@ page import="com.dogma.vo.gen.*" %><%@ page import="com.dogma.dao.*" %><%@ page import="java.util.*" %><%@ page import="java.sql.*" %><%@ page import="java.io.*" %><%@ page import="com.dogma.DogmaException"%><%! 
protected class Test extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

%><%@page import="com.dogma.Parameters"%><% 	boolean tryOpen = "true".equals(request.getParameter("tryOpen"));  %><html>

Acceso a datos "El flaco"®... (powered by Pf)<br>
Storage: <%= Parameters.DOCUMENT_STORAGE %><br>
Try open: <%= tryOpen %> (?tryOpen=true to try to open the file)<br><br><table border="1" cellpadding="0" cellspacing="0"><tr><td align="center"><b>File</b></td><td align="center"><b>isFile</b></td><td align="center"><b>exists</b></td><td align="center"><b>canRead</b></td><% if (tryOpen) { %><td>open</td><% } %><td align="center"><b>path</b></td><td align="center"><b>user</b></td><td align="center"><b>date</b></td><td align="center"><b>other files</b></td></tr><%
	PreparedStatement ps = null;
	ResultSet resultSet = null;
	DBConnection dbConn = null;
	Connection con = null;
	
	int cant = 0;
	long iniTime = 0;
	long endTime = 0;
    try {
    	iniTime = System.currentTimeMillis();
		dbConn = DBManagerUtil.getApiaConnection();
		Test test = new Test();
		con =  test.getDBConnection2(dbConn);

		ps = StatementFactory.getStatement(con,"select * from document",StatementFactory.DEBUG);
     	resultSet = ps.executeQuery();
     	int countBad = 0;
     	int countOk = 0;
     	while (resultSet.next()) {
     		File aFile = new File(Parameters.DOCUMENT_STORAGE + File.separator + resultSet.getString("DOC_PATH")); 

     		if (aFile.exists()) {
     			countOk ++;
     			continue;
     		} 
     		countBad ++; %><tr><td><%= aFile.getName() %></td><td><%= aFile.isFile() %></td><td><%= aFile.exists() %></td><td><%= aFile.canRead() %></td><% if (tryOpen) {
	     			try {
	     				new FileInputStream(aFile).close();
	     				%><td>OK</td><%
	     			} catch (Exception e) {
	     				%><td><%= e.toString() %></td><% 
	     			} 
	     		} %><td><%= aFile.getAbsolutePath() %></td><td><%= resultSet.getString("REG_USER") %></td><td><%= resultSet.getString("REG_DATE") %></td><td><% if (! aFile.exists()) {
	     			File[] files = aFile.getParentFile().listFiles();
	     			if (files != null) {
	     				for (int i = 0; i < files.length; i ++) { %><%= files[i].getName() %><br><% }
	     			}
	     			
	     		} %></td></tr><%
     	} %><tr><td colspan="7">
     		Bad: <b><%= countBad %></b><br>
     		Ok: <b><%= countOk %></b></td></tr><%	}catch (Exception e) {
		e.printStackTrace();
	}	 finally {
		try {
			resultSet.close();
			ps.close();
		} catch (Exception ignore) {}
		try {
			con.close();
			DBManagerUtil.close(dbConn);
		} catch (Exception ignore) {}
	}			     	
%></table></html>
