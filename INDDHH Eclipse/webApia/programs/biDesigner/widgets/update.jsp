<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.WidgetVo"%><%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.BIParameters"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.vo.custom.charts.ChartDataVo"%><%@include file="../../../components/scripts/server/startInc.jsp"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp"%></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.WidgetBean"></jsp:useBean><%
dBean.initBean();

WidgetVo widVo = dBean.getWidgetVo();
String actualUser = dBean.getActualUser(request);
boolean saveChanges = (widVo.getWidId()==null)?true:dBean.hasWritePermission(request, widVo.getWidId(), actualUser);

Collection cubeCol = dBean.getAllCubes();
Collection widBusClasCol = dBean.getAllWidgetBusClasses(request);
Collection qryGraphCol = dBean.getAllQuerysWithGraph(request);
Collection qryCol = dBean.getAllQuerys(request);
HashMap measures = dBean.getAllCbesMeasures();

String cubeStr = dBean.getAllCubesInStr(cubeCol);
String widBusClaStr = dBean.getAllBusClaInStr(widBusClasCol);
String qryStr = dBean.getAllQuerysInStr(qryCol);
String qryGraphStr = dBean.getAllQuerysInStr(qryGraphCol);
String nodeName = widVo.getExecutionNode();

boolean kpiType = true;
boolean customType = false;
boolean cubeType = false;
boolean queryType = false;
boolean querySQLType = false;
boolean srcCube = false;

if (widVo!=null && widVo.getWidType()!=null && widVo.getWidType().intValue() != widVo.WIDGET_TYPE_KPI_ID.intValue()){
	kpiType = false;
}
if (widVo!=null && widVo.getWidType()!=null && widVo.getWidType().intValue() == widVo.WIDGET_TYPE_CUSTOM_ID.intValue()){
	customType = true;
}
if (widVo!=null && widVo.getWidType()!=null && widVo.getWidType().intValue() == widVo.WIDGET_TYPE_CUBE_ID.intValue()){
	cubeType = true;
}
if (widVo!=null && widVo.getWidType()!=null && widVo.getWidType().intValue() == widVo.WIDGET_TYPE_QUERY_ID.intValue()){
	queryType = true;
}
if (widVo!=null && widVo.getWidSrcType()!=null && widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_CUBE_VIEW_ID.intValue()){
	srcCube = true;
}
if (widVo!=null && widVo.getWidSrcType()!=null && widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_QUERY_SQL_ID.intValue()){
	querySQLType = true;
}

