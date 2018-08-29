<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@include file="../../../components/scripts/server/startInc.jsp"%><%@page import="com.dogma.vo.biSchemaDef.MeasureInfoVo"%><%@page import="com.dogma.vo.biSchemaDef.CalculatedMemberInfoVo"%><%@page import="com.dogma.vo.biSchemaDef.TableInfoVo"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.vo.custom.CmbDataVo"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp"%><script language="JavaScript">

var flashLoaded=false;

var actionAfter="";

var isInternetExplorer = navigator.appName.indexOf("Microsoft") != -1;
// Handle all the FSCommand messages in a Flash movie.
function treeDrop_DoFSCommand(command, args) {
	var treeDropObj = isInternetExplorer ? document.all.treeDrop : document.treeDrop;
	//
	// Place your code here.
	//
	if(command=="getTables"){
		setTables();
	}else if(command=="getPrimaries"){
		var par1=args.split(".")[0];
		var par2=args.split(".")[1];
		setPrimaries(par1,par2);
	}else if(command=="getSharedDimensions"){
		setSharedDimensions();
	}else if(command=="getColumns"){
		setColumns();
	}else if(command=="outputXML"){
		gotXMLOutput(args);
	}else if(command=="loadDimensionProps"){
		setDimensionProps();
	}else if(command=="flashLoaded"){
		setFlashLoaded(true);
	}else if(command=="flashHidden"){
		flashHidden(args);
	}else if(command=="loadHierarchyTableProps"){
		//alert("loadHierarchyTableProps");
	}else{
		alert(command+"--"+args);
	}
	
}
// Hook for Internet Explorer.
if (navigator.appName && navigator.appName.indexOf("Microsoft") != -1 && navigator.userAgent.indexOf("Windows") != -1 && navigator.userAgent.indexOf("Windows 3.1") == -1) {
	document.write('<script language=\"VBScript\"\>\n');
	document.write('On Error Resume Next\n');
	document.write('Sub treeDrop_FSCommand(ByVal command, ByVal args)\n');
	document.write('	Call treeDrop_DoFSCommand(command, args)\n');
	document.write('End Sub\n');
	document.write('</script\>\n');
}
//--></script><script language="javascript">
	var lastTab=0;

	function tabSwitch(){
		actionAfter="";
		if(MSIE && lastTab==3){
			getXml();
		}
		if(document.getElementById("samplesTab").shownIndex==3){
			getFlashObject("treeDrop").style.width=(getStageWidth()-20)+"px"
			getFlashObject("treeDrop").style.height=(getStageHeight()-100)+"px"
			setColumns();
			loadModel();
			if(MSIE){
				setDimensionProps();
			}
		}
		lastTab=document.getElementById("samplesTab").shownIndex;
	}

	function setTables(){
		var tables=getSelectedTables();
		getFlashObject("treeDrop").SetVariable("call", "setTables,"+tables);
	}

	function setPrimaries(tableId,tableName){
		var primaries=getTableCols(tableId,tableName);
		getFlashObject("treeDrop").SetVariable("call", "setPrimaries,"+primaries);
	}

	function setColumns(){
		var columns=getSourceColumns();
		if (columns != ''){
			getFlashObject("treeDrop").SetVariable("call", "setColumns,"+columns);
		}
	}
	
	function getXml(){
		if(flashLoaded){
			getFlashObject("treeDrop").SetVariable("call", "getOutputXML");
		}else if(actionAfter=="generate"){
			btnGen_click();
		}else{
			btnConf_click();
		}
	}
	
	function setDimensionProps(){
		var props=getFactColumns();
		getFlashObject("treeDrop").SetVariable("call", "setDimensionProps,"+props);
	}
	
	function setSharedDimensions(){
		var dimensions = getSharedDimensions();
		getFlashObject("treeDrop").SetVariable("call", "setSharedDimensions,"+dimensions);
	}
	
	function getFlashObject(movieName){
		if (window.document[movieName]){
			return window.document[movieName];
		}
		if (navigator.appName.indexOf("Microsoft Internet")==-1){
			if (document.embeds && document.embeds[movieName]){
				return document.embeds[movieName];
			}
		}else{ // if (navigator.appName.indexOf("Microsoft Internet")!=-1){
			return document.getElementById(movieName);
		}
	}
	
	function gotXMLOutput(xml){
		document.getElementById("treeModel").value=xml;
		if(actionAfter=="generate"){
			var aux=xml.split('"?>');
			xml="<nodes>"+aux[aux.length-1]+"</nodes>";
			document.getElementById("treeModel").value=xml;
			btnGen_click();
		}else if(actionAfter=="confirm"){
			var aux=xml.split('"?>');
			xml="<nodes>"+aux[aux.length-1]+"</nodes>";
			document.getElementById("treeModel").value=xml;
			btnConf_click();
		}
	}
	
	function loadModel(){
		if(MSIE){
			var model=document.getElementById("treeModel").value;
			getFlashObject("treeDrop").SetVariable("call", ("loadXML,"+model));
		}
	}
	
	function setFlashLoaded(to){
		flashLoaded=to;
		var model=document.getElementById("treeModel").value;
		getFlashObject("treeDrop").SetVariable("call", ("loadXML,"+model));
	}
	
	function flashHidden(xml){
		document.getElementById("treeModel").value=xml;
		if(document.getElementById("samplesTab").shownIndex!=3){
			setTimeout('document.getElementById("samplesTab").showContent(document.getElementById("samplesTab").shownIndex);',100);
		}
	}
	
	
