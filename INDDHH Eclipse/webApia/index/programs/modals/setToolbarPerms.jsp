<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body onload="toolbarOptionsLoad()"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titPermAcc")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtToolbar")%></DIV><table class="tblFormLayout"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNavOlap")%>"><input type=checkbox name="chkNavOlap" id="chkNavOlap"><%=LabelManager.getName(labelSet,"lblNavOlap")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblBIMdxQryEditor")%>"><input type=checkbox name="chkMDX" id="chkMDX"><%=LabelManager.getName(labelSet,"lblBIMdxQryEditor")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblConfTabOlap")%>"><input type=checkbox name="chkCnfOlapTable" id="chkCnfOlapTable"><%=LabelManager.getName(labelSet,"lblConfTabOlap")%></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblShowParents")%>"><input type=checkbox name="chkShowParents" id="chkShowParents"><%=LabelManager.getName(labelSet,"lblShowParents")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblHidRepeat")%>"><input type=checkbox name="chkHidRepeat" id="chkHidRepeat"><%=LabelManager.getName(labelSet,"lblHidRepeat")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblSupEmpRows")%>"><input type=checkbox name="chkSupEmpRows" id="chkSupEmpRows"><%=LabelManager.getName(labelSet,"lblSupEmpRows")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblExcAxes")%>"><input type=checkbox name="chkExcAxes" id="chkExcAxes"><%=LabelManager.getName(labelSet,"lblExcAxes")%></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMemDetail")%>"><input type=checkbox name="chkMemDatail" id="chkMemDatail"><%=LabelManager.getName(labelSet,"lblMemDetail")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblOpeDetail")%>"><input type=checkbox name="chkOpeDetail" id="chkOpeDetail"><%=LabelManager.getName(labelSet,"lblOpeDetail")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblEntDetail")%>"><input type=checkbox name="chkEntDetail" id="chkEntDetail"><%=LabelManager.getName(labelSet,"lblEntDetail")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblShowOriData")%>"><input type=checkbox name="chkShowOriData" id="chkShowOriData"><%=LabelManager.getName(labelSet,"lblShowOriData")%></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblShowChart")%>"><input type=checkbox name="chkShowChart" id="chkShowChart"><%=LabelManager.getName(labelSet,"lblShowChart")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblConfChart")%>"><input type=checkbox name="chkConfChart" id="chkConfChart"><%=LabelManager.getName(labelSet,"lblConfChart")%></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblConfPrint")%>"><input type=checkbox name="chkConfPrint" id="chkConfPrint"><%=LabelManager.getName(labelSet,"lblConfPrint")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblPDFExport")%>"><input type=checkbox name="chkPdfExport" id="chkPdfExport"><%=LabelManager.getName(labelSet,"lblPDFExport")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblExcExport")%>"><input type=checkbox name="chkExcExport" id="chkExcExport"><%=LabelManager.getName(labelSet,"lblExcExport")%></td><td></td></tr></table><iframe name="toolbarSubmit" style="height:1px;width:1px;visibility:hidden;"></iframe></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="center" style="width:100%"></td><TD align="rigth"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
var viewId = <%=request.getParameter("viewId")%>;
var userId = "<%=request.getParameter("userId")%>";

