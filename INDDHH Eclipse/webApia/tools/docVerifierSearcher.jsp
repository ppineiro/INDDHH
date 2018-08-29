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

public Collection loadFiles(File path) {
	Collection result = new ArrayList();
	
	if (path.isDirectory()) {
		File[] files = path.listFiles();
		for (int i = 0; i < files.length; i++) {
			if (files[i].isDirectory()) {
				result.addAll(this.loadFiles(files[i]));
			} else {
				result.add(files[i].getAbsolutePath());
			}
		}
	} else {
		result.add(path.getAbsolutePath());
	}
	
	return result;
}

public String searchFor(Collection files, File aFile) {
	String aFileName = aFile.getName();
	for (Iterator it = files.iterator(); it.hasNext(); ) {
		String file = (String) it.next();
		if (file.endsWith(aFileName)) return file;
	}
	
	return null;
}

%>

<%@page import="com.dogma.Parameters"%>

<% 	boolean tryOpen = "true".equals(request.getParameter("tryOpen"));  %>
<html>
<head>
	<title>Document Verifier and Searcher</title>
	<style type="text/css">
		body {
			font-family: verdana;
			font-size: 10px;
		}
		td {
			font-family: verdana;
			font-size: 10px;
		}
		pre {
			font-family: verdana;
			font-size: 10px;
		}
		textarea {
			font-family: verdana;
			font-size: 10px;
		}
		input {
			font-family: verdana;
			font-size: 10px;
		}
		select {
			font-family: verdana;
			font-size: 10px;
		}
		
		a {
			text-decoration: none;
			color: blue;
		}
	</style>
