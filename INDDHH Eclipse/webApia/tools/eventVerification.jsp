<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>

<%@page import="com.dogma.dao.EventDAO" %>
<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Collection" %>
<%@page import="com.dogma.dataAccess.DogmaDBManager" %>
<%@page import="com.st.db.dataAccess.DBConnection" %>

<%@page import="com.st.db.dataAccess.DBAdmin"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.st.db.dataAccess.DBManager"%>
<%@page import="com.st.db.dataAccess.ConnectionDAO"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="com.dogma.vo.EventVo"%>
<%@page import="java.util.Iterator"%>
<head>
	<title>Process Condition Verifier</title>
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
	
	private Connection getConnection(DBConnection dbConn) throws Exception {
		ConnectionGetter conGetter = new ConnectionGetter();
		return conGetter.getDBConnection2(dbConn);
	}
	
	private DBConnection getDbConnection() throws Exception {
		DBManager manager = (DBManager) managersMap.get("DOGMA_MANAGER");
		return manager.getConnection(null,null,null,0,0,0,0);
	}

	private void addMessage(StringBuffer buffer, String msg) {
		buffer.append(msg + "<br>");
	}
	
	private void addError(StringBuffer buffer, String msg) {
		this.addMessage(buffer,"<font color='red'>[ERROR]</font> " + msg);
	}
	
	private void addError(StringBuffer buffer, Exception e) {
		ByteArrayOutputStream byteArrayOut = new ByteArrayOutputStream();
		PrintWriter printWriter = new PrintWriter(byteArrayOut);
		e.printStackTrace(printWriter);
		printWriter.flush();
		
		this.addMessage(buffer,"<font color='red'>[ERROR]</font> <pre>" + byteArrayOut.toString() + "</pre>");
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
	
	public String verify(){
		StringBuffer buffer = new StringBuffer();
		DBConnection conn = null;
		
		try{
			this.addMessage(buffer,"Getting Apia connection...");
			conn = this.getDbConnection();
			this.addMessage(buffer,"Going through application events...");
			this.addMessage(buffer,"");
			Collection dbEvents = EventDAO.getInstance().getAllEvents(conn, null, null);
			Collection appEvents = EventVo.events;

			//go through all application events
			for(Iterator appIt = appEvents.iterator();appIt.hasNext();){
				EventVo appEvent = (EventVo)appIt.next();
				Integer appId = appEvent.getEvtId();
				String appName = appEvent.getEvtName();
				String appScope = appEvent.getEvtScope();
				//init candidate
				EventVo dbEvent = null;
				String prefix = "<b>("+appId+" - "+appName+" - "+appScope+")</b>: ";
				//go through all database events looking for app event
				for(Iterator dbIt = dbEvents.iterator();dbIt.hasNext() && appId != null;){
					EventVo candidate = (EventVo)dbIt.next();
					if(appId.equals(candidate.getEvtId())){
						//matching event found in database
						dbEvent = candidate;
						//remove candidate to know its match was found
						dbEvents.remove(candidate);
						break;
					}
				}//done searching in db events
				if(dbEvent != null){
					if(appName.equals(dbEvent.getEvtName()) && appScope.equals(dbEvent.getEvtScope())){
						addInfo(buffer,prefix+"OK");
					}else{
						String warns = prefix;
						if(!appScope.equals(dbEvent.getEvtScope())){
							warns += "SCOPE in db (<b>"+dbEvent.getEvtScope()+"</b>) does not match";
						}
						if(!appName.equals(dbEvent.getEvtName())){
							if(!appScope.equals(dbEvent.getEvtScope())) warns += " and ";
							warns += "NAME in db (<b>"+dbEvent.getEvtName()+"</b>) does not match";
						}
						addWarning(buffer,warns);
					}
				}else{
					addError(buffer,prefix+"ID not found in database");
				}
			}//done with all app events
			this.addMessage(buffer,"");
			if(dbEvents.size() == 0){
				this.addMessage(buffer,"<b>All events in database have a corresponding match in the application</b>");
			}else{
				this.addMessage(buffer,"<b>Database events with no matching id in the application:</b>");
				//go through all remaining database events
				for(Iterator dbIt = dbEvents.iterator();dbIt.hasNext();){
					EventVo dbEvent = (EventVo)dbIt.next();
					addWarning(buffer,"<b>("+dbEvent.getEvtId()+" - "+dbEvent.getEvtName()+" - "+dbEvent.getEvtScope()+")</b>");
				}
			}
		} catch (Exception e) {
			this.addError(buffer,e);
		} finally {
			if (conn != null) {
				this.addMessage(buffer,"");
				this.addMessage(buffer,"Closing connection...");
				conn.close();
			}
		}
		return buffer.toString();
	}
}
%>
<div style="overflow: auto; white-space: nowrap; width: 100%; height: 95%"><%
out.print(new Test().verify());
 %></div>
</body>