function toolbarOptionsLoad(){
	var sXMLSourceUrl = "<%=Parameters.ROOT_PATH%>/programs/modals/viewButtonsXML.jsp?vwId=" + viewId;
	var listener=new Object();
	listener.onLoad=function(xml){
		if (isXMLOk(xml)) {
			readVwButtonsXML(xml);
		}
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}

function readVwButtonsXML(sXmlResult){
	var xmlRoot=getXMLRoot(sXmlResult);
	if (xmlRoot.nodeName != "EXCEPTION") {
		if (xmlRoot.childNodes.length == 0){ //Si es 0, es porque aún nunca se configuro, si ya se configuro tiene almenos el botón ver propieades en false (ya que no se muestra)
			document.getElementById("chkConfChart").checked = true;	
			document.getElementById("chkConfPrint").checked = true;
			document.getElementById("chkPdfExport").checked = true;
			document.getElementById("chkExcExport").checked = true;
		}else {
			for(i=0;i<xmlRoot.childNodes.length;i++){
				var btnName = xmlRoot.childNodes[i].firstChild.nodeName;
				var btnVisible = xmlRoot.childNodes[i].firstChild.firstChild.nodeValue;
				if (btnName == "NAV_OLAP" && btnVisible == "true"){
					document.getElementById("chkNavOlap").checked = true;
				}
				if (btnName == "MDX_EDITOR" && btnVisible == "true"){
					document.getElementById("chkMDX").checked = true;
				}
				if (btnName == "CNF_OLAP_TBL" && btnVisible == "true"){
					document.getElementById("chkCnfOlapTable").checked = true;
				}
				if (btnName == "PRNT_MEMBERS" && btnVisible == "true"){
					document.getElementById("chkShowParents").checked = true;
				}
				if (btnName == "HIDE_SPANS" && btnVisible == "true"){
					document.getElementById("chkHidRepeat").checked = true;
				}
				if (btnName == "SUP_EMP_ROWS" && btnVisible == "true"){
					document.getElementById("chkSupEmpRows").checked = true;
				}
				if (btnName == "SWAP_AXES" && btnVisible == "true"){
					document.getElementById("chkExcAxes").checked = true;
				}
				if (btnName == "DRILL_MEMBER" && btnVisible == "true"){
					document.getElementById("chkMemDatail").checked = true;
				}
				if (btnName == "DRILL_POSITION" && btnVisible == "true"){
					document.getElementById("chkOpeDetail").checked = true;
				}
				if (btnName == "DRILL_REPLACE" && btnVisible == "true"){
					document.getElementById("chkEntDetail").checked = true;
				}
				if (btnName == "DRILL_THROUGH" && btnVisible == "true"){
					document.getElementById("chkShowOriData").checked = true;
				}
				if (btnName == "SHOW_CHART" && btnVisible == "true"){
					document.getElementById("chkShowChart").checked = true;
				}
				if (btnName == "CHART_CONFIG" && btnVisible == "true"){
					document.getElementById("chkConfChart").checked = true;
				}
				if (btnName == "PRINT_CONFIG" && btnVisible == "true"){
					document.getElementById("chkConfPrint").checked = true;
				}
				if (btnName == "PRINT_PDF" && btnVisible == "true"){
					document.getElementById("chkPdfExport").checked = true;
				}
				if (btnName == "PRINT_EXCEL" && btnVisible == "true"){
					document.getElementById("chkExcExport").checked = true;
				}
			}
		}
	}else{
		alert("error occurred");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}	

function getSelected(){
	//var result = new Array();
	var btnIds="";
	
	if (document.getElementById("chkNavOlap").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_OLAP_NAVIGATOR%>;
		btnIds += <%=VwPropertiesVo.BTN_OLAP_NAVIGATOR%> + ";";
	}	
	if (document.getElementById("chkMDX").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_SHOW_MDX_EDITOR%>;
		btnIds += <%=VwPropertiesVo.BTN_SHOW_MDX_EDITOR%> + ";";
	}
	if (document.getElementById("chkCnfOlapTable").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_CONFIG_OLAP_TABLE%>;
		btnIds += <%=VwPropertiesVo.BTN_CONFIG_OLAP_TABLE%> + ";";
	}
	if (document.getElementById("chkShowParents").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_SHOW_PARENT_MEMBERS%>;
		btnIds += <%=VwPropertiesVo.BTN_SHOW_PARENT_MEMBERS%> + ";";
	}
	if (document.getElementById("chkHidRepeat").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_HIDE_SPANS%>;
		btnIds += <%=VwPropertiesVo.BTN_HIDE_SPANS%> + ";";
	}
	if (document.getElementById("chkSupEmpRows").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_SUPRESS_EMPTY_ROWS%>;
		btnIds += <%=VwPropertiesVo.BTN_SUPRESS_EMPTY_ROWS%> + ";";
	}
	if (document.getElementById("chkExcAxes").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_SWAP_AXES%>;
		btnIds += <%=VwPropertiesVo.BTN_SWAP_AXES%> + ";";
	}
	if (document.getElementById("chkMemDatail").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_DRILL_MEMBER%>;
		btnIds += <%=VwPropertiesVo.BTN_DRILL_MEMBER%> + ";";
	}
	if (document.getElementById("chkOpeDetail").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_DRILL_POSITION%>;
		btnIds += <%=VwPropertiesVo.BTN_DRILL_POSITION%> + ";";
	}
	if (document.getElementById("chkEntDetail").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_DRILL_REPLACE%>;
		btnIds += <%=VwPropertiesVo.BTN_DRILL_REPLACE%> + ";";
	}
	if (document.getElementById("chkShowOriData").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_DRILL_THROUGH%>;
		btnIds += <%=VwPropertiesVo.BTN_DRILL_THROUGH%> + ";";
	}
	if (document.getElementById("chkShowChart").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_SHOW_CHART%>;
		btnIds += <%=VwPropertiesVo.BTN_SHOW_CHART%> + ";";
	}
	if (document.getElementById("chkConfChart").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_CHART_CONFIG%>;
		btnIds += <%=VwPropertiesVo.BTN_CHART_CONFIG%> + ";";
	}
	if (document.getElementById("chkConfPrint").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_PRINT_CONFIG%>;
		btnIds += <%=VwPropertiesVo.BTN_PRINT_CONFIG%> + ";";
	}
	if (document.getElementById("chkPdfExport").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_PRINT_PDF%>;
		btnIds += <%=VwPropertiesVo.BTN_PRINT_PDF%> + ";";
	}
	if (document.getElementById("chkExcExport").checked){
		//result[result.length] = <%=VwPropertiesVo.BTN_PRINT_EXCEL%>;
		btnIds += <%=VwPropertiesVo.BTN_PRINT_EXCEL%> + ";";
	}	

	//return result;
	return btnIds;
}	

function btnConf_click() {
	var btnIds = getSelected();
	var vars="&after=afterConfirm&userId="+userId+"&viewId="+viewId+"&btnIds="+btnIds;
	
	var frm=document.getElementById("frmMain");
	var action=frm.action;
	var target=frm.target;
	frm.action=URL_ROOT_PATH+"/Views?action=uploadViewButtons"+vars;
	frm.target="toolbarSubmit";
	frm.submit();
	frm.action=action;
	frm.target=target;
}	

function afterConfirm(result) {
	window.returnValue=result;
	window.close();
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>