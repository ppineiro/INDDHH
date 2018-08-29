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

<%@include file="_commonValidate.jsp" %>

<%!

public static class ClassComparator implements Comparator {
	public int compare(Object obj1, Object obj2) {
		String claName1 = (obj1 == null) ? "" : obj1.getClass().getName();
		String claName2 = (obj2 == null) ? "" : obj2.getClass().getName();
		
		return claName1.compareTo(claName2);
	}
}

public static Collection<ConnectionDAO> SUPPORTED_DAO = new ArrayList<ConnectionDAO>();

static {
	SUPPORTED_DAO.add(com.dogma.dao.ArtifactDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.AttributeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BITablesDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BPMNProcessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BpmnTimerDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BpmnTimerProcessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusClaParameterDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusClaParBindingDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusClassDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusClassWsStsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntAttCmbDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntEvtBusClassDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntEvtEntStatusDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntEvtStatusDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntFormDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntInstanceDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntInstAttributeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntInstDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntInstRelationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntityDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntProcessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntRelatedDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntStaRelationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.BusEntStatusDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CalendarDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CalendarFreeDaysDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CalendarLaboralDaysDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CampaignDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ClaTreeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CmpDateDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CmpFunctionalityDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CmpIpDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CmpNodeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CmpPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CmpProcessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CmpProfileDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CmpTaskDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CmpTimeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CmpUserDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CubeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.CubeViewDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DashboardDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DataBaseCleanUpDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DataBaseDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DbConnectionDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DbDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DocFreeMetadataDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DocLockDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DocMetadataDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DocPermissionDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DocTypeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DocTypeMetadataDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DocVersionDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DshPanelDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DshPnlParameterDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DshWidCommentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.DshWidgetDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EntityDwColumnDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EntityInstanceRelationsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvDwAttributeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvironmentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvMessageDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvMsgPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvParameterDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvPrfDashboardDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvPrfFunctionalityDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvProfileDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EnvUserDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.EventDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ExtProEleDepInstanceDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ExtProEleInstanceDAO.getInstance());
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
	SUPPORTED_DAO.add(com.dogma.dao.HomePageTemplateDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ImagesDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.LabelsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.LanguageDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.LblSetDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.LogAccessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MdxQueryDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonBusBusEntityDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonBusEntFormDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonBusFilterDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonBusinessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonBusProcessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonBusProjectDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonDocumentDocDateDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonDocumentDocMetadataDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonDocumentDocSizeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonDocumentDocSourceDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonDocumentDocTypeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonDocumentRegInstDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonDocumentUsersDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonitorProcessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonitorTaskDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.MonProFormDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.NotificationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.NotPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ObjAccessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.PanelDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ParametersDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.PnlParameterDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.PoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.PoolHierarchyDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.PrfFuncionalityDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProcessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProcessDwColumnDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProcessVerifierDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProDocEventsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProDocFieldsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleBusEntFormDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleBusEntStatusDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleDependencyDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleDepInstanceDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleDepScenarioDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleEvtBusClassDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleFormDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleInstanceDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleInstAttributeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleInstHistoryDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProElementDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProElePoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProElePoolScenarioDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleRolScenarioDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleSceMultDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEleScenarioDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProEvtBusClassDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProfileDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProInstanceDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProInstAttributeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProInstCommentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProInstDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProInstRelationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProjectDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProNotificationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProNotMessageDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProNotPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.PropertyDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProRollbackDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProServiceDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ProXpdlMapDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QryChartDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QryChtPropertyDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QryChtSerieDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QryColumnDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QryEvtBusClassDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QryNavigationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.QueryDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.ReportDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.RepParameterDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.RepQueryDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.RevokedCertsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.RoleDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.RolMappingDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.SchBusClaActivityDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.SchemaDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.SchErrNotificationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.SimScenarioDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.SimScePoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.SimSceProcessDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.SocialMessageDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.SocMesChannelsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TaskDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TaskSchedulerDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TasksListDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TaskVerifierDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TranslationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskDocEventsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskDocFieldsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskDocumentDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskNotificationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskNotMessageDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskNotPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskSchAttributeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskSchExclusionDayDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskSchNumberDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskSchPrivilegeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskSchTemplateDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.TskSchWeekDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UserDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsersSubstitutesDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrCertificatesDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrDashboardDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrDshPanelDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrDshPnlParameterDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrFavoritesDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrNotReadDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrPoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrProfileDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrPwdHistoryDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrSignsDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrStylesDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrSubstitutePoolDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.UsrSubstituteProfileDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.VwDirectoryDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.VwPropertiesDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.WidgetDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.WidHtmlCodeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.WidInformationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.WidKpiZoneDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.WidPropertiesDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.WidQryFilterDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.WidSqlDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.WidValueDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.WsPubAttributeDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.WsPublicationDAO.getInstance());
	SUPPORTED_DAO.add(com.dogma.dao.XmlSchemaDefDAO.getInstance());
	
	Collections.sort((ArrayList) SUPPORTED_DAO, new ClassComparator());
}