%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titWidget")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><div type ="tabElement" id="samplesTab" ontabswitch="tabSwitch()" <%=(request.getParameter("defaultTab")!=null?(" defaultTab='"+request.getParameter("defaultTab").toString()+"'"):"" )%>><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDatGen")%>" tabText="<%=LabelManager.getName(labelSet,"tabDatGen")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatWidget")%></DIV><br><table width="100%" class="tblFormLayout"><tr><%
						String widTitle = widVo.getWidTitle();
					%><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td align="left"><input name="widNom" id="widNom" maxlength="50" p_required="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" <%if(widVo!=null && widVo.getWidName()!=null) {%> value="<%=dBean.fmtStr(widVo.getWidName())%>" <%}%>></td><td></td><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblTit")%>"><%=LabelManager.getNameWAccess(labelSet, "lblTit")%>:</td><td align="left"><input name="widTit" id="widTit" maxlength="50" p_required="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTit")%>" value="<%=dBean.fmtStr(widTitle)%>"></td><td></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td align="left" colspan=2><input name="widDes" id="widDes" maxlength="255" style="width:280px" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" <%if(widVo!=null && widVo.getWidDesc()!=null) {%> title="<%=dBean.fmtStr(widVo.getWidDesc())%>" value="<%=dBean.fmtStr(widVo.getWidDesc())%>" <%}%>></td><td></td><td></td><td></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblType")%>"><%=LabelManager.getNameWAccess(labelSet,"lblType")%>:</td><td align="left"><select name="cmbType" id="cmbType" onChange="cmbType_change()" style="width:100px" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblType")%>"><option value="<%=widVo.WIDGET_TYPE_KPI_ID.intValue()%>" <%=(widVo != null && widVo.getWidType() != null && widVo.getWidType().intValue() == widVo.WIDGET_TYPE_KPI_ID.intValue())?"selected":""%>><%=widVo.WIDGET_TYPE_KPI_NAME%></option><option value="<%=widVo.WIDGET_TYPE_CUBE_ID.intValue()%>" <%=(widVo != null && widVo.getWidType() != null && widVo.getWidType().intValue() == widVo.WIDGET_TYPE_CUBE_ID.intValue())?"selected":""%>><%=widVo.WIDGET_TYPE_CUBE_NAME%></option><option value="<%=widVo.WIDGET_TYPE_QUERY_ID.intValue()%>" <%=(widVo != null && widVo.getWidType() != null && widVo.getWidType().intValue() == widVo.WIDGET_TYPE_QUERY_ID.intValue())?"selected":""%>><%=widVo.WIDGET_TYPE_QUERY_NAME%></option><option value="<%=widVo.WIDGET_TYPE_CUSTOM_ID.intValue()%>" <%=(widVo != null && widVo.getWidType() != null && widVo.getWidType().intValue() == widVo.WIDGET_TYPE_CUSTOM_ID.intValue())?"selected":""%>><%=widVo.WIDGET_TYPE_CUSTOM_NAME%></option></select><input type=hidden name="typIdHid" value="<%=(widVo!=null && widVo.getWidType() != null)?widVo.getWidType().intValue():0%>"></td><td></td><td></td><td></td><td></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblPerAlwActive")%>"><%=LabelManager.getNameWAccess(labelSet,"lblPerAlwActive")%>:</td><td><table width="100%"><tr><td align="left"><input type="checkbox" name="chkWidActive" id="chkWidActive" <%=(widVo!=null && widVo.getWidRefresh()!=null && widVo.getWidRefresh().intValue() == 0)?"checked":""%> onclick="enableDisableRefTime()" <%=(widVo != null && widVo.getWidType() != null && widVo.getWidType().intValue() != widVo.WIDGET_TYPE_KPI_ID.intValue() && widVo.getWidType().intValue() != widVo.WIDGET_TYPE_CUSTOM_ID.intValue())?"disabled":""%>></input></td><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblPeri")%>""><%=LabelManager.getNameWAccess(labelSet,"lblPeri")%>:</td></tr></table></td><td><select name="cmbRefPeriod" id="cmbRefPeriod" onChange="cmbRefPeriod_change()" style="width:150px" <%=(widVo==null || widVo.getWidRefresh()==null || widVo.getWidRefresh().intValue() != 0)?"disabled":""%>><option></option><%
							Collection cPer = dBean.getPeriodicity(request,labelSet);
							if(cPer!=null){
								Iterator itPer = cPer.iterator();
								while(itPer.hasNext()){
									CmbDataVo cmb = (CmbDataVo)itPer.next();
									%><option value="<%=dBean.fmtHTML(cmb.getValue())%>" <%=(widVo!=null && widVo.getPeriodicity()!=null && widVo.getPeriodicity().equals(cmb.getValue()))?"selected":""%>><%=dBean.fmtHTML(cmb.getText())%></option><%
								}
							}
						%></select></td><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblHorEjec")%>"><%=LabelManager.getNameWAccess(labelSet,"lblHorEjec")%>:</td><td><input type=text name="txtHorIni" id="txtHorIni" maxlength=5 size=5 p_mask="<%=DogmaUtil.getHTMLTimeMask()%>" <%=(widVo==null || widVo.getWidRefresh()==null || widVo.getWidRefresh().intValue() != 0 || widVo.getNextExecution()==null)?"disabled":"p_required='true'"%> accesskey="<%=LabelManager.getAccessKey(labelSet,"lblHorIni")%>"  <%if(widVo!=null && widVo.getNextExecution()!=null){%>value="<%=widVo.getHourMinute(widVo.getNextExecution())%>"<%}%>></td></tr><tr><td></td><td></td><td></td><td align=right><%=LabelManager.getName(labelSet,"lblExeNode")%>:</td><td><input type="radio" name="radExeNode" id="radExeNode1" onclick="showOtherNode(1,false);" value="1" <%if(nodeName==null || "".equals(nodeName)) {out.print(" checked ");}%><%=(widVo==null || widVo.getWidRefresh()==null || widVo.getWidRefresh().intValue() != 0)?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblAllNodes")%></td><td></td></tr><tr><td></td><td></td><td></td><td><input type=hidden name="radSelected" value="<%=(nodeName==null || "".equals(nodeName))?1:2%>"></td><td colspan=2><input type="radio" name="radExeNode" id="radExeNode2" onclick="showOtherNode(2,true);" value="2" <%if (nodeName!=null && !"".equals(nodeName)) {out.print(" checked ");}%><%= (widVo==null || widVo.getWidRefresh()==null || widVo.getWidRefresh().intValue() != 0)?"disabled":"" %>><%=LabelManager.getName(labelSet,"lblSpecNode")%>:
						<input <%=(nodeName == null || "".equals(nodeName))?"disabled":"" %> type="text" name="txtExeNode" id="txtExeNode" value="<%=(nodeName != null)?dBean.fmtHTML(nodeName):""%>"></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblRefTime")%>"><%=LabelManager.getNameWAccess(labelSet,"lblRefTime")%>:</td><td align="left"><input p_numeric="true" name="txtRef" id="txtRef" maxlength="5" style="width:40px" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblRefTime")%>" value="<%=(widVo!=null && widVo.getWidRefresh()!=null && widVo.getWidRefresh().intValue() != 0)?widVo.getWidRefresh().intValue():""%>" <%=(widVo!=null && widVo.getWidRefresh()!=null && widVo.getWidRefresh().intValue() == 0)?"disabled":""%>><select name="cmbRefType" id="cmbRefType" style="width:100px" <%=(widVo!=null && widVo.getWidRefresh()!=null && widVo.getWidRefresh().intValue() == 0)?"disabled":""%>><option value="<%=widVo.WIDGET_REF_TIME_SEC.intValue()%>" <%=(widVo != null && widVo.getWidRefType() != null && widVo.getWidRefType().intValue() == widVo.WIDGET_REF_TIME_SEC.intValue())?"selected":""%>><%=widVo.WIDGET_REF_TIME_SEC_NAME%></option><option value="<%=widVo.WIDGET_REF_TIME_MIN.intValue()%>" <%=(widVo != null && widVo.getWidRefType() != null && widVo.getWidRefType().intValue() == widVo.WIDGET_REF_TIME_MIN.intValue())?"selected":""%>><%=widVo.WIDGET_REF_TIME_MIN_NAME%></option><option value="<%=widVo.WIDGET_REF_TIME_HOR.intValue()%>" <%=(widVo != null && widVo.getWidRefType() != null && widVo.getWidRefType().intValue() == widVo.WIDGET_REF_TIME_HOR.intValue())?"selected":""%>><%=widVo.WIDGET_REF_TIME_HOR_NAME%></option></select></td><td></td><td></td><td></td><td></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblDshChild")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDshChild")%>:</td><td align="left"><select name="dshChild" id="widFather" style="width:140px" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDshChild")%>"><option value=""></option><%
					 			Collection dshCol = dBean.getAllDashboards();
		   						if (dshCol!=null && dshCol.size()>0){
									Iterator dshIt = dshCol.iterator();
									while (dshIt.hasNext()){
		   								DashboardVo dshVo = (DashboardVo) dshIt.next();
		   								%><option value="<%=dshVo.getDashboardId().intValue()%>" <%=(widVo!=null && widVo.getDshChildId()!= null && widVo.getDshChildId().intValue() == dshVo.getDashboardId().intValue())?"selected":""%>><%=dshVo.getDashboardName()%></option><%
	   								}
				   				}%></select></td></tr><tr><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"></tr></table><br><br><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatSource")%></DIV><br><table width="100%" class="tblFormLayout"><%
		   				String tdSrcTitle = "";
		   				String tdSrcContent = "";
		   				String visible="none";
		   				String sqlTypeVisible="none";
		   				if (!customType){
		   					tdSrcTitle=LabelManager.getToolTip(labelSet,"lblWidSource");
		   					tdSrcContent = tdSrcTitle + ":";
		   					if (querySQLType){
		   						sqlTypeVisible = "block";
			   				}else {
			   					visible = "block";
			   				}
		   				}
		   				%><tr <%=(!customType || querySQLType)?"style='display:block'":"style='display:none'"%>><td style="width:200px" align="right" title="<%=tdSrcTitle%>"><%=tdSrcContent%></td><td align="left"><select name="cmbSrcType" id="cmbSrcType" style="width:160px" onChange="cmbSrcType_change(this)" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblWidSource")%>"><%if(kpiType){%><option value="<%=widVo.WIDGET_SRC_TYPE_BUS_CLASS_ID.intValue()%>" <%=(widVo != null && widVo.getWidSrcType() != null && widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_BUS_CLASS_ID.intValue())?"selected":""%>><%=widVo.WIDGET_SRC_TYPE_BUS_CLASS_NAME%></option><%}%><%if(kpiType || cubeType){%><option value="<%=widVo.WIDGET_SRC_TYPE_CUBE_VIEW_ID.intValue()%>" <%=(widVo != null && widVo.getWidSrcType() != null && widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_CUBE_VIEW_ID.intValue())?"selected":""%>><%=widVo.WIDGET_SRC_TYPE_CUBE_VIEW_NAME%></option><%}%><%if(kpiType || queryType){%><option value="<%=widVo.WIDGET_SRC_TYPE_QUERY_ID.intValue()%>" <%=(widVo != null && widVo.getWidSrcType() != null && widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_QUERY_ID.intValue())?"selected":""%>><%=widVo.WIDGET_SRC_TYPE_QUERY_NAME%></option><%}%><%if(kpiType){%><option value="<%=widVo.WIDGET_SRC_TYPE_QUERY_SQL_ID.intValue()%>" <%=(widVo != null && widVo.getWidSrcType() != null && widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_QUERY_SQL_ID.intValue())?"selected":""%>><%=widVo.WIDGET_SRC_TYPE_QUERY_SQL_NAME%></option><%}%></select><input type="hidden" name="txtHidOri" id="txtHidOri" value="<%=(widVo!=null && widVo.getWidSrcType() != null )?widVo.getWidSrcType().intValue():0%>"></td></tr><tr style="display:<%=sqlTypeVisible%>"><td style="width:200px" align="right" title="<%=LabelManager.getToolTip(labelSet,"lblQryDbNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryDbNom")%>:</td><td><select name="dbConId" id="dbConId" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblQryDbNom")%>" p_required="true"><option value="-1" <%=(widVo.getSqlQueryDbConId() == null || widVo.getSqlQueryDbConId().equals(new Integer("-1")))?"selected":""%>><%=LabelManager.getName(labelSet,"lblLocalDbNom")%></option><option value="0" <%=(widVo.getSqlQueryDbConId() == null || widVo.getSqlQueryDbConId().equals(new Integer("0")))?"selected":""%>>BIDB</option><%
  								Collection conCol = null;
  								if (widVo!=null && widVo.getSqlQueryDbConId()!=null){
  									conCol = dBean.getDBConnections(request,true);
  								}else{
  									conCol = dBean.getDBConnections(request,false);
  								}
			  					if (conCol != null) {
   									Iterator iterator = conCol.iterator();
				   					DbConnectionVo connection;
   									while (iterator.hasNext()) {
   										connection = (DbConnectionVo) iterator.next(); %><option value="<%=dBean.fmtInt(connection.getDbConId())%>" <%=connection.getDbConId().equals(widVo.getSqlQueryDbConId())?"selected":""%>><%=dBean.fmtStr(connection.getDbConName())%></option><%
   									}
			  					}%></select><input type=hidden name="dbConIdHid" value="<%=(widVo.getSqlQueryDbConId()!=null)?widVo.getSqlQueryDbConId().intValue():0%>"></td></tr><tr style="display:<%=sqlTypeVisible%>"><td style="width:200px" align="right" title="<%=LabelManager.getToolTip(labelSet,"lblSQLQuery")%>"><%=LabelManager.getName(labelSet,"lblSQLQuery")%>:</td><td><table><tr><td><textarea name="txtSqlQuery" id="txtSqlQuery" title="<%=LabelManager.getToolTip(labelSet,"lblWidSelSQL")%>" p_maxlength="true" maxlength="255" cols="130" rows="3" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblWidSelSQL")%>"><%=(widVo.getSqlQuery()!=null)?dBean.fmtHTML(widVo.getSqlQuery()):""%></textarea></td><td><button type="button" id="btnTestSQL" onclick="btnTestSQL_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnTestSql")%>" title="<%=LabelManager.getToolTip(labelSet,"btnTestSql")%>"><%=LabelManager.getName(labelSet,"btnTestSql")%></button><iframe name="testSql" style="height:1px;width:1px;visibility:hidden;"></iframe></td></tr></table></td></tr><tr style="display:<%=visible%>"><%
			  			String tdTitle="";
			  			if (!customType){
			  				if(widVo!=null && widVo.getWidSrcType() != null && widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_CUBE_VIEW_ID.intValue()){
								tdTitle=LabelManager.getToolTip(labelSet,"lblCube");
			   				}else if (widVo!=null && widVo.getWidSrcType() != null && widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_QUERY_ID.intValue()){
			   					tdTitle=LabelManager.getToolTip(labelSet,"lblUsrQuerys");
		   					}else{
		   						tdTitle=LabelManager.getName(labelSet,"lblBusClass");
		   					}
		   				}%><td style="width:200px" align="right" title="<%=tdTitle%>"><%=tdTitle%>:</td><td align="left"><table cellspacing="0" cellpadding="0"><tr style="padding:0px"><td style="padding:0px"><select name="cmbSrc" id="cmbSrc" style="width:260px" onChange="cmbSrc_change()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblCube")%>"><option value="0"></option><%if(widVo!=null && widVo.getWidSrcType()!=null && widVo.getWidSrcId()!=null){
		   						if(widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_CUBE_VIEW_ID.intValue()){	
			   						if (cubeCol!=null && cubeCol.size()>0){
				   						Iterator cubeIt = cubeCol.iterator();
				   						while (cubeIt.hasNext()){
		   									CubeVo cbeVo = (CubeVo) cubeIt.next();
		   									String cbeName = cbeVo.getCubeName();
		   									if (cbeName.startsWith("lblDw") || cbeName.startsWith("mnuDw")){
												if (cbeName.indexOf("_")>0){
													cbeName = LabelManager.getName(labelSet, cbeName.substring(0, cbeName.indexOf("_"))) + cbeName.substring(cbeName.indexOf("_"), cbeName.length());
												}else{
													cbeName = LabelManager.getName(labelSet, cbeName);
												}
											}%><option value="<%=cbeVo.getCubeId()%>" <%=(widVo.getWidSrcId().intValue() == cbeVo.getCubeId().intValue())?"selected":""%>><%=cbeName%></option><%
		   								}
		   							}
		   						}else if (widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_BUS_CLASS_ID.intValue()){
		   							if (widBusClasCol!=null && widBusClasCol.size()>0){
				   						Iterator widBusIt = widBusClasCol.iterator();
				   						while (widBusIt.hasNext()){
		   									BusClassVo busClaVo = (BusClassVo) widBusIt.next();%><option value="<%=busClaVo.getBusClaId().intValue()%>" <%=(widVo.getWidSrcId().intValue() == busClaVo.getBusClaId().intValue())?"selected":""%>><%=busClaVo.getBusClaName()%></option><%
		   								}
		   							}
		   						}else if (widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_QUERY_ID.intValue()){
		   							Iterator qryIt = null;
		   							if (widVo.getWidType().intValue() == widVo.WIDGET_TYPE_KPI_ID.intValue()){
		   								qryIt = qryCol.iterator();
		   							}else if (qryCol!=null && qryCol.size()>0){
		   								qryIt = qryGraphCol.iterator();
		   							}
		   							if (qryIt != null){
				   						while (qryIt.hasNext()){
		   									QueryVo queryVo = (QueryVo) qryIt.next();%><option value="<%=queryVo.getQryId()%>" <%=(widVo.getWidSrcId().intValue() == queryVo.getQryId().intValue())?"selected":""%>><%=queryVo.getQryName()%></option><%
		   								}
		   							}
		   						}
		   					}else{
			   					if (widBusClasCol!=null && widBusClasCol.size()>0){
				   					Iterator widBusIt = widBusClasCol.iterator();
				   					while (widBusIt.hasNext()){
		   								BusClassVo busClaVo = (BusClassVo) widBusIt.next();%><option value="<%=busClaVo.getBusClaId().intValue()%>"><%=busClaVo.getBusClaName()%></option><%
		   							}
		   						}
		   					}
		   					%></select></td><td><%if (!customType){
		   						if(widVo!=null && widVo.getWidSrcType()!=null && widVo.getWidSrcId()!=null){
		   							if(widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_CUBE_VIEW_ID.intValue()){ //Tipo vista de cubo%><td style=\"vertical-align:bottom\"><img id="imgBusClaParams" title="<%=LabelManager.getName(labelSet,"lblSelBusClaParameters")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod_red.gif" width="15" height="14" onclick="openParameterModal(this)" style="cursor:pointer;cursor:hand;display:none"></td><input type="hidden" name="txtHidParValues" id="txtHidParValues" value=""><td style=\"vertical-align:bottom;\"><img id="imgBusClaShowParams" title="<%=LabelManager.getName(labelSet,"lblSelQueryColumn")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif" width="15" height="14" onclick="openParameterShowModal(this)" style="cursor:pointer;cursor:hand;display:none"></td><input type="hidden" name="txtHidWidQryColumn" id="txtHidWidQryColumn" value=""><%}else if(widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_BUS_CLASS_ID.intValue()){ //Tipo clase de negocio%><td style=\"vertical-align:bottom;\"><img id="imgBusClaParams" title="<%=LabelManager.getName(labelSet,"lblSelBusClaParameters")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod_red.gif" width="15" height="14" onclick="openParameterModal(this)" style="cursor:pointer;cursor:hand;display:block"></td><input type="hidden" name="txtHidParValues" id="txtHidParValues" value="<%=widVo.getSrcParams()%>"><td style=\"vertical-align:bottom;\"><img id="imgBusClaShowParams" title="<%=LabelManager.getName(labelSet,"lblSelQueryColumn")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif" width="15" height="14" onclick="openParameterShowModal(this)" style="cursor:pointer;cursor:hand;display:none"></td><input type="hidden" name="txtHidWidQryColumn" id="txtHidWidQryColumn" value=""><%}else if (widVo.getWidType().intValue() == widVo.WIDGET_TYPE_KPI_ID.intValue()){ //Tipo consulta de usuario de un widget kpi%><td style=\"vertical-align:bottom;\"><img id="imgBusClaParams" title="<%=LabelManager.getName(labelSet,"lblSelQueryFilters")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod_red.gif" width="15" height="14" onclick="openParameterModal(this)" style="cursor:pointer;cursor:hand;display:block"></td><input type="hidden" name="txtHidParValues" id="txtHidParValues" value="<%=widVo.getSrcParams()%>"><td style=\"vertical-align:bottom;\"><img id="imgBusClaShowParams" title="<%=LabelManager.getName(labelSet,"lblSelQueryColumn")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif" width="15" height="14" onclick="openParameterShowModal(this)" style="cursor:pointer;cursor:hand;display:block"></td><input type="hidden" name="txtHidWidQryColumn" id="txtHidWidQryColumn" value="<%=widVo.getWidParOutName()%>"><%}else if (widVo.getWidType().intValue() == widVo.WIDGET_TYPE_QUERY_ID.intValue()){ //Tipo consulta de usuario de un widget Consulta%><td style=\"vertical-align:bottom;\"><img id="imgBusClaParams" title="<%=LabelManager.getName(labelSet,"lblSelQueryFilters")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod_red.gif" width="15" height="14" onclick="openParameterModal(this)" style="cursor:pointer;cursor:hand;display:block"></td><input type="hidden" name="txtHidParValues" id="txtHidParValues" value="<%=widVo.getSrcParams()%>"><td style=\"vertical-align:bottom;\"><img id="imgBusClaShowParams" title="<%=LabelManager.getName(labelSet,"lblSelQueryColumn")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif" width="15" height="14" onclick="openParameterShowModal(this)" style="cursor:pointer;cursor:hand;display:none"></td><input type="hidden" name="txtHidWidQryColumn" id="txtHidWidQryColumn" value="<%=widVo.getWidParOutName()%>"><%}
		   						}else{ //por defecto de tipo clase de negocio%><td style=\"vertical-align:bottom;\"><img id="imgBusClaParams" title="<%=LabelManager.getName(labelSet,"lblSelBusClaParameters")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod_red.gif" width="15" height="14" onclick="openParameterModal(this)" style="cursor:pointer;cursor:hand;display:block"></td><input type="hidden" name="txtHidParValues" id="txtHidParValues" value="<%=widVo.getSrcParams()%>"><td style=\"vertical-align:bottom;\"><img id="imgBusClaShowParams" title="<%=LabelManager.getName(labelSet,"lblSelQueryColumn")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif" width="15" height="14" onclick="openParameterShowModal(this)" style="cursor:pointer;cursor:hand;display:none"></td><input type="hidden" name="txtHidWidQryColumn" id="txtHidWidQryColumn" value=""><%}
		   					}else{%><td style=\"vertical-align:bottom\"><img style="visibility:hidden" id="imgBusClaParams" title="<%=LabelManager.getName(labelSet,"lblSelBusClaParameters")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod_red.gif" width="15" height="14" onclick="openParameterModal(this)" style="cursor:pointer;cursor:hand;display:none"></td><input type="hidden" name="txtHidParValues" id="txtHidParValues" value=""><td style=\"vertical-align:bottom;\"><img id="imgBusClaShowParams" title="<%=LabelManager.getName(labelSet,"lblSelQueryColumn")%>" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/btn_mod.gif" width="15" height="14" onclick="openParameterShowModal(this)" style="cursor:pointer;cursor:hand;display:none"></td><input type="hidden" name="txtHidWidQryColumn" id="txtHidWidQryColumn" value=""><%} %></td></tr></table></td></tr><%
		   			String vwVisible = "none";
		   			if (srcCube){
		   				vwVisible = "block";
		   			}
		   			%><tr style="display:<%=vwVisible%>"><td style="width:200px" align="right" title="<%=LabelManager.getToolTip(labelSet,"lblVis")%>"><%=LabelManager.getNameWAccess(labelSet,"lblVis")%>:</td><td align="left"><select name="cmbView" id="cmbView" style="width:260px" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblVis")%>"><option value="0"></option><%if(widVo!=null && widVo.getWidSrcId()!=null){
		   								if(widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_CUBE_VIEW_ID.intValue()){		
			   								Collection vwCol = dBean.getCubeViews(widVo.getWidSrcId());
			   								if (vwCol!=null && vwCol.size()>0){
				   								Iterator vwIt = vwCol.iterator();
				   								while (vwIt.hasNext()){
			   										CubeViewMdxVo cbeVwMdxVo = (CubeViewMdxVo) vwIt.next();
			   										if (widVo.getWidParId()!=null && cbeVwMdxVo.getVwId()!=null){%><option value="<%=cbeVwMdxVo.getVwId()%>" <%=(widVo.getWidParId().intValue() == cbeVwMdxVo.getVwId().intValue())?"selected":""%>><%=cbeVwMdxVo.getVwName()%></option><%}
		   										}
		   									}
		   								}
		   							}
		   					%></select><input type=hidden name="txtHidView" id="txtHidView"/></td></tr></table><table><%
		   				String custVisible="none";
		   				if (customType){
		   					custVisible="block";
		   				}
		   				boolean isUrl = false;
		   				String lblHtmlUrl="";
		   				String lblTstHtmlUrl="";
		   				String lblToolTipTxtArea="";
		   				if(widVo!=null && widVo.getWidSrcType()!=null && widVo.getWidSrcType().intValue() == widVo.WIDGET_SRC_TYPE_URL_ID.intValue()){
		   					isUrl=true;
		   					lblHtmlUrl= "lblDirUrl";
		   					lblTstHtmlUrl="lblTstUrl";
		   					lblToolTipTxtArea="lblEntCodUrl";
		   				}else{
		   					lblHtmlUrl="lblCodHtml";
		   					lblTstHtmlUrl="lblTestHtml";
		   					lblToolTipTxtArea="lblEntCodHtml";
		   				}
		   				%><tr style="display:<%=custVisible%>"><td style="width:200px" align="right"><%=LabelManager.getName(labelSet,"lblUrl")%></td><td><input type="checkbox" id="chkCustUrl" name="chkCustUrl" <%=(isUrl)?"checked":""%> onclick="clickCustUrl()"></td></tr><tr style="display:<%=custVisible%>"><td  style="width:200px" align="right" title="<%=LabelManager.getToolTip(labelSet,lblHtmlUrl)%>"><%=LabelManager.getName(labelSet,lblHtmlUrl)%>:</td><td><textarea name="txtCustomSrc" id="txtCustomSrc" title="<%=LabelManager.getToolTip(labelSet,lblToolTipTxtArea)%>" p_maxlength="true" maxlength="255" cols="130" rows="3" accesskey="<%=LabelManager.getAccessKey(labelSet,lblToolTipTxtArea)%>"><%=dBean.fmtHTML(widVo.getWidHtmlCod())%></textarea></td></tr><tr style="display:<%=custVisible%>"><td style="width:200px"></td><td><input type="hidden"/><button type="button" id="btnDelHtml" style="visibility:<%=(!customType)?"hidden":"visible"%>" onclick="btnDelHtml_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDelHtml")%>" title="<%=LabelManager.getToolTip(labelSet,"lblDelHtml")%>"><%=LabelManager.getName(labelSet,"lblDelHtml")%></button><button type="button" id="btnTestHtml" style="visibility:<%=(!customType)?"hidden":"visible"%>" onclick="btnTestHtml_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,lblTstHtmlUrl)%>" title="<%=LabelManager.getToolTip(labelSet,lblTstHtmlUrl)%>"><%=LabelManager.getName(labelSet,lblTstHtmlUrl)%></button></td></tr></table><br><br><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtNot")%></DIV><br><table width="100%" class="tblFormLayout"><%
		   				boolean notifOnUpdError = widVo.getWidFlags(WidgetVo.FLAG_NOTIFY_ADMIN);
		   				String emails = widVo.getWidMails();
		   			%><tr><td style="width:270px" align="right"><input name="chkNotify" type="checkbox" onclick="chkNotifyClk()" <%if (widVo.getWidFlags()!=null && widVo.getWidFlags(WidgetVo.FLAG_NOTIFY_ADMIN)) {%> checked <%}%><%=(widVo==null || widVo.getWidRefresh()==null || widVo.getWidRefresh().intValue() != 0)?"disabled":""%>><%=LabelManager.getName(labelSet,"lblWidUpdOnError")%></input></td><td align="left"><input name="txtEmails" maxlength="255" size=80 title="<%=LabelManager.getName(labelSet,"msgSchAdmEmails")%>" type="text" <%if (widVo.getWidFlags()==null || !widVo.getWidFlags(WidgetVo.FLAG_NOTIFY_ADMIN)) {%> disabled <%}%><%if(widVo!=null && widVo.getWidId() != null) {%>value="<%=dBean.fmtStr(widVo.getWidMails())%>"<%}%>></td></tr></table><br><br></div><!--     HISTORICO         --><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabWidHistoric")%>" tabText="<%=LabelManager.getName(labelSet,"tabWidHistoric")%>"><%@ include file="historic.jsp" %></div><!--      INFORMACION COMPLEMENTARIA          --><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabWidInfo")%>" tabText="<%=LabelManager.getName(labelSet,"tabWidInfo")%>"><%@ include file="extraInformation.jsp" %></div><!--      PERMISOS          --><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabWidPer")%>" tabText="<%=LabelManager.getName(labelSet,"tabWidPer")%>"><%@ include file="permissions.jsp" %></div></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></td><TD align="right"><%if (customType || cubeType || queryType){%><button type="button" id="btnConf" onclick="btnConf_click()" <%=(!saveChanges)?"disabled":"" %> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><%}else{%><button type="button" id="btnConf" onclick="btnNext_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSig")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSig")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSig")%></button><%}%><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp"%><script language="javascript" defer="true" src='<%=Parameters.ROOT_PATH%>/programs/biDesigner/widgets/update.js'></script><script type="text/javascript">
