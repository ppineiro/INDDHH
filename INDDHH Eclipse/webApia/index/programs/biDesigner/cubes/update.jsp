<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@include file="../../../components/scripts/server/startInc.jsp"%><%@page import="com.dogma.vo.biSchemaDef.MeasureInfoVo"%><%@page import="com.dogma.vo.biSchemaDef.CalculatedMemberInfoVo"%><%@page import="com.dogma.vo.biSchemaDef.TableInfoVo"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.vo.custom.CmbDataVo"%><%@page import="com.dogma.vo.biSchemaDef.CubeInfoVo"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp"%><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/biDesigner/cubes/update.js'></script><script language="JavaScript">

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
	}else if(command=="getForeigns"){
		setForeigns();
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
	}else if(command=="testSQL"){
		var tbl=args.split("|")[0];
		var sql=args.split("|")[1];
		testSqlViewFlash(sql,tbl);
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
			//getXml();
			getXmlAtTabSwitch();
		}
		if(document.getElementById("samplesTab").shownIndex==3){
			getFlashObject("treeDrop").style.width=(getStageWidth()-20)+"px"
			getFlashObject("treeDrop").style.height=(getStageHeight()-100)+"px"
// 			if(MSIE){
				setColumns();
// 			}
			loadModel();
			if(MSIE){
				//setDimensionProps();
				//setForeigns();
			}
		}else{
			flashLoaded=false;
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
	
	function setForeigns(){
		
		var foreigns=getFactColumns();
		getFlashObject("treeDrop").SetVariable("call", "setForeigns,"+foreigns);
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
		}else{
			btnConf_click();
		}
	}
	
	function getXmlAtTabSwitch(){
		if(flashLoaded){
			getFlashObject("treeDrop").SetVariable("call", "getOutputXML");
		}
	}
	
	function setDimensionProps(){
		var props=getSourceColumns();
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
		if(actionAfter=="confirm"){
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
		//document.getElementById("treeModel").value=xml;
		var aux=xml.split('"?>');
		xml="<nodes>"+aux[aux.length-1]+"</nodes>";
		document.getElementById("treeModel").value=xml;
		if(document.getElementById("samplesTab").shownIndex!=3){
			setTimeout('document.getElementById("samplesTab").showContent(document.getElementById("samplesTab").shownIndex);',100);
		}
	}
	
	
</script></head><body onload="start()"><jsp:useBean id="dBean" scope="session"
	class="com.dogma.bean.administration.CubeBean"></jsp:useBean><%
CubeVo cbeVo = dBean.getCubeVo();
String actualUser = dBean.getActualUser(request);
boolean saveChanges = (cbeVo.getCubeId()==null)?true:dBean.hasWritePermission(request, cbeVo.getCubeId(), actualUser);

%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet, "titCubes")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type="tabElement" id="samplesTab" ontabswitch="tabSwitch()" defaultTab="<%=("true".equals(request.getParameter("generated")))?4:0%>"><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDatGen")%>" tabText="<%=LabelManager.getName(labelSet,"tabDatGen")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet, "sbtDatCube")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet, "lblNom")%>:</td><%
		String cubeName = "";
		String cubeTitle = "";
		String cubeDesc = "";
		
		if (request.getParameter("cubeName")!=null){
			cubeName = request.getParameter("cubeName");
  		}else if(cbeVo!=null && cbeVo.getCubeName()!=null){
  		 	cubeName = cbeVo.getCubeName();
  		}
  		if (request.getParameter("cubeTitle")!=null){
			cubeTitle = request.getParameter("cubeTitle");
  		}else if(cbeVo!=null && cbeVo.getCubeTitle()!=null){
  		 	cubeTitle = cbeVo.getCubeTitle();
  		}
  		if (request.getParameter("cubeDesc")!=null){
			cubeDesc = request.getParameter("cubeDesc");
  		}else if(cbeVo!=null && cbeVo.getCubeDesc()!=null){
  		 	cubeDesc = cbeVo.getCubeDesc();
  		}
  		if (cubeName.startsWith("lblDw")){
			cubeName = LabelManager.getName(labelSet, cubeName);
  		}
  		if (cubeTitle.startsWith("lblDw") || cubeTitle.startsWith("mnuDw")){
			cubeTitle = LabelManager.getName(labelSet, cubeTitle);
  		}
  		if (cubeDesc.startsWith("lblDw")){
			if (cubeDesc.indexOf(")") > 0){
				cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc.substring(0, cubeDesc.indexOf("(") - 1)) + " " + cubeDesc.substring(cubeDesc.indexOf("("), cubeDesc.length());
		    }else{
				cubeDesc = LabelManager.getToolTip(labelSet, cubeDesc);
 			}
		}
  		
		%><td><input name="txtName" id="txtName" title="<%=cubeName%>" p_required="true" style="width:250px" maxlength="50" onchange="cubeName_change('<%=cubeName%>')" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" value="<%=dBean.fmtStr(cubeName)%>"></td><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblTit")%>"><%=LabelManager.getNameWAccess(labelSet, "lblTit")%>:</td><td><input name="txtTitle" id="txtTitle" title="<%=cubeTitle%>" p_required="true" style="width:250px" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTit")%>" type="text" value="<%=dBean.fmtStr(cubeTitle)%>"></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet, "lblDes")%>:</td><td colspan=3><input name="txtDesc" id="txtDesc" title="<%=cubeDesc%>" maxlength="255" size=80 accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" value="<%=dBean.fmtStr(cubeDesc)%>"></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblQryDbNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryDbNom")%>:</td><td><select name="dbConId" id="dbConId" onChange="cmbSource_change()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblQryDbNom")%>" p_required=true <%=(cbeVo!=null && cbeVo.getCubeId()!=null)?"disabled":""%>><option value="-1" <%=(cbeVo.getDbConId() == null || cbeVo.getDbConId().equals(new Integer("-1")))?"selected":""%>><%=LabelManager.getName(labelSet,"lblLocalDbNom")%></option><option value="0" <%=(cbeVo.getDbConId() == null || cbeVo.getDbConId().equals(new Integer("0")))?"selected":""%>>BIDB</option><%
  					Collection conCol = null;
  					if (cbeVo!=null && cbeVo.getDbConId()!=null){
  						conCol = dBean.getDBConnections(request,true);
  					}else{
  						conCol = dBean.getDBConnections(request,false);
  					}
  					if (conCol != null) {
   						Iterator iterator = conCol.iterator();
	   					DbConnectionVo connection;
   						while (iterator.hasNext()) {
   							connection = (DbConnectionVo) iterator.next(); %><option value="<%=dBean.fmtInt(connection.getDbConId())%>" <%=connection.getDbConId().equals(cbeVo.getDbConId())?"selected":""%>><%=dBean.fmtStr(connection.getDbConName())%></option><%
   						}
  					}%></select><input type=hidden name="dbConIdHid" value="<%=(cbeVo.getDbConId()!=null)?cbeVo.getDbConId().intValue():0%>"></td></tr><tr><td><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"></td><td></td><td></td><td></td></tr></table><br><br><br><!--     - Perfiles con acceso al cubo   --><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblPrfAccCube")%></DIV><div type="grid" id="gridProfiles" style="height:100px"><table id="tblProfiles"  width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="200px" style="min-width:200px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th></tr></thead><tbody id="tblPerBody"><%  Collection cubeProfs = dBean.getCubeProfiles();
		if (cubeProfs != null && cubeProfs.size()>0){
		Iterator itProfiles = cubeProfs.iterator();
		while (itProfiles.hasNext()) {
			ProfileVo profileVo = (ProfileVo) itProfiles.next();
			%><tr><td style="width:0px;display:none;"><input type="hidden" name="chkPrfSel"><input type=hidden name="chkPrf" value="<%=dBean.fmtInt(profileVo.getPrfId())%>"></td><td style="min-width:200px"><%if(profileVo.getPrfAllEnv().intValue() == 1){out.print("<B>");}%><%=dBean.fmtHTML(profileVo.getPrfName())%></td><%if(profileVo.getPrfAllEnv().intValue() == 1){out.print("</B>");}%></tr><%
		} 
	}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" id="btnAddCbePrf" onclick="btnAddProfile_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" id="btnDelCbePrf" onclick="btnDelProfile_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table><br><br><br><br><!--   Ejecucion del cubo  
