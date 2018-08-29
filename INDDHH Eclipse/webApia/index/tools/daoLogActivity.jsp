<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="com.st.db.dataAccess.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.lang.reflect.*" %>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.st.util.logger.FileLogger"%>
<%@page import="com.st.util.logger.Logger"%>
<%@page import="java.io.File"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.dogma.Configuration"%>
<html>
<head>
	<title>DaoLogActivity 1.3</title>
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
		
		div {
			height: 500px; 
			overflow:auto; 
			border: 1px;
			border-color: black;
			border-style: solid;
		}
	</style>
	
	<script language="javascript">
		function everythingTo(setTo) {
			var elements = document.getElementsByTagName("SELECT");
			if (elements != null) {
				for (var i = 0; i < elements.length; i++) {
					if (setTo == null) {
						elements[i].selectedIndex = (elements[i].getAttribute("recomended") == "true")?0:1;
					} else {
						elements[i].selectedIndex = setTo?0:1;
					}
				}
			}
		}
	</script>
</head>

<%!

public static class ClassComparator implements Comparator {
	public int compare(Object obj1, Object obj2) {
		String claName1 = (obj1 == null) ? "" : obj1.getClass().getName();
		String claName2 = (obj2 == null) ? "" : obj2.getClass().getName();
		
		return claName1.compareTo(claName2);
	}
}

public static Collection SUPPORTED_DAO = new ArrayList();

static {
	SUPPORTED_DAO.add(com.dogma.dao.AttributeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusClaParameterDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusClaParBindingDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusClassDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntEvtBusClassDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntFormDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntInstanceDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntInstAttributeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntInstDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntityDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntProcessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntRelatedDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntStaRelationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntStatusDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CalendarDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CalendarFreeDaysDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CalendarLaboralDaysDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ClaTreeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DbConnectionDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EntityDwColumnDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvDwAttributeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvironmentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvMessageDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvMsgPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvPrfFunctionalityDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvProfileDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvUserDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.FormDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.FrmDocEventsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.FrmDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.FrmEvtBusClassDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.FrmFieldDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.FrmFldEntBindingDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.FrmFldEvtBusClassDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.FrmFldPropertyDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.FrmPropertyDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.FunctionalityDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ImagesDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.LabelsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.LanguageDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.LblSetDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonBusEntFormDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonProFormDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.NotificationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.NotPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.PoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.PoolHierarchyDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.PrfFuncionalityDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProcessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProcessDwColumnDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProDocEventsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleBusEntFormDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleBusEntStatusDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleDependencyDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleDepInstanceDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleEvtBusClassDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleFormDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleInstanceDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleInstAttributeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProElementDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProElePoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEvtBusClassDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProfileDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProInstanceDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProInstAttributeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProInstCommentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProInstDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProjectDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProNotificationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProNotMessageDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProNotPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QryChartDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QryChtPropertyDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QryChtSerieDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QryColumnDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QryEvtBusClassDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QryNavigationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QueryDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.RoleDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.SchBusClaActivityDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TaskDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskDocEventsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskDocFieldsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskNotificationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskNotMessageDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskNotPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UserDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsersSubstitutesDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrDeskCalendarDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrDeskDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrNotReadDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrProfileDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrPwdHistoryDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrSubstitutePoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.VwDirectoryDAO.getInstance());
	
	Collections.sort((ArrayList) SUPPORTED_DAO, new ClassComparator());
}

