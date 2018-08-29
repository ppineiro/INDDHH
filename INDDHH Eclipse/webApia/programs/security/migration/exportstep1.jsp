<%@page import="com.dogma.util.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.migration.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MigrationBean"/><%
			EnvironmentVo envVo = dBean.getEnvVo();
		%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMigEnv")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><!--      Environment Data (Show VO data)													         --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtMigExpData")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td><%=LabelManager.getName(labelSet,"lblMigEnvId")%>:</td><td><%=envVo.getEnvId()%></td><td><%=LabelManager.getName(labelSet,"lblMigEnvName")%>:</td><td><%=envVo.getEnvName()%></td></tr><tr><td><%=LabelManager.getName(labelSet,"lblMigEnvDescription")%>:</td><td colspan="3"><%=envVo.getEnvDesc()%></td></tr></table><!--       Available migrators, select what to export										         --><%
					ArrayList migrators = (ArrayList)com.dogma.migration.MigratorProvider.getAllMigrators();
					ArrayList rootMigrators = (ArrayList)com.dogma.migration.MigratorProvider.getRootMigrators();

					if (migrators == null || rootMigrators == null) {
						// We init the code
						com.dogma.migration.MigratorProvider.init();
						
						migrators = (ArrayList)com.dogma.migration.MigratorProvider.getAllMigrators();
					}
				%><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblMigSelDefinition")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%
						int i = 0;
						while (i < migrators.size()) {
							BaseMigrator migrator = (BaseMigrator)migrators.get(i);
							if (migrator.isDefinition() && MigratorProvider.isTopLevel(((BaseMigrator)migrator).getEntityName())) {
								out.println("<tr>");
								out.println("<td align='left'>");
								//out.println("<input type='checkbox' name='migname' id='migname' checked value='" + migrator.getClass().getName() + "' >");

								if (migrator.getClass().getName().indexOf("Labels") == -1) {
									out.println("<input type='checkbox' name='migname' id='migname' checked value='" + migrator.getClass().getName() + "' >");
								} else {
									out.println("<input type='checkbox' name='migname' id='migname' value='" + migrator.getClass().getName() + "' >");
								}

								out.println(LabelManager.getName(labelSet,MigratorProvider.getDescription(((BaseMigrator)migrator).getEntityName())));
								out.println("</td>");
								out.println("<td align='left'>");

								String objectName = migrator.getClass().getName();
								objectName = StringUtil.replace(objectName, "MigratorImpl", "");
								objectName = objectName.substring(objectName.lastIndexOf(".") + 1);

								if (migrator.getClass().getName().indexOf("SchBusClaActivity") == -1 && migrator.getClass().getName().indexOf("PoolHierarchy") == -1) {
									out.println("<button onclick=\"btnFilter_click('" + objectName + "')\" title=\"" + LabelManager.getName(labelSet,"btnEjeFil") + "\">" + LabelManager.getName(labelSet,"btnEjeFil") + "</button>");
								}
								
								out.println("</td>");
								out.println("</tr>");
							}
							i++;
						}
					%></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblMigSelInstance")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%
						i = 0;
						while (i < migrators.size()) {
							BaseMigrator migrator = (BaseMigrator)migrators.get(i);
							if (migrator.isInstance() && MigratorProvider.isTopLevel(((BaseMigrator)migrator).getEntityName())) {
								out.println("<tr>");
								out.println("<td align='left'>");
								if (migrator.getClass().getName().indexOf("Instance") == -1) {
									out.println("<input type='checkbox' name='migname' id='migname' checked value='" + migrator.getClass().getName() + "' >");
								} else {
									out.println("<input type='checkbox' name='migname' id='migname' value='" + migrator.getClass().getName() + "' >");
								}
								out.println(LabelManager.getName(labelSet,MigratorProvider.getDescription(((BaseMigrator)migrator).getEntityName())));
								out.println("</td>");
								out.println("<td align='left'>");

								String objectName = migrator.getClass().getName();
								objectName = StringUtil.replace(objectName, "MigratorImpl", "");
								objectName = objectName.substring(objectName.lastIndexOf(".") + 1);
								
								out.println("<button onclick=\"btnFilter_click('" + objectName + "')\" title=\"" + LabelManager.getName(labelSet,"btnEjeFil") + "\">" + LabelManager.getName(labelSet,"btnEjeFil") + "</button>");
								out.println("</td>");
								out.println("</tr>");
							}
							i++;
						}
					%></table><%
		// Builds the post string
		int p = 0;
		while (p < migrators.size()) {
			BaseMigrator migrator = (BaseMigrator)migrators.get(p);
			if (MigratorProvider.isTopLevel(((BaseMigrator)migrator).getEntityName())) {
				String objectName = migrator.getClass().getName();
				objectName = StringUtil.replace(objectName, "MigratorImpl", "");
				objectName = objectName.substring(objectName.lastIndexOf(".") + 1);
				
				out.println("\t<input type=\"hidden\" value=\"\" name=\"selection" + objectName + "\" id=\"selection" + objectName + "\">");
			}
			p++;
		}
		out.println("");
	%></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD><button type="button" onclick="checkAll_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSelAll")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSelAll")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSelAll")%></button><button type="button" onclick="unCheckAll_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSelNone")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSelNone")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSelNone")%></button></TD><TD><button type="button" onclick="btnSig_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSig")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSig")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSig")%></button><button type="button" onclick="btnVol_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnSal_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><!--     Auxiliary inclusion end (Constants, parameters, etc)								         --><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/migration/exportstep1.js'></script><script language="javascript">
	
	// Checks all the checkboxes
	function checkAll_click() {
		var elems = document.getElementsByTagName('input');
		if (elems != null) {
			for (i = 0; i < elems.length; i++) {
				if (elems[i].type == 'checkbox') {
					elems[i].checked = true;
				}
			}
		}
	}

	// Unchecks all the checkboxes
	function unCheckAll_click() {
		var elems = document.getElementsByTagName('input');
		if (elems != null) {
			for (i = 0; i < elems.length; i++) {
				if (elems[i].type == 'checkbox') {
					
					elems[i].checked = false;
				}
			}
		}
	}