<DIV class="subTit"><%=LabelManager.getName(labelSet,"lblExecution")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getName(labelSet,"lblLoadInMemAtStart")%>"><%=LabelManager.getNameWAccess(labelSet,"lblLoadInMemAtStart")%>:</td><td><input type="checkbox" name="chkLodInMemAtStart" title="<%=LabelManager.getToolTip(labelSet,"lblLoadInMemAtStart")%>" <%=(dBean.getSchedVo()==null || SchBusClaActivityVo.STATUS_DISABLED==dBean.getSchedVo().getSchActStatus().intValue())?"":"checked"%> title="<%=LabelManager.getToolTip(labelSet,"lblLoadInMemAtStart")%>"></input></td></tr></table>
 --></div><div type="tab" style="visibility:hidden" style="visibility:hidden;"
	tabTitle="<%=LabelManager.getToolTip(labelSet,"tabMapTables")%>"
	tabText="<%=LabelManager.getName(labelSet,"tabMapTables")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet, "sbtMapTables")%></DIV><br><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td></td><td></td><td></td><td></td></tr><tr><td align=left style="margin:100px" colspan=4><table><tr><td title="<%=LabelManager.getName(labelSet,"lblTables")%>"><%=LabelManager.getName(labelSet,"lblTables")%></td><td></td><td></td><td title="<%=LabelManager.getName(labelSet,"lblSelTables")%>"><%=LabelManager.getName(labelSet,"lblSelTables")%></td><td></td><td></td><td></td><td></td><td title="<%=LabelManager.getName(labelSet,"lblColumns")%>"><%=LabelManager.getName(labelSet,"lblColumns")%></td><td></td><td></td><td></td><td title="<%=LabelManager.getName(labelSet,"lblSelColumns")%>"><%=LabelManager.getName(labelSet,"lblSelColumns")%></td></tr><tr><td><select multiple style="height:500px;width:200px" name="selTables" id="selTables" ondblclick="addTable_click()" p_maxlength="true" maxlength="255" cols=20 rows=4 accesskey=""><%
						dBean.loadTablesCol(request,null);
						Collection cnxTables = dBean.getCnxTables();
						if (cnxTables != null && cnxTables.size() > 0) {
								Iterator it = cnxTables.iterator();
								int id = 0;
								while (it.hasNext()) {
									String table = (String) it.next();
									%><option value="<%=id%>"><%=dBean.fmtHTML(table)%></option><%
									id++;
								}
							}	
					%></select></td><td><button type="button" onclick="addTable_click()" title="<%=LabelManager.getToolTip(labelSet,"btnAddTable")%>">&gt;&gt;</button><br><br><button type="button" onclick="delTable_click()" title="<%=LabelManager.getToolTip(labelSet,"btnDelTable")%>">&lt;&lt;</button></td><%
					Collection colTables = dBean.getSchemaTables();
					String strTablesSelHid = "";
						%><td><input type=hidden name="txtTablesSelHid" value=""></td><td><select multiple style="height:500px;width:200px" onClick="showColumns()" name="txtTablesSel" id="txtTablesSel" p_maxlength="true" maxlength="255" cols=20 rows=4 accesskey=""><%
						if (colTables != null && colTables.size()>0) {
							Iterator it = colTables.iterator();
							int id = 0;
							while (it.hasNext()) {
								String tableName = (String)it.next();
								%><option value="<%=id%>"><%=dBean.fmtHTML(tableName)%></option><%
								id++;
							}
						}
					%></select></td><td></td><td></td><td></td><td></td><td><select multiple style="height:500px;width:240px" name="txtColumns" id="txtColumns" ondblclick="addColumn_click()" p_maxlength="true" maxlength="255" cols=20 rows=4 accesskey=""></select></td><td></td><td><button type="button" onclick="addColumn_click()"
						title="<%=LabelManager.getToolTip(labelSet,"btnAddCol")%>">&gt;&gt;
					</button><br><br><button type="button" onclick="delColumn_click()" 
						title="<%=LabelManager.getToolTip(labelSet,"btnDelCol")%>">&lt;&lt;
					</button></td><td><input type=hidden name="txtColumnsSelHid" value="<%=(dBean.getTmpMapCols()!=null && !dBean.getTmpMapCols().equals(""))?dBean.getTmpMapCols():""%>"></td><td><select multiple style="height:500px;width:270px" name="txtColumnsSel" id="txtColumnsSel" ondblclick="delColumn_click()" p_maxlength="true" maxlength="255" cols=20 rows=4 accesskey=""><%
						Collection colCols = dBean.getAllColumns();
						if (colCols!=null && colCols.size()>0){
						  	Iterator itCols = colCols.iterator();
						  	int i=0;
						  	while (itCols.hasNext()){
						 		String colAct = (String)itCols.next();%><option value="<%=i%>"><%=(dBean.fmtHTML(colAct))%></option><%
								i++;
							}
					  	}
					%></select></td></tr><tr><td><button onclick="cmbSource_change()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAct")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAct")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAct")%></button><button id="btn_prevTables" onclick="getPrevTables()" title="<%=LabelManager.getToolTip(labelSet,"btnNavPrev")%>" disabled><</button><button id="btn_nextTables" onclick="getNextTables()" title="<%=LabelManager.getToolTip(labelSet,"btnNavNext")%>" <%=(cnxTables.size() < dBean.getCantTables())?"":"disabled"%>>></button></td></tr></table></td></tr></table></div><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabCreMeasures")%>" tabText="<%=LabelManager.getName(labelSet,"tabCreMeasures")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtFactTable")%></DIV><br><table ><tr><td></td><td></td><td></td><td></td></tr><tr><td style="margin:100px" colspan=4><table width="100%" class="tblFormLayout"><%
			String factName = "";
			String sql = "";
			boolean useTable = false;
			boolean areTables = false;
			boolean useSql = false;
			String aliasView = "";
			String factTableColumns = dBean.getFactTableColumns();
			
			if (colTables != null && colTables.size()>0) {
				areTables = true;
			}
			
			if (dBean.getSchemaInfoVo().getActualCube()!=null){
				CubeInfoVo cbeInfVo = dBean.getSchemaInfoVo().getCube(dBean.getSchemaInfoVo().getActualCube());
				if (cbeInfVo != null && cbeInfVo.getView()!=null){
					sql = dBean.getSchemaInfoVo().getCube(dBean.getSchemaInfoVo().getActualCube()).getView().getSql().getValue();
					aliasView = dBean.getSchemaInfoVo().getCube(dBean.getSchemaInfoVo().getActualCube()).getView().getAlias();
					useSql = true;
				}else{
					Collection colFactTable = dBean.getSchemaInfoVo().getFactTable();
					if (colFactTable != null && colFactTable.size() == 1){
						Iterator itFactTable = colFactTable.iterator();
						factName = (String) itFactTable.next();
						useTable = true;
					}				
				}
			}
			%><tr><td><input type="radio" id="radFactTable1" name="radFactTable" onclick="changeRadFact(1);" value="" <%=(!useSql && areTables)?"checked":""%>><%=LabelManager.getName(labelSet,"lblUseTable")%><span><input name="txtSelFactTable" id="txtSelFactTable" type="hidden" value="<%=(useTable)?factName:""%>"><select	name="selFactTable" id="selFactTable" onchange="changeSelFactTable()" <%=(factName!=null && dBean.getTmpTblIdSel()!=null)?"p_required='true'":""%><%=(useTable)?"":"disabled='true'"%>><%
						if (areTables) {
							Iterator it = colTables.iterator();
							int id = 0;
							while (it.hasNext()) {
								String tableName = (String)it.next();
								%><option value="<%=id%>" "<%=(tableName.equals(factName))?"selected":""%>"><%=dBean.fmtHTML(tableName)%></option><%
								id++;
							}
						}
						%></select></span></td><td></td><td></td><td></td></tr><tr><td><input type="radio" id="radFactTable2" name="radFactTable" onclick="changeRadFact(2);" value="" <%=(!areTables || useSql)?"checked":""%>><%=LabelManager.getName(labelSet,"lblCreView")%></td><td></td><td></td><td></td></tr></table><table><tr style="margin-left:25px"><td title="<%=LabelManager.getToolTip(labelSet,"lblPropAliasView")%>"><%=LabelManager.getNameWAccess(labelSet, "lblPropAliasView")%>:</td><td><input  maxlength="30" <%=(!areTables || (sql!=null && sql!=""))?"":"disabled"%> name="txtViewAlias" id="txtViewAlias" <%=(!areTables || useSql)?"p_required='true'":""%> maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPropAliasView")%>" type="text" value="<%=(useSql)?aliasView:""%>" onchange="checkAliasViewName()"></td><td></td></tr><tr style="margin-left:25px"><td title="<%=LabelManager.getToolTip(labelSet,"lblSql")%>"><%=LabelManager.getNameWAccess(labelSet, "lblSql")%>:</td><td><textarea <%=(sql!=null)?"":"disabled"%> name="txtFactTableView" p_maxlength="true" <%=(!areTables || useSql)?"p_required=\"true\"":""%> value="<%=(useSql)?dBean.fmtHTML(sql):""%>" onchange="checkFactView()" cols=120 rows=6><%=(useSql)?sql:""%></textarea><input type="hidden" id="viewSQLColumns" value="<%=factTableColumns%>"></input></td><td><button id="btnTestSql" onclick="btnTestSqlView()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnTestSql")%>" title="<%=LabelManager.getToolTip(labelSet,"btnTestSql")%>"><%=LabelManager.getNameWAccess(labelSet,"btnTestSql")%></button><button id="btnChangeSql" onclick="btnChangeSqlView()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMod")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMod")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMod")%></button><iframe name="testSql" style="height:1px;width:1px;visibility:hidden;"></iframe><input name="hidFactTableView" id="hidFactTableView" type="hidden" value="<%=(useSql)?dBean.fmtHTML(sql):""%>"></td></tr><tr><td><input name="radSelected" id="radSelected" type="hidden" value=<%=(useTable)?"1":"2"%>></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtMeasures")%></DIV><table><tr><td><div type="grid" id="gridMeasures" style="height:290px"><table width="390px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;"	title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="220px" style="width:220px" title="<%=LabelManager.getToolTip(labelSet,"lblSourceField")%>"><%=LabelManager.getName(labelSet, "lblSourceField")%></th><th min_width="120px" style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblMeasName")%>"><%=LabelManager.getName(labelSet, "lblMeasName")%></th><th min_width="120px" style="width:120px" title="<%=LabelManager.getToolTip(labelSet,"lblMeasDispName")%>"><%=LabelManager.getName(labelSet, "lblMeasDispName")%></th><th min_width="90px" style="width:90px" title="Tipo de medida"><%=LabelManager.getName(labelSet, "titMeasType")%></th><th min_width="60px"style="width:60px" title="<%=LabelManager.getToolTip(labelSet,"lblAggregator")%>"><%=LabelManager.getName(labelSet, "lblAggregator")%></th><th min_width="60px"style="width:60px" title="<%=LabelManager.getToolTip(labelSet,"lblFormat")%>"><%=LabelManager.getName(labelSet, "lblFormat")%></th><th min_width="190px"style="width:190px" title="Formúla"><%=LabelManager.getName(labelSet, "titFormula")%></th><th min_width="20px"style="width:20px" title="Visible"><%=LabelManager.getName(labelSet, "titVisible")%></th></tr></thead><tbody><%
							Collection colMeasures = dBean.getSchemaInfoVo().getActualCubeMeasures();
							Collection colCalMemb = dBean.getSchemaInfoVo().getActualCalMembers();
							int row = 0;
							if (colMeasures != null && colMeasures.size() > 0) {
								Iterator it = colMeasures.iterator();
								while (it.hasNext()) {
									MeasureInfoVo measInfoVo = (MeasureInfoVo) it.next();
									String column = dBean.getFullColumn(request, useSql, measInfoVo.getColumn());
									%><tr><td style="width:0px;display:none;"><input name='txtColSel' value="<%=(dBean.inTmpMeasures(measInfoVo.getName())!=null)?dBean.inTmpMeasures(measInfoVo.getName()):measInfoVo.getColumn()%>" style='display:none'></td><td><select name="selColumn" onchange="changeHidden(this)"><% 	String cols = factTableColumns;
											String optNom="";
											int optId = 0;
											while (cols.indexOf(",")>-1){
												optNom = "";
												if (useTable){
													optNom = factName + "." + cols.substring(0,cols.indexOf(","));
												}else{
													optNom = aliasView + "." + cols.substring(0,cols.indexOf(","));
												}%><option value="<%=optId%>" <%=column.equals(optNom)?"selected":""%>><%=optNom%></option><%
												optId++;
												cols = cols.substring(cols.indexOf(",")+1,cols.length());
											}
											if (useTable){
												optNom = factName + "." + cols;
											}else{
												optNom = aliasView + "." + cols;
											}%><option value="<%=optId%>" <%=column.equals(optNom)?"selected":""%>><%=optNom%></option></select><input name="hidColumn" type="hidden" size=40 value="<%=(dBean.inTmpMeasures(measInfoVo.getName())!=null)?dBean.inTmpMeasures(measInfoVo.getName()):column%>" /></td><td><input type="text" name="name" onchange="chkMeasName(this,'<%=measInfoVo.getName()%>')" value="<%=measInfoVo.getName()%>"></td><td><input type="text" name="capName" onchange="chkMeasCaption(this)" value="<%=measInfoVo.getCaption()%>"></td><td><select name="selTypeMeasure" onchange="changeMeasureType(this)"><option selected value="0"><%=LabelManager.getName(labelSet, "lblMeasStandard")%></option><option value="1"><%=LabelManager.getName(labelSet, "lblMeasCalculated")%></option></select></td><td><select name="selAgregator"><%  if (measInfoVo.getDataType()==null || "Numeric".equals(measInfoVo.getDataType()) || "Integer".equals(measInfoVo.getDataType())){%><option value='0' <%=measInfoVo.getAggregator().toUpperCase().equals("SUM")?"selected":""%>>SUM</option><option value='1' <%=measInfoVo.getAggregator().toUpperCase().equals("AVG")?"selected":""%>>AVG</option><option value='2' <%=measInfoVo.getAggregator().toUpperCase().equals("COUNT")?"selected":""%>>COUNT</option><option value='3' <%=measInfoVo.getAggregator().toUpperCase().equals("MIN")?"selected":""%>>MIN</option><option value='4' <%=measInfoVo.getAggregator().toUpperCase().equals("MAX")?"selected":""%>>MAX</option><option value='5' <%=measInfoVo.getAggregator().toUpperCase().equals("DISTINCT COUNT")?"selected":""%>>DIST.COUNT</option><%
										}else{%><option value='2' <%=measInfoVo.getAggregator().toUpperCase().equals("COUNT")?"selected":""%>>COUNT</option><option value='5' <%=measInfoVo.getAggregator().toUpperCase().equals("DISTINCT COUNT")?"selected":""%>>DIST.COUNT</option><%
										}%></select></td><td><input type="text" name="format" value="<%=measInfoVo.getFormatString()!=null?measInfoVo.getFormatString():""%>"></td><td><input type="text" name="formula" value="" size=40 style='display:none'></td><td><input type="checkbox" name="visible" <%=("true".equals(measInfoVo.getVisible()))?"checked":""%> value="<%=row%>"></td></tr><%
									row ++;
								}
							}
							if (colCalMemb != null && colCalMemb.size() > 0) {
								Iterator it = colCalMemb.iterator();
								while (it.hasNext()) {
									CalculatedMemberInfoVo calMembVo = (CalculatedMemberInfoVo) it.next();
									String formula = calMembVo.getFormula().replace("[Measures].[","");
									formula = formula.replace("]","");
									%><tr><td style="width:0px;display:none;"><input name='txtColSel' value='' style='display:none'></td><td><input type="text" name="selColumn" disabled="true" size=40 style="border:0px;background:transparent;" value="" /><input name="hidColumn" type="hidden" size=40 value="" /></td><td><input type="text" name="name" value="<%=calMembVo.getName()%>"></td><td><input type="text" name="capName" style="display:none;" value=""></td><td><select name="selTypeMeasure" onchange="changeMeasureType(this)"><option value="0"><%=LabelManager.getName(labelSet, "lblMeasStandard")%></option><option selected value="1"><%=LabelManager.getName(labelSet, "lblMeasCalculated")%></option></select></td><td><select name="selAgregator" disabled="true" style="display:none;"></select></td><td><input type="text" name="format" style="display:none;" value=""></td><td><input type="text" name="formula" value="<%=formula%>" size=40 title="[Measure1] [+,-,*,/] [Measure2 or Number] Ej: TotalCompras - TotalGastos"></td><td><input type="checkbox" name="visible" <%=("true".equals(calMembVo.getVisible()))?"checked":""%> value="<%=row%>"></td></tr><%	
									row ++;
								}
							}
						%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" name="btnAddMeasure" id="btnAddMeasure" onclick="btnAddMeasure_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet, "btnAgr")%></button><button type="button" name="btnDelMeasure" id="btnDelMeasure" onclick="btnDelMeasure_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>"	title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet, "btnEli")%></button></td></tr></table></table></td></tr></table></div><div type="tab" style="visibility:hidden;"
	tabTitle="<%=LabelManager.getToolTip(labelSet,"tabCreDimensions")%>"
	tabText="<%=LabelManager.getName(labelSet,"tabCreDimensions")%>"><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" id="treeDrop" width="580" height="430" align="middle"><param name="allowScriptAccess" value="sameDomain" /><param name="movie" value="<%=Parameters.ROOT_PATH%>/programs/biDesigner/cubes/treeDrop.swf" /><param name="quality" value="high" /><param name="wmode" value="opaque" /><param name="bgcolor" value="#ffffff" /><param name="flashVars" value="labels=<%=Parameters.ROOT_PATH%>/programs/biDesigner/cubes/labels.jsp" /><embed wmode="opaque" flashVars="labels=<%=Parameters.ROOT_PATH%>/programs/biDesigner/cubes/labels.jsp" src="<%=Parameters.ROOT_PATH%>/programs/biDesigner/cubes/treeDrop.swf" quality="high" bgcolor="#ffffff" width="1500" height="1000" swLiveConnect=true id="treeDrop" name="treeDrop" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" /></object><%