private String getCombos(HttpServletRequest request) {
	StringBuffer buffer = new StringBuffer();
	StringBuffer bufferError = new StringBuffer();
	StringBuffer noInformation = new StringBuffer();

	String lastLetter = null;
	
	boolean onlyRefresh = "true".equals(request.getParameter("refresh"));
	boolean closeGroup = false;
	Collection<String> openGroups = new TreeSet<String>();
	
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
				if (closeGroup) {
					buffer.append("</div>");
					buffer.append("</div>");
				}
				buffer.append("<div class='fieldGroup'>");
				buffer.append("<h3 class='aGroup' id='aGroup" + firstLetter + "' letter='" + firstLetter + "'>+ " + firstLetter + "</h3>");
				buffer.append("<div class='hidden' id='group" + firstLetter + "'>");
				closeGroup = true;
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
	
				buffer.append("<div class='field'><span>");					
				buffer.append(visualDaoClassName + ":</span><select name=\"" + daoClassName + "\" recomended=\"" + defaultActive + "\" >");
				buffer.append("<option value=\"true\" " + (currentActive?"selected":"") + ">true</option>");
				buffer.append("<option value=\"false\" " + (currentActive?"":"selected") + ">false</option>");
				buffer.append("</select>");
				
				buffer.append("<span class='information'>");
				if (valueChanged) {
					openGroups.add(firstLetter);
					buffer.append("State changed correctly");
				} else if (valueChangeError != null) {
					openGroups.add(firstLetter);
					buffer.append("<b>Error</b> while changeing value: ");
					buffer.append(valueChangeError);
				}
				buffer.append("</span>");
				
				buffer.append("<span class='information'>");
				buffer.append("Recomended value: <b>" + defaultActive + "</b>");
				buffer.append("</span><span class='information'>");
				buffer.append("Property value: <b>" + ((propertyActive == null)?"not present":propertyActive.toString()) + "</b>");
				buffer.append("</span></div>");
			} else {
				noInformation.append("<div class='field'>Could not retrieve information for: <b>" + daoClassName.substring(daoClassName.lastIndexOf(".") + 1) + "</b></div>");
			}
		} catch (Throwable e) {
			bufferError.append("<div class='field'>Can't retrieve activity state for: <b>" + daoClassName + "</b><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Error: " + e.toString() + ")</div>");
		}
	}
	
	if (closeGroup) {
		buffer.append("</div>");
		buffer.append("</div>");
	}
	
	if (noInformation.length() > 0) {
		buffer.append("<h3 class='justOpen' letter='NoInformation'>No information</h3>");
		buffer.append("<div class='hidden' id='groupNoInformation'>");
		buffer.append(noInformation.toString());
		buffer.append("</div>");
	}
	
	if (bufferError.length() > 0) {
		buffer.append("<h3 class='justOpen' letter='Errors')>Errrors</h3>");
		buffer.append("<div class='hidden' id='groupErrors'>");
		buffer.append(bufferError.toString());
		buffer.append("</div>");
	}
	
	buffer.append("<input type='hidden' id='openGroups' value='");
	boolean notFirst = false;
	for (String letter : openGroups) {
		if (notFirst) buffer.append(" ");
		buffer.append(letter);
		notFirst = true;
	}
	buffer.append("'>");
	
	return buffer.toString();
}

%>

<html>
<head>
	<title>DAO Log Activity</title>
	<style type="text/css">
		<%@include file="_commonStyles.jsp" %>
		
		form div.field span { width: 150px !important; text-align: right; }
		form div.field span.information { width: 200px !important; text-align: left !important;}
		form div.field select { margin-right: 5px; }
		
		.aGroup, .justOpen { cursor: pointer; }
		.hidden { display: none; }
	</style>
	
	<%@include file="_commonInclude.jsp" %>
	
	<script language="javascript">
		<%@include file="_commonScript.jsp" %>
		
		window.addEvent('load', function() {
			$$('h3.aGroup').each(function(ele) {
				ele.addEvent('click', function() {
					var letter = this.get('letter');
					var group = $('group' + letter);
					group.toggleClass('hidden');
					
					this.innerHTML = group.hasClass('hidden') ? ("+ " + letter) : ("- " + letter);
				});
			});
			$$('h3.justOpen').each(function(ele) {
				ele.addEvent('click', function() {
					var letter = this.get('letter');
					var group = $('group' + letter);
					group.toggleClass('hidden');
				});
			});
			
			var openGroups = $('openGroups');
			openGroups = openGroups.value.split(" ");
			for (var i = 0; i < openGroups.length; i++) {
				if (openGroups[i] == "") continue;
				$('aGroup' + openGroups[i]).fireEvent('click');
			}
		});
		
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


<body>
	<%@include file="_commonLogin.jsp" %>

	<% if (_logged) { %>
		<form action="?" method="post" id="form">
			<div class="mainHeader">
				Options:
				<input type="submit" value="Change states">
				<input type="submit" onclick="document.getElementById('refresh').value = 'true'" value="Refresh">
				<input type="submit" onclick="everythingTo(true)" value="All to TRUE">
				<input type="submit" onclick="everythingTo(false)" value="All to FALSE">
				<input type="submit" onclick="everythingTo(null)" value="All to RECOMENDED">
				<input type="hidden" id="refresh" name="refresh" value="false">
				<input type="hidden" id="_avoidLogout" name="_avoidLogout" value="<%= _avoidLogout %>">
				<%@include file="_commonLogout.jsp" %>
			</div>
			
			<div class="workarea" id="workarea">
				<%= this.getCombos(request) %>
				
				<b><font color=red>ATTENTION:</font></b> It is recomended to use allways the <b>Recomended value</b>. Use with precaution.
		</form>
	<% } %>
</body>
</html>