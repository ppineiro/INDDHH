
<%@page import="com.dogma.Parameters"%>
<%@page import="org.apache.lucene.analysis.Analyzer"%>
<%@page import="org.apache.lucene.analysis.standard.StandardAnalyzer"%>
<%@page import="org.apache.lucene.queryParser.QueryParser"%>
<%@page import="org.apache.lucene.search.Query"%>
<%@page import="org.apache.lucene.search.Searcher"%>
<%@page import="org.apache.lucene.search.IndexSearcher"%>
<%@page import="org.apache.lucene.search.TopDocs"%>
<%@page import="org.apache.lucene.search.Sort"%>
<%@page import="org.apache.lucene.search.TopDocCollector"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collection"%>
<%@page import="org.apache.lucene.document.Document"%>
<%@page import="org.apache.lucene.index.IndexReader"%>
<%@page import="org.apache.lucene.index.IndexWriter"%>
<%@page import="com.st.db.dataAccess.DBManager"%>
<%@page import="com.st.db.dataAccess.DBConnection"%>
<%@page import="com.dogma.dataAccess.DogmaDBManager"%>
<%@page import="com.st.db.dataAccess.DBAdmin"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.st.db.dataAccess.ConnectionDAO"%>
<%@page import="com.st.db.dataAccess.StatementFactory"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Iterator"%><html>
<head>
	<title>Document Index Verification</title>
	<style type="text/css">
		body		{ font-family: verdana; font-size: 10px; }
		td			{ font-family: verdana; font-size: 10px; } 
		th			{ font-family: verdana; font-size: 10px; font-weight: normal;} 
		pre			{ font-family: verdana; font-size: 10px; }
		textarea	{ font-family: verdana; font-size: 10px; }
		input		{ font-family: verdana; font-size: 10px; }
		select		{ font-family: verdana; font-size: 10px; }
	</style>
</head>
<body>

<%!

private static class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

private class DBAdminAccess extends DBAdmin {
	public HashMap getHashMap() { return this.managersMap; }
}

private class DocInfoVo {
	private Integer envId;
	private Integer docId;
	private String docName;
	
	private DocInfoVo(Integer envId, Integer docId) {
		this.envId = envId;
		this.docId = docId;
	}

	private DocInfoVo(Integer envId, Integer docId, String docName) {
		this.envId = envId;
		this.docId = docId;
		this.docName = docName;
	}
	
	public boolean equals(Object aVo) {
		if (!(aVo instanceof DocInfoVo)) return false;
		return this.equals((DocInfoVo) aVo);
	}
	
	public String toString() {
		return this.envId + " - " + this.docId;
	}

	public boolean equals(DocInfoVo aDocInfoVo) {
		if (! aDocInfoVo.envId.equals(this.envId)) return false;
		if (! aDocInfoVo.docId.equals(this.docId)) return false;
		
		return true;
	}
}

%>

<% 

Boolean logged = (Boolean) request.getSession().getAttribute("loggedDocIndexVerification");

if (logged == null) logged = new Boolean(false);
if (request.getParameter("logout") != null) logged = new Boolean(false);

if (! logged.booleanValue()) {
	String user = request.getParameter("user");
	String pwd = request.getParameter("pwd");
	
	logged = new Boolean("admin".equals(user) && "admin22".equals(pwd));
	request.getSession().setAttribute("loggedDocIndexVerification",logged);
}

%>

