<%@page import="com.dogma.UserData"%><%@page import="com.dogma.vo.ProcessVo"%><%@page import="com.dogma.business.querys.factory.QueryColumns"%><%@page import="com.dogma.vo.BusEntityVo"%><%@page import="biz.statum.sdk.util.FlagUtil"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="com.apia.security.SecurityFacade"%><%@page import="com.dogma.vo.QueryVo"%><%@page import="com.st.db.dataAccess.StatementFactory"%><%@page import="com.dogma.dataAccess.DBManagerUtil"%><%@page import="java.sql.ResultSet"%><%@page import="java.sql.PreparedStatement"%><%@page import="com.st.db.dataAccess.DBConnection"%><%@page import="java.sql.Connection"%><%@page import="com.st.db.dataAccess.ConnectionDAO"%><%! 
protected class Test extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

private boolean queryCanHaveFunctionality(String qryType) {
	return 	QueryVo.TYPE_QUERY.equals(qryType) || 
			QueryVo.TYPE_ENTITY.equals(qryType) || 
			QueryVo.TYPE_TASK_LIST.equals(qryType) || 
			QueryVo.TYPE_OFF_LINE.equals(qryType) || 
			QueryVo.TYPE_PROCESS_MONITOR.equals(qryType) || 
			QueryVo.TYPE_MON_ENTITY.equals(qryType) || 
			QueryVo.TYPE_TASK_MONITOR.equals(qryType);
}

%><%@page import="com.dogma.Parameters"%><% 	String doUpdate = request.getParameter("doUpdate");  %><html><head><title>Apia 3.0 Functionality URL Verifier</title><style type="text/css">
		body { font-family: verdana; font-size: 10px; }
		td { font-family: verdana; font-size: 10px; }
		pre { font-family: verdana; font-size: 10px; }
		input { font-family: verdana; font-size: 10px; }
		select { font-family: verdana; font-size: 10px; }
		a { text-decoration: none; color: blue; }
	</style></head><body>
