<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body onload="loadAtts()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.EntitiesBean"></jsp:useBean><%String  dimAttIdsStr = dBean.getDimAttIdsAsString();
  String  msrAttIdsStr = dBean.getMsrAttIdsAsString();
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titVwEntAttsAsoc")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><table id="treeTable"><tr><td nowrap="" valign="top"><ul><li class="clsFolder" title="<%=LabelManager.getToolTip(labelSet,"sbtDatEntNeg")%>"><IMG onclick="doLIAction(this, 'entityData')" SRC="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif"/><span><%=LabelManager.getName(labelSet,"sbtDatEntNeg")%></span><input type="hidden" name="hidEntDataId" value="1"></input></li><li class="clsFolder" title="<%=LabelManager.getToolTip(labelSet,"sbtRedDatEntNeg")%>"><IMG onclick="doLIAction(this, 'entityRedAtts')" SRC="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif"/><span><%=LabelManager.getName(labelSet,"sbtRedDatEntNeg")%></span><input type="hidden" name="hidEntDataId" value="2"></input></li><li class="clsFolder" title="<%=LabelManager.getToolTip(labelSet,"sbtFrmDatEntNeg")%>"><IMG onclick="doLIAction(this, 'actEntityForms')" SRC="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif"/><span><%=LabelManager.getName(labelSet,"sbtFrmDatEntNeg")%></span><input type="hidden" name="hidEntDataId" value="3"></input></li><li class="clsFolder" title="<%=LabelManager.getToolTip(labelSet,"sbtProFrmDatEntNegJer")%>"><IMG onclick="doLIAction(this, 'entityProcessJer')" SRC="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif"/><span><%=LabelManager.getName(labelSet,"sbtProFrmDatEntNegJer")%></span><input type="hidden" name="hidEntDataId" value="4"></input></li></ul></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script type="text/javascript">
var PRO_LABEL = "<%=LabelManager.getName(labelSet,"lblPro")%>" + ": ";
var SUB_PRO_LABEL = "<%=LabelManager.getName(labelSet,"lblSubPro")%>" + ": ";
var TASK_LABEL = "<%=LabelManager.getName(labelSet,"lblTask")%>" + ": ";
var FORM_LABEL = "<%=LabelManager.getName(labelSet,"lblForm")%>" + ": ";
var ATT_LABEL = "<%=LabelManager.getName(labelSet,"lblAtt")%>" + ": ";
var TYPE_LABEL = "<%=LabelManager.getName(labelSet,"lblTip")%>" + ": ";
var OBLIG_LABEL = "<%=LabelManager.getName(labelSet,"titObligatory")%>" + ": ";
var MAP_ENTITY_LABEL = "<%=LabelManager.getName(labelSet,"lblMapEntity")%>" + ": ";
var DATE_LABEL = "<%=LabelManager.getName(labelSet,"lblDate")%>";
var NUMERIC_LABEL = "<%=LabelManager.getName(labelSet,"lblNum")%>";
var STRING_LABEL = "<%=LabelManager.getName(labelSet,"lblStr")%>";
var ENTITY_ID_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeIdeEnt").toUpperCase()%>";
var ENTITY_STATUS_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeStaEnt").toUpperCase()%>";
var ENTITY_CREATOR_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeUsuCreEnt").toUpperCase()%>";
var ENTITY_CRE_DATE_LABEL = "<%=LabelManager.getName(labelSet,"lblEjeFecCreEnt").toUpperCase()%>";
var ENT_PRO_FORM_LABEL = "<%=LabelManager.getName(labelSet,"lblProEntFor")%>";
var PRO_PRO_FORM_LABEL = "<%=LabelManager.getName(labelSet,"lblProProFor")%>";

var ENTITY_ID_NAME = "<%=EntityDwColumnVo.BASIC_ENT_DATA_COL_IDENT_NAME%>";
var ENTITY_ID_ID = "<%=EntityDwColumnVo.BASIC_ENT_DATA_COL_IDENT%>";