private String getCombos(HttpServletRequest request) {
	StringBuffer buffer = new StringBuffer();
	StringBuffer bufferError = new StringBuffer();

	String lastLetter = null;
	
	boolean onlyRefresh = "true".equals(request.getParameter("refresh"));
	
	buffer.append("<table border=0 cellpadding=1 cellspacing=0>");
	
	for (Iterator it = SUPPORTED_DAO.iterator(); it.hasNext(); ) {
		Object daoInstance = it.next();
		if (daoInstance == null) continue;
		Class daoClass = daoInstance.getClass();
		String daoClassName = daoClass.getName();
		try {
			String visualDaoClassName = daoClassName.substring(daoClassName.lastIndexOf(".") + 1);

			if (visualDaoClassName.indexOf("_") != -1) visualDaoClassName = visualDaoClassName.substring(0,visualDaoClassName.indexOf("_"));

			String firstLetter = visualDaoClassName.substring(visualDaoClassName.lastIndexOf(".") + 1).substring(0,1);
			
			if (lastLetter == null || ! firstLetter.equals(lastLetter)) {
				buffer.append("<tr><td><b>" + firstLetter + "</b></td></tr>");
			}
			
			lastLetter = firstLetter;			Field[] daoFields = daoClass.getDeclaredFields();
			
			Field logActivity = null;
			Field defaultLog = null;
			
			for (int i = 0; i < daoFields.length; i++) { //Buscar los campos
				Field daoField = daoFields[i];
				if (daoField.getName().equals("logActivity")) logActivity = daoField;
				if (daoField.getName().equals("defaultLog")) defaultLog = daoField;
			}
			
			if (logActivity == null) { //Buscar los campos en la clase padre
				Class parentDaoClass = daoClass.getSuperclass();
				daoFields = parentDaoClass.getDeclaredFields();
				
				for (int i = 0; i < daoFields.length; i++) { //Buscar los campos
					Field daoField = daoFields[i];
					if (daoField.getName().equals("logActivity")) logActivity = daoField;
					if (daoField.getName().equals("defaultLog")) defaultLog = daoField;
				}
			}
			
			if (logActivity != null) {
				Object fieldValue = logActivity.get(daoInstance);
				boolean currentActive = (fieldValue != null && fieldValue instanceof Boolean && ((Boolean) fieldValue).booleanValue());
				
				fieldValue = defaultLog.get(daoInstance);
				boolean defaultActive = (fieldValue != null && fieldValue instanceof Boolean && ((Boolean) fieldValue).booleanValue());
	
				Boolean propertyActive = Configuration.logDAOActivity(visualDaoClassName);
				
				boolean valueChanged = false;
				String valueChangeError = null;
				
				if (request.getParameter(daoClassName) != null && ! onlyRefresh) {
					boolean newActive = "true".equals(request.getParameter(daoClassName));
					
					if (currentActive != newActive) {
						try {
							logActivity.setBoolean(daoInstance, newActive);
							fieldValue = logActivity.get(daoInstance);
							currentActive = (fieldValue != null && fieldValue instanceof Boolean && ((Boolean) fieldValue).booleanValue());
							valueChanged = true;
						} catch (Exception e) {
							valueChangeError = e.getMessage();
						}
					}
				}
	
				buffer.append("<tr><td align=right>");					
				buffer.append(visualDaoClassName + ":</td><td><select name=\"" + daoClassName + "\" recomended=\"" + defaultActive + "\" >");
				buffer.append("<option value=\"true\" " + (currentActive?"selected":"") + ">true</option>");
				buffer.append("<option value=\"false\" " + (currentActive?"":"selected") + ">false</option>");
				buffer.append("</select>");
				buffer.append("</td><td>");
				
				if (valueChanged) {
					buffer.append("State changed correctly - ");
				} else if (valueChangeError != null) {
					buffer.append("<b>Error</b> while changeing value: ");
					buffer.append(valueChangeError);
					buffer.append(" - ");
				}
				buffer.append("</td><td>");
				buffer.append("Recomended value: <b>" + defaultActive + "</b>");
				buffer.append("</td><td>");
				buffer.append("Property value: <b>" + ((propertyActive == null)?"not present":propertyActive.toString()) + "</b>");
				buffer.append("</td></tr>");
			} else {
				buffer.append("<tr><td colspan=\"5\">Could not retrieve information for: <b>" + daoClassName.substring(daoClassName.lastIndexOf(".") + 1) + "</b></td></tr>");
			}
		} catch (Throwable e) {
			bufferError.append("<tr><td colspan=\"5\">Can't retrieve activity state for: <b>" + daoClassName + "</b><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Error: " + e.toString() + ")</td></tr>");
		}
	}
	
	buffer.append(bufferError.toString());
	
	buffer.append("</table>");
	
	return buffer.toString();
}

%>

<body>
<form action="?" method="post" id="form">
<b>DAO log activity states</b><hr>
<div>
<%= this.getCombos(request) %>
</div><br>
<input type="submit" value="Change states">
<input type="submit" onclick="document.getElementById('refresh').value = 'true'" value="Refresh">
<input type="submit" onclick="everythingTo(true)" value="All to TRUE">
<input type="submit" onclick="everythingTo(false)" value="All to FALSE">
<input type="submit" onclick="everythingTo(null)" value="All to RECOMENDED">
<br><br>
<input type="hidden" id="refresh" name="refresh" value="false">
<b><font color=red>ATTENTION:</font></b> It is recomended to use allways the <b>Recomended value</b>. Use with precaution.
</form>

</body>
</html>