</script></head><body><jsp:useBean id="dBean" scope="session"
	class="com.dogma.bean.administration.CubeBean"></jsp:useBean><%
CubeVo cbeVo = dBean.getCubeVo();
//cargamos las dimensiones compartidas de todos los schemas: Ej: "schema1.dim1-dim2-dim3;schema2.dim1-dim2;..."
dBean.loadSharedDimensions(request);
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet, "titCubes")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type="tabElement" id="samplesTab" ontabswitch="tabSwitch()" defaultTab="<%=("true".equals(request.getParameter("generated")))?4:0%>"><div type="tab" style="visibility:hidden" style="visibility:hidden;"
	tabTitle="<%=LabelManager.getToolTip(labelSet,"tabProGen")%>"
	tabText="<%=LabelManager.getName(labelSet,"tabProGen")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet, "sbtDatCube")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet, "lblNom")%>:</td><%if (request.getParameter("cubeName")!=null){%><td><input name="txtName" id="txtName" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" value="<%=dBean.fmtStr(request.getParameter("cubeName"))%>"></td><%}else{%><td><input name="txtName" id="txtName" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(cbeVo!=null && cbeVo.getCubeName()!=null) {%> value="<%=dBean.fmtStr(cbeVo.getCubeName())%>" <%}%>></td><%}%></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet, "lblDes")%>:</td><%if (request.getParameter("cubeDesc")!=null){%><td colspan=3><input name="txtDesc" id="txtDesc" maxlength="255" size=80 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" value="<%=dBean.fmtStr(request.getParameter("cubeDesc"))%>"></td><%}else{%><td colspan=3><input name="txtDesc" id="txtDesc" maxlength="255" size=80 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" <%if(cbeVo!=null && cbeVo.getCubeDesc()!=null) {%> value="<%=dBean.fmtStr(cbeVo.getCubeDesc())%>" <%}%>></td><%}%></tr><tr><%
		Collection colSch = dBean.getSchemasWithEnv(request);
		%><td style="width:20%;"
			title="<%=LabelManager.getToolTip(labelSet,"titSchema")%>"><%=LabelManager.getNameWAccess(labelSet, "titSchema")%>:</td><td><input type=hidden name="idSch" value=""><select	name="selSch" p_required="true" onchange="selSchema_click(<%=request.getParameter("generated")%>)" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblSch")%>"><%if (colSch != null && colSch.size() > 0) {
				Iterator itSch = colSch.iterator();
				SchemaVo schVo = null;
				%><option value=""></option><%
				while (itSch.hasNext()) {
					schVo = (SchemaVo) itSch.next();
					%><option value="<%=schVo.getSchIdEnv().contains("_ALL")?schVo.getSchIdEnv().replace("_ALL","_"+LabelManager.getName(labelSet,"lblTodAmb")):schVo.getSchIdEnv()%>"
					<%if (dBean.getSchId()!=null && schVo.getSchemaId() != null && schVo.getSchemaId().intValue() == dBean.getSchId().intValue()){
						out.print(" selected");
					}else if (cbeVo.getCubeId() != null && schVo.getSchemaId() != null && dBean.getSchemaId(cbeVo.getCubeId()) != null && schVo.getSchemaId().intValue() == dBean.getSchemaId(cbeVo.getCubeId()).intValue())  {
						out.print(" selected");
					}%>
					><%=schVo.getSchemaName()%></option><%}%><%}%></select></td></tr><tr><td></td><td></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblAmb")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAmb")%>:</td><td><select	name="selAmb" id="selAmb" <%=(cbeVo!=null && cbeVo.getEnvId()==null)?"disabled":""%>><%if(cbeVo!=null){
		   	if (cbeVo.getEnvId()!=null){
			   	if (cbeVo.getEnvId().intValue() != -1){//El schema pertenece a un ambiente%><option selected disabled="true" value="<%=dBean.fmtInt(cbeVo.getEnvId())%>"><%=dBean.fmtStr(cbeVo.getEnvName())%></option><%}else{%><option selected value="-2"><%=LabelManager.getName(labelSet,"lblActual")%></option><option value="-1"><%=LabelManager.getName(labelSet,"lblTodAmb")%></option><%}%><%}else{%><option value="-2"><%=LabelManager.getName(labelSet,"lblActual")%></option><option selected value="-1"><%=LabelManager.getName(labelSet,"lblTodAmb")%></option><%}
		}else{%><option selected value="-2"><%=LabelManager.getName(labelSet,"lblActual")%></option><option value="-1"><%=LabelManager.getName(labelSet,"lblTodAmb")%></option><%}%></select></td></tr></table></div><div type="tab" style="visibility:hidden" style="visibility:hidden;"
	tabTitle="<%=LabelManager.getToolTip(labelSet,"lblMapTables")%>"
	tabText="<%=LabelManager.getName(labelSet,"lblMapTables")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet, "lblMapTables")%></DIV><br><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td></td><td></td><td></td><td></td></tr><tr><td align=left style="margin:100px" colspan=4><table><tr><td title="Entidades"><%=" Entidades"%></td><td></td><td></td><td title="Entidades y tablas seleccionadas">Entidades y Tablas seleccionadas</td><td></td><td></td><td></td><td></td><td title="Atributos y Columnas">Atributos - Columnas</td><td></td><td></td><td></td><td title="Seleccion">Atributos y Columnas seleccionadas</td></tr><tr><td><table><tr><td><select multiple style="height:235px;width:200px"
							name="selEntidades" onClick="deseleccionar('selTables')"
							id="selEntidades" p_maxlength="true" maxlength="255" cols=20
							rows=4 accesskey=""><%
								Collection colEntities = dBean.getEntities(request);
								if (colEntities != null) {
									Iterator it = colEntities.iterator();
									int i = 0;
									BusEntityVo aVO = null;
									while (it.hasNext()) {
										aVO = (BusEntityVo) it.next();
										%><option value="<%=dBean.fmtInt(aVO.getBusEntId())%>"><%=dBean.fmtHTML(aVO.getBusEntName())%></option><%
									}
								}
							%></select></td><td><button type="button" onclick="addEntity_click()"
							title="<%=LabelManager.getToolTip(labelSet,"btnAddTable")%>">&gt;&gt;</button><br><br><button type="button" onclick="delTable_click()"
							title="<%=LabelManager.getToolTip(labelSet,"btnDelTable")%>">&lt;&lt;</button></td></tr><tr><td title="Tablas">Tablas</td></tr><tr><td><select multiple style="height:235px;width:200px"
							name="selTables" id="selTables"
							onClick="deseleccionar('selEntidades')" p_maxlength="true"
							maxlength="255" cols=20 rows=4 accesskey=""><%
								Collection colTables = dBean.getBITables();
								if (colTables != null) {
									Iterator it = colTables.iterator();
									BITablesVo biTableVo = null;
									while (it.hasNext()) {
										biTableVo = (BITablesVo) it.next();
										%><option value="<%=dBean.fmtInt(biTableVo.getId())%>"><%=dBean.fmtHTML(biTableVo.getName())%></option><%
									}
								}
							%></select></td><td><button type="button" onclick="addTable_click()"
							title="<%=LabelManager.getToolTip(labelSet,"btnAddTable")%>">&gt;&gt;</button><br><br><button type="button" onclick="delTable_click()"
							title="<%=LabelManager.getToolTip(labelSet,"btnDelTable")%>">&lt;&lt;</button></td></tr></table></td><%
					Collection colFact = dBean.getSchemaInfoVo().getAllTables();
					String strTablesSelHid = "";
					
					if (colFact != null) {
						Collection colBiTables = dBean.getBITables(colFact);
						if (colBiTables != null) {
							Iterator it = colBiTables.iterator();
							while (it.hasNext()) {
								BITablesVo biTableVo = (BITablesVo) it.next();
								if ("".equals(strTablesSelHid)){
									strTablesSelHid = ";" + biTableVo.getId() + ";";
								}else{
									strTablesSelHid = strTablesSelHid + biTableVo.getId() + ";";
								}
							}
						}
					}
					
					if (dBean.getTmpMapTables()!=null && !dBean.getTmpMapTables().equals("")){
						%><td><input type=hidden name="txtTablesSelHid" value="<%=dBean.getTmpMapTables()%>"></td><%
					}else if (!"".equals(strTablesSelHid)){
						%><td><input type=hidden name="txtTablesSelHid" value="<%=strTablesSelHid%>"></td><%
					}else {
						%><td><input type=hidden name="txtTablesSelHid" value=""></td><%
					}
				%><td><input type=hidden name="txtEntitiesSelHid" value="<%=(dBean.getTmpMapEntities()!=null && !dBean.getTmpMapEntities().equals(""))?dBean.getTmpMapEntities():""%>"></td><td rowspan=3><select multiple style="height:500px;width:180px"	onClick="showColumns()" name="txtTablesSel" id="txtTablesSel" p_maxlength="true" maxlength="255" cols=20 rows=4 accesskey=""><%
						if (colFact != null) {
							Collection colBiTables = dBean.getBITables(colFact);
							if (colBiTables != null) {
								Iterator it = colBiTables.iterator();
								while (it.hasNext()) {
									BITablesVo biTableVo = (BITablesVo) it.next();
									%><option value="<%=dBean.fmtInt(biTableVo.getId())%>"><%=dBean.fmtHTML(biTableVo.getName()	+ " (TABLE)")%></option><%
								}
							}
						}
						if (dBean.getTmpMapEntities()!=null && !"true".equals(request.getParameter("generated"))){
							if (colEntities != null) {
								Iterator it = colEntities.iterator();
								int i = 0;
								BusEntityVo aVO = null;
								while (it.hasNext()) {
									aVO = (BusEntityVo) it.next();
									if (dBean.getTmpMapEntities().contains(";" + aVO.getBusEntId().intValue() + ";")){
										%><option value="<%=dBean.fmtInt(aVO.getBusEntId())%>"><%=dBean.fmtHTML(aVO.getBusEntName()) + " (ENTITY)"%></option><%
									}
								}
							}
						}
						if (dBean.getTmpMapTables()!=null && !"true".equals(request.getParameter("generated"))){
							if (colTables != null) {
								Iterator it = colTables.iterator();
								int i = 0;
								BITablesVo biTableVo = null;
								while (it.hasNext()) {
									biTableVo = (BITablesVo) it.next();
									if (dBean.getTmpMapTables().contains(";" + biTableVo.getId().intValue() + ";")){
										%><option value="<%=dBean.fmtInt(biTableVo.getId())%>"><%=dBean.fmtHTML(biTableVo.getName()) + " (TABLE)"%></option><%
									}
								}
							}
						}
					%></select></td><td></td><td></td><td></td><td></td><td rowspan=3><select multiple style="height:500px;width:200px"
					name="txtColumns" id="txtColumns" p_maxlength="true"
					maxlength="255" cols=20 rows=4 accesskey=""></td><td></td><td><button type="button" onclick="addColumn_click()"
					title="<%=LabelManager.getToolTip(labelSet,"lblAddCol")%>">&gt;&gt;</button><br><br><button type="button" onclick="delColumn_click()"
					title="<%=LabelManager.getToolTip(labelSet,"lblDelCol")%>">&lt;&lt;</button></td><td><input type=hidden name="txtColumnsSelHid" value="<%=(dBean.getTmpMapCols()!=null && !dBean.getTmpMapCols().equals(""))?dBean.getTmpMapCols():""%>"></td><td rowspan=3><select multiple style="height:500px;width:300px"
					name="txtColumnsSel" id="txtColumnsSel" p_maxlength="true"
					maxlength="255" cols=20 rows=4 accesskey=""><%
						Collection colTmpCols = dBean.getAllTmpColumns();
						if (colTmpCols != null && colTmpCols.size() > 0 && !"true".equals(request.getParameter("generated"))) {
							Iterator it = colTmpCols.iterator();
							while (it.hasNext()) {
								String str = (String) it.next();
								int indx = str.indexOf("_");
								String id = str.substring(0,indx);
								String col = str.substring(indx+1, str.length());
								%><option value="<%=id%>"><%=dBean.fmtHTML(col)%></option><%
							}
						}	
						if ("true".equals(request.getParameter("generated"))) {
							Collection colCols = dBean.getSchemaInfoVo().getAllColumns();
							if (colCols != null && colCols.size() > 0) {
								Iterator it = colCols.iterator();
								while (it.hasNext()) {
									String name = (String) it.next();
									%><option value="<%=0%>"><%=dBean.fmtHTML(name)%></option><%
								}
							}
						}
					%></select></td></tr></table></td></tr></table></div><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"lblCreMeasures")%>" tabText="<%=LabelManager.getName(labelSet,"lblCreMeasures")%>"><DIV class="subTit">Tabla de hechos</DIV><br><table class="tblFormLayout"><tr><td></td><td></td><td></td><td></td></tr><tr><td style="margin:100px" colspan=4><table><%
			String factName = null;
			String sql = null;
			if (dBean.getSchemaInfoVo().getActualCube()!=null){
				if (dBean.getSchemaInfoVo().getCube(dBean.getSchemaInfoVo().getActualCube()).getView()!=null){
					sql = dBean.getSchemaInfoVo().getCube(dBean.getSchemaInfoVo().getActualCube()).getView().getSql().getValue();
				}else{
					Collection colFactTable = dBean.getSchemaInfoVo().getFactTable();
					if (colFactTable.size() == 1){
						Iterator itFactTable = colFactTable.iterator();
						factName = (String) itFactTable.next();
					}				
				}
			}
			%><tr><td><input type="radio" name="radFactTable" onclick="changeRadFact(1);" value="" <%=((factName!=null && dBean.isUseNewFactTable() && !"true".equals(request.getParameter("generated")))||(factName==null && sql==null && !"true".equals(request.getParameter("generated"))))?"checked":""%>>Crear nueva tabla de hechos</td><td valign="top"><input name="txtNewFactTableName" size=55 <%=((factName!=null && dBean.isUseNewFactTable() && !"true".equals(request.getParameter("generated")))||(factName==null && sql==null && !"true".equals(request.getParameter("generated"))))?"p_required='true'":""%> onchange="checkFactTableName();" maxlength="30" type="text" value="<%=(factName!=null && dBean.isUseNewFactTable() && !"true".equals(request.getParameter("generated")))?factName:""%>"></td></tr><tr><td><input type="radio" name="radFactTable" onclick="changeRadFact(2);" value="" <%=((factName!=null && !dBean.isUseNewFactTable()) || ("true".equals(request.getParameter("generated"))))?"checked":""%>>Usar tabla existente</td><td><input name="txtSelFactTable" id="txtSelFactTable" type="hidden" value="<%=(factName!=null && "true".equals(request.getParameter("generated")))?factName:""%>"><select	name="selFactTable" id="selFactTable" onchange="changeSelFactTable()" <%=((factName!=null && dBean.getTmpTblIdSel()!=null) || ("true".equals(request.getParameter("generated"))))?"p_required='true'":""%><%=((factName!=null && !dBean.isUseNewFactTable()) || ("true".equals(request.getParameter("generated"))))?"":"disabled='true'"%>><%
					Collection col3 = dBean.getBITables();
					
					if (col3 != null) {
						Iterator it = col3.iterator();
						BITablesVo biTableVo = null;
						%><option value="" <%=(dBean.getTmpTblIdSel()!=null)?"":"selected"%>></option><%
						while (it.hasNext()) {
							biTableVo = (BITablesVo) it.next();
							if (factName!=null && factName.equals(biTableVo.getName())){
								%><option value="<%=dBean.fmtInt(biTableVo.getId())%>" selected><%=dBean.fmtHTML(biTableVo.getName())%></option><%
							}else if (dBean.getTmpTblIdSel()!=null && (dBean.getTmpTblIdSel().intValue() == biTableVo.getId().intValue())){
								%><option value="<%=dBean.fmtInt(biTableVo.getId())%>" selected><%=dBean.fmtHTML(biTableVo.getName())%></option><%
							}else{
								%><option value="<%=dBean.fmtInt(biTableVo.getId())%>"><%=dBean.fmtHTML(biTableVo.getName())%></option><%
							}
						}
					}
				%></select></td></tr><tr><td><input type="radio" name="radFactTable" onclick="changeRadFact(3);" value="" <%=(sql!=null && !dBean.isUseNewFactTable())?"checked":""%>>Crear vista</td><td valign="top"><textarea <%=(sql!=null && !dBean.isUseNewFactTable())?"":"disabled"%> name="txtFactTableView" p_maxlength="true" <%=(sql!=null)?"p_required='true'":""%> value="<%=(sql!=null)?sql:""%>" maxlength="255" onchange="checkFactView();" cols=80 rows=6><%=(sql!=null)?sql:""%></textarea></td></tr><tr><td><input name="radSelected" id="radSelected" type="hidden" value=<%=("true".equals(request.getParameter("generated")))?"2":"1"%>></td></tr></table><DIV class="subTit">Medidas</DIV><table><tr><td><div type="grid" id="gridMeasures" style="height:290px"><table width="390px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;"	title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:220px"	title="<%=LabelManager.getToolTip(labelSet,"lblSourceField")%>"><%=LabelManager.getName(labelSet, "lblSourceField")%></th><th style="width:120px"	title="<%=LabelManager.getToolTip(labelSet,"lblDispName")%>"><%=LabelManager.getName(labelSet, "lblDispName")%></th><th style="width:90px" title="Tipo de medida">Tipo de medida</th><th style="width:60px" title="<%=LabelManager.getToolTip(labelSet,"lblAggregator")%>"><%=LabelManager.getName(labelSet, "lblAggregator")%></th><th style="width:60px" title="<%=LabelManager.getToolTip(labelSet,"lblFormat")%>"><%=LabelManager.getName(labelSet, "lblFormat")%></th><th style="width:190px" title="Formúla">Formúla</th><th style="width:20px" title="Visible">Visible</th></tr></thead><tbody><%
							Collection colMeasures = dBean.getSchemaInfoVo().getActualCubeMeasures();
							Collection colCalMemb = dBean.getSchemaInfoVo().getActualCalMembers();
							if (colMeasures != null && colMeasures.size() > 0) {
								Iterator it = colMeasures.iterator();
								while (it.hasNext()) {
									MeasureInfoVo measInfoVo = (MeasureInfoVo) it.next();
									String column = dBean.getFullColumn(measInfoVo.getColumn());
									
									%><tr><td style="width:0px;display:none;"><input name='txtColSel' value="<%=(dBean.inTmpMeasures(measInfoVo.getName())!=null)?dBean.inTmpMeasures(measInfoVo.getName()):measInfoVo.getColumn()%>" style='display:none'></td><td><input type="selColumn" disabled="true" size=40 style="border:0px;background:transparent;" value="<%=(dBean.inTmpMeasures(measInfoVo.getName())!=null)?dBean.inTmpMeasures(measInfoVo.getName()):column%>" /></td><td><input type="text" name="dispName" <%=(dBean.inTmpMeasures(measInfoVo.getName())==null)?"disabled='true'":""%> value="<%=measInfoVo.getName()%>"></td><td><select name="selTypeMeasure" <%=(dBean.inTmpMeasures(measInfoVo.getName())==null)?"disabled='true'":""%> onchange="changeMeasureType(this)"><option selected value="0">Measure</option><option value="1">Calculated Member</option></select></td><td><select name="selAgregator" <%=(dBean.inTmpMeasures(measInfoVo.getName())==null)?"disabled='true'":""%>><option value='0' <%=measInfoVo.getAggregator().toUpperCase().equals("SUM")?"selected":""%>>SUM</option><option value='1' <%=measInfoVo.getAggregator().toUpperCase().equals("AVG")?"selected":""%>>AVG</option><option value='2' <%=measInfoVo.getAggregator().toUpperCase().equals("COUNT")?"selected":""%>>COUNT</option><option value='3' <%=measInfoVo.getAggregator().toUpperCase().equals("MIN")?"selected":""%>>MIN</option><option value='4' <%=measInfoVo.getAggregator().toUpperCase().equals("MAX")?"selected":""%>>MAX</option></select></td><td><input type="text" name="format" <%=(dBean.inTmpMeasures(measInfoVo.getName())==null)?"disabled='true'":""%> value="<%=measInfoVo.getFormatString()!=null?measInfoVo.getFormatString():""%>"></td><td><input type="text" name="formula" disabled="true" value="" size=40 style='display:none'></td><td><input type="checkbox" <%=(dBean.inTmpMeasures(measInfoVo.getName())==null)?"disabled='true'":""%> name="visible" checked="<%=measInfoVo.getVisible()%>"></td></tr><%
								}
							}
							if (colCalMemb != null && colCalMemb.size() > 0) {
								Iterator it = colCalMemb.iterator();
								while (it.hasNext()) {
									CalculatedMemberInfoVo calMembVo = (CalculatedMemberInfoVo) it.next();									
									%><tr><td style="width:0px;display:none;"><input name='txtColSel' value='' style='display:none'></td><td><input type="selColumn" disabled="true" size=40 style="border:0px;background:transparent;" value="" /></td><td><input type="text" name="dispName" <%=(dBean.inTmpMeasures(calMembVo.getName())==null)?"disabled='true'":""%> value="<%=calMembVo.getName()%>"></td><td><select name="selTypeMeasure" <%=(dBean.inTmpMeasures(calMembVo.getName())==null)?"disabled='true'":""%> onchange="changeMeasureType(this)"><option value="0">Measure</option><option selected value="1">Calculated Member</option></select></td><td><select name="selAgregator" disabled="true" style="display:none;"></select></td><td><input type="text" name="format" disabled="true" style="display:none;" value=""></td><td><input type="text" name="formula" <%=(dBean.inTmpMeasures(calMembVo.getName())==null)?"disabled='true'":""%> value="<%=calMembVo.getFormula()%>" size=40></td><td><input type="checkbox" <%=(dBean.inTmpMeasures(calMembVo.getName())==null)?"disabled='true'":""%> name="checkVisible" checked="<%=calMembVo.getVisible()%>"></td></tr><%	
								}
							}
						%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" onclick="btnAddMeasure_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet, "btnAgr")%></button><button type="button" onclick="btnDelMeasure_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>"	title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet, "btnEli")%></button></td></tr></table></table></td></tr></table></div><div type="tab" style="visibility:hidden" style="visibility:hidden;"
	tabTitle="<%=LabelManager.getToolTip(labelSet,"lblCreDimensions")%>"
	tabText="<%=LabelManager.getName(labelSet,"lblCreDimensions")%>"><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" id="treeDrop" width="580" height="430" align="middle"><param name="allowScriptAccess" value="sameDomain" /><param name="movie" value="<%=Parameters.ROOT_PATH%>/programs/biDesigner/cubes/treeDrop.swf" /><param name="quality" value="high" /><param name="wmode" value="transparent" /><param name="bgcolor" value="#ffffff" /><param name="flashVars" value="labels=<%=Parameters.ROOT_PATH%>/programs/biDesigner/cubes/labels.jsp" /><embed wmode="transparent" flashVars="labels=<%=Parameters.ROOT_PATH%>/programs/biDesigner/cubes/labels.jsp" src="<%=Parameters.ROOT_PATH%>/programs/biDesigner/cubes/treeDrop.swf" quality="high" bgcolor="#ffffff" width="580" height="430" swLiveConnect=true id="treeDrop" name="treeDrop" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" /></object><%String strXml = dBean.getCubeXML();
