
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.dao.DocumentDAO"%>
<%@page import="com.dogma.vo.DocumentVo"%>
<%@page import="com.dogma.document.DocumentAccessor"%>
<%@page import="com.st.db.dataAccess.DBManager"%>
<%@page import="com.st.db.dataAccess.DBAdmin"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.st.db.dataAccess.DBConnection"%>
<%@page import="com.st.db.dataAccess.ConnectionDAO"%>
<%!
protected class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

protected class Test extends DBAdmin {
	private Connection getConnection() throws Exception {
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		DBConnection dbConn = manager.getConnection(null,null,null,0,0,0,0);
		ConnectionGetter conGetter = new ConnectionGetter();
		return conGetter.getDBConnection2(dbConn);
	}
	
	private DBConnection getDbConnection() throws Exception {
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		return manager.getConnection(null,null,null,0,0,0,0);
	}
	
	private void addMessage(StringBuffer buffer, String msg) {
		buffer.append(System.currentTimeMillis() + ": " + msg + "<br>");
	}
	
	private void addError(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"<font color='red'>[ERROR]</font> " + msg);
	}
	
	private void addFatal(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"<font color='red'><b>[FATAL]</b></font> " + msg);
	}
	
	private void addDebug(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"[DEBUG] " + msg);
	}
	
	private void addInfo(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"<font color='blue'>[INFO]</font> " + msg);
	}
	
	private void addWarning(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"<font color='orange'>[WARNING]</font> " + msg);
	}

	public DocumentVo getDocument(Integer envId, Integer docId) throws Exception {
		DBConnection conn = null;
		try{
			conn = this.getDbConnection();
			DocumentVo docVo = DocumentDAO.getInstance().getDocumentVo(conn,envId,docId);
			UserData userData = new UserData();
			userData.setUserId("documentDownloader");
			DocumentAccessor.getInstance().getDocumentManager(conn).downloadDocument(docVo, userData);
			return docVo;
		} catch (Throwable e) {
			throw new Exception(e.getMessage());
		} finally {
			if (conn != null) {
				try{
				conn.close();
				}catch(Exception e){
					
				}
			}
		}
	}
}
%>

<%
Integer envId = Integer.parseInt(request.getParameter("envId"));
Integer docId = Integer.parseInt(request.getParameter("docId"));

Test test = new Test();
DocumentVo docVo = test.getDocument(envId, docId);



ServletOutputStream outs = response.getOutputStream();

response.setContentType("application/x-msdownload"); 

if (docVo == null || docVo.getDocName() == null){
	response.setHeader("Content-Disposition", "attachment; filename=ERROR");
} else {
	String sourceFile = docVo.getTmpFilePath();
	String fileName = docVo.getDocName();
	fileName = fileName.replaceAll(" ","_");
	response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

	try {
	
	FileInputStream in = new FileInputStream(sourceFile);
	
	byte[] buffer = new byte[8 * 1024];
	int count = 0;
	do {
		outs.write(buffer, 0, count);
		count = in.read(buffer, 0, buffer.length);
	} while (count != -1);
	
	in.close();
	outs.close();
	
	//Borramos el documento del dir temporal
	File docFileFrom = new File(sourceFile);
	docFileFrom.delete();
	
	} catch (Exception e) {
		e.printStackTrace();
		response.setHeader("Content-Disposition", "attachment; filename=ERROR");
	}
}

%>