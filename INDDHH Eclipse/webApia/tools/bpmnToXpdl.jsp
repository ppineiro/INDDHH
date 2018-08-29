<%@page import="com.st.db.dataAccess.DAOException"%>
<%@page import="com.dogma.DogmaException"%>
<%@page import="com.st.db.dataAccess.DBConnection"%>
<%@page import="com.st.db.dataAccess.StatementFactory"%>
<%@page import="com.st.util.i18n.I18N"%>
<%@page import="java.io.*"%>
<%@page import="java.math.BigInteger"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.xmlbeans.*"%>
<%@page import="org.wfmc.x2008.xpdl21.*"%>
<%@page import="com.dogma.*"%>
<%@page import="com.dogma.vo.*"%>
<%@page import="com.dogma.dao.*"%>
<%@page import="com.dogma.vo.custom.ProDefinitionVo"%>
<%@page import="com.st.db.dataAccess.ConnectionDAO"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.dogma.dataAccess.DBManagerUtil"%>
<%@page import="com.apia.core.CoreFacade"%>
<%@page import="org.wfmc.x2008.xpdl21.ActivitiesDocument.Activities"%>
<%@page import="org.wfmc.x2008.xpdl21.ActivityDocument.Activity"%>
<%@page import="org.wfmc.x2008.xpdl21.ActivitySetDocument.ActivitySet"%>
<%@page import="org.wfmc.x2008.xpdl21.ActivitySetsDocument.ActivitySets"%>
<%@page import="org.wfmc.x2008.xpdl21.BlockActivityDocument.BlockActivity"%>
<%@page import="org.wfmc.x2008.xpdl21.ConditionDocument.Condition"%>
<%@page import="org.wfmc.x2008.xpdl21.ConnectorGraphicsInfoDocument.ConnectorGraphicsInfo"%>
<%@page import="org.wfmc.x2008.xpdl21.ConnectorGraphicsInfosDocument.ConnectorGraphicsInfos"%>
<%@page import="org.wfmc.x2008.xpdl21.CoordinatesDocument.Coordinates"%>
<%@page import="org.wfmc.x2008.xpdl21.EndEventDocument.EndEvent"%>
<%@page import="org.wfmc.x2008.xpdl21.EventDocument.Event"%>
<%@page import="org.wfmc.x2008.xpdl21.ImplementationDocument.Implementation"%>
<%@page import="org.wfmc.x2008.xpdl21.LoopDocument.Loop"%>
<%@page import="org.wfmc.x2008.xpdl21.LoopMultiInstanceDocument.LoopMultiInstance"%>
<%@page import="org.wfmc.x2008.xpdl21.LoopStandardDocument.LoopStandard"%>
<%@page import="org.wfmc.x2008.xpdl21.NodeGraphicsInfoDocument.NodeGraphicsInfo"%>
<%@page import="org.wfmc.x2008.xpdl21.NodeGraphicsInfosDocument.NodeGraphicsInfos"%>
<%@page import="org.wfmc.x2008.xpdl21.PackageHeaderDocument.PackageHeader"%>
<%@page import="org.wfmc.x2008.xpdl21.ParticipantDocument.Participant"%>
<%@page import="org.wfmc.x2008.xpdl21.ParticipantsDocument.Participants"%>
<%@page import="org.wfmc.x2008.xpdl21.PerformerDocument.Performer"%>
<%@page import="org.wfmc.x2008.xpdl21.PerformersDocument.Performers"%>
<%@page import="org.wfmc.x2008.xpdl21.PoolDocument.Pool"%>
<%@page import="org.wfmc.x2008.xpdl21.PoolsDocument.Pools"%>
<%@page import="org.wfmc.x2008.xpdl21.RouteDocument.Route"%>
<%@page import="org.wfmc.x2008.xpdl21.StartEventDocument.StartEvent"%>
<%@page import="org.wfmc.x2008.xpdl21.SubFlowDocument.SubFlow"%>
<%@page import="org.wfmc.x2008.xpdl21.TaskDocument.Task"%>
<%@page import="org.wfmc.x2008.xpdl21.TransitionDocument.Transition"%>
<%@page import="org.wfmc.x2008.xpdl21.TransitionsDocument.Transitions"%>
<%@page import="org.wfmc.x2008.xpdl21.WorkflowProcessesDocument.WorkflowProcesses"%>
<%//@page import="com.dogma.xpdl.BaseToXPDL"%>


<head>
	<title>Base to XPDL</title>
	<style type="text/css">
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
	</style>
</head>
<body>

<%!

protected class ConnectionGetter extends ConnectionDAO {
	public Connection getDBConnection2(DBConnection dbConn) {
		return ConnectionDAO.getDBConnection(dbConn);
	}
}

private static I18N resourceBundle = new I18N("com.dogma.dao.BPMNProcessDAO");
//private static I18N resourceBundle = new I18N("com.dogma.dao.ProcessDAO");

private static String SQL_XPDL_TRANSITIONS_2	= resourceBundle.getString("SQL_XPDL_TRANSITIONS_2");
private static String SQL_XPDL_ACTIVITIES		= resourceBundle.getString("SQL_XPDL_ACTIVITIES");
private static String SQL_XPDL_ACT_FORMS		= resourceBundle.getString("SQL_XPDL_ACT_FORMS");
private static String SQL_XPDL_ACT_FORMS_ATTS	= resourceBundle.getString("SQL_XPDL_ACT_FORMS_ATTS");
private static String SQL_XPDL_ACT_FORMS_EVTS	= resourceBundle.getString("SQL_XPDL_ACT_FORMS_EVTS");
private static String SQL_XPDL_PRO_EVTS			= resourceBundle.getString("SQL_XPDL_PRO_EVTS");
private static String SQL_XPDL_PRO_ELE_EVTS		= resourceBundle.getString("SQL_XPDL_PRO_ELE_EVTS");
private static String SQL_XPDL_PERFORMERS		= resourceBundle.getString("SQL_XPDL_PERFORMERS");
private static String SQL_XPDL_TRAN_CONDITION	= resourceBundle.getString("SQL_XPDL_TRAN_CONDITION");

//private static String SQL_PROCS_TO_GEN_ENV_ID		= resourceBundle.getString("SQL_PROCS_TO_GEN_ENV_ID");
private static String SQL_PROCS_BPMN_TO_GEN_ENV_ID	= resourceBundle.getString("SQL_PROCS_BPMN_TO_GEN_ENV_ID");
private static String SQL_PROCS_TO_GEN_PRO_NAME		= resourceBundle.getString("SQL_PROCS_TO_GEN_PRO_NAME");

private ConnectionGetter conGetter = new ConnectionGetter();

protected class BaseToXPDL {

