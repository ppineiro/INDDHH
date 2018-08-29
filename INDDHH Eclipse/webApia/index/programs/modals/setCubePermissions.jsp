<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %><% String dimensions = request.getParameter("dimensions"); %></head><body onload=""><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titPermAcc")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtPerAccCbe")%></DIV><div style="overflow:auto;height:260px"><table class="tblFormLayout" id="tblDimensions"><tr><td><input name="prfName" id="prfName" type="hidden" value=""><input name="hidDims" id="hidDims" type="hidden" value=""><input name="cbeName" id="cbeName" type="hidden" value=""><input name="hidFrom" id="hidFrom" type="hidden" value=""></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDwDimensions")%>"><%=LabelManager.getName(labelSet,"lblDwDimensions")%></td><td title="<%=LabelManager.getToolTip(labelSet,"lblVisible")%>"><%=LabelManager.getName(labelSet,"lblVisible")%></td></tr></table></div></form><iframe name="tableSubmit" id="tableSubmit" style="display:none"></iframe></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="center" style="width:100%"></td><TD align="rigth"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	var allChecked = false; //<-- debe ser true si se va a verificar que no se confirme con todos clickeados
	var dims = document.getElementById("hidDims").value;
	if (dims!=null && "" != dims){
		while (dims.indexOf(";")>0){
			var dimName = dims.substring(0,dims.indexOf(";"));
			dims = dims.substring(dims.indexOf(";")+1, dims.length);//Salteamos el nombre
			dims = dims.substring(dims.indexOf(";")+1, dims.length);//Salteamos la visibilidad anterior
				
			if (!document.getElementById("chk_"+dimName).checked){
				allChecked = false;
				break;
			}
		}
	}
	var continuar = true;
	//if (allChecked){
	//	if (!confirm("<%=LabelManager.getName(labelSet,"msgAllDimVis")%>")) {
	//		continuar = false;
	//	}
	//}
	
	if (continuar){
		var from = document.getElementById("hidFrom").value;
		var frm=document.getElementById("frmMain");
		var action=frm.action;
		var target=frm.target;
		if (from == "userCube"){
			frm.action="biDesigner.CubeAction.do?action=saveDimsRestrictions"+windowId+"&removeRow="+allChecked+"&after=afterConfirm";
		}else if (from == "entityCube"){
			frm.action="administration.EntitiesAction.do?action=saveDimsRestrictions"+windowId+"&removeRow="+allChecked+"&after=afterConfirm";
		}else if (from == "processCube"){
			frm.action="administration.ProcessAction.do?action=saveDimsRestrictions"+windowId+"&removeRow="+allChecked+"&after=afterConfirm";	
		}else { //bpmnAction
			frm.action="administration.BPMNAction.do?action=saveDimsRestrictions"+windowId+"&removeRow="+allChecked+"&after=afterConfirm";	
		}
		frm.target="tableSubmit";
		frm.submit();
		frm.action=action;
		frm.target=target;
	}
}	

function afterConfirm(par){
	if ("OK"==par || "removeRow"==par){
		window.returnValue=par;
		window.close();
	}else{
		alert(par);
	}
}
/*
function dimensionsLoad(){
	var sXMLSourceUrl = "<%=Parameters.ROOT_PATH%>/programs/modals/dimensionsXML.jsp?cubeId=<%=request.getParameter("cubeId")%>";
	var listener=new Object();
	listener.onLoad=function(xml){
		if (isXMLOk(xml)) {
			readDimensionsXML(xml);
		}
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}
*/
function setXml(dims,prfName,cbeName,from){
	document.getElementById("prfName").value = prfName;
	document.getElementById("hidDims").value = dims;
	document.getElementById("cbeName").value = cbeName;
	document.getElementById("hidFrom").value = from;	
	
	var oTr = document.createElement("TR");
	var oTd0 = document.createElement("TD"); 
	var oTd1 = document.createElement("TD");
	var tblDimensions;
	if (MSIE){
		tblDimensions=document.getElementById("tblDimensions").firstChild;
	}else {
		tblDimensions=document.getElementById("tblDimensions");
	}
	oTr.appendChild(oTd0);
	oTr.appendChild(oTd1);
	tblDimensions.appendChild(oTr);
	var i=0;
	while (dims.indexOf(";")>0){
		var dim = dims.substring(0,dims.indexOf(";"));
		dims = dims.substring(dims.indexOf(";")+1, dims.length);
		var visible = dims.substring(0,dims.indexOf(";"));
		dims = dims.substring(dims.indexOf(";")+1, dims.length);
		
		var oTr = document.createElement("TR");
		if (i%2==0) {
			oTr.className="trOdd";
		}

		var oTd0 = document.createElement("TD"); 
		var oTd1 = document.createElement("TD");
		 
		oTd0.innerHTML = dim;
		if (visible=="true"){
			oTd1.innerHTML = "<input type=checkbox name='chk_" + dim + "' checked id='chk_" + dim + "'>";
		}else {
			oTd1.innerHTML = "<input type=checkbox name='chk_" + dim + "' id='chk_" + dim + "'>";		
		}
		
		oTr.appendChild(oTd0);
		oTr.appendChild(oTd1);

		tblDimensions.appendChild(oTr);
		i++;
	}
}

function getSelected(){
	var oRows = document.getElementById("gridProfiles").selectedItems;
	var tblDimensions=document.getElementById("tblDimensions");
	if (oRows != null) {
		var result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd = oRow.cells[0];
			arr = new Array();
			arr[0] = oTd.profileId;
			arr[1] = oTd.profileName;
			arr[2] = oTd.profileAll;
			
			result[i] = arr;
		}
		return result;
	} else {
		return null;
	}
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>