Apia 3.0 functionalities URL's will be update. Select what to update: <a href="?doUpdate=query"><b>query</b></a>, <a href="?doUpdate=entity"><b>entities</b></a>, <a href="?doUpdate=process"><b>processes</b></a>, <a href="?doUpdate=bi"><b>BI</b></a>, <a href="?doUpdate=report"><b>reports</b></a>  or <a href="?doUpdate=all"><b>all</b></a>.
<%
	PreparedStatement ps = null;
	PreparedStatement psf = null;
	PreparedStatement psq = null;
	ResultSet resultSet = null;
	ResultSet resultSetQ = null;
	DBConnection dbConn = null;
	Connection con = null;

	if ("all".equals(doUpdate) || "query".equals(doUpdate)) { %><hr><b>Update of query functionalities</b><br><%
		
	    try {
			dbConn = DBManagerUtil.getApiaConnection();
			Test test = new Test();
			con =  test.getDBConnection2(dbConn);
	
			ps = StatementFactory.getStatement(con,"select * from query where fnc_id is not null",StatementFactory.DEBUG);
			psf = StatementFactory.getStatement(con,"update functionality set fnc_url = ? where fnc_id_auto = ?",StatementFactory.DEBUG);
	
			resultSet = ps.executeQuery();
	
			while (resultSet.next()) {
				Integer qryId = Integer.valueOf(resultSet.getInt("qry_id_auto"));
				String qryName = resultSet.getString("qry_name");
				String qryType = resultSet.getString("qry_type");
				int fncId = resultSet.getInt("fnc_id");
	
				if (! this.queryCanHaveFunctionality(qryType)) continue;
				
				String url = SecurityFacade.getInstance().createUrlQuery(qryType, qryId);
				
				psf.setString(1, url);
				psf.setInt(2, fncId);
				psf.execute();
				con.commit(); %>
				
				Query URL <b><%= qryName %> (<%= qryId %>)</b> updated to <b><%= url %></b><br><% 
	     		
	     	} 
		} catch (Exception e) {
			String error = StringUtil.toString(e, true); %><hr><font color="red">Error found: <%= e.getMessage() %></font><br><%= error %><%
			
		} finally {
			try {
				resultSet.close();
				ps.close();
				psf.close();
			} catch (Exception ignore) {}
			try {
				con.close();
				DBManagerUtil.close(dbConn);
			} catch (Exception ignore) {}
		}
	}

	if ("all".equals(doUpdate) || "entity".equals(doUpdate)) {
	    %><hr><b>Update of business entities functionalities</b><br><%
	    try {
			dbConn = DBManagerUtil.getApiaConnection();
			Test test = new Test();
			con =  test.getDBConnection2(dbConn);
	
			ps = StatementFactory.getStatement(con,"select * from bus_entity where fnc_id is not null",StatementFactory.DEBUG);
			psf = StatementFactory.getStatement(con,"update functionality set fnc_url = ? where fnc_id_auto = ?",StatementFactory.DEBUG);
			psq = StatementFactory.getStatement(con,"SELECT * FROM query q, qry_column qc WHERE q.reg_status = 0 AND qc.reg_status = 0 AND q.env_id = ? AND q.qry_type = ? AND qc.env_id = q.env_id AND qc.qry_id = q.qry_id_auto AND (qc.qry_col_name = ? OR qc.qry_col_name = ?) AND qc.qry_col_value = ?",StatementFactory.DEBUG);
	
			resultSet = ps.executeQuery();
	
			while (resultSet.next()) {
				Integer envId = Integer.valueOf(resultSet.getInt("env_id"));
				Integer busEntId = Integer.valueOf(resultSet.getInt("bus_ent_id_auto"));
				String busEntName = resultSet.getString("bus_ent_name");
				String busEntFlags = resultSet.getString("bus_ent_flags");
				Integer fncId = resultSet.getString("fnc_id") == null ? null : Integer.valueOf(resultSet.getInt("fnc_id"));
				Integer fncMonEntId = resultSet.getString("fnc_mon_ent_id") == null ? null : Integer.valueOf(resultSet.getInt("fnc_mon_ent_id"));

				if (fncId == null && fncMonEntId == null) continue;
				
				if (fncId != null) {
					boolean fncUpdated = false;
					if (FlagUtil.getFlagValue(busEntFlags, BusEntityVo.FLAG_HAS_AUTOMATIC_QUERY)) {
						psq.setInt(1, envId.intValue());
						psq.setString(2, QueryVo.TYPE_ENTITY_AUTOMATIC);
						psq.setString(3, QueryColumns.COLUMN_BUS_ENT_ID);
						psq.setString(4, QueryColumns.COLUMN_BUS_ENT_ID.toLowerCase());
						psq.setString(5, busEntId.toString());
						
						resultSetQ = psq.executeQuery();
						
						if (resultSetQ.next()) {
							Integer qryId = Integer.valueOf(resultSetQ.getInt("qry_id_auto"));
							
							String url = "apia.query.EntityInstanceAction.run?action=init&query=" + qryId.toString();
							
							psf.setString(1, url);
							psf.setInt(2, fncId);
							psf.execute();
							con.commit(); %>
							
							Business entity administration QUERY URL <b><%= busEntName %> (<%= busEntId %>)</b> updated to <b><%= url %></b><br><%
							fncUpdated = true;
						}
					}
					
					if (! fncUpdated) {
						String url = "apia.execution.EntInstanceListAction.run?action=init&busEntId=" + busEntId.toString();
						
						psf.setString(1, url);
						psf.setInt(2, fncId);
						psf.execute();
						con.commit(); %>
						
						Business entity administration URL <b><%= busEntName %> (<%= busEntId %>)</b> updated to <b><%= url %></b><br><%
					}
				}
				
				if (fncMonEntId != null) {
					String url = "apia.monitor.EntitiesAction.run?action=init&busEntId=" + busEntId.toString();
					
					psf.setString(1, url);
					psf.setInt(2, fncId);
					psf.execute();
					con.commit(); %>
					
					Business entity monitor URL <b><%= busEntName %> (<%= busEntId %>)</b> updated to <b><%= url %></b><br><%
				}
	     	} 
		} catch (Exception e) {
			String error = StringUtil.toString(e, true); %><hr><font color="red">Error found: <%= e.getMessage() %></font><br><%= error %><%
			
		} finally {
			try {
				resultSet.close();
				ps.close();
				psf.close();
				psq.close();
			} catch (Exception ignore) {}
			try {
				con.close();
				DBManagerUtil.close(dbConn);
			} catch (Exception ignore) {}
		} 
	}
	
	
	
	
	
	//-------inicio reportes
	
	if ("all".equals(doUpdate) || "report".equals(doUpdate)) {
	    %><hr><b>Update of reports functionalities</b><br><%
	    try {
			dbConn = DBManagerUtil.getApiaConnection();
			Test test = new Test();
			con =  test.getDBConnection2(dbConn);
	
			ps = StatementFactory.getStatement(con,"select * from report where fnc_id is not null",StatementFactory.DEBUG);
			psf = StatementFactory.getStatement(con,"update functionality set fnc_url = ? where fnc_id_auto = ?",StatementFactory.DEBUG);
	
			resultSet = ps.executeQuery();
	
			while (resultSet.next()) {
				Integer fncId = resultSet.getString("fnc_id") == null ? null : Integer.valueOf(resultSet.getInt("fnc_id"));
				String repName = resultSet.getString("rep_name");
				Integer repId = resultSet.getString("rep_id_auto") == null ? null : Integer.valueOf(resultSet.getInt("rep_id_auto"));
				if (fncId == null ) continue;
				
				if (fncId != null) {
						String url = "apia.execution.GenerateReportAction.run?action=init&repId=" + repId.toString();
						
						psf.setString(1, url);
						psf.setInt(2, fncId);
						psf.execute();
						con.commit(); %>
						
					Report URL <b><%= repName %> (<%= repId %>)</b> updated to <b><%= url %></b><br><%
					
				}
				
				
	     	} 
		} catch (Exception e) {
			String error = StringUtil.toString(e, true); %><hr><font color="red">Error found: <%= e.getMessage() %></font><br><%= error %><%
			
		} finally {
			try {
				resultSet.close();
				ps.close();
				psf.close();
				psq.close();
			} catch (Exception ignore) {}
			try {
				con.close();
				DBManagerUtil.close(dbConn);
			} catch (Exception ignore) {}
		} 
	}
	
	//-------fin reportes
	
	
	
	
	
	
	
	
	
	
	
	
	
	if ("all".equals(doUpdate) || "process".equals(doUpdate)) {
	    %><hr><b>Update of process functionalities</b><br><%
	    try {
			dbConn = DBManagerUtil.getApiaConnection();
			Test test = new Test();
			con =  test.getDBConnection2(dbConn);
	
			ps = StatementFactory.getStatement(con,"select p.*, bep.bus_ent_id from process p, bus_ent_process bep where p.env_id=bep.env_id and p.pro_id_auto = bep.pro_id and p.reg_status =0 and bep.reg_status=0 and fnc_id is not null",StatementFactory.DEBUG);
			psf = StatementFactory.getStatement(con,"update functionality set fnc_url = ? where fnc_id_auto = ?",StatementFactory.DEBUG);
	
			
			resultSet = ps.executeQuery();
	
			while (resultSet.next()) {
				Integer envId = Integer.valueOf(resultSet.getInt("env_id"));
				Integer proId = Integer.valueOf(resultSet.getInt("pro_id_auto"));
				String proName = resultSet.getString("pro_name");
				String proFlags = resultSet.getString("pro_flags");
				String proAction = resultSet.getString("pro_action");
				Integer entId = Integer.valueOf(resultSet.getInt("bus_ent_id"));
				Integer fncId = resultSet.getString("fnc_id") == null ? null : Integer.valueOf(resultSet.getInt("fnc_id"));
				 
				if (fncId == null ) continue;
				
				if (fncId != null) {
					boolean fncUpdated = false;
					if (FlagUtil.getFlagValue(proFlags, ProcessVo.FLAG_CREATE_FUNCTIONALITY)) {
						
						UserData userData = new UserData();
						userData.setUserId("admin");
						String url = SecurityFacade.getInstance().createUrlProcess(proAction, proId, entId, userData);
						
						psf.setString(1, url);
						psf.setInt(2, fncId);
						psf.execute();
						con.commit(); %>
						
						Pro  URL <b><%= proName %> (<%= proId %>)</b> updated to <b><%= url %></b><br><%
					}
				}
				
	     	} 
		} catch (Exception e) {
			String error = StringUtil.toString(e, true); %><hr><font color="red">Error found: <%= e.getMessage() %></font><br><%= error %><%
			
		} finally {
			try {
				resultSet.close();
				ps.close();
				psf.close();
				psq.close();
			} catch (Exception ignore) {}
			try {
				con.close();
				DBManagerUtil.close(dbConn);
			} catch (Exception ignore) {}
		} 
	}
	
	
	
	if ("all".equals(doUpdate) || "bi".equals(doUpdate)) {%><hr><b>Update of BI Navigator functionalities</b><br><%
	    try {
			dbConn = DBManagerUtil.getApiaConnection();
			Test test = new Test();
			con =  test.getDBConnection2(dbConn);
	
			ps = StatementFactory.getStatement(con,"select * from functionality where fnc_url like 'redirect.jsp?link=administration.BIAction.do%3Faction=navigator%'",StatementFactory.DEBUG);
			psf = StatementFactory.getStatement(con,"update functionality set fnc_url = ? where fnc_id_auto = ?",StatementFactory.DEBUG);
	
			resultSet = ps.executeQuery();
	
			while (resultSet.next()) {
				Integer fncId = Integer.valueOf(resultSet.getInt("fnc_id_auto"));
				String fncUrl = resultSet.getString("fnc_url");
				
				String theUrl = fncUrl;
				theUrl = StringUtil.replaceAll(theUrl, "%3F", "?");
				theUrl = StringUtil.replaceAll(theUrl, "&amp;", "&");
				
				String[] params	= StringUtil.split(StringUtil.split(theUrl, "?")[2], "&");
				StringBuffer url = new StringBuffer();
				url.append("apia.administration.BIAction.run?action=openNavigator");
				
				for (int i = 0; i < params.length; i++) {
					if (params[i].startsWith("action")) continue;
					url.append("&");
					url.append(params[i]);
				}
				
				psf.setString(1, url.toString());
				psf.setInt(2, fncId);
				psf.execute();
				con.commit(); %>
				
				BI URL from <b><%= fncUrl %></b> updated to <b><%= url %></b><br><%
	     	} 
		} catch (Exception e) {
			String error = StringUtil.toString(e, true); %><hr><font color="red">Error found: <%= e.getMessage() %></font><br><%= error %><%
			
		} finally {
			try {
				resultSet.close();
				ps.close();
				psf.close();
				psq.close();
			} catch (Exception ignore) {}
			try {
				con.close();
				DBManagerUtil.close(dbConn);
			} catch (Exception ignore) {}
		} %><hr><b>Update of BI Viewer functionalities</b><br><%
	    try {
			dbConn = DBManagerUtil.getApiaConnection();
			Test test = new Test();
			con =  test.getDBConnection2(dbConn);
	
			ps = StatementFactory.getStatement(con,"select * from functionality where fnc_url like 'redirect.jsp?link=administration.BIAction.do%3Faction=viewer%'",StatementFactory.DEBUG);
			psf = StatementFactory.getStatement(con,"update functionality set fnc_url = ? where fnc_id_auto = ?",StatementFactory.DEBUG);
	
			resultSet = ps.executeQuery();
	
			while (resultSet.next()) {
				Integer fncId = Integer.valueOf(resultSet.getInt("fnc_id_auto"));
				String fncUrl = resultSet.getString("fnc_url");
				
				String theUrl = fncUrl;
				theUrl = StringUtil.replaceAll(theUrl, "%3F", "?");
				theUrl = StringUtil.replaceAll(theUrl, "&amp;", "&");
				
				String[] params	= StringUtil.split(StringUtil.split(theUrl, "?")[2], "&");
				StringBuffer url = new StringBuffer();
				url.append("apia.administration.BIAction.run?action=openViewer");
				
				for (int i = 0; i < params.length; i++) {
					if (params[i].startsWith("action")) continue;
					url.append("&");
					url.append(params[i]);
				}
				
				psf.setString(1, url.toString());
				psf.setInt(2, fncId);
				psf.execute();
				con.commit(); %>
				
				BI URL from <b><%= fncUrl %></b> updated to <b><%= url %></b><br><%
	     	} 
		} catch (Exception e) {
			String error = StringUtil.toString(e, true); %><hr><font color="red">Error found: <%= e.getMessage() %></font><br><%= error %><%
			
		} finally {
			try {
				resultSet.close();
				ps.close();
				psf.close();
				psq.close();
			} catch (Exception ignore) {}
			try {
				con.close();
				DBManagerUtil.close(dbConn);
			} catch (Exception ignore) {}
		}
	} %></body></html>