	//private ConnectionGetter conGetter = new ConnectionGetter();
	private HashSet<Integer> randomElems = new HashSet<Integer>();
	
	
	public void generateXPDLFile(Connection conn, DBConnection dbConn, Integer envId, ProDefinitionVo proVo, String pathFile, Integer lblSetId,Integer langId) throws DogmaException {
		PrintWriter out = null;
		try {
			//armar archivo xpdl
			org.wfmc.x2008.xpdl21.PackageDocument packDoc = getXPDLWorkflowProcStandard(dbConn, conn, envId, proVo);
		
			XmlOptions validateOptions = new XmlOptions();
			ArrayList<XmlError> errors = new ArrayList<XmlError>();
			validateOptions.setErrorListener(errors);
			 
			boolean ok = packDoc.validate(validateOptions);
			StringBuffer errorMsgs = new StringBuffer();
			if (!ok) {
				for (int i = 0; i < errors.size(); i++) {
					XmlError error = errors.get(i);

					errorMsgs.append("\n");
					errorMsgs.append("Message: " + error.getMessage() + "\n");
					errorMsgs.append("Location of invalid XML: " + error.getCursorLocation().xmlText() + "\n");
				}
				throw new DogmaException(errorMsgs.toString());
			}
			 
			//escribir archivo xpdl
			out = new PrintWriter(new File(pathFile),"UTF-8");
			out.println(XMLTags.XML_HEAD_UTF);
			out.println(packDoc);
			
			if (out.checkError()) {
				throw new DogmaException("Ocurrió un error escribiendo el archivo XPDL de exportación.");
			}
		} catch(FileNotFoundException e) {
			throw new DogmaException(e);
		} catch(UnsupportedEncodingException e) {
			throw new DogmaException(e);
		} catch(Exception e) {
			throw new DogmaException(e);
		} finally {
			if (out != null) {
				out.close();
			}
		}
	}
	
	private HashMap<String,String> mapProEleIds(ProDefinitionVo proVo) throws DogmaException {
		ArrayList<String> proDefsXml = CoreFacade.getInstance().getBpmnXML(proVo);
		String xpdlMap = proDefsXml.get(0);
		HashMap<String,String> result = new HashMap<String,String>();
		if (xpdlMap != null) {
			biz.statum.x2009.apiaXPDL21.PackageDocument packDoc = null;
			try {
				packDoc = biz.statum.x2009.apiaXPDL21.PackageDocument.Factory.parse(xpdlMap);
			} catch (XmlException xmle) {
				throw new DogmaException(xmle);
			}
			if (packDoc != null) {
				biz.statum.x2009.apiaXPDL21.PackageType packType = packDoc.getPackage();
				biz.statum.x2009.apiaXPDL21.WorkflowProcessesDocument.WorkflowProcesses workflowProcesses = packType.getWorkflowProcesses();
				List<biz.statum.x2009.apiaXPDL21.ProcessType> processes = workflowProcesses.getWorkflowProcessList();
				biz.statum.x2009.apiaXPDL21.ProcessType proc = processes.get(0);
				List<biz.statum.x2009.apiaXPDL21.ActivityDocument.Activity> proActs = proc.getActivities().getActivityList();
				for (biz.statum.x2009.apiaXPDL21.ActivityDocument.Activity act : proActs) {
					if (act.getName() != null) {
						String id = act.getId();
						if (act.isSetBlockActivity()) {
							id = act.getBlockActivity().getActivitySetId();
						} else if (act.isSetImplementation() && act.getImplementation().isSetSubFlow()) {
							id = act.getImplementation().getSubFlow().getId();
						}
						result.put(id, act.getName());
					}
				}
			}
		}
		return result;
	}
	
