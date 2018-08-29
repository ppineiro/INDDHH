<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.migration.*"%><%@page import="java.util.*"%><%@page import="com.st.util.*"%><%@page import="com.dogma.bean.security.MigrationBean"%><% try { %><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.MigrationBean"/><%
			EnvironmentVo envVo = dBean.getEnvVo();
		%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMigEnv")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><!--      Environment Data (Show basic VO data)													         --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtMigExpData")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td><%=LabelManager.getName(labelSet,"lblMigEnvId")%>:</td><td><%=envVo.getEnvId()%></td><td><%=LabelManager.getName(labelSet,"lblMigEnvName")%>:</td><td><%=envVo.getEnvName()%></td></tr></table><br><br><!--     Export objects																	         --><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblMigExpObjects")%></DIV><table class="tblFormLayout"><%
						// Iterate on the objects and display the information
						HashMap idMap = dBean.getIds();
						if (idMap == null) {
							idMap = new HashMap();
						}
						Iterator imaps = idMap.keySet().iterator();
						while (imaps.hasNext()) {
							String type = (String)imaps.next();
							
							// Get the VO name, and use it to get the description
							String className = StringUtil.replace(type, "com.dogma.migration.definition.", "");
							className = StringUtil.replace(className, "com.dogma.migration.instance.", "");
							className = StringUtil.replace(className, "MigratorImpl", "");
							String description = LabelManager.getName(labelSet,MigratorProvider.getDescription(className));
							
							HashMap idAuxMap = (HashMap)idMap.get(type);
							if (idAuxMap.size() > 0) {
								// Display the object ids and the names
								%><tr><td align='left' colspan='4'><a href="javascript:showhideTBL('tbl<%=className%>');"><%=LabelManager.getName(labelSet,"lblMigObjectsFor")%>: <b><%=description%><b></a></td></tr><tr><td align='center' colspan='4'><table class="tblFormLayout" id='tbl<%=className%>' name='tbl<%=className%>' style="display:none"><%
								if (! com.dogma.migration.definition.LabelsMigratorImpl.class.getName().equals(type)) {
									// We sort the elements by description, so that the lookup is easier
									ArrayList idArr = new ArrayList();
									Iterator iids = idAuxMap.keySet().iterator();
									while (iids.hasNext()) {
										Object id = iids.next();
										
										// Not always the description is a string
										Object dsc = idAuxMap.get(id);
										
										idArr.add(dsc + MigrationBean.SEPARATOR_IDDES + id);
									}
										
									Collections.sort(idArr);
									iids = idArr.iterator();
									while (iids.hasNext()) {
										String iddata = (String)iids.next();
										String[] idvec = StringUtil.split(iddata, MigrationBean.SEPARATOR_IDDES, true); %><tr name='trSelected'><td align='left' name='tdSelected'><% if ((! com.dogma.migration.definition.EnvParameterMigratorImpl.class.getName().equals(type)) &&  !(com.dogma.migration.definition.PoolHierarchyMigratorImpl.class.getName().equals(type))) { %><input type='checkbox' name='cbxSelected' id='cbxSelected' value='<%=type+"-"+idvec[1]%>' ><% } %></td><td align='left'><%=idvec[1]%></td><td align='left' colspan='4'><%=idvec[0]%></td></tr><%
									} 
								} %></table></td></tr><tr><td align='left' colspan='4'></td></tr><%
							}
						}					
					%></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD><button type="button" onclick="checkAll_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSelAll")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSelAll")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSelAll")%></button><button type="button" onclick="unCheckAll_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSelNone")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSelNone")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSelNone")%></button><button type="button" onclick="removeSelected_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRemSel")%>" title="<%=LabelManager.getAccessKey(labelSet,"btnRemSel")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRemSel")%></button></TD><TD><button type="button" onclick="btnAnt_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAnt")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAnt")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAnt")%></button><button type="button" onclick="btnSig_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSig")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSig")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSig")%></button><button type="button" onclick="btnVol_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnSal_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><!--     Auxiliary inclusion end (Constants, parameters, etc)								         --><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/migration/exportstep2.js'></script><script language="javascript">
	function showhideTBL(type) {
		var table = document.getElementById(type);
		if (table != null) {
			if (table.style.display == 'none') {
				table.style.display = 'block';
			} else {
				table.style.display = 'none';
			}
		}
	}
</script><script language="javascript">
	
	// Checks all the checkboxes
	function checkAll_click() {
		var elems = document.getElementsByTagName('input');
		if (elems != null) {
			for (i = 0; i < elems.length; i++) {
				// Only check it, if it is visible
				if (elems[i].type == 'checkbox') {
					if (elems[i].parentNode.parentNode.parentNode.parentNode.style.display == 'block') {
						elems[i].checked = true;
					}
				}
			}
		}
	}

	// Unchecks all the checkboxes
	function unCheckAll_click() {
		var elems = document.getElementsByTagName('input');
		if (elems != null) {
			for (i = 0; i < elems.length; i++) {
				// Only check it, if it is visible
				if (elems[i].type == 'checkbox') {
					if (elems[i].parentNode.parentNode.parentNode.parentNode.style.display == 'block') {
						elems[i].checked = false;
					}
				}
			}
		}
	}

</script><% 
	} catch (Throwable e) { 
		out.println(e.getMessage());
	}
%> 