var WIDGET_TYPE_KPI_ID = "<%=WidgetVo.WIDGET_TYPE_KPI_ID%>";
var WIDGET_TYPE_KPI_NAME = "<%=WidgetVo.WIDGET_TYPE_KPI_NAME%>";
var WIDGET_TYPE_CUBE_ID = "<%=WidgetVo.WIDGET_TYPE_CUBE_ID%>";
var WIDGET_TYPE_CUBE_NAME = "<%=WidgetVo.WIDGET_TYPE_CUBE_NAME%>";
var WIDGET_TYPE_QUERY_ID = "<%=WidgetVo.WIDGET_TYPE_QUERY_ID%>";
var WIDGET_TYPE_QUERY_NAME = "<%=WidgetVo.WIDGET_TYPE_QUERY_NAME%>";
var WIDGET_TYPE_CUSTOM_ID = "<%=WidgetVo.WIDGET_TYPE_CUSTOM_ID%>";
var WIDGET_TYPE_CUSTOM_NAME = "<%=WidgetVo.WIDGET_TYPE_CUSTOM_NAME%>";
var WIDGET_SRC_TYPE_CUBE_VIEW_ID = "<%=WidgetVo.WIDGET_SRC_TYPE_CUBE_VIEW_ID%>";
var WIDGET_SRC_TYPE_CUBE_VIEW_NAME = "<%=WidgetVo.WIDGET_SRC_TYPE_CUBE_VIEW_NAME%>";
var WIDGET_SRC_TYPE_BUS_CLASS_ID = "<%=WidgetVo.WIDGET_SRC_TYPE_BUS_CLASS_ID%>";
var WIDGET_SRC_TYPE_BUS_CLASS_NAME = "<%=WidgetVo.WIDGET_SRC_TYPE_BUS_CLASS_NAME%>";
var WIDGET_SRC_TYPE_QUERY_ID = "<%=WidgetVo.WIDGET_SRC_TYPE_QUERY_ID%>";
var WIDGET_SRC_TYPE_QUERY_NAME = "<%=WidgetVo.WIDGET_SRC_TYPE_QUERY_NAME%>";
var WIDGET_SRC_TYPE_QUERY_SQL_ID = "<%=WidgetVo.WIDGET_SRC_TYPE_QUERY_SQL_ID%>";
var WIDGET_SRC_TYPE_QUERY_SQL_NAME = "<%=WidgetVo.WIDGET_SRC_TYPE_QUERY_SQL_NAME%>";
var GAUGE_IMAGE_SRC = "<%=WidgetVo.WIDGET_GAUGE_SRC_IMAGE%>"; 
var CUBE_IMAGE_SRC = "<%=WidgetVo.WIDGET_CUBE_SRC_IMAGE%>";
var QUERY_IMAGE_SRC = "<%=WidgetVo.WIDGET_QUERY_SRC_IMAGE%>";
var ALL_CUBES_STR = "<%=cubeStr%>";
var ALL_WID_CLASSES_STR = "<%=widBusClaStr%>";
var ALL_QRYS_STR = "<%=qryStr%>";
var ALL_QRYS_GRAPH_STR = "<%=qryGraphStr%>";
var LBL_SOURCE = "<%=LabelManager.getToolTip(labelSet,"lblWidSource")%>";
var LBL_CUBE = "<%=LabelManager.getName(labelSet,"lblCube")%>";
var LBL_CUBE_VIEW = "<%=LabelManager.getName(labelSet,"lblVis")%>";
var LBL_BUS_CLASS = "<%=LabelManager.getName(labelSet,"lblBusClass")%>";
var LBL_COD_HTML = "<%=LabelManager.getName(labelSet,"lblCodHtml")%>";
var LBL_URL = "<%=LabelManager.getName(labelSet,"lblUrl")%>";
var LBL_SEL_BUS_CLASS_PARAMS = "<%=LabelManager.getName(labelSet,"lblSelBusClaParameters")%>";
var LBL_SEL_QUERY_FILTERS = "<%=LabelManager.getName(labelSet,"lblSelQueryFilters")%>";
var LBL_QUERY = "<%=LabelManager.getName(labelSet,"lblUsrQuerys")%>";
var LBL_SQL_QUERY = "<%=LabelManager.getName(labelSet,"lblSQLQuery")%>";
var LBL_SEL_BUS_CLASS = "<%=LabelManager.getName(labelSet,"lblSelBusClass")%>";
var LBL_DEL_BUS_CLASS = "<%=LabelManager.getName(labelSet,"lblDelBusClass")%>";
var LBL_BTN_CONF_ACC_KEY = "<%=LabelManager.getAccessKey(labelSet,"btnCon")%>";
var LBL_BTN_CONF_TITLE = "<%=LabelManager.getToolTip(labelSet,"btnCon")%>";
var LBL_BTN_CONF_NAME = "<%=LabelManager.getName(labelSet,"btnCon")%>";
var LBL_BTN_SIG_ACC_KEY = "<%=LabelManager.getAccessKey(labelSet,"btnSig")%>";
var LBL_BTN_SIG_TITLE = "<%=LabelManager.getToolTip(labelSet,"btnSig")%>";
var LBL_BTN_SIG_NAME = "<%=LabelManager.getName(labelSet,"btnSig")%>";
var LBL_TST_URL = "<%=LabelManager.getName(labelSet,"lblTstUrl")%>";
var LBL_TST_HTML = "<%=LabelManager.getName(labelSet,"lblTestHtml")%>";
var LBL_DIR_URL = "<%=LabelManager.getName(labelSet,"lblDirUrl")%>";
var LBL_USR_QRYS_WITH_GRAPHS = "<%=LabelManager.getName(labelSet,"lblUsrQryWithGraphs")%>";
var LBL_USR_QRYS = "<%=LabelManager.getName(labelSet,"lblUsrAllQry")%>";
var LBL_RESULT = "<%=LabelManager.getName(labelSet,"sbtRes")%>";
var LBL_ENT_COD_HTML = "<%=LabelManager.getName(labelSet,"lblEntCodHtml")%>";
var LBL_ENT_COD_URL = "<%=LabelManager.getName(labelSet,"lblEntCodUrl")%>";
var SCH_PERIOD_DAY = "<%=SchBusClaActivityVo.PERIODICITY_EVERY_DAY%>";
var SCH_PERIOD_WEEK = "<%=SchBusClaActivityVo.PERIODICITY_EVERY_WEEK%>";
var SCH_PERIOD_MONTH = "<%=SchBusClaActivityVo.PERIODICITY_EVERY_MONTH%>";
var SCH_PERIOD_YEAR = "<%=SchBusClaActivityVo.PERIODICITY_EVERY_YEAR%>";
var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";
var MSG_MUST_SEL_ONE_ROW_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelOneRowFirst")%>";
var MSG_MUST_SEL_META_BY = "<%=LabelManager.getName(labelSet,"msgMstSelMetaBy")%>";