<% if (logged.booleanValue()) { 
	if (Parameters.DOC_INDEX_ACTIVE) { %>
		Start index optimization<br><%
		IndexWriter writer = null;
		try {
			writer = new IndexWriter(Parameters.DOC_INDEX_PATH, new StandardAnalyzer(), ! IndexReader.indexExists(Parameters.DOC_INDEX_PATH), IndexWriter.MaxFieldLength.UNLIMITED);
			writer.optimize();
		} catch (Exception e) { %>
			Error during index optimization: <%= e.getMessage() %><br><%
			e.printStackTrace();
		} finally {
			if (writer != null) {
				try {
					writer.close();
				} catch (Exception e) { %>
					Error during index close: <%= e.getMessage() %><br><%
					e.printStackTrace();
				}
			}
		} %>
		End of index optimization<br><br>
		Start of documents retrieve from index<br><%
		
        Collection indexDocIds = new ArrayList();
        String errorMsg = null;
        IndexReader reader = null;
        try {
			 reader = IndexReader.open(Parameters.DOC_INDEX_PATH);
	
			int num = reader.numDocs();
			for (int i = 0; i < num; i++) {
				Document doc = reader.document(i);
				DocInfoVo docInfoVo = new DocInfoVo(Integer.valueOf(doc.get("env_id")), Integer.valueOf(doc.get("doc_id")));
				indexDocIds.add(docInfoVo);
			}
        } catch (Exception e) {
        	errorMsg = e.getMessage();
        } finally {
        	if (reader != null) {
        		try { reader.close(); } catch (Exception e) {}
        	}
        }%>
		Amount of documents in index: <b><%= indexDocIds.size() %></b>.<br>
		<% if (errorMsg != null) { %><b>Error</b> while getting documents information: <%= errorMsg %><br><% } %>
		<br><%
		if (errorMsg == null) { %>
			Start of documents retrieve from database<br><%
			Collection dbDocIds = new ArrayList();
			
			DBManager manager = (DBManager) new DBAdminAccess().getHashMap().get("DOGMA_MANAGER");
			DBConnection dbConn = null;
			try {
				dbConn = DogmaDBManager.getConnection();
				ConnectionGetter conGetter = new ConnectionGetter();
				Connection conn = conGetter.getDBConnection2(dbConn);
				PreparedStatement statement = StatementFactory.getStatement(conn,"select * from document where reg_status = 0",false);
				ResultSet resultSet = statement.executeQuery();
				
				while (resultSet.next()) {
					dbDocIds.add(new DocInfoVo(Integer.valueOf(resultSet.getInt("env_id")), Integer.valueOf(resultSet.getInt("doc_id_auto")), resultSet.getString("doc_name")));
				}
			} catch (Exception e) {
				errorMsg = e.getMessage();
			} finally {
				if (dbConn != null) {
					try {
						dbConn.close();
					} catch (Exception e) { %>
						Error while closeing connection. Error: <%= e.getMessage() %> <%
					} 
				}
			} %>
			
			Amount of documents in DB: <b><%= dbDocIds.size() %></b>.<br>
			<% if (errorMsg != null) { %><b>Error</b> while getting documents information: <%= errorMsg %><br><% }
			
			if (errorMsg == null) { %>
				Searching for documents in databsae that are not in the index<br><%
				
				int countNotIndex = 0;
				
				for (Iterator it = dbDocIds.iterator(); it.hasNext(); ) {
					DocInfoVo dbDocInfoVo = (DocInfoVo) it.next();
					if (! indexDocIds.contains(dbDocInfoVo)) { %>
						Cant't find in index the document: <%= dbDocInfoVo.docName %> (envId <%= dbDocInfoVo.envId %> - docId <%= dbDocInfoVo.docId %>)<br><%
						countNotIndex ++;
					}
				} %>
				<br>
				Amount of not indexed: <b><%= countNotIndex %></b><%
			}
		}
	} else { %>
		<b>Note</b>: the document index in Apia is not active. There is no reason to run/execute this.
<% } %> 
	<hr>
	<a href="?logout=yes">Logout</a><%
} else { %>
	<form action="" method="post">
		<b>Login is require to continue</b><br>
		User: <input type="text" name="user"><br>
		Password: <input type="password" name="pwd"><br>
		<input type="submit" value="Login">
	</form>
	<b>Warning</b>: the execution of this JSP will may consume a lot of RAM memory and CPU. Before getting all files the index will be optimized.</b>
<% } %>

</body>
</html>