</head>
<body>
<% String sql = "select * from document where doc_path like 'entInstaces/1001-%'"; %>
The following SQL will be use to retrieve the documents <b><%= sql %></b>. Alter the docVerifierSearcher.jsp file to change the SQL to use.<br>
The files are being search at <b><%= new File(Parameters.DOCUMENT_STORAGE).getAbsolutePath() %></b><br><br>
Start again? <a href="?">[YES]</a><br>
<% if (request.getParameter("execute") == null) { %>
<b><font color="red">[ WARNING ]</font></b> The execution of this code may require time and memory. Are you sure you want to continue? <a href="?execute=true">[YES]</a><br>
<b><font color="red">[ WARNING ]</font></b> The execution of this code may require time and memory. Are you sure you want to continue? <a href="?execute=true&saveTo=file">[YES - Generate result in file]</a>
<% } else { %>
<hr><%
	PreparedStatement ps = null;
	ResultSet resultSet = null;
	DBConnection dbConn = null;
	Connection con = null;
	
	int cantProcessed	= 0;
 	int count			= 0;
 	int countOk			= 0;
 	int countFound		= 0;
 	int countNotFound	= 0;
	long iniTime		= System.currentTimeMillis();
	
	boolean saveToFile	= request.getParameter("saveTo") != null;
	StringBuffer bufferMessage	= new StringBuffer();
	StringBuffer bufferSql		= new StringBuffer();

	Collection files = new ArrayList();
	
	files = this.loadFiles(new File(Parameters.DOCUMENT_STORAGE));

	if (files != null && files.size() > 0) {
		try {
			dbConn = DogmaDBManager.getConnection();
			Test test = new Test();
			con =  test.getDBConnection2(dbConn);
			
			String filePath			= Parameters.DOCUMENT_STORAGE + File.separator;
			int filePathToRemove	= filePath.length();
			
			ps = StatementFactory.getStatement(con,sql,StatementFactory.DEBUG);
	     	resultSet = ps.executeQuery();
	     	while (resultSet.next()) {
	     		count ++;
	     		File aFile = new File(filePath + resultSet.getString("DOC_PATH")); 
	     		if (aFile.exists()) {
	     			countOk ++;
	     			continue; //the file is OK, continue with the next
	     		}
	     		
	     		String foundFile = this.searchFor(files, aFile);
	     		if (foundFile != null) {
	     			if (! saveToFile) {
	     				out.print("Document <b>" + resultSet.getString("DOC_ID_AUTO") + "</b> with location <b>" + resultSet.getString("DOC_PATH") + "</b> may be found like <b>" + foundFile + "</b>.<br>");
	     				out.print("SQL: update document set doc_path = '" + foundFile.substring(filePathToRemove) + "' where doc_id_auto = " + resultSet.getString("DOC_ID_AUTO") + ";<br>");
	     			} else {
	     				bufferMessage.append("Document [" + resultSet.getString("DOC_ID_AUTO") + "] with location [" + resultSet.getString("DOC_PATH") + "] may be found like [" + foundFile + "].\r\n");
	     				bufferSql.append("update document set doc_path = '" + foundFile.substring(filePathToRemove) + "' where doc_id_auto = " + resultSet.getString("DOC_ID_AUTO") + ";\r\n");
	     			}
	     			countFound ++;
	     		} else {
	     			if (! saveToFile) {
	     				out.print("Document <b>" + resultSet.getString("DOC_ID_AUTO") + "</b> with location <b>" + resultSet.getString("DOC_PATH") + "</b> was not found.<br>");
	     				out.print("SQL: delete from document where doc_id_auto = " + resultSet.getString("DOC_ID_AUTO") + ";<br>");
	     			} else {
	     				bufferMessage.append("Document [" + resultSet.getString("DOC_ID_AUTO") + "] with location [" + resultSet.getString("DOC_PATH") + "] was not found.\r\n");
	     				bufferSql.append("delete from document where doc_id_auto = " + resultSet.getString("DOC_ID_AUTO") + ";\r\n");
	     			}
	     			countNotFound ++;
	     		}
	     	}
		} catch (Exception e) { %><b>Error:</b><br><%
			java.io.ByteArrayOutputStream bout = new java.io.ByteArrayOutputStream(); 
			e.printStackTrace(new java.io.PrintStream(bout)); 
			%><pre><%= bout.toString() %></pre><br><%
		} finally {
			try {
				resultSet.close();
				ps.close();
			} catch (Exception ignore) {}
			try {
				con.close();
				dbConn.close();
			} catch (Exception ignore) {}
		}
		
		if (saveToFile) {
			FileWriter o = null;

			String fileName = Parameters.TMP_FILE_STORAGE + File.separator + "docVerifierSearcher_" + System.currentTimeMillis() + ".txt";
			try {
				out.print("Saveing file: <b>" + fileName + "</b><br>");
				o = new FileWriter(new File(fileName), false);
				o.write(bufferMessage.toString());
				o.flush();
			} catch (Exception e) {
				out.print("<b>Error</b> saveing file: " + fileName + ". Error: <b>" + e.getMessage() + "</b><br>");
			} finally {
				if (o != null) o.close();
			}

			fileName = Parameters.TMP_FILE_STORAGE + File.separator + "docVerifierSearcher_sql_" + System.currentTimeMillis() + ".txt";
			try {
				out.print("Saveing file: <b>" + fileName + "</b><br>");
				o = new FileWriter(new File(fileName), false);
				o.write(bufferSql.toString());
				o.flush();
			} catch (Exception e) {
				out.print("<b>Error</b> saveing file: " + fileName + ". Error: <b>" + e.getMessage() + "</b><br>");
			} finally {
				if (o != null) o.close();
			}
		}
		
	} else { %>
		No files where found to analyze in the file system.<br>
	<% } %>
	<br>
	Time required <b><%= System.currentTimeMillis() - iniTime %> ms</b>.<br><br>
	Total files <b><%= count %></b><br>
	Total not found <b><%= countNotFound %></b><br>
	Total may be found <b><%= countFound %></b><br>
	Total found <b><%= countOk %></b><%
} %>
</body>
</html>