</script><script language="javascript">

	// Contains the current migrator
	var selectedObject = '';

	// Selected elements for exchange with the modal
	var selectedData = '';
	
	<%
		// Creates the javascript variables to post
		int j = 0;
		while (j < migrators.size()) {
			BaseMigrator migrator = (BaseMigrator)migrators.get(j);
			if (MigratorProvider.isTopLevel(((BaseMigrator)migrator).getEntityName())) {
				String objectName = migrator.getClass().getName();
				objectName = StringUtil.replace(objectName, "MigratorImpl", "");
				objectName = objectName.substring(objectName.lastIndexOf(".") + 1);
				
				out.println("\tvar selection" + objectName + " = '';");
			}
			j++;
		}
		out.println("");
	%>

	function openModalMigration(url, width, height) {
		var paramArr = "status:no; help:no; unadorned:yes; center:yes; dialogWidth:"+width+"px; dialogHeight:"+height+"px;";
		return openModal(url, window.self, paramArr);
	}

	// Calls the filtering function, using the migrator name
	function btnFilter_click(objectName) {
		window.selectedObject = objectName;
		
	<%
		// Copies the contents of the variable selectionXXXXXX to selectedData
		j = 0;
		while (j < migrators.size()) {
			BaseMigrator migrator = (BaseMigrator)migrators.get(j);
			if (MigratorProvider.isTopLevel(((BaseMigrator)migrator).getEntityName())) {
				String objectName = migrator.getClass().getName();
				objectName = StringUtil.replace(objectName, "MigratorImpl", "");
				objectName = objectName.substring(objectName.lastIndexOf(".") + 1);
				
				out.println("\tif (selectedObject == '" + objectName + "') {");
				out.println("\t\tselectedData = selection" + objectName + ";");
				out.println("\t}");
			}
			j++;
		}
		out.println("");
	%>
		
		var rets=openModalMigration("/programs/security/migration/filter/genericFilter.jsp?objectId=" + objectName,500,300);
		var doAfter=function(rets){
			if (rets != null) {
	<%
		// Copies the contents of the variable selectedData to selectionXXXXXX
		j = 0;
		while (j < migrators.size()) {
			BaseMigrator migrator = (BaseMigrator)migrators.get(j);
			if (MigratorProvider.isTopLevel(((BaseMigrator)migrator).getEntityName())) {
				String objectName = migrator.getClass().getName();
				objectName = StringUtil.replace(objectName, "MigratorImpl", "");
				objectName = objectName.substring(objectName.lastIndexOf(".") + 1);
				
				out.println("\tif (selectedObject == '" + objectName + "') {");
				out.println("\t\tselection" + objectName + " = selectedData;");
				out.println("\t}");
			}
			j++;
		}
		out.println("");
	%>
				
			}
		}
		rets.onclose=function(){
			doAfter(rets.returnValue);
		}
		
	}
	
	function btnSig_click(){
		// First check if something is selected
		var nonec = true;
		var elems = document.getElementsByTagName('input');
		if (elems != null) {
			for (i = 0; i < elems.length; i++) {
				if (elems[i].type == 'checkbox') {
					if (elems[i].checked) {
						nonec = false;
						break;
					}
				}
			}
		}
		if (nonec) {
			alert(GNR_CHK_AT_LEAST_ONE);
			return;
		}
	
		var submitString = "security.MigrationAction.do?";
		
		// Selected elements 
		submitString += "action=expstep2";
		
	<%
		// Builds the post string
		j = 0;
		while (j < migrators.size()) {
			BaseMigrator migrator = (BaseMigrator)migrators.get(j);
			if (MigratorProvider.isTopLevel(((BaseMigrator)migrator).getEntityName())) {
				String objectName = migrator.getClass().getName();
				objectName = StringUtil.replace(objectName, "MigratorImpl", "");
				objectName = objectName.substring(objectName.lastIndexOf(".") + 1);
				
				out.println("\tdocument.getElementById(\"selection" + objectName + "\").value = selection" + objectName + ";");
			}
			j++;
		}
		out.println("");
	%>
			
				document.getElementById("frmMain").action = submitString;
			
		submitForm(document.getElementById("frmMain"));
	}	
	
</script>