System.out.println("strXml:"+strXml); 
String cubeXml=XMLUtils.transform(dBean.getEnvironmentId(),strXml,"/programs/biDesigner/cubes/cubo_to_xml.xsl"); 
%><input id='treeModel' name='treeModel' type='hidden' value='<%=cubeXml%>'></div><%if ("true".equals(request.getParameter("generated"))) {%><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"lblDataLoad")%>" tabText="<%=LabelManager.getName(labelSet,"lblDataLoad")%>"><br><table class="tblFormLayout"><tr><td></td><td></td><td></td><td></td></tr><tr><td style="margin:100px" colspan=4><table><tr><td><div type="grid" id="gridLoadData" style="height:290px"><table width="390px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;"	title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblSrcType")%>"><%=LabelManager.getName(labelSet,"lblSrcType")%></th><th style="width:120px"	title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet, "lblNom")%></th><th style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblSrcType")%>"><%=LabelManager.getName(labelSet, "lblSrcType")%></th><th style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblSrcName")%>"><%=LabelManager.getName(labelSet, "lblSrcName")%></th><th style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblDstTable")%>"><%=LabelManager.getName(labelSet, "lblDstTable")%></th><th style="width:180px" title="<%=LabelManager.getToolTip(labelSet,"lblDstTblColumns")%>"><%=LabelManager.getName(labelSet, "lblDstTblColumns")%></th><th style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblSta")%>"><%=LabelManager.getName(labelSet, "lblSta")%></th><th style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblPeri")%>"><%=LabelManager.getName(labelSet, "lblPeri")%></th><th style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblUltEje")%>"><%=LabelManager.getName(labelSet,"lblUltEje")%></th><th style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblLoadType")%>"><%=LabelManager.getName(labelSet,"lblLoadType")%></th><th style="width:180px" title=""></th></tr></thead><tbody><%
							Collection colDwLoadData = dBean.getDwLoadData();
							if (colDwLoadData != null && colDwLoadData.size() > 0) {
								Iterator it = colDwLoadData.iterator();
								int i = 0;
								while (it.hasNext()) {
									DwLoadDataVo dwLoadDataVo = (DwLoadDataVo) it.next();
									%><tr><td style="width:0px;display:none;"><input name="chkSel<%=i%>" value="" type="hidden"><input name='loadDwColId<%=i%>' value="<%=dwLoadDataVo.getDwLoadDataId().intValue() %>" type="hidden"><input name='loadDwCount' value="" type="hidden"></td><td><% if (dwLoadDataVo.getType()==null){%><%}else if (dwLoadDataVo.getType().intValue()==DwLoadDataVo.TYPE_DIMENSION_STANDARD){%><%=LabelManager.getName(labelSet,"lblDimStandard")%><%}else if (dwLoadDataVo.getType().intValue()==DwLoadDataVo.TYPE_DIMENSION_USAGE){%><%=LabelManager.getName(labelSet,"lblDimUsage")%><%}else if (dwLoadDataVo.getType().intValue()==DwLoadDataVo.TYPE_DIMENSION_DEGENERATED){%><%=LabelManager.getName(labelSet,"lblDimDegenerated")%><%}else if (dwLoadDataVo.getType().intValue()==DwLoadDataVo.TYPE_DIMENSION_SHARED){%><%=LabelManager.getName(labelSet,"lblDimShared")%><%}else if (dwLoadDataVo.getType().intValue()==DwLoadDataVo.TYPE_FACTABLE){%><%=LabelManager.getName(labelSet,"lblFactTable")%><%}%></td><td><%=dwLoadDataVo.getName()%></td><td><% if (dwLoadDataVo.getSrcType()==null){%><%}else if (dwLoadDataVo.getSrcType().intValue()==DwLoadDataVo.SRC_TYPE_ENTITY){%><%=LabelManager.getName(labelSet,"lblEnt")%><%}else if (dwLoadDataVo.getSrcType().intValue()==DwLoadDataVo.SRC_TYPE_TABLE){%><%=LabelManager.getName(labelSet,"lblTable")%><%}else if (dwLoadDataVo.getSrcType().intValue()==DwLoadDataVo.SRC_TYPE_DIMENSION){%><%=LabelManager.getName(labelSet,"lblDwDimension")%><%}else if (dwLoadDataVo.getSrcType().intValue()==DwLoadDataVo.SRC_TYPE_VIEW){%><%=LabelManager.getName(labelSet,"lblVis")%><%}%></td><td><%if (dwLoadDataVo.getSrcName()!=null){%><%=dwLoadDataVo.getSrcName()%><%}else{%><%}%></td><td><%if (dwLoadDataVo.getDstTable() != null){%><%=dwLoadDataVo.getDstTable()%><%}else{%><%}%></td><td><%if (dwLoadDataVo.getDstTableColumns() != null){%><%=dwLoadDataVo.getDstTableColumns()%><%}else{%><%}%></td><td><%if (dwLoadDataVo.getCount().intValue() == 0){%><%="VACIA"%><%}else{%><%="CON " +  dwLoadDataVo.getCount().intValue() + " FILAS" %><%}%></td><td><%if (((dwLoadDataVo.getType()!=null)&&(dwLoadDataVo.getType().intValue()==DwLoadDataVo.TYPE_DIMENSION_DEGENERATED || dwLoadDataVo.getType().intValue()==DwLoadDataVo.TYPE_DIMENSION_USAGE))||((dwLoadDataVo.getSrcType()!=null) && (dwLoadDataVo.getSrcType().intValue()==DwLoadDataVo.SRC_TYPE_VIEW))){%><%}else{ %><select name="loadDwPeriodicity" id="loadDwPeriodicity" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPeri")%>" ><%
													Collection cPer = SchedulerBean.getPeriodicity(request,labelSet);
													if(cPer!=null){
														Iterator itPer = cPer.iterator();
														while(itPer.hasNext()){
															CmbDataVo cmb = (CmbDataVo)itPer.next();
															%><option value="<%=dBean.fmtHTML(cmb.getValue())%>" <%if(dwLoadDataVo!=null && dwLoadDataVo.getPeriodicity()!=null && dwLoadDataVo.getPeriodicity().equals(cmb.getValue())){out.print(" selected ");}%> ><%=dBean.fmtHTML(cmb.getText())%></option><%
														}
													}
												%></select><%}%></td><td><%=(dwLoadDataVo!=null && dwLoadDataVo.getLastUpdate()!=null)?dwLoadDataVo.getLastUpdate():""%></td><td><%if (((dwLoadDataVo.getType()!=null)&&(dwLoadDataVo.getType().intValue()==DwLoadDataVo.TYPE_DIMENSION_DEGENERATED || dwLoadDataVo.getType().intValue()==DwLoadDataVo.TYPE_DIMENSION_USAGE))||((dwLoadDataVo.getSrcType()!=null) && (dwLoadDataVo.getSrcType().intValue()==DwLoadDataVo.SRC_TYPE_VIEW))){%><%}else{ %><select name="loadDwloadType" id="loadDwloadType" onchange="changeLoadType(this)" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblLoadType")%>" ><option value="0" <%if(dwLoadDataVo!=null && dwLoadDataVo.getBusClass()==null && dwLoadDataVo.getSql() == null){out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblAutomatic")%></option><option value="1" <%if(dwLoadDataVo!=null && dwLoadDataVo.getBusClass()!=null){out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblCla")%></option><option value="2" <%if(dwLoadDataVo!=null && dwLoadDataVo.getSql() != null){out.print(" selected ");}%> ><%=LabelManager.getName(labelSet,"lblSql")%></option></select><%}%></td><td><%if (dwLoadDataVo!=null && dwLoadDataVo.getBusClass()!=null){%><input type="input" size=40 name="dwLoadUse" id="dwLoadUse" value="<%=dwLoadDataVo.getBusClass()%>"><%}else if (dwLoadDataVo!=null && dwLoadDataVo.getSql()!=null){%><input type="input" size=40 name="dwLoadUse" id="dwLoadUse" value="<%=dwLoadDataVo.getSql()%>"><%} %></td></tr><%i++;%><%}
							}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" onclick="btnTest_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDwLoadTest")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDwLoadTest")%>"><%=LabelManager.getNameWAccess(labelSet, "btnDwLoadTest")%></button><button type="button" onclick="btnExecuteNow_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnExecNow")%>"	title="<%=LabelManager.getToolTip(labelSet,"btnExecNow")%>"><%=LabelManager.getNameWAccess(labelSet, "btnExecNow")%></button></td></tr></table></table></td></tr></table></div><%}%></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" <%=("false".equals(request.getParameter("generated")))?"disabled=\"true\"":""%> onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet, "btnCon")%></button><%if("true".equals(request.getParameter("generated"))){%><button type="button" onclick="actionAfter='generate';getXml()"accesskey="<%=LabelManager.getAccessKey(labelSet,"btnReGen")%>" title="<%=LabelManager.getToolTip(labelSet,"btnReGen")%>"><%=LabelManager.getNameWAccess(labelSet, "btnReGen")%></button><%}else{%><button type="button" onclick="actionAfter='generate';getXml()"accesskey="<%=LabelManager.getAccessKey(labelSet,"btnGen")%>" title="<%=LabelManager.getToolTip(labelSet,"btnGen")%>"><%=LabelManager.getNameWAccess(labelSet, "btnGen")%></button><%}%><button type="button" onclick="btnBack_click()"	accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet, "btnVol")%></button><button type="button" onclick="btnExit_click()"	accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet, "btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp"%><script language="javascript" defer="true" src='<%=Parameters.ROOT_PATH%>/programs/biDesigner/cubes/update.js'></script><script type="text/javascript">
var dimShared = "<%=dBean.getSharedDimensions()%>";
</script>