var ENTITY_STATUS_NAME = "<%=EntityDwColumnVo.BASIC_ENT_DATA_COL_STATUS_NAME%>";
var ENTITY_STATUS_ID = "<%=EntityDwColumnVo.BASIC_ENT_DATA_COL_STATUS%>";

var ENTITY_CREATOR_NAME = "<%=EntityDwColumnVo.BASIC_ENT_DATA_COL_CREATE_USER_NAME%>";
var ENTITY_CREATOR_ID = "<%=EntityDwColumnVo.BASIC_ENT_DATA_COL_CREATE_USER%>";

var ENTITY_CRE_DATE_NAME = "<%=EntityDwColumnVo.BASIC_ENT_DATA_COL_CREATE_DATE_NAME%>";
var ENTITY_CRE_DATE_ID = "<%=EntityDwColumnVo.BASIC_ENT_DATA_COL_CREATE_DATE%>";

var selAtts = new Array();
var selBasicDat = new Array();
</script><script language="javascript">
function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}

function doLIAction(aEvent, type){
	var element = aEvent;
	aEvent.cancelBubble = true;
	if(element.tagName=="SPAN"){
		element=element.parentNode;
	}
	if (type=="entityData" || type=="entityRedAtts" || type=="actEntityForms" || type=="entityFormAtts" || type=="entityForms" || type=="entityForm" || type=="entityProcessJer" || type=="processJer" || type=="process" || type=="task" || type=="form"){
		var fldAtt = element.Fldstate;
		if(fldAtt!="open"){//Estaba cerrado --> hay que abrir
			element.Fldstate="open";
			element.src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>"+"/images/open.gif";//show open
		}else{ //Estaba abierto --> hay que cerrar
			element.Fldstate="";
			element.src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>"+"/images/closed.gif";//showCloseds
		}
	}
	if(fldAtt!="open"){
		if (type=="entityData"){
			openBasicData(element);
		}else if (type == "task"){
			openTaskForms(element);
		}else{
			openData(element,type);
		}
	}else{
		closeData(element);
	}
}

function closeData(element){
	var ul = element.parentNode.getElementsByTagName("UL");
	while(ul.length >0){
		ul[0].parentNode.removeChild(ul[0]);
	}
}

function loadAtts(){
	var attIds = "";
	if ("true" == "<%=request.getParameter("forDimensions")%>"){
		attIds = "<%=dimAttIdsStr%>";
	}else if ("true" == "<%=request.getParameter("forMeasures")%>"){
		attIds = "<%=msrAttIdsStr%>";
	}
	if (attIds.length > 0){
		var sepPos = attIds.indexOf(",");     
		while (sepPos>=0){
			var attId = attIds.substring(0,sepPos);
			if (parseInt(attId)>0){
				selAtts[selAtts.length] = attId;
			}else{
				selBasicDat[selBasicDat.length] = attId;
			}
			attIds = attIds.substring(sepPos+1,attIds.length);
			sepPos = attIds.indexOf(",");     
		}
		if (parseInt(attIds)>0){
			selAtts[selAtts.length] = attIds;
		}else{
			selBasicDat[selBasicDat.length] = attIds;
		}
	}
}

