<%@ page language="java" %>
<%@ page import="com.dogma.business.querys.*" %>
<%@ page import="com.dogma.business.*" %>
<%@ page import="com.st.db.dataAccess.*" %>
<%@ page import="com.dogma.dataAccess.*" %>
<%@ page import="com.dogma.vo.*" %>
<%@ page import="com.dogma.vo.gen.*" %>
<%@ page import="com.dogma.dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.dogma.DogmaException"%>

<%! 
protected class Test extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

%>




<html>

<form action="webDBMagic.jsp">
Acceso a datos "El flaco"®... <br>
Type an SQL Statement:
<%if (request.getParameter("sql")!=null) {%>
	<input type=text name=sql size="100" value="<%=request.getParameter("sql")%>">
<%}else{%>
	<input type=text name=sql size="100" value="">
<%}%>
<input type=submit value="Execute">
</form>

<%
if (request.getParameter("sql")!=null) {
	
	PreparedStatement ps = null;
	ResultSet resultSet = null;
	DBConnection dbConn = null;
	Connection con = null;
	int cant = 0;
	long iniTime = 0;
	long endTime = 0;
    try {
		
			dbConn = DogmaDBManager.getConnection();
			Test test = new Test();
			con =  test.getDBConnection2(dbConn);
			ps = StatementFactory.getStatement(con,request.getParameter("sql"),StatementFactory.DEBUG);
			iniTime = System.currentTimeMillis();
	     	resultSet = ps.executeQuery();
	     	endTime = System.currentTimeMillis();
	     	ResultSetMetaData rsmd = resultSet.getMetaData();
     		int numberOfColumns = rsmd.getColumnCount();
     		%><table border=1><%
     		%><tr><%
     		for (int i=0;i<numberOfColumns;i++) {
     			out.print("<td>"+rsmd.getColumnName(i+1) + "</td>");
     		}
     		%></tr><%
     		
     		while (resultSet.next()){
     			%><tr><%
     			for (int i=0;i<numberOfColumns;i++) {
     				out.print("<td>" + resultSet.getObject(i+1) + "</td>");
     			}	
     			cant++;
     			%></tr><%
     		}
     		
     		%>
 
     		</table>
     		<%
     		
	}catch (Exception e) {
		e.printStackTrace();
	}	 finally {
		try {
			resultSet.close();
			ps.close();
		} catch (Exception ignore) {}
		try {
			con.close();
			dbConn.close();
		} catch (Exception ignore) {}
	}			     	
	    	
	out.println("Total Records  = " + cant);
	out.println("<b>Execution time in milliseconds  = " + (endTime-iniTime)+"</b>");
 


}
%>

</html>