String strXml = null;
strXml = dBean.getCubeXML();
String cubeXml = null;
cubeXml=XMLUtils.transform(dBean.getEnvironmentId(),strXml,"/programs/biDesigner/cubes/cubo_to_xml.xsl");
%><input id='treeModel' name='treeModel' type='hidden' value='<%=cubeXml%>'><iframe name="treeModSubmit" id="gridSubmit" style="display:none"></iframe></div><!--      PERMISOS          --><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabCbePer")%>" tabText="<%=LabelManager.getName(labelSet,"tabCbePer")%>"><%@ include file="permissions.jsp" %></div></form></div></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="actionAfter='confirm';getXml()" <%=(!saveChanges)?"disabled":"" %> accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet, "btnCon")%></button><button type="button" onclick="btnBack_click()"	accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet, "btnVol")%></button><button type="button" onclick="btnExit_click()"	accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet, "btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp"%><script type="text/javascript">
var envId = "<%=dBean.getEnvId(request)%>";

MSG_MUST_ENT_ONE_PRF = "<%=LabelManager.getName(labelSet,"msgMustEntOneProfile")%>";
MSG_MUST_SEL_ONE_TBL = "<%=LabelManager.getName(labelSet,"msgMustSelOneTable")%>";
MSG_MUST_SEL_ONE_COL = "<%=LabelManager.getName(labelSet,"msgMustSelOneColumn")%>";
MSG_MUST_ENT_ONE_MEAS = "<%=LabelManager.getName(labelSet,"msgMustEntOneMeasure")%>";
MSG_MUST_ENT_ONE_VIEW_FIRST = "<%=LabelManager.getName(labelSet,"msgMustEntOneVwFirst")%>";
MSG_MUST_SEL_ONE_TBL_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelOneTblFirst")%>";
MSG_MUST_SEL_ONE_COL_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelOneColFirst")%>";
MSG_MUST_SEL_ONE_PKEY_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelOnePkeyFirst")%>";
MSG_MUST_SEL_ONE_FKEY_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelOneFkeyFirst")%>";
MSG_SEL_COL_IS_IN_USE_BY_MSR = "<%=LabelManager.getName(labelSet,"msgSelColIsInUseByMeasure")%>";
MSG_MUST_SEL_MEAS_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelMeasFirst")%>";
MSG_MUST_SEL_DIM_FIRST = "<%=LabelManager.getName(labelSet,"msgMustSelDimFirst")%>";
LBL_MEAS_STANDARD = "<%=LabelManager.getName(labelSet,"lblMeasStandard")%>";
MSG_MUST_ENT_TWO_DIMS = "<%=LabelManager.getName(labelSet,"msgMustEntTwoDimensions")%>";
MSG_MUST_ENT_ONE_DIM = "<%=LabelManager.getName(labelSet,"msgMustEntOneDimension")%>";
MSG_ATLEAST_ONE_MEAS_VISIBLE = "<%=LabelManager.getName(labelSet,"msgAtLeastOneMeasVisible")%>";
MSG_MIS_MEA_ATT = "<%=LabelManager.getName(labelSet,"msgMisMeaAttribute")%>";
MSG_MEAS_OP1_NAME_INVALID = "<%=LabelManager.getName(labelSet,"msgMeasOp1NameInvalid")%>";
MSG_MEAS_OP2_NAME_INVALID = "<%=LabelManager.getName(labelSet,"msgMeasOp2NameInvalid")%>";
MSG_OP_INVALID = "<%=LabelManager.getName(labelSet,"msgOpInvalid")%>";
MSG_DIM_INVALID_NAME = "<%=LabelManager.getName(labelSet,"msgBIInvDimName")%>";
MSG_HIER_INVALID_NAME = "<%=LabelManager.getName(labelSet,"msgBIInvHierName")%>";
MSG_LVL_INVALID_NAME = "<%=LabelManager.getName(labelSet,"msgBIInvLvlName")%>";
LBL_MEAS_CALCULATED = "<%=LabelManager.getName(labelSet,"lblMeasCalculated")%>";
MSG_ALR_EXI_MEAS = "<%=LabelManager.getName(labelSet,"msgAlrExiMeas") %>";
MSG_CANT_UPDATE = "<%=LabelManager.getName(labelSet,"msgCntUpdCube") %>";
MSG_VWS_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgViewsWillBeLost") %>";
MSG_VW_REF_ONL_ONE_TABLE = "<%=LabelManager.getName(labelSet,"msgVwRefOnlOneTable") %>"; 
MSG_TBL_REF_BY_VW = "<%=LabelManager.getName(labelSet,"msgTblRefByVwMstBe") %>";
MSG_WRG_MEA_NAME = "<%=LabelManager.getName(labelSet,"msgWrgMeaName")%>";
MSG_MUST_ENTER_FORMULA = "<%=LabelManager.getName(labelSet,"msgMustEntFormula")%>";
MSG_MEAS_CANT_AUTOREF = "<%=LabelManager.getName(labelSet,"msgMeasCantAutoref")%>";
MSG_MUST_ENTER_ONE_LVL_BY_DIM = "<%=LabelManager.getName(labelSet,"msgMustEntOneLvlByDim")%>";
MSG_CANT_BE_TWO_DIMS_WITH_SAME_NAME = "<%=LabelManager.getName(labelSet,"msgCantBeTwoDimWitSamName")%>";
MSG_MUST_ENT_ONE_VIEW_FIRST_FOR_HIER = "<%=LabelManager.getName(labelSet,"msgMustEntOneVwFirForHierarchy")%>";
MSG_SEL_PK_FOR_JIER = "<%=LabelManager.getName(labelSet,"msgSelPkeyForHier")%>";
MSG_ERROR_IN_VW_DIM = "<%=LabelManager.getName(labelSet,"msgErrInVwDim")%>";
MSG_CUBE_NAME_ALREADY_EXIST = "<%=LabelManager.getName(labelSet,"msgCubExi")%>";
MSG_SEL_TBL_FOR_JIER = "<%=LabelManager.getName(labelSet,"msgSelTblForHier")%>";
MSG_MEAS_AND_DIM_WILL_BE_DELETED = "<%=LabelManager.getName(labelSet,"msgMeasAndDimsWillBeDeleted")%>";
CANT_TABLES_BY_PAGE = "<%=dBean.getCantTabByPage()%>";
MSG_WRONG_NAME = "<%=LabelManager.getName(labelSet,"msgNomInv")%>";
MSG_MUST_ENT_VW_ALIAS_FIRST = "<%=LabelManager.getName(labelSet, "msgMustEntVwAliasFirst")%>";
MSG_ERROR_RETRIEVING_SQL_METADATA = "<%=LabelManager.getName(labelSet, "msgErrRetSqlMetadta").replace("\"","'")%>";
MSG_ERROR_FACT_TABLE_VIEW = "<%=LabelManager.getName(labelSet, "msgErrFacTabView").replace("\"","'")%>";
MSG_ERROR_IN_SQL_VIEW_WITH_COMS = "<%=LabelManager.getName(labelSet, "msgErrSqlVwWithComs")%>";
MSG_ERROR_IN_SQL_VIEW_WITH_MINOR_CHAR = "<%=LabelManager.getName(labelSet, "msgInvVWChar").replace("<TOK1>", "<")%>";
MSG_ERROR_IN_SQL_VIEW_WITH_ORDER_BY = "<%=LabelManager.getName(labelSet, "msgInvVWClause")%>";
MSG_MEAS_INV_NAME = "<%=LabelManager.getName(labelSet, "msgMeasNomInv")%>";
MSG_MEAS_INV_CAP = "<%=LabelManager.getName(labelSet,"msgMeasCapInv")%>";
MSG_ALR_EXI_MEAS_CAP = "<%=LabelManager.getName(labelSet,"msgAlrExiMeasCap") %>";
MSG_WRG_MEA_CAP = "<%=LabelManager.getName(labelSet,"msgWrgMeaCap")%>";
MSG_MEAS_NAME_CHG_ALERT = "<%=LabelManager.getName(labelSet, "msgMsrNameChgAlert")%>";
MSG_CUBE_NAME_CHG_ALERT = "<%=LabelManager.getName(labelSet, "msgCbeNameChgAlert")%>";
LBL_SEL_DIM_TO_DENIE_ACCESS = "<%=LabelManager.getName(labelSet, "lblCliSelDimension")%>";
CANT_TABLES = "<%=dBean.getCantTables()%>";
MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";
MSG_PRF_NO_ACC_DELETED = "<%=LabelManager.getName(labelSet,"msgPrfNoAccDeleted")%>";
MSG_PRFS_NO_ACC_DELETED = "<%=LabelManager.getName(labelSet,"msgPrfsNoAccDeleted")%>";
MSG_CBE_NAME_MISS = "<%=LabelManager.getName(labelSet,"msgCbeNameMiss")%>";
ACTUAL_PAGE = "1";
<%if (cbeVo != null && cbeVo.getCubeId()!=null){%>
CANT_VIEWS = "<%=dBean.getCubeViewsList(cbeVo.getCubeId()).size()%>";
<%}else{%>
CANT_VIEWS = 0;
<%}%>
SQL = "<%=sql%>";
</script>