function openBasicData(element){
	var oUL = document.createElement("ul");
	var oLI1 = document.createElement("li"); 
	var oLI2 = document.createElement("li");
	var oLI3 = document.createElement("li");
	var oLI4 = document.createElement("li");
	
	//1.Identificador de la entidad
	oLI1.title = ENTITY_ID_LABEL;
	if (checkIfSelBasicDat(-1)){
		oLI1.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this,-1)\"></input>";
	}else{
		oLI1.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this,-1)\"></input>";
	}
	oLI1.innerHTML = oLI1.innerHTML + "<span>"+ENTITY_ID_LABEL+"</span>";
	oLI1.innerHTML = oLI1.innerHTML + "<input type='hidden' name='hidEntDatId' value='-1'></input>";
	
	//2.Estado de la entidad
	oLI2.title = ENTITY_STATUS_LABEL;
	if (checkIfSelBasicDat(-2)){
		oLI2.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this,-2)\"></input>";
	}else{
		oLI2.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this,-2)\"></input>";
	}
	oLI2.innerHTML = oLI2.innerHTML + "<span>"+ENTITY_STATUS_LABEL+"</span>";
	oLI2.innerHTML = oLI2.innerHTML + "<input type='hidden' name='hidEntDatId' value='-2'></input>";
	
	//3.Creador de la entidad
	oLI3.title = ENTITY_CREATOR_LABEL;
	if (checkIfSelBasicDat(-3)){
		oLI3.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this,-3)\"></input>";
	}else{
		oLI3.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this,-3)\"></input>";
	}
	oLI3.innerHTML = oLI3.innerHTML + "<span>"+ENTITY_CREATOR_LABEL+"</span>";
	oLI3.innerHTML = oLI3.innerHTML + "<input type='hidden' name='hidEntDatId' value='-3'></input>";
	
	//4.Fecha de creacion de la entidad
	oLI4.title = ENTITY_CRE_DATE_LABEL;
	if (checkIfSelBasicDat(-4)){
		oLI4.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselBasicData(this,-4)\"></input>";
	}else{
		oLI4.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselBasicData(this,-4)\"></input>";
	}
	oLI4.innerHTML = oLI4.innerHTML + "<span>"+ENTITY_CRE_DATE_LABEL+"</span>";
	oLI4.innerHTML = oLI4.innerHTML + "<input type='hidden' name='hidEntDatId' value='-4'></input>";
	
	oUL.appendChild(oLI1);
	oUL.appendChild(oLI2);
	oUL.appendChild(oLI3);
	oUL.appendChild(oLI4);
	
	element.parentNode.appendChild(oUL);
}

function openTaskForms(element){
	obj = element.parentNode;
	var objId = obj.getElementsByTagName("INPUT")[0].value;
	var proEleId = obj.getElementsByTagName("INPUT")[1].value;
	var proId = obj.getElementsByTagName("INPUT")[2].value;
	
	var oUL = document.createElement("ul");
	var oLI1 = document.createElement("li"); 
	//var oLI2 = document.createElement("li");
	
	//1.Formularios de entidad
	oLI1.title = ENT_PRO_FORM_LABEL;
	oLI1.innerHTML = "<IMG onclick=\"doLIAction(this, 'entityForms')\" SRC=\"<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>/images/closed.gif\"/>";
	oLI1.innerHTML = oLI1.innerHTML + "<span>" + ENT_PRO_FORM_LABEL +"</span>";
	oLI1.innerHTML = oLI1.innerHTML + "<input type='hidden' name='hidObjId' value='" + objId + "'></input>";
	oLI1.innerHTML = oLI1.innerHTML + "<input type='hidden' name='hidProEleId' value='" + proEleId + "'></input>";
	oLI1.innerHTML = oLI1.innerHTML + "<input type='hidden' name='hidProId' value='" + proId + "'></input>";
	
	//2.Formularios de proceso
	//oLI2.title = PRO_PRO_FORM_LABEL;
	//oLI2.innerHTML = "<IMG onclick=\"doLIAction(this, 'processForms')\" SRC=\"<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>/images/closed.gif\"/>";
	//oLI2.innerHTML = oLI2.innerHTML + "<span>" + PRO_PRO_FORM_LABEL +"</span>";
	//oLI2.innerHTML = oLI2.innerHTML + "<input type='hidden' name='hidObjId' value='" + objId + "'></input>";
	//oLI2.innerHTML = oLI2.innerHTML + "<input type='hidden' name='hidProEleId' value='" + proEleId + "'></input>";
	//oLI2.innerHTML = oLI2.innerHTML + "<input type='hidden' name='hidProId' value='" + proId + "'></input>";
	
	oUL.appendChild(oLI1);
	//oUL.appendChild(oLI2); //No se agrega pq solo se deben mostrar los formularios de entidad
	
	element.parentNode.appendChild(oUL);
}