	private org.wfmc.x2008.xpdl21.PackageDocument getXPDLWorkflowProcStandard(DBConnection dbConn, Connection conn, Integer envId, ProDefinitionVo proVo) throws DAOException, DogmaException {
		PreparedStatement statement = null;
		try {
			org.wfmc.x2008.xpdl21.PackageDocument newPackage = org.wfmc.x2008.xpdl21.PackageDocument.Factory.newInstance();
			PackageType packType = newPackage.addNewPackage();
			Date fechaActual = new Date();
			packType.setId(proVo.getProId()+"_"+proVo.getProVerId()+"_"+fechaActual.getTime());
			PackageHeader packHeader = packType.addNewPackageHeader();
			packHeader.addNewXPDLVersion().setStringValue("2.1");
			packHeader.addNewVendor().setStringValue("STATUM");
			packHeader.addNewCreated().setStringValue(fechaActual.toString());
			Pools pools = packType.addNewPools();
			Pool pool = pools.addNewPool();
			pool.setBoundaryVisible(false);
			pool.setMainPool(true);
			pool.setProcess(proVo.getProId().toString());
			pool.setId(proVo.getProId()+"_"+proVo.getProVerId());
			NodeGraphicsInfos graphInfos = pool.addNewNodeGraphicsInfos();
			NodeGraphicsInfo graphInfo = graphInfos.addNewNodeGraphicsInfo();
			Coordinates coords = graphInfo.addNewCoordinates();
			coords.setXCoordinate(0.0);
			coords.setYCoordinate(0.0);
			WorkflowProcesses wProcs = packType.addNewWorkflowProcesses();
			ProcessType wProc = wProcs.addNewWorkflowProcess();
			wProc.setId(proVo.getProId().toString());
			wProc.setName(proVo.getProName());
			wProc.addNewProcessHeader();
			String proEleIdsFrom = getXPDLProcTransitionsStandard(conn, envId, proVo, wProc);
			HashMap<String,String> mapProEleNames = mapProEleIds(proVo);
			getXPDLProcActivitiesStandard(dbConn, conn, envId, proVo, wProc, wProcs, packType, proEleIdsFrom, mapProEleNames);
			
			String procDoc = "";
			boolean addProcDoc = false;
			String processDoc = getProcDocumentation(dbConn, envId, proVo.getProId());
			if (processDoc.length() > 0) {
				procDoc += "&lt;documentation&gt;" + processDoc + "&lt;/documentation&gt;";
				addProcDoc = true;
			}
			
			statement = StatementFactory.getStatement(conn,SQL_XPDL_PRO_EVTS,StatementFactory.DEBUG);
			statement.setInt(1, envId);
			statement.setInt(2, proVo.getProId());
			statement.setInt(3, proVo.getProVerId());
			ResultSet resultSet = statement.executeQuery();
			String docEvts = "&lt;events&gt;";
			boolean addEvtDoc = false;
			while(resultSet.next()) {
				docEvts += "&lt;event ";
				String evtName = resultSet.getString("evt_name");
				docEvts += "evtName=&quot;"+evtName+"&quot; ";
				String busClaName = resultSet.getString("bus_cla_name");
				docEvts += "busClaName=&quot;"+busClaName+"&quot; ";
				String busClaDesc = resultSet.getString("bus_cla_desc");
				if (busClaDesc == null) {
					busClaDesc = "";
				}
				docEvts += "busClaDesc=&quot;"+busClaDesc+"&quot; ";
				docEvts += "/&gt;";
				addEvtDoc = true;
				addProcDoc = true;
			}
			docEvts += "&lt;/events&gt;";
			if (addEvtDoc) {
				procDoc += docEvts;
			}
			if (addProcDoc) {
				org.wfmc.x2008.xpdl21.ObjectDocument.Object obj = wProc.addNewObject();
				obj.setId(getRandomElementId().toString());
				obj.addNewDocumentation().setStringValue(procDoc);
			}

			return newPackage;
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
	
	private String getProcDocumentation(DBConnection dbConn, Integer envId, Integer proId) throws DAOException{
		String procDoc = "";
		try {
			ProDocFieldsVo proDocFieldsVo = ProDocFieldsDAO.getInstance().getProDocFieldsVo(dbConn, envId, proId);
			if (proDocFieldsVo != null) {
				String proDocObj = proDocFieldsVo.getProDocObj();
				if (proDocObj != null && proDocObj.length() > 0) {
					procDoc += "Objetivo del proceso: " + proDocObj + " \n";
				}
				String fld1 = proDocFieldsVo.getProDocField1();
				String fldDesc1 = proDocFieldsVo.getProDocField1Desc();
				if ((fld1 != null && fld1.length() > 0) || (fldDesc1 != null && fldDesc1.length() > 0)) {
					procDoc += fld1 + ": " + fldDesc1 + " \n";
				}
				String fld2 = proDocFieldsVo.getProDocField2();
				String fldDesc2 = proDocFieldsVo.getProDocField2Desc();
				if ((fld2 != null && fld2.length() > 0) || (fldDesc2 != null && fldDesc2.length() > 0)) {
					procDoc += fld2 + ": " + fldDesc2 + " \n";
				}
				String fld3 = proDocFieldsVo.getProDocField3();
				String fldDesc3 = proDocFieldsVo.getProDocField3Desc();
				if ((fld3 != null && fld3.length() > 0) || (fldDesc3 != null && fldDesc3.length() > 0)) {
					procDoc += fld3 + ": " + fldDesc3 + " \n";
				}
				String fld4 = proDocFieldsVo.getProDocField4();
				String fldDesc4 = proDocFieldsVo.getProDocField4Desc();
				if ((fld4 != null && fld4.length() > 0) || (fldDesc4 != null && fldDesc4.length() > 0)) {
					procDoc += fld4 + ": " + fldDesc4 + " \n";
				}
				String fld5 = proDocFieldsVo.getProDocField5();
				String fldDesc5 = proDocFieldsVo.getProDocField5Desc();
				if ((fld5 != null && fld5.length() > 0) || (fldDesc5 != null && fldDesc5.length() > 0)) {
					procDoc += fld5 + ": " + fldDesc5 + " \n";
				}
				String fld6 = proDocFieldsVo.getProDocField6();
				String fldDesc6 = proDocFieldsVo.getProDocField6Desc();
				if ((fld6 != null && fld6.length() > 0) || (fldDesc6 != null && fldDesc6.length() > 0)) {
					procDoc += fld6 + ": " + fldDesc6 + " \n";
				}
				String fld7 = proDocFieldsVo.getProDocField7();
				String fldDesc7 = proDocFieldsVo.getProDocField7Desc();
				if ((fld7 != null && fld7.length() > 0) || (fldDesc7 != null && fldDesc7.length() > 0)) {
					procDoc += fld7 + ": " + fldDesc7 + " \n";
				}
				String fld8 = proDocFieldsVo.getProDocField8();
				String fldDesc8 = proDocFieldsVo.getProDocField8Desc();
				if ((fld8 != null && fld8.length() > 0) || (fldDesc8 != null && fldDesc8.length() > 0)) {
					procDoc += fld8 + ": " + fldDesc8 + " \n";
				}
				String fld9 = proDocFieldsVo.getProDocField9();
				String fldDesc9 = proDocFieldsVo.getProDocField9Desc();
				if ((fld9 != null && fld9.length() > 0) || (fldDesc9 != null && fldDesc9.length() > 0)) {
					procDoc += fld9 + ": " + fldDesc9 + " \n";
				}
				String fld10 = proDocFieldsVo.getProDocField10();
				String fldDesc10 = proDocFieldsVo.getProDocField10Desc();
				if ((fld10 != null && fld10.length() > 0) || (fldDesc10 != null && fldDesc10.length() > 0)) {
					procDoc += fld10 + ": " + fldDesc10 + " \n";
				}
				String fld11 = proDocFieldsVo.getProDocField11();
				String fldDesc11 = proDocFieldsVo.getProDocField11Desc();
				if ((fld11 != null && fld11.length() > 0) || (fldDesc11 != null && fldDesc11.length() > 0)) {
					procDoc += fld11 + ": " + fldDesc11 + " \n";
				}
				String fld12 = proDocFieldsVo.getProDocField12();
				String fldDesc12 = proDocFieldsVo.getProDocField12Desc();
				if ((fld12 != null && fld12.length() > 0) || (fldDesc12 != null && fldDesc12.length() > 0)) {
					procDoc += fld12 + ": " + fldDesc12 + " \n";
				}
				String fld13 = proDocFieldsVo.getProDocField13();
				String fldDesc13 = proDocFieldsVo.getProDocField13Desc();
				if ((fld13 != null && fld13.length() > 0) || (fldDesc13 != null && fldDesc13.length() > 0)) {
					procDoc += fld13 + ": " + fldDesc13 + " \n";
				}
				String fld14 = proDocFieldsVo.getProDocField14();
				String fldDesc14 = proDocFieldsVo.getProDocField14Desc();
				if ((fld14 != null && fld14.length() > 0) || (fldDesc14 != null && fldDesc14.length() > 0)) {
					procDoc += fld14 + ": " + fldDesc14 + " \n";
				}
				String fld15 = proDocFieldsVo.getProDocField15();
				String fldDesc15 = proDocFieldsVo.getProDocField15Desc();
				if ((fld15 != null && fld15.length() > 0) || (fldDesc15 != null && fldDesc15.length() > 0)) {
					procDoc += fld15 + ": " + fldDesc15 + " \n";
				}
			}
			return procDoc;
		} catch (DAOException e) {
			throw e;
		}
	}
	
	private String getTaskDocumentation(DBConnection dbConn, Integer envId, Integer tskId) throws DAOException{
		String tskDoc = "";
		try {
			TskDocFieldsVo tskDocFieldsVo = TskDocFieldsDAO.getInstance().getTskDocFieldsVo(dbConn, envId, tskId);
			if (tskDocFieldsVo != null) {
				String actDesc = tskDocFieldsVo.getTskDocDesc();
				if (actDesc != null && actDesc.length() > 0) {
					tskDoc += "Descripción genérica: " + actDesc + " \n";
				}
				
				String actMan = tskDocFieldsVo.getTskDocActMan();
				String actTar = tskDocFieldsVo.getTskDocActTar();
				String actManPos = tskDocFieldsVo.getTskDocActManPos();
				if ((actMan != null && actMan.length() > 0) || (actTar != null && actTar.length() > 0) || (actManPos != null && actManPos.length() > 0)) {
					tskDoc += "\nCurso básico \n";
					if (actMan != null && actMan.length() > 0) {
						tskDoc += "Acciones manuales anteriores: " + actMan + " \n";
					}
					if (actTar != null && actTar.length() > 0) {
						tskDoc += "Acciones de la tarea: " + actTar + " \n";
					}
					if (actManPos != null && actManPos.length() > 0) {
						tskDoc += "Acciones manuales posteriores: " + actManPos + " \n";
					}
				}
				
				String actManAnt = tskDocFieldsVo.getTskDocActManAnt();
				String actTarAlt = tskDocFieldsVo.getTskDocActTarAlt();
				String actManPosAlt = tskDocFieldsVo.getTskDocActManPosAlt();
				if ((actManAnt != null && actManAnt.length() > 0) || (actTarAlt != null && actTarAlt.length() > 0) || (actManPosAlt != null && actManPosAlt.length() > 0)) {
					tskDoc += "\nCurso alternativo \n";
					if (actManAnt != null && actManAnt.length() > 0) {
						tskDoc += "Acciones manuales anteriores: " + actManAnt + " \n";
					}
					
					if (actTarAlt != null && actTarAlt.length() > 0) {
						tskDoc += "Acciones de la tarea: " + actTarAlt + " \n";
					}
					
					if (actManPosAlt != null && actManPosAlt.length() > 0) {
						tskDoc += "Acciones manuales posteriores: " + actManPosAlt + " \n";
					}
				}
			}
			return tskDoc;
		} catch (DAOException e) {
			throw e;
		}
	}
	
	
	private Integer getRandomElementId() {
		String id = String.valueOf(System.currentTimeMillis());
		String dividendo = id.substring(4);
		Integer dividendoFinal = Integer.valueOf(dividendo);
		if (dividendoFinal.toString().length() < 9) {
			while (dividendo.length() < 9) {
				dividendo += dividendo + "1";
			}
		}
		String divisor = id.substring(0,2);
		double coef1 = Math.random();
		while (coef1 < 0.1) {
			coef1 = Math.random();
		}
		double dividendoTmp = Integer.valueOf(dividendo)*coef1;
		int divisorTmp = Integer.valueOf(divisor);
		double coef2 = Math.random();
		while (coef2 < 0.1) {
			coef2 = Math.random();
		}
		Double idTmp = Double.valueOf((dividendoTmp / divisorTmp)*coef2);
		Integer result = Integer.valueOf(idTmp.intValue());
		if (randomElems.add(result)) {
			return result;
		} else {
			return getRandomElementId();
		}
	}

	
	private void getXPDLProcActivitiesStandard(DBConnection dbConn, Connection conn, Integer envId, ProDefinitionVo proVo, ProcessType wProc, WorkflowProcesses wProcs, PackageType packType, String proEleIdsFrom, HashMap<String,String> mapProEleNames) throws DAOException {
		PreparedStatement statement = null;
		PreparedStatement stmtFrm = null;
		PreparedStatement stmtAtt = null;
		PreparedStatement stmtEvt = null;
		PreparedStatement stmtFrmEvt = null;
		ResultSet resultSet = null;
		Activities acts = Activities.Factory.newInstance();
		HashMap<Integer,ArrayList<PoolVo>> proElements = new HashMap<Integer,ArrayList<PoolVo>>();
		HashMap<Integer,Boolean> eleIsTask = new HashMap<Integer,Boolean>();
		HashMap<Integer,PoolVo> participants = new HashMap<Integer,PoolVo>();
		HashSet<Integer> poolVoIds = new HashSet<Integer>();
		try {
			statement = StatementFactory.getStatement(conn,SQL_XPDL_ACTIVITIES,StatementFactory.DEBUG);
			statement.setInt(1, envId);
			statement.setInt(2, proVo.getProId());
			statement.setInt(3, proVo.getProVerId());
			resultSet = statement.executeQuery();
			while(resultSet.next()) {
				Activity act = acts.addNewActivity();
				Integer proEleId = resultSet.getInt("pro_ele_id_auto");
				act.setId(proEleId.toString());
				proElements.put(proEleId,new ArrayList<PoolVo>());
				
				if (resultSet.getObject("pro_ele_start") != null || resultSet.getObject("pro_ele_end") != null) {
					Event evt = act.addNewEvent();
					if (resultSet.getInt("pro_ele_start") == 1) {
						StartEvent startEvt = evt.addNewStartEvent();
						startEvt.setImplementation(StartEventDocument.StartEvent.Implementation.OTHER);
						startEvt.setTrigger(StartEventDocument.StartEvent.Trigger.NONE);
					} else if (resultSet.getInt("pro_ele_end") == 1) {
						EndEvent endEvt = evt.addNewEndEvent();
						endEvt.setImplementation(EndEventDocument.EndEvent.Implementation.OTHER);
						endEvt.setResult(EndEventDocument.EndEvent.Result.NONE);
					}
					eleIsTask.put(proEleId,Boolean.valueOf(false));
				} else if (resultSet.getObject("ope_id") != null) {
					Route route = act.addNewRoute();
					if (resultSet.getInt("ope_id") == 1 || resultSet.getInt("ope_id") == 4) {
						route.setGatewayType(RouteDocument.Route.GatewayType.EXCLUSIVE);
						route.setExclusiveType(RouteDocument.Route.ExclusiveType.DATA);
					} else if (resultSet.getInt("ope_id") == 2) {
						route.setGatewayType(RouteDocument.Route.GatewayType.PARALLEL);
					} else if (resultSet.getInt("ope_id") == 3 || resultSet.getInt("ope_id") == 5) {
						route.setGatewayType(RouteDocument.Route.GatewayType.INCLUSIVE);
					}
					eleIsTask.put(proEleId,Boolean.valueOf(false));
				} else if (resultSet.getObject("tsk_id") != null) {
					Implementation impl = act.addNewImplementation();
					Task task = impl.addNewTask();
					task.addNewTaskUser();
					String tskName = resultSet.getString("tsk_name");
					act.setName(tskName);
					if (resultSet.getObject("pro_ele_multiplier") != null && resultSet.getInt("pro_ele_multiplier") == 1) {
						Loop loop = act.addNewLoop();
						LoopMultiInstance loopMI = loop.addNewLoopMultiInstance();
						loopMI.setMIOrdering(LoopMultiInstanceDocument.LoopMultiInstance.MIOrdering.PARALLEL);
						loopMI.setMIFlowCondition(LoopMultiInstanceDocument.LoopMultiInstance.MIFlowCondition.ALL);
						if (resultSet.getObject("pro_ele_mult_value") != null) {
							loopMI.setLoopCounter(BigInteger.valueOf(resultSet.getInt("pro_ele_mult_value")));
						}
					}
					eleIsTask.put(proEleId,Boolean.valueOf(true));
					
					String tskDoc = "";
					boolean addtskDoc = false;
					String taskDoc = getTaskDocumentation(dbConn, envId, Integer.valueOf(resultSet.getObject("tsk_id").toString()));
					if (taskDoc.length() > 0) {
						tskDoc += "&lt;documentation&gt;" + taskDoc + "&lt;/documentation&gt;";
						addtskDoc = true;
					}
					
					stmtFrm = StatementFactory.getStatement(conn,SQL_XPDL_ACT_FORMS,StatementFactory.DEBUG);
					stmtFrm.setInt(1, envId);
					stmtFrm.setInt(2, proVo.getProId());
					stmtFrm.setInt(3, proVo.getProVerId());
					stmtFrm.setInt(4, proEleId);
					stmtFrm.setInt(5, envId);
					stmtFrm.setInt(6, proVo.getProId());
					stmtFrm.setInt(7, proVo.getProVerId());
					stmtFrm.setInt(8, proEleId);
					ResultSet resultSetFrms = stmtFrm.executeQuery();
					String docFormsEvts = "&lt;forms&gt;";
					//boolean addDoc = false;
					boolean addFrmDoc = false;
					while(resultSetFrms.next()) {
						docFormsEvts += "&lt;form ";
						String frmType = resultSetFrms.getString("frm_type");
						if (frmType.equalsIgnoreCase("E")) {
							docFormsEvts += "frmType=&quot;E&quot; ";
						} else if (frmType.equalsIgnoreCase("P")) {
							docFormsEvts += "frmType=&quot;P&quot; ";
						}
						String frmName = resultSetFrms.getString("frm_name");
						docFormsEvts += "frmName=&quot;"+frmName+"&quot; ";
						String frmTitle = resultSetFrms.getString("frm_title");
						if (frmTitle == null) {
							frmTitle = "";
						}
						docFormsEvts += "frmTitle=&quot;"+frmTitle+"&quot; ";
						
						Integer stepId = resultSetFrms.getInt("pro_ele_frm_step_id");
						Integer order = resultSetFrms.getInt("pro_ele_frm_order");
						docFormsEvts += "frmStepId=&quot;"+stepId+"&quot; ";
						docFormsEvts += "frmOrder=&quot;"+order+"&quot; ";
						
						stmtAtt = StatementFactory.getStatement(conn,SQL_XPDL_ACT_FORMS_ATTS,StatementFactory.DEBUG);
						stmtAtt.setInt(1, envId);
						stmtAtt.setInt(2, resultSetFrms.getInt("frm_id"));
						Integer frmId = resultSetFrms.getInt("frm_id");
						ResultSet resultSetAtts = stmtAtt.executeQuery();
						HashSet<Integer> distinctGrids = new HashSet<Integer>();
						HashMap<Integer,Integer> mapGrids = new HashMap<Integer,Integer>();
						String docAtts = "";
						boolean addAttsDoc = false;
						int gridId = 0;
						while(resultSetAtts.next()) {
							docAtts += "&lt;attribute ";
							docAtts += "attName=&quot;" + resultSetAtts.getString("att_name") + "&quot; ";
							docAtts += "attLabel=&quot;" + resultSetAtts.getString("att_label") + "&quot; ";
							String tooltip = resultSetAtts.getString("att_desc");
							if (tooltip == null) {
								tooltip = "";
							}
							docAtts += "attTooltip=&quot;" + tooltip + "&quot; ";
							String dataType = resultSetAtts.getString("att_type");
							if (dataType.equals(AttributeVo.TYPE_STRING)) {
								dataType = "String";
							} else if (dataType.equals(AttributeVo.TYPE_NUMERIC)) {
								dataType = "Number";
							} else if (dataType.equals(AttributeVo.TYPE_DATE)) {
								dataType = "Date";
							}
							docAtts += "datatype=&quot;" + dataType + "&quot; ";
							String regExp = resultSetAtts.getString("att_reg_exp");
							if (regExp == null) {
								regExp = "";
							}
							docAtts += "regExp=&quot;" + regExp + "&quot; ";
							Integer typeId = resultSetAtts.getInt("fld_typ_id");
							if (typeId == IFldType.TYPE_INPUT) {
								docAtts += "fieldtype=&quot;Input&quot; ";
							} else if (typeId == IFldType.TYPE_SELECT) {
								docAtts += "fieldtype=&quot;ComboBox&quot; ";
							} else if (typeId == IFldType.TYPE_CHECK) {
								docAtts += "fieldtype=&quot;CheckBox&quot; ";
							} else if (typeId == IFldType.TYPE_RADIO) {
								docAtts += "fieldtype=&quot;Radio Button&quot; ";
							} else if (typeId == IFldType.TYPE_MULIPLE) {
								docAtts += "fieldtype=&quot;ListBox&quot; ";
							} else if (typeId == IFldType.TYPE_AREA) {
								docAtts += "fieldtype=&quot;Text Area&quot; ";
							} else if (typeId == IFldType.TYPE_FILE) {
								docAtts += "fieldtype=&quot;File Input&quot; ";
							} else if (typeId == IFldType.TYPE_EDITOR) {
								docAtts += "fieldtype=&quot;Editor&quot; ";
							} else if (typeId == IFldType.TYPE_PASSWORD) {
								docAtts += "fieldtype=&quot;Password&quot; ";
							} else {
								docAtts += "fieldtype=&quot;Input&quot; ";
							}
							//resultSetAtts.getInt("frm_fld_id");
							Integer gridVal = resultSetAtts.getInt("frm_fld_id_father");
							if (gridVal != null && gridVal != 0) {
								boolean newVal = distinctGrids.add(gridVal);
								if (newVal) {
									gridId++;
									mapGrids.put(gridVal, gridId);
								}
								Integer tmpGridId = mapGrids.get(gridVal);
								docAtts += "grid=&quot;" + tmpGridId + "&quot; ";
							} else {
								docAtts += "grid=&quot;&quot; ";
							}
							docAtts += "/&gt;";
							addAttsDoc = true;
						}
						stmtAtt.close();
						

						//---------------------------------------------------------------------------------------------
						stmtFrmEvt = StatementFactory.getStatement(conn,SQL_XPDL_ACT_FORMS_EVTS,StatementFactory.DEBUG);
						stmtFrmEvt.setInt(1, envId);
						stmtFrmEvt.setInt(2, frmId);
						ResultSet resultSetEvts = stmtFrmEvt.executeQuery();
						String docFrmEvts = "&lt;events&gt;";
						boolean addFrmEvtDoc = false;
						if (resultSetEvts != null) {
							while(resultSetEvts.next()) {
								docFrmEvts += "&lt;event ";
								String evtName = resultSetEvts.getString("evt_name");
								docFrmEvts += "evtName=&quot;"+evtName+"&quot; ";
								String busClaName = resultSetEvts.getString("bus_cla_name");
								docFrmEvts += "busClaName=&quot;"+busClaName+"&quot; ";
								String busClaDesc = resultSetEvts.getString("bus_cla_desc");
								if (busClaDesc == null) {
									busClaDesc = "";
								}
								docFrmEvts += "busClaDesc=&quot;"+busClaDesc+"&quot; ";
								docFrmEvts += "/&gt;";
								addFrmEvtDoc = true;
							}
						}
						stmtFrmEvt.close();
						docFrmEvts += "&lt;/events&gt;";
						
			
						if (!addAttsDoc && !addFrmEvtDoc) {
							docFormsEvts += "/&gt;";
						} else {
							if (!addFrmEvtDoc) {
								docFormsEvts += "&gt;";
								docFormsEvts += docAtts;
								docFormsEvts += "&lt;/form&gt;";
							} else {
								docFormsEvts += "&gt;";
								if (addAttsDoc) {
									docFormsEvts += docAtts;
								} 
								docFormsEvts += docFrmEvts;
								docFormsEvts += "&lt;/form&gt;";
							}
						}
						addFrmDoc = true;
						addtskDoc = true;
					}
					stmtFrm.close();
					docFormsEvts += "&lt;/forms&gt;";
					
					//-------------------------------------------------------------------------------------------------
						
					
					stmtEvt = StatementFactory.getStatement(conn,SQL_XPDL_PRO_ELE_EVTS,StatementFactory.DEBUG);
					stmtEvt.setInt(1, envId);
					stmtEvt.setInt(2, proVo.getProId());
					stmtEvt.setInt(3, proVo.getProVerId());
					stmtEvt.setInt(4, proEleId);
					ResultSet resultSetEvt = stmtEvt.executeQuery();
					String docEvts = "&lt;events&gt;";
					boolean addEvtDoc = false;
					if (resultSetEvt != null) {
						while(resultSetEvt.next()) {
							docEvts += "&lt;event ";
							String evtName = resultSetEvt.getString("evt_name");
							docEvts += "evtName=&quot;"+evtName+"&quot; ";
							String busClaName = resultSetEvt.getString("bus_cla_name");
							docEvts += "busClaName=&quot;"+busClaName+"&quot; ";
							String busClaDesc = resultSetEvt.getString("bus_cla_desc");
							if (busClaDesc == null) {
								busClaDesc = "";
							}
							docEvts += "busClaDesc=&quot;"+busClaDesc+"&quot; ";
							docEvts += "/&gt;";
							addEvtDoc = true;
							addtskDoc = true;
						}
					}
					stmtEvt.close();
					docEvts += "&lt;/events&gt;";
					
					if (addEvtDoc) {
						docFormsEvts += docEvts;
					}
					if (addFrmDoc || addEvtDoc) {
						tskDoc += docFormsEvts;
					}
					
					if (addtskDoc) {
						org.wfmc.x2008.xpdl21.ObjectDocument.Object obj = act.addNewObject();
						obj.setId(getRandomElementId().toString());
						obj.addNewDocumentation().setStringValue(tskDoc);
					}
					
				} else if (resultSet.getObject("pro_ele_pro_id") != null) {	
					String proName = resultSet.getString("pro_name");
					if (proName == null) {
						proName = mapProEleNames.get(resultSet.getObject("pro_ele_pro_id").toString());
					}
					act.setName(proName);
					if (resultSet.getString("pro_ele_pro_type").equals("M")) {
						BlockActivity blockAct = act.addNewBlockActivity2();
						blockAct.setActivitySetId(String.valueOf(resultSet.getInt("pro_ele_pro_id")));
					} else {
						Implementation impl = act.addNewImplementation();
						SubFlow subFlow = impl.addNewSubFlow();
						subFlow.setId(String.valueOf(resultSet.getInt("pro_ele_pro_id")));
						subFlow.setName(proName);
					}
					if (resultSet.getObject("pro_ele_multiplier") != null &&  resultSet.getInt("pro_ele_multiplier") == 1) {
						Loop loop = act.addNewLoop();
						loop.setLoopType(LoopDocument.Loop.LoopType.MULTI_INSTANCE);
						LoopMultiInstance loopMI = loop.addNewLoopMultiInstance();
						loopMI.setMIOrdering(LoopMultiInstanceDocument.LoopMultiInstance.MIOrdering.PARALLEL);
						loopMI.setMIFlowCondition(LoopMultiInstanceDocument.LoopMultiInstance.MIFlowCondition.ALL);
						if (resultSet.getObject("pro_ele_mult_value") != null) {
							loopMI.setLoopCounter(BigInteger.valueOf(resultSet.getInt("pro_ele_mult_value")));
						}
					} else if (resultSet.getObject("pro_ele_iteration") != null && resultSet.getInt("pro_ele_iteration") == 1) {
						Loop loop = act.addNewLoop();
						loop.setLoopType(LoopDocument.Loop.LoopType.STANDARD);
						LoopStandard loopStd = loop.addNewLoopStandard();
						loopStd.setTestTime(LoopStandardDocument.LoopStandard.TestTime.AFTER);
					}
					eleIsTask.put(proEleId,Boolean.valueOf(false));
				}
				String coordsXY = resultSet.getString("pro_ele_design_xml");
				ArrayList<Double> xy = getXYCoordinates(coordsXY);
				NodeGraphicsInfos graphInfos = act.addNewNodeGraphicsInfos();
				NodeGraphicsInfo graphInfo = graphInfos.addNewNodeGraphicsInfo();
				Coordinates coords = graphInfo.addNewCoordinates();
				coords.setXCoordinate(xy.get(0));
				coords.setYCoordinate(xy.get(1));
			}
			statement.close();
			ArrayList<PoolVo> poolIds = null;
			for (Integer proEleIdVal : proElements.keySet()) {
				if (eleIsTask.get(proEleIdVal)) {
					statement = StatementFactory.getStatement(conn,SQL_XPDL_PERFORMERS,StatementFactory.DEBUG);
					statement.setInt(1, envId);
					statement.setInt(2, proVo.getProId());
					statement.setInt(3, proVo.getProVerId());
					statement.setInt(4, proEleIdVal);
					resultSet = statement.executeQuery();
					poolIds = new ArrayList<PoolVo>();
					while(resultSet.next()) {
						Integer poolId = resultSet.getInt("pool_id_auto");
						String poolName = resultSet.getString("pool_name");
						PoolVo poolVo = new PoolVo();
						poolVo.setPoolId(poolId);
						poolVo.setPoolName(poolName);
						poolIds.add(poolVo);
						if (poolVoIds.add(poolId)) {
							participants.put(poolId, poolVo);
						}
					}
					proElements.get(proEleIdVal).addAll(poolIds);
				}
			}
			statement.close();
			HashSet<String> subProcsReusable = new HashSet<String>();
			HashSet<String> subProcsEmbedded = new HashSet<String>();
			for (Activity actVal : acts.getActivityList()) {
				String actId = actVal.getId();
				if (actVal.isSetImplementation()) {
					Implementation implVal = actVal.getImplementation();
					if (implVal.isSetTask()) {
						ArrayList<PoolVo> poolVal = proElements.get(Integer.valueOf(actId));
						if (poolVal != null && poolVal.size() > 0) {
							Performers perfs = actVal.addNewPerformers();
							for (PoolVo perfVal : poolVal) {
								Performer perf = perfs.addNewPerformer();
								perf.setStringValue(perfVal.getPoolName());
							}
						}
					} else if (implVal.isSetSubFlow()) {
						if (subProcsReusable.add(implVal.getSubFlow().getName().toUpperCase())) {
							ProcessType newSubProc = wProcs.addNewWorkflowProcess();
							newSubProc.addNewProcessHeader();
							newSubProc.setId(implVal.getSubFlow().getId());
							newSubProc.setName(implVal.getSubFlow().getName());
						}
					}
				} else if (actVal.isSetBlockActivity2()) {
					ActivitySets actSetsVal;
					if (!wProc.isSetActivitySets()) {
						actSetsVal = wProc.addNewActivitySets();
					} else {
						actSetsVal = wProc.getActivitySets();
					}
					if (subProcsEmbedded.add(actVal.getName().toUpperCase())) {
						ActivitySet actSetVal = actSetsVal.addNewActivitySet();
						actSetVal.setId(actVal.getBlockActivity2().getActivitySetId());
						actSetVal.setName(actVal.getName());
					}
				}
				statement = StatementFactory.getStatement(conn,SQL_XPDL_TRAN_CONDITION,StatementFactory.DEBUG);
				statement.setInt(1, envId);
				statement.setInt(2, proVo.getProId());
				statement.setInt(3, proVo.getProVerId());
				statement.setInt(4, Integer.valueOf(actVal.getId()));
				resultSet = statement.executeQuery();
				if (resultSet != null && resultSet.next()) {
					if (resultSet.getString("pro_ele_dep_eval_cond") != null) {
						String condition = resultSet.getString("pro_ele_dep_eval_cond").trim();
						if (actVal.isSetLoop() && actVal.getLoop().isSetLoopStandard() && condition != null && condition.length() > 0) {
							actVal.getLoop().getLoopStandard().setLoopCondition2(condition);
						}
					}
				}
				statement.close();
			}
			if (participants != null && participants.size() > 0) {
				Participants parts = packType.addNewParticipants();
				for (Integer poolVoId : poolVoIds) {
					Participant part = parts.addNewParticipant();
					PoolVo poolVo = participants.get(poolVoId);
					part.setId(poolVo.getPoolId().toString());
					part.setName(poolVo.getPoolName());
					part.addNewParticipantType().setType(ParticipantTypeDocument.ParticipantType.Type.ROLE);
				}
			}
			wProc.setActivities(acts);
		} catch (SQLException e) {
			throw new DAOException(e, statement.toString());
		} finally{
			try{
				if (stmtEvt != null) {
					stmtEvt.close();
				}
				if (stmtAtt != null) {
					stmtAtt.close();
				}
				if (stmtFrm != null) {
					stmtFrm.close();
				}
				if (statement != null) {
					statement.close();
				}
			} catch (SQLException sqle){
				throw new DAOException(sqle);
			}
		}
	}
	
	
	private String getXPDLProcTransitionsStandard(Connection conn, Integer envId, ProDefinitionVo proVo, ProcessType wProc) throws DAOException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		Transitions transitions = Transitions.Factory.newInstance();
		HashSet<Integer> proEleIds = new HashSet<Integer>();
		HashSet<Integer> proEleIdsFrom = new HashSet<Integer>();
		HashMap<String,ArrayList<Double>> proEleCoords = new HashMap<String,ArrayList<Double>>();
		
		Collection<ProEleDependencyVo> proEleDeps = proVo.getEleDependencies();
		if (proEleDeps != null) {
			for (ProEleDependencyVo proEleDep : proEleDeps) {
				Integer tranFrom = proEleDep.getProEleIdFrom();
				Integer tranTo = proEleDep.getProEleIdTo();
				if (!tranFrom.equals(tranTo)) {
					String tranName = proEleDep.getProEleDepName();
					proEleIds.add(tranFrom);
					proEleIdsFrom.add(tranFrom);
					proEleIds.add(tranTo);
					Transition newTran = transitions.addNewTransition();
					newTran.setId(tranFrom+"_"+tranTo);
					if (tranName != null && tranName.trim().length() > 0) {
						newTran.setName(tranName.trim());
					}
					newTran.setFrom(tranFrom.toString());
					newTran.setTo(tranTo.toString());
					String cond = proEleDep.getProEleDepEvalCond();
					if (cond != null) {
						Condition newCond = newTran.addNewCondition();
						ExpressionType newExp = newCond.addNewExpression();
						newExp.set(XmlString.Factory.newValue(cond));
					}
				}
			}
		}
		
		try {

			String sql = "( ";
			for (Integer i : proEleIds) {
				sql += i + ", ";
			}
			sql = sql.substring(0, sql.length()-2) + " )";
			
			String idsFrom = "( ";
			for (Integer i : proEleIdsFrom) {
				idsFrom += i + ", ";
			}
			idsFrom = idsFrom.substring(0, idsFrom.length()-2) + " )";
			
			statement = StatementFactory.getStatement(conn,SQL_XPDL_TRANSITIONS_2 + sql,StatementFactory.DEBUG);
			statement.setInt(1, envId);
			statement.setInt(2, proVo.getProId());
			statement.setInt(3, proVo.getProVerId());
			resultSet = statement.executeQuery();
			while(resultSet.next()){
				Integer proEleId = resultSet.getInt("pro_ele_id_auto");
				String coordsXY = resultSet.getString("pro_ele_design_xml");
				
				ArrayList<Double> xy = getXYCoordinates(coordsXY);
				
				if (resultSet.getObject("pro_ele_start") != null || resultSet.getObject("pro_ele_end") != null || resultSet.getObject("ope_id") != null) {
					xy.set(0, xy.get(0) + 15.0);
					xy.set(1, xy.get(1) + 15.0);
				} else if (resultSet.getObject("pro_ele_pro_id") != null || resultSet.getObject("tsk_id") != null) {
					xy.set(0, xy.get(0) + 45.0);
					xy.set(1, xy.get(1) + 30.0);
				}
				proEleCoords.put(proEleId.toString(),xy);
			}
			for (Transition transition : transitions.getTransitionList()) {
				
				ArrayList<Double> coordValInic = proEleCoords.get(transition.getFrom());
				ArrayList<Double> coordValFin = proEleCoords.get(transition.getTo());
				ConnectorGraphicsInfos graphInfos = transition.addNewConnectorGraphicsInfos();
				ConnectorGraphicsInfo graphInfo = graphInfos.addNewConnectorGraphicsInfo();
				Coordinates coordsInic = graphInfo.addNewCoordinates();
				coordsInic.setXCoordinate(coordValInic.get(0));
				coordsInic.setYCoordinate(coordValInic.get(1));
				Coordinates coordsFin = graphInfo.addNewCoordinates();
				coordsFin.setXCoordinate(coordValFin.get(0));
				coordsFin.setYCoordinate(coordValFin.get(1));
			}
			wProc.setTransitions(transitions);
			return idsFrom;
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
	
	private ArrayList<Double> getXYCoordinates(String coordsXY) {
		int yBegin = coordsXY.indexOf("y=");
		yBegin += 3;
		int yEnd = coordsXY.indexOf("\"",yBegin);
		String yCoord = coordsXY.substring(yBegin,yEnd);
		
		int xBegin = coordsXY.indexOf("x=");
		xBegin += 3;
		int xEnd = coordsXY.indexOf("\"",xBegin);
		String xCoord = coordsXY.substring(xBegin,xEnd);
		
		double x = Double.valueOf(xCoord);
		double y = Double.valueOf(yCoord);
		
		ArrayList<Double> xy = new ArrayList<Double>();
		xy.add(x);
		xy.add(y);
		
		return xy;
	}

	
	
	public Collection<ProcessVo> getAllProcessesToGen(Connection conn,Integer envId) throws DAOException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		ProcessVo process = null;
		Collection<ProcessVo> colRet = new ArrayList<ProcessVo>();
		try {
			statement = StatementFactory.getStatement(conn,SQL_PROCS_BPMN_TO_GEN_ENV_ID,StatementFactory.DEBUG);
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
	
	public Collection<ProcessVo> getAllProcessesToGen(Connection conn, String proName, Integer envId) throws DAOException {
		PreparedStatement statement = null;
		ResultSet resultSet = null;
		ProcessVo process = null;
		Collection<ProcessVo> colRet = new ArrayList<ProcessVo>();
		try {
			statement = StatementFactory.getStatement(conn,SQL_PROCS_TO_GEN_PRO_NAME,StatementFactory.DEBUG);
			statement.setString(1,proName);
			statement.setInt(2,envId);
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
		
%>
		


<html>
<head>
</head>
<body>
<% 
Object paramLogged = request.getSession().getAttribute("logged");
Boolean logged = null;
Integer envId = Integer.valueOf(1);
String proName = "";
if (paramLogged instanceof Boolean) logged = (Boolean) paramLogged;

if (logged == null) logged = new Boolean(false);
if (request.getParameter("logout") != null) logged = new Boolean(false);

if (! logged.booleanValue()) {
	String user = request.getParameter("user");
	String pwd = request.getParameter("pwd");
	
	logged = new Boolean("admin".equals(user) && "admin22".equals(pwd));
	request.getSession().setAttribute("logged",logged);
}


if (logged.booleanValue()) {
	if (request.getParameter("envId") != null && request.getParameter("envId") != "") {
		System.out.println(request.getParameter("envId"));
		envId = Integer.valueOf(request.getParameter("envId"));
	}
	proName = request.getParameter("proName");
	DBConnection dbConn = null;
	String filePath = "";
	try {
		BaseToXPDL btx = new BaseToXPDL();
		dbConn = DBManagerUtil.getApiaConnection();
		Connection conn = conGetter.getDBConnection2(dbConn);
		ArrayList<String> processedXPDLs = new ArrayList<String>();
		ArrayList<String> errorsXPDLs = new ArrayList<String>();
		System.out.println("Generating XPDLs...");
		Collection<ProcessVo> procsToGen = new ArrayList<ProcessVo>();
		if (proName != null && proName.length() > 0) {
			procsToGen = btx.getAllProcessesToGen(conn, proName, envId);
		} else {
			procsToGen = btx.getAllProcessesToGen(conn, envId);
		}
		System.out.println("size: "+procsToGen.size());
		for (ProcessVo procToGen : procsToGen) {
			filePath = Parameters.TMP_FILE_STORAGE + File.separator + procToGen.getProName() + ".xpdl";
			try {
				ProDefinitionVo proVo = CoreFacade.getInstance().getBpmnProcessDefinition(envId, procToGen.getProId(), procToGen.getProVerId(), Integer.valueOf(1), Integer.valueOf(1));
				btx.generateXPDLFile(conn,dbConn,envId,proVo,filePath,Integer.valueOf(1),Integer.valueOf(1));
			} catch (Exception ex) {
				System.out.println("Error generating process: " + procToGen.getProName());
				errorsXPDLs.add(procToGen.getProName());
				continue;
			}
			processedXPDLs.add(procToGen.getProName());
			System.out.println(procToGen.getProName());
			System.out.println(filePath);
		}
		if (processedXPDLs.size() > 0) {
			System.out.println("XPDLs have been successfully generated.");
		}
		
		logged = Boolean.valueOf(false); 
		%>
		<div>
			<center><b>User Options</b></center>
			<center><a href="?logout=yes">Logout</a></center><br>
			<center><b>Operation Complete</b></center><br>
		</div>
		<% if (processedXPDLs.size() > 0) { %>
		<div>
			<center><b>The generated XPDLs have been stored in the configured Temporal Folder Path.</b></center><br>
			<center><b>The following processes have been successfully generated: </b></center><br>
		<% }
		for (String procName : processedXPDLs) {
			%><center><%=procName%></center><br><%
		}
		%></div><%
		if (errorsXPDLs.size() > 0) { %>
		<div>
			<center><b>Check the definition of the following processes, errors occurred while trying to generate their corresponding XPDLs.</b></center><br>
			<center><b>The following processes haven't been successfully generated: </b></center><br>
		<% }
		for (String procName : errorsXPDLs) {
			%><center><%=procName%></center><br><%
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
} else { %>
	<form action="" method="post">
		<b>Login is require to continue</b><br>
		User: <input type="text" name="user"><br>
		Password: <input type="password" name="pwd"><br>
		Environment Id: <input type="text" name="envId"><br>
		Process Name: <input type="text" name="proName"><br>
		<input type="submit" value="Login">
	</form>
<% } %>
</body>
</html>

