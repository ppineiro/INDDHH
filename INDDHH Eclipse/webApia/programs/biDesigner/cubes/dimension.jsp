<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><% boolean onlyOne = request.getParameter("onlyOne") != null; %><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.CubeBean"></jsp:useBean></head><body onload="init()"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titNewDimension")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><table class="tblFormLayout"><tr><td title="<%=LabelManager.getName(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtNom" id="txtNom" maxlength="50" p_required="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>"></td></tr><tr><td title="<%=LabelManager.getName(labelSet,"lblDesc")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDesc")%>:</td><td><input name="txtDesc" id="txtDesc" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDesc")%>"></td></tr><tr><td title="<%=LabelManager.getName(labelSet,"lblTable")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTable")%>:</td><td><input type=hidden name="txtSelTable" value=""><select style="width:200px" name="selTables" onchange="showPriKeys()" p_required="true" id="selTables" p_maxlength="true" maxlength="255" cols=20 rows=4 accesskey=""></td></tr><tr><td style="width:20%;" title="<%=LabelManager.getToolTip(labelSet,"lblPriKey")%>"><%=LabelManager.getNameWAccess(labelSet,"lblPriKey")%>:</td><td><select style="width:200px" name="selPriKeys" p_required="true" id="selPriKeys" p_maxlength="true" maxlength="255" cols=20 rows=4 accesskey=""><option value=""></option></td></tr><tr><td style="width:20%;" title="<%=LabelManager.getToolTip(labelSet,"lblShared")%>"><%=LabelManager.getNameWAccess(labelSet,"lblShared")%>:</td><td><input type="checkbox" name="chkShared" onclick="chkSharedClick()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblShared")%>"></td></tr></table></form></div><TABLE class="pageBottom"><TR><TD align="right"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">

function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}	

function btnExit_click() {
	window.returnValue=null;
	window.close();
}

function init(){
	var doc=window.parent.frames["workArea"].document;
	
	var cmb=doc.getElementById("txtTablesSel");
	var opt=document.createElement("OPTION");
	document.getElementById("selTables").appendChild(opt);
	for(var i=0;i<cmb.options.length;i++){
		var opt=document.createElement("OPTION");
		opt.innerHTML=cmb.options[i].text;
		opt.value=cmb.options[i].value;
		document.getElementById("selTables").appendChild(opt);
	}
}

function showPriKeys(){
	if (document.getElementById("selTables").selectedIndex >= 0){
		//borramos las que habia antes
		borrarTextArea("selPriKeys");
			
		var tablesSel = document.getElementById("selTables");
		// Obtener el índice de la opción que se ha seleccionado
		var indiceSeleccionado = tablesSel.selectedIndex;
		// Con el índice y el array "options", obtener la opción seleccionada
		var opcionSeleccionada = tablesSel.options[indiceSeleccionado];
		// Obtener el valor y el texto de la opción seleccionada
		var tableName = opcionSeleccionada.text;
		var tableId = opcionSeleccionada.value;
		
		doXMLLoad(tableId);
	}
}

function borrarTextArea(name){
	while(document.getElementById(name).options.length>0){
		var opt=document.getElementById(name).options[0];
		if(opt){
			opt.parentNode.removeChild(opt);
		}
	}
}

function doXMLLoad(tableId){
	var sXMLSourceUrl = URL_ROOT_PATH+"/programs/biDesigner/cubes/updateColumnsXML.jsp?tableId=" + tableId;
	var listener=new Object();
	listener.onLoad=function(xml){
		if (isXMLOk(xml)) {
			readDocXML(xml);
		}
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}

function readDocXML(sXmlResult){
	var xmlRoot=getXMLRoot(sXmlResult);
	if (xmlRoot.nodeName != "EXCEPTION") {
		for(i=0;i<xmlRoot.childNodes.length;i++){
			var xRow = xmlRoot.childNodes[i];
			var attId=xRow.childNodes[0].firstChild.nodeValue;
			var attName=xRow.childNodes[1].firstChild.nodeValue;
			var oOpt = document.createElement("OPTION");
			oOpt.innerHTML = attName;
			oOpt.value = attId;
			document.getElementById("selPriKeys").appendChild(oOpt);
		}
	}else{
		alert("error occurred");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}
</script>