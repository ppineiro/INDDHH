<%@ page contentType="text/html; charset=utf-8" language="java"%><%@page import="com.st.db.dataAccess.ConnectionDAO"%><%@page import="java.sql.Connection"%><%@page import="com.dogma.dataAccess.DBManagerUtil"%><%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@page import="java.math.BigInteger"%><%@page import="java.sql.*"%><%@page import="org.apache.xmlbeans.XmlException"%><%@page import="biz.statum.x2009.apiaXPDL21.*"%><%@page import="biz.statum.x2009.apiaXPDL21.ActivityDocument.Activity"%><%@page import="biz.statum.x2009.apiaXPDL21.ApiaEventDocument.ApiaEvent"%><%@page import="biz.statum.x2009.apiaXPDL21.ApiaEventsDocument.ApiaEvents"%><%@page import="biz.statum.x2009.apiaXPDL21.ApiaProEventDocument.ApiaProEvent"%><%@page import="biz.statum.x2009.apiaXPDL21.ApiaProEventsDocument.ApiaProEvents"%><%@page import="biz.statum.x2009.apiaXPDL21.BusClaParBindingDocument.BusClaParBinding"%><%@page import="biz.statum.x2009.apiaXPDL21.BusClaParBindingsDocument.BusClaParBindings"%><%@page import="biz.statum.x2009.apiaXPDL21.FormRefDocument.FormRef"%><%@page import="biz.statum.x2009.apiaXPDL21.FormsRefDocument.FormsRef"%><%@page import="biz.statum.x2009.apiaXPDL21.TaskDocument.Task"%><%@page import="biz.statum.x2009.apiaXPDL21.WorkflowProcessesDocument.WorkflowProcesses"%><%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.*"%><%@page import="com.dogma.dao.*"%><%@page import="com.st.db.dataAccess.*"%><%@page import="com.st.util.i18n.I18N"%><%@page import="com.dogma.vo.custom.ProDefinitionVo"%><head><title>Change XPDLs</title><style type="text/css">
		body		{ font-family: verdana; font-size: 10px; }
		td			{ font-family: verdana; font-size: 10px; } 
		th			{ font-family: verdana; font-size: 10px; font-weight: normal;} 
		pre			{ font-family: verdana; font-size: 10px; }
		textarea	{ font-family: verdana; font-size: 10px; }
		input		{ font-family: verdana; font-size: 10px; }
		select		{ font-family: verdana; font-size: 10px; }
		
		table.conns									{ border-width: 0px; background-color: #FFFFFF; }
		table.conns	thead tr th						{ background-color: #EEEEEE; border-width: 1px; border-color: #EEEEEE; border-style: solid; }
		table.conns	thead tr th:hover				{ background-color: #EEEEEE; background-color: #DDDDDD; border-color: #DDDDDD; }
		table.conns	thead tr th.noHover:hover		{ background-color: #EEEEEE; background-color: #EEEEEE; }
		table.conns tbody tr td				 		{ border-color: #FFFFFF; border-style: solid; border-width: thin; padding: 1px; }
		table.conns tbody tr:hover 					{ background-color: #EEEEEE; }
		table.conns tbody tr:hover td				{ border-color: #EEEEEE; border-top-color: #DDDDDD; border-bottom-color: #DDDDDD; }
		table.conns tbody tr:hover td:hover 		{ background-color: #DDDDDD; border-color: #DDDDDD; border-top-color: #DDDDDD; border-bottom-color: #DDDDDD; }
		table.conns tbody tr:hover td.noHover:hover { background-color: #EEEEEE; border-color: #EEEEEE; border-top-color: #DDDDDD; border-bottom-color: #DDDDDD; }
		table.conns tbody tr:hover td.bold			{ font-weight: bold; border-top-color: #DDDDDD; border-bottom-color: #DDDDDD; }
		
		table.sql 									{ border-width: 0px; background-color: #FFFFFF; }
		table.sql thead th							{ border-style: solid; border-color: #000000; border-width: thin; background-color: #DDDDDD; font-weight: bold; text-align: center; }
		table.sql tbody td							{ border-style: solid; border-color: #DDDDDD; border-width: thin; white-space: nowrap; padding-left: 2px; padding-right: 5px; }
		table.sql thead tr th						{ border-style: solid; border-color: #DDDDDD; border-width: thin; }
		table.sql tbody tr:hover 					{ background-color: #DDDDDD; }
		table.sql tbody tr:hover td.noHover:hover	{ background-color: #FFFFFF; border-color: #FFFFFF; }
		table.sql tbody tr td.noHover				{ background-color: #FFFFFF; border-color: #FFFFFF; }
		
		a			{ text-decoration: none; color: blue; }
	</style></head><body><%! 

protected class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}


private static I18N resourceBundle = new I18N("com.dogma.dao.BPMNProcessDAO");
private static String SQL_GET_PROCS_TO_FIX	= resourceBundle.getString("SQL_GET_PROCS_TO_FIX");

protected class BaseToExistingXPDL {
	
	public ArrayList<String> changeXPDL(Integer envId, DBConnection dbConn, Connection conn) throws DogmaException {
		ArrayList<String> processedXPDLs = new ArrayList<String>();
		try {
			System.out.println("Changing XPDLs...");
			Collection<ProcessVo> procsToFix = getAllProcessesToFix(conn, envId);
			for (ProcessVo procToFix : procsToFix) {
				ProDefinitionVo proVo = CoreFacade.getInstance().getBpmnProcessDefinition(envId, procToFix.getProId(), procToFix.getProVerId(), Integer.valueOf(1), Integer.valueOf(1));
				String xpdlSimple = processXPDLToFix(proVo);
				BPMNProcessDAO.getInstance().updateXPDLComplete(dbConn, xpdlSimple, xpdlSimple, proVo);
				processedXPDLs.add(procToFix.getProName());
				System.out.println(procToFix.getProName());
			}
			if (processedXPDLs.size() > 0) {
				DBManagerUtil.commit(dbConn);
				System.out.println("XPDLs have been successfully changed");
			}
			return processedXPDLs;
		} catch (DAOException e) {
			DBManagerUtil.rollback(dbConn);
			throw new DogmaException(e);
		} catch (DogmaException e) {
			DBManagerUtil.rollback(dbConn);
			throw e;
		} catch (Exception e) {
			DBManagerUtil.rollback(dbConn);
			throw new DogmaException(e);
		} finally {
			DBManagerUtil.close(dbConn);
		}
	}

	private String processXPDLToFix(ProDefinitionVo proVo) throws DogmaException {
		ArrayList<String> proDefsXml = CoreFacade.getInstance().getBpmnXML(proVo);
		String xpdlMap = proDefsXml.get(0);
		String result = null;
		if (xpdlMap != null) {
			PackageDocument packDoc = null;
			try {
				packDoc = PackageDocument.Factory.parse(xpdlMap);
			} catch (XmlException xmle) {
	            throw new DogmaException(xmle);
	        }
			if (packDoc != null) {
		        PackageType packType = packDoc.getPackage();
		        WorkflowProcesses workflowProcesses = packType.getWorkflowProcesses();
	        	List<ProcessType> processes = workflowProcesses.getWorkflowProcessList();
	            ProcessType proc = processes.get(0);
	        	List<Activity> proActs = proc.getActivities().getActivityList();
	        	Collection<ProEleEvtBusClassVo> eleEvts = proVo.getEleEvents();
	        	Collection<ProEleFormVo> proEleFrms = proVo.getEleForms();
	        	Collection<ProEleBusEntFormVo> entFrms = proVo.getEntForms();
	        	boolean init = false;
				for (Activity act : proActs) {
					if (act.isSetImplementation() && act.getImplementation().isSetTask()) {
						Task tsk = act.getImplementation().getTask();
						if (eleEvts != null && eleEvts.size() > 0) {
							if (act.isSetApiaEvents()) {
								act.unsetApiaEvents();
							}
							ApiaEvents aEvts = act.addNewApiaEvents();
				        	for (ProEleEvtBusClassVo proEleEvt : eleEvts) {
				        		if (act.getId().equals(proEleEvt.getProEleId().toString())) {
				        			ApiaEvent aEvt = aEvts.addNewApiaEvent();			
				        			if (proEleEvt.getBusClaId() != null) {
				        				aEvt.setBusClaId(BigInteger.valueOf(proEleEvt.getBusClaId()));
				    				}
				        			aEvt.setBusClaName(proEleEvt.getBusClaName());
				        			aEvt.setEvtName(proEleEvt.getEvtName());
				    				if (proEleEvt.getEvtId() != null) {
				    					aEvt.setEvtId(BigInteger.valueOf(proEleEvt.getEvtId()));
				    				}
				    				if (proEleEvt.getProEleEvtBusClaExeOrder() != null) {
				    					aEvt.setProEleEvtBusClaExecOrder(BigInteger.valueOf(proEleEvt.getProEleEvtBusClaExeOrder()));
				    				}
		
				    				Collection<BusClaParBindingVo> binds = proEleEvt.getBindings();
				    				if (binds != null && binds.size() > 0) {
				    					if (aEvt.isSetBusClaParBindings()) {
				    						aEvt.unsetBusClaParBindings();
				    					}
				    					BusClaParBindings busClaParBinds = aEvt.addNewBusClaParBindings();
				    					for (BusClaParBindingVo bind : binds) {
				    						BusClaParBinding busClaParBindVal = busClaParBinds.addNewBusClaParBinding();
				    						if (bind.getAttId() != null) {
				    							busClaParBindVal.setAttId(BigInteger.valueOf(bind.getAttId()));
				    						}
				    						busClaParBindVal.setAttLabel(bind.getAttLabel());
				    						busClaParBindVal.setAttName(bind.getAttName());
				    						if (bind.getBusClaParBndId() != null) {
				    							busClaParBindVal.setBusClaParBndId(BigInteger.valueOf(bind.getBusClaParBndId()));
				    						}
				    						busClaParBindVal.setBusClaParBndType(bind.getBusClaParBndType());
				    						busClaParBindVal.setBusClaParBndValue(bind.getBusClaParBndValue());
				    						if (bind.getBusClaParId() != null) {
				    							busClaParBindVal.setBusClaParId(BigInteger.valueOf(bind.getBusClaParId()));
				    						}
				    						busClaParBindVal.setBusClaParName(bind.getBusClaParName());
				    						busClaParBindVal.setBusClaParType(bind.getBusClaParType());
				    					}
				    				}
				        		}
				        	}
						}
						
						if (proEleFrms != null && proEleFrms.size() > 0) {
							if (tsk.isSetFormsRef()) {
								tsk.unsetFormsRef();
								init = true;
							}
							FormsRef frmsRef = tsk.addNewFormsRef();
							for (ProEleFormVo proEleFrm : proEleFrms) {
								if (act.getId().equals(proEleFrm.getProEleId().toString())) {
									FormRef frmRef = frmsRef.addNewFormRef();
									frmRef.setFrmId(BigInteger.valueOf(proEleFrm.getFrmId()));
									frmRef.setFrmName(proEleFrm.getFrmName());
									frmRef.setFrmType(FormRefDocument.FormRef.FrmType.P);
									frmRef.setProEleFrmStepId(BigInteger.valueOf(proEleFrm.getProEleFrmStepId()));
									frmRef.setProEleFrmReadOnly(BigInteger.valueOf(proEleFrm.getProEleFrmReadonly()));
									frmRef.setProEleFrmOrder(BigInteger.valueOf(proEleFrm.getProEleFrmOrder()));
									frmRef.setProEleFrmMultiply(proEleFrm.getProEleFrmMultiply());
									frmRef.setProEleFrmEvalCond(proEleFrm.getProEleFrmEvalCond());
									frmRef.setProEleFrmEvalSql(proEleFrm.getProEleFrmEvalSql());
								}
							}
						}
			        	if (entFrms != null && entFrms.size() > 0) {
			        		FormsRef frmsRef = tsk.getFormsRef();
			        		if (!init) {
			        			if (tsk.isSetFormsRef()) {
			        				tsk.unsetFormsRef();
			        			}
			        			frmsRef = tsk.addNewFormsRef();
			        		}
			        		for (ProEleBusEntFormVo entFrm : entFrms) {
			        			if (act.getId().equals(entFrm.getProEleId().toString())){
			        				FormRef frmRef = frmsRef.addNewFormRef();
			        				frmRef.setFrmId(BigInteger.valueOf(entFrm.getFrmId()));
									frmRef.setFrmName(entFrm.getFrmName());
									frmRef.setFrmType(FormRefDocument.FormRef.FrmType.E);
									frmRef.setBusEntId(BigInteger.valueOf(entFrm.getBusEntId()));
									frmRef.setProEleFrmStepId(BigInteger.valueOf(entFrm.getProEleBusEntFrmStepId()));
									frmRef.setProEleFrmReadOnly(BigInteger.valueOf(entFrm.getProEleBusEntFrmReadonly()));
									frmRef.setProEleFrmOrder(BigInteger.valueOf(entFrm.getProEleBusEntFrmOrder()));
									frmRef.setProEleFrmMultiply(entFrm.getProEleBusEntFrmMultiply());
									frmRef.setProEleFrmEvalCond(entFrm.getProEleBusEntFrmEvalCond());
									frmRef.setProEleFrmEvalSql(entFrm.getProEleBusEntFrmEvalSql());
			        			}
			        		}
			        	}
					}
				}
	    		Collection<ProEvtBusClassVo> proEvts = proVo.getProEvents();
	    		if (proEvts != null && proEvts.size() > 0) {
	    			if (proc.isSetApiaProEvents()) {
	    				proc.unsetApiaProEvents();
	    			}

	    			ApiaProEvents aProEvts = proc.addNewApiaProEvents();
	    			for (ProEvtBusClassVo proEvt : proEvts) {
	    				
	    				ApiaProEvent aProEvt = aProEvts.addNewApiaProEvent();
	    				
	    				if (proEvt.getBusClaId() != null) {
	    					aProEvt.setBusClaId(BigInteger.valueOf(proEvt.getBusClaId()));
	    				}
	    				aProEvt.setBusClaName(proEvt.getBusClaName());
	    				aProEvt.setEvtName(proEvt.getEvtName());
	    				if (proEvt.getEvtId() != null) {
	    					aProEvt.setEvtId(BigInteger.valueOf(proEvt.getEvtId()));
	    				}
	    				if (proEvt.getProEvtBusClaExeOrder() != null) {
	    					aProEvt.setProEvtBusClaExecOrder(BigInteger.valueOf(proEvt.getProEvtBusClaExeOrder()));
	    				}
	    				
	    				Collection<BusClaParBindingVo> binds = proEvt.getBindings();
	    				if (binds != null && binds.size() > 0) {
	    					if (aProEvt.isSetBusClaParBindings()) {
	    						aProEvt.unsetBusClaParBindings();
	    					}
	    					BusClaParBindings busClaParBinds = aProEvt.addNewBusClaParBindings();
	    					for (BusClaParBindingVo bind : binds) {
	    						BusClaParBinding busClaParBindVal = busClaParBinds.addNewBusClaParBinding();
	    						if (bind.getAttId() != null) {
	    							busClaParBindVal.setAttId(BigInteger.valueOf(bind.getAttId()));
	    						}
	    						busClaParBindVal.setAttLabel(bind.getAttLabel());
	    						busClaParBindVal.setAttName(bind.getAttName());
	    						if (bind.getBusClaParBndId() != null) {
	    							busClaParBindVal.setBusClaParBndId(BigInteger.valueOf(bind.getBusClaParBndId()));
	    						}
	    						busClaParBindVal.setBusClaParBndType(bind.getBusClaParBndType());
	    						busClaParBindVal.setBusClaParBndValue(bind.getBusClaParBndValue());
	    						if (bind.getBusClaParId() != null) {
	    							busClaParBindVal.setBusClaParId(BigInteger.valueOf(bind.getBusClaParId()));
	    						}
	    						busClaParBindVal.setBusClaParName(bind.getBusClaParName());
	    						busClaParBindVal.setBusClaParType(bind.getBusClaParType());
	    					}
	    				}
	    			}
	    		}
			}
			result = packDoc.toString();
		}
		return result;
	}

	private Collection<ProcessVo> getAllProcessesToFix(Connection conn,Integer envId) throws DAOException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		ProcessVo process = null;
		Collection<ProcessVo> colRet = new ArrayList<ProcessVo>();
		try {
			statement = StatementFactory.getStatement(conn,SQL_GET_PROCS_TO_FIX,StatementFactory.DEBUG);
			statement.setInt(1, envId.intValue());
			resultSet = statement.executeQuery();
			while(resultSet.next()){
				process = ProcessDAO.getInstance().createVo(resultSet);
				colRet.add(process);
			}
			return colRet;
		} catch (SQLException e) {
			throw new DAOException(e, statement.toString());
		} finally{
			try{
				statement.close();
			} catch (SQLException sqle){
				throw new DAOException(sqle);
			}
		}		
	}	
}

%><%
Object paramLogged = request.getSession().getAttribute("logged");
Boolean logged = null;
if (paramLogged instanceof Boolean) logged = (Boolean) paramLogged;

if (logged == null) logged = new Boolean(false);
if (request.getParameter("logout") != null) logged = new Boolean(false);

if (! logged.booleanValue()) {
	String user = request.getParameter("user");
	String pwd = request.getParameter("pwd");
	
	logged = new Boolean("admin".equals(user) && "admin22".equals(pwd));
	request.getSession().setAttribute("logged",logged);
}
%><html><head></head><body><% 
if (logged.booleanValue()) {
	DBConnection dbConn = null;
	try {
		BaseToExistingXPDL btex = new BaseToExistingXPDL();
		dbConn = DBManagerUtil.getApiaConnection();
		ConnectionGetter conGetter = new ConnectionGetter();
		Connection conn = conGetter.getDBConnection2(dbConn);
		ArrayList<String> processedXPDLs = btex.changeXPDL(Integer.valueOf(1),dbConn,conn);
		logged = Boolean.valueOf(false); 
		%><div><center><b>User Options</b></center><center><a href="?logout=yes">Logout</a></center><br><center><b>Operation Complete</b></center><br></div><% if (processedXPDLs.size() > 0) { %><div><center><b>The following processes have been successfully changed: </b></center><br><% }
		for (String proName : processedXPDLs) {
			%><center><%=proName%></center><br><%
		}
		%></div><%
	} catch (Exception e) {
		System.out.println(e);
	}  finally {
		if (dbConn != null) {
			try {
				dbConn.close();
			} catch (Exception e) {
				System.out.println(e);
			}
		}
	}
} else { %><form action="" method="post"><b>Login is require to continue</b><br>
		User: <input type="text" name="user"><br>
		Password: <input type="password" name="pwd"><br><input type="submit" value="Login"></form><% } %></body></html>