<% if (widVo!=null && widVo.getWidId()!=null){%>
var WID_ID = "<%=widVo.getWidId().intValue()%>";
<%}else{%>
var WID_ID = "0";
<%}%>
var MSG_ALR_EXI_ZNE = "<%=LabelManager.getName(labelSet,"msgAlrExiZne") %>";
var MSG_WRN_ZNE_SECUENCE = "<%=LabelManager.getName(labelSet,"msgWrnZneSecuence") %>";
var MSG_MIS_KPI_MIN_VAL = "<%=LabelManager.getName(labelSet,"msgMisKpiMinValue") %>";
var MSG_MIS_KPI_MAX_VAL = "<%=LabelManager.getName(labelSet,"msgMisKpiMaxValue") %>";
var MSG_ALL_ZNE_MUS_HAV_MAX_VAL = "<%=LabelManager.getName(labelSet,"msgAllZneMusHavMaxValue") %>";
var MSG_ONE_ZNE_MUS_STA_MIN_VAL = "<%=LabelManager.getName(labelSet,"msgOneZneMusStaMinKpi") %>";
var MSG_ONE_ZNE_MUS_STA_MAX_VAL = "<%=LabelManager.getName(labelSet,"msgOneZneMusStaMaxKpi") %>";
var MSG_MUS_SEL_ONE_CBE = "<%=LabelManager.getName(labelSet,"msgMusSelOneCube") %>";
var MSG_MUS_SEL_ONE_BUS_CLA = "<%=LabelManager.getName(labelSet,"msgMusSelOneBusClass") %>";
var MSG_MUS_SEL_ONE_QRY = "<%=LabelManager.getName(labelSet,"msgMusSelOneQuery") %>";
var MSG_MUS_SEL_ONE_VW = "<%=LabelManager.getName(labelSet,"msgMusSelOneVw") %>";
var MSG_MUS_SEL_ONE_PERI = "<%=LabelManager.getName(labelSet,"msgMusSelPeri") %>";
var MSG_MUS_ENT_NODE_NAME = "<%=LabelManager.getName(labelSet,"msgInvalidNodeName") %>";
var MSG_WID_BUS_CLA_ERR = "<%=LabelManager.getName(labelSet,"msgWidBusClaErr").replace("\"","\\\"")%>";
var MSG_MUST_SEL_BUS_CLA_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelBusClaFirst") %>";
var MSG_MUST_SEL_BUS_CLA_WIDGET = "<%=LabelManager.getName(labelSet,"msgMusSelBusClaWidget") %>";
var MSG_MUST_SEL_QUERY_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelQueryFirst") %>";
var MSG_BUS_CLA_NOT_EXIST = "<%=LabelManager.getName(labelSet,"msgBusClaNotExist") %>";
var MSG_BUS_CLA_NOT_EXIST = "<%=LabelManager.getName(labelSet,"msgBusClaNotExist") %>";
var MSG_QUERY_NOT_EXIST = "<%=LabelManager.getName(labelSet,"msgQryNotExist") %>";
var MSG_PAR_BUS_CLA_NOT_VAL = "<%=LabelManager.getName(labelSet,"msgParBusClaNotVal") %>";
var MSG_REF_TIME_MISS = "<%=LabelManager.getName(labelSet,"msgRefTimeMiss") %>";
var MSG_WRNG_REF_TIME = "<%=LabelManager.getName(labelSet,"msgWrngRefTime") %>";
var MSG_FIL_QRY_NOT_VAL = "<%=LabelManager.getName(labelSet,"msgFilQryNotVal") %>";
var MSG_NOT_PAR_VALUE_FOUND = "<%=LabelManager.getName(labelSet,"msgNotParValue") %>";
var MSG_MST_SEL_QRY_COL = "<%=LabelManager.getName(labelSet,"msgQryColMustSel") %>";
var MSG_CHI_WID_MUS_STO_VALUES = "<%=LabelManager.getName(labelSet,"msgChiWidMusStoValues") %>";
var MSG_MUST_ENT_COD_HTML = "<%=LabelManager.getName(labelSet,"msgMustEntCodHtml")%>";
var MSG_MUST_ENT_URL = "<%=LabelManager.getName(labelSet,"msgMustEntUrl")%>";
var MSG_SQL_NOT_NUM_RET = "<%=LabelManager.getName(labelSet,"msgWidSQLNotNumReturn")%>";
var PARAM_IO_IN 	= "<%=BusClaParameterVo.PARAM_IO_IN%>";
var PARAM_IO_OUT 	= "<%=BusClaParameterVo.PARAM_IO_OUT%>";
var PARAM_IO_IN_OUT = "<%=BusClaParameterVo.PARAM_IO_IN_OUT%>";
var LBL_NUMBER = "<%=LabelManager.getName(labelSet,"lblNum")%>";
var LBL_NUMBER_ID = "<%=AttributeVo.TYPE_NUMERIC%>";
var LBL_STRING = "<%=LabelManager.getName(labelSet,"lblStr")%>";
var LBL_STRING_ID = "<%=AttributeVo.TYPE_STRING%>";
var LBL_DATE = "<%=LabelManager.getName(labelSet,"lblFec")%>";
var LBL_DATE_ID = "<%=AttributeVo.TYPE_DATE%>";
var HTML_COD_EXAMPLE = "<!-------  Example Weather in Montevideo, Uruguay by Weather Channel ---------><script type='text/javascript' src='http://voap.weather.com/weather/oap/UYXX0006?template=EVNTH&par=3000000007&unit=1&key=twciweatherwidget'>";

</script>