function openData(element,type){
	obj = element.parentNode;
	var objId = obj.getElementsByTagName("INPUT")[0].value;
	var sXMLSourceUrl
	if (type=="entityRedAtts"){ //Atributos redundantes
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.EntitiesAction.do?action=getTreeXMLForAddAttDim&opt=1" + windowId;
	}else if (type=="actEntityForms"){ //Formularios de la entidad actual
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.EntitiesAction.do?action=getTreeXMLForAddAttDim&opt=2" + windowId;
	}else if (type=="entityForms"){ //Formularios de entidad
		var proEleId = obj.getElementsByTagName("INPUT")[1].value;
		var proId = obj.getElementsByTagName("INPUT")[2].value;
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.EntitiesAction.do?action=getTreeXMLForAddAttDim&opt=3" + "&proId=" + proId + "&proEleId=" + proEleId + windowId;
	//}else if (type=="processForms"){ //Formularios de proceso
	//	var proEleId = obj.getElementsByTagName("INPUT")[1].value;
	//	var proId = obj.getElementsByTagName("INPUT")[2].value;
	//	sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.ProcessAction.do?action=getTreeXMLForAddAttDim&opt=4" + "&proId=" + proId + "&proEleId=" + proEleId + windowId;
	//}else if (type=="entityProcess"){ //Procesos y subprocesos donde se utiliza la entidad (todos en un mismo nivel)
	//	sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.EntitiesAction.do?action=getTreeXMLForAddAttDim&opt=5" + windowId;
	}else if (type=="process"){ //Proceso
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.EntitiesAction.do?action=getTreeXMLForAddAttDim&opt=4" + "&proId=" + objId + windowId;
	}else if (type=="task"){ //Tarea de proceso
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.EntitiesAction.do?action=getTreeXMLForAddAttDim&opt=5" + "&tskId=" + objId + windowId;
	}else if (type=="form"){ //Formulario de tarea
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.EntitiesAction.do?action=getTreeXMLForAddAttDim&opt=6" + "&frmId=" + objId + windowId;
	}else if (type =="entityFormAtts" || type=="entityForm"){ //Atributos de un formulario de entidad
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.EntitiesAction.do?action=getTreeXMLForAddAttDim&opt=7" + "&frmId=" + objId + windowId;
	}else if (type=="entityProcessJer"){ //Procesos donde se utiliza la entidad (solo los procesos padres)
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.EntitiesAction.do?action=getTreeXMLForAddAttDim&opt=8" + "&proId=" + objId + windowId;
	}else if (type=="processJer"){ //Sub-Procesos y tareas de un proceso
		sXMLSourceUrl =  "<%=Parameters.ROOT_PATH%>/administration.EntitiesAction.do?action=getTreeXMLForAddAttDim&opt=9" + "&proId=" + objId + windowId;
	}
	var listener=new Object();
	listener.onLoad=function(xml){
		if (isXMLOk(xml)) {
			readXML(xml,element,type);
		}
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}

function readXML(XmlResult,element,type){
	var xmlRoot=getXMLRoot(XmlResult);
	var nextType;
	var prefix;
	var nextType2;
	var prefix2;
	
	if (type=="entityData"){
		nextType = "attribute";
		prefix = "";
	}else if (type=="entityRedAtts"){
		nextType = "attribute";
		prefix = ATT_LABEL;
	}else if (type=="actEntityForms"){ //Formularios asociados a la entidad actual
		nextType = "entityFormAtts";
		prefix = FORM_LABEL;
	}else if (type=="entityForms"){ //Si hizo click en la opcion formularios de entidad
		nextType = "entityForm"; // Debo mostrar formularios de entidad
		prefix = FORM_LABEL;
	//}else if (type=="processForms"){//Si hizo click en la opcion formularios de procesos
	//	nextType = "processForm"; //Debo mostrar formularios de proceso
	//	prefix = FORM_LABEL;
	//}else if (type=="entityProcess"){
	//	nextType = "process";
	//	prefix = PRO_LABEL;
	}else if (type=="entityProcessJer"){
		nextType = "processJer";
		prefix = PRO_LABEL;
	}else if (type=="processJer"){
		nextType = "processJer";
		prefix = SUB_PRO_LABEL;
		nextType2="task";
		prefix2= TASK_LABEL;
	//}else if (type=="process"){
	//	nextType2 = "task";
	//	prefix = TASK_LABEL;
	}else if (type=="task"){
		nextType = "form";
		prefix = FORM_LABEL;
	}else if (type=="form"){
		nextType = "attribute";
		prefix = ATT_LABEL;
	}else if (type == "entityFormAtts" || type=="entityForm"){
		nextType = "attribute";
		prefix = ATT_LABEL;
	}
	if (xmlRoot.nodeName != "EXCEPTION") {
		if (xmlRoot.childNodes.length == 0) {
			//document.getElementById("noData").style.display="block";
		} else {
			xRow = xmlRoot.childNodes[0];
			for(i=0;i<xmlRoot.childNodes.length;i++){
				xRow = xmlRoot.childNodes[i];

				//Identificador
				var objId = xRow.childNodes[0].firstChild.nodeValue;

				var objName = "";;
				//Nombre
				if (type=="entityRedAtts" || type == "entityFormAtts" || type=="entityForm" || type == "form"){
					objName = prefix + xRow.childNodes[1].firstChild.nodeValue + " (" + xRow.childNodes[3].firstChild.nodeValue;
					if (xRow.childNodes[2].firstChild != null){ //Si tiene descripcion la mostramos
						objName = objName + " - " + xRow.childNodes[2].firstChild.nodeValue + ")";
					}else{
						objName = objName + ")";
					}
				}else if (type=="processJer") { 
					if (xRow.childNodes[4]!=null && 'true' == xRow.childNodes[4].firstChild.nodeValue){ // es subproceso
						objName = prefix + xRow.childNodes[1].firstChild.nodeValue + " (" + xRow.childNodes[3].firstChild.nodeValue;
						if (xRow.childNodes[2].firstChild != null){ //Si tiene descripcion la mostramos
							objName = objName + " - " + xRow.childNodes[2].firstChild.nodeValue + ")";
						}else{
							objName = objName + ")";
						}
					}else{ //es tarea
						objName = prefix2 + xRow.childNodes[1].firstChild.nodeValue + " (" + xRow.childNodes[3].firstChild.nodeValue;
						if (xRow.childNodes[2].firstChild != null){ //Si tiene descripcion la mostramos
							objName = objName + " - " + xRow.childNodes[2].firstChild.nodeValue + ")";
						}else{
							objName = objName + ")";
						}
					}
				}else{
					objName = prefix + xRow.childNodes[1].firstChild.nodeValue + " (" + xRow.childNodes[3].firstChild.nodeValue;
					if (xRow.childNodes[2].firstChild != null){ //Si tiene descripcion la mostramos
						objName = objName + " - " + xRow.childNodes[2].firstChild.nodeValue + ")";
					}else{
						objName = objName + ")";
					}
				}
				
				//ToolTip (solo para atributos de formularios de la entidad y de tareas de procesos)
				var objTitle = "";
				if (type == "entityFormAtts" || type=="entityForm" || type == "form"){
					if (xRow.childNodes[4].firstChild != null){
						var attType = xRow.childNodes[4].firstChild.nodeValue;
						if (attType == "D"){
							objTitle = "(" + TYPE_LABEL + DATE_LABEL;
						}else if (attType == "S"){
							objTitle = "(" + TYPE_LABEL + STRING_LABEL;						
						}else{
							objTitle = "(" + TYPE_LABEL + NUMERIC_LABEL;
						}
					}
					if (xRow.childNodes[5].firstChild != null){
						var oblig = xRow.childNodes[5].firstChild.nodeValue;
						objTitle = objTitle + ", " + OBLIG_LABEL + oblig;
					}
					if (xRow.childNodes[6].firstChild != null){
						var entity = xRow.childNodes[6].firstChild.nodeValue;
						objTitle = objTitle + ", " + MAP_ENTITY_LABEL + entity + ")";
					}else{
						objTitle = objTitle + ")";
					}
				}
				var oUL = document.createElement("ul");
				var oLI = document.createElement("li"); 
			
				oLI.title = objTitle;
				var isTask = false;
				if (type!="form" && type!="entityRedAtts" && type!="entityFormAtts" && type!="entityForm"){
					if (type=="processJer"){ //Si es subproceso
						if (xRow.childNodes[4]!=null && 'true'==xRow.childNodes[4].firstChild.nodeValue){//es subproceso
							oLI.innerHTML = "<IMG onclick=\"doLIAction(this,'"+nextType+"')\" SRC='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif'/>";							
						}else{//es tarea
							isTask = true;
							oLI.innerHTML = "<IMG onclick=\"doLIAction(this,'"+nextType2+"')\" SRC='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif'/>";
						}
					}else{
						oLI.innerHTML = "<IMG onclick=\"doLIAction(this,'"+nextType+"')\" SRC='<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/closed.gif'/>";
					}
				}else{
					if (checkIfSelected(objId)){
						oLI.innerHTML = "<input type='checkbox' checked name='chkAtt' onclick=\"selUnselAttribute(this,"+objId+")\"></input>";
					}else{
						oLI.innerHTML = "<input type='checkbox' name='chkAtt' onclick=\"selUnselAttribute(this,"+objId+")\"></input>";
					}
				}
				oLI.innerHTML = oLI.innerHTML + "<span>"+objName+"</span>";
				oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidTskId' value='"+objId+"'></input>";
				
				if (isTask){ //Si se van a mostrar tareas -> guardamos el proEleId de la tarea
					oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidProEleId' value='"+xRow.childNodes[4].firstChild.nodeValue+"'></input>";
					oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidProId' value='"+xRow.childNodes[5].firstChild.nodeValue+"'></input>";
				}else{
					oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidProEleId' value='-1'></input>";
					oLI.innerHTML = oLI.innerHTML + "<input type='hidden' name='hidProId' value='-1'></input>";
				}
				
				oUL.appendChild(oLI);
				element.parentNode.appendChild(oUL);
			}
		}
	}else{
		alert("error occurred");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}

function notInSelAtts(attId){
	for (var i=0; i<selAtts.length; i++){
		if (selAtts[i] == attId){
			return false;
		}
	}
	return true;
}

function notInBasicDatAtts(attId){
	for (var i=0; i<selBasicDat.length; i++){
		if (selBasicDat[i] == attId){
			return false;
		}
	}
	return true;
}

function selUnselAttribute(obj,attId){
	var li = obj.parentNode;
	if(li.getElementsByTagName("INPUT")[0].checked){
		if (notInSelAtts(attId)){
			selAtts[selAtts.length] = attId;
		}
	}else{
		for (var i=0; i<selAtts.length; i++){
			if (selAtts[i] == attId) {	
				selAtts[i] = null;
				return;
			}
		}
	}
}

function selUnselBasicData(obj,datId){
	var li = obj.parentNode;
	if(li.getElementsByTagName("INPUT")[0].checked){
		if (notInBasicDatAtts(datId)){
			selBasicDat[selBasicDat.length] = datId;
		}
	}else{
		for (var i=0; i<selBasicDat.length; i++){
			if (selBasicDat[i] == datId) {	
				selBasicDat[i] = null;
				return;
			}
		}
	}
}

function checkIfSelected(attId){
	for(var i=0;i<selAtts.length;i++){
		if (selAtts[i] == attId){
			return true;
		}
	}
	return false;
}

function checkIfSelBasicDat(datId){
	for(var i=0;i<selBasicDat.length;i++){
		if (selBasicDat[i] == datId){
			return true;
		}
	}
	return false;
}

//Funcion para usar con Ajax
function getXMLHttpRequest(){
	var http_request = null;
	if (window.XMLHttpRequest) {
		// browser has native support for XMLHttpRequest object
		http_request = new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		// try XMLHTTP ActiveX (Internet Explorer) version
		try {
			http_request = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e1) {
			try {
				http_request = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e2) {
				http_request = null;
			}
		}
	}
	return http_request;
}

function getSelectedValues(){
	var str = "&forDimensions=" + "<%=request.getParameter("forDimensions")%>" + "&forMeasures=" + "<%=request.getParameter("forMeasures")%>";
	if (selAtts.length > 0){
		for (i = 0; i < selAtts.length; i++) {
			if (selAtts[i]!=null){
				if (str==""){
					str = "&attId=" + selAtts[i];
				}else{
					str = str + "&attId=" + selAtts[i];
				}
			}
		}
	}
	if (selBasicDat.length >0){
		for (i = 0; i < selBasicDat.length; i++) {
			if (selBasicDat[i]!=null){
				if (str==""){
					str = "&attId=" + selBasicDat[i];
				}else{
					str = str + "&attId=" + selBasicDat[i];
				}
			}
		}
	}
	return str;
}

function getSelected(){
	result = new Array();
	var str = getSelectedValues();
	if (str != ""){
		var	http_request = getXMLHttpRequest();
		http_request.open('POST', "administration.EntitiesAction.do?action=getAttsInfo"+windowId, false);
		http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");

		http_request.send(str);
		if (http_request.readyState == 4) {
	   	   if (http_request.status == 200) {
	           if(http_request.responseText != "NOK"){
	              var attsInfo = http_request.responseText; //El formato de la respuesta es: 'id-nom-desc-tipo-idMapEnt-nameMapEnt-id-nom-desc-tipo-idMapEnt-nameMapEnt-..'
	              if (attsInfo == "NOK"){return;}
	              var i=0;
	              
	              //1.Agregamos los atributos seleccionados
				  while (attsInfo.indexOf(",")>-1){
					var attId = attsInfo.substring(0,attsInfo.indexOf(","));
					attsInfo = attsInfo.substring(attsInfo.indexOf(",")+1,attsInfo.length);
					var attNom;
					if (attsInfo.indexOf(",")<0){
						attNom = attsInfo;					
					}else{
						attNom = attsInfo.substring(0,attsInfo.indexOf(","));
					}
					attsInfo = attsInfo.substring(attsInfo.indexOf(",")+1,attsInfo.length);
					arr = new Array();
					if (attId != "skip"){
						var attLbl = attsInfo.substring(0,attsInfo.indexOf(","));
						attsInfo = attsInfo.substring(attsInfo.indexOf(",")+1,attsInfo.length);
						var attType = attsInfo.substring(0,attsInfo.indexOf(","));
						attsInfo = attsInfo.substring(attsInfo.indexOf(",")+1,attsInfo.length);
						var attIdMap = attsInfo.substring(0,attsInfo.indexOf(","));
						attsInfo = attsInfo.substring(attsInfo.indexOf(",")+1,attsInfo.length);
						var attNamMap = "null";
						if (attsInfo.indexOf(",")<0){
							attNamMap = attsInfo;
						}else{
							attNamMap = attsInfo.substring(0,attsInfo.indexOf(","));
						}
						attsInfo = attsInfo.substring(attsInfo.indexOf(",")+1,attsInfo.length);
						arr[0] = attId;
						arr[1] = attNom;
						arr[2] = attLbl;
						//if (attIdMap!=null && attIdMap!="" && attIdMap!="undefined" && attIdMap!="null"){ //Si tiene una entidad de mapeo 
						//	arr[3] = "S"; //el tipo es string
						//}else{
							arr[3] = attType;
						//}
						arr[4] = attIdMap;
						arr[5] = attNamMap;
						
						//alert("attId:"+attId+", attName:" + attNom + ", attLbl:"+ attLbl+", attType:"+attType+", attMapEntId:"+attIdMap+", attMapEntName:"+attNamMap);
						
					}else{
						arr[0] = attId; //Ponemos la palabra que indica que se debe hacer skip
						arr[1] = attNom; //si se debe hacer skip, en attNom tenemos el attId (hecho asi por si existe un att llamado skip)
					}
					result[i] = arr;
					i++;
				  }
				  
				}
		  }else {
	         return "NOK";
	      }
		}else{
	          return "Could not contact the server.";  
		}
	} 
	return result;
}

function enableConfirm() {
	var oRows = document.getElementById("gridForms").selectedItems;
	document.getElementById("btnConf").disabled = (oRows == null) || (oRows.length == 0);
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}

</script>