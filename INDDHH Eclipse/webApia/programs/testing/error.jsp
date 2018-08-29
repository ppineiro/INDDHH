<%@page import="java.util.*"%><%@page import="com.dogma.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><jsp:useBean id="bTest"  
			 class="com.dogma.testing.web.controller.TestBean"      
			 scope="session"/><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Configuración Testing</TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false" ><table border=0 align="center" valign="middle" class="tblFormLayout"><thead><tr><td>Opciones para definir errores de testing</td></tr></thead><tbody><tr><td title="Último Archivo">Seleccione Archivo XML:</td><td><select name="txtFileName" id="txtFileName"><%Collection col = bTest.getAllReqFile();
   						if (col != null) {
	   						Iterator it = col.iterator();
	   						String fileName = null;
	   						while (it.hasNext()) {
	   						 	fileName = bTest.fmtStr((String) it.next()); 
	   						 	%><option value="<%=fileName%>"><%=fileName%></option><%	
		   					}
		   				}%></select></td></tr></tbody></TABLE><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")%></DIV><div type="grid" id="gridRequest" style="height:350px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="Sel"></th><th style="width:5%"  title="Id">Id</th><th style="width:20%"  title="Name">Name</th><th style="width:60%"  title="Action">Action</th><th style="width:15%"  title="Error">Error</th></tr></thead><tbody ></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD><button type="button" onclick="btnSearch_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></TD><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName("lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName("lblNoData")%></div></TD><TD align="rigth"><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></HTML><%@include file="../../components/scripts/server/endInc.jsp" %><SCRIPT LANGUAGE=javascript>

function btnSearch_click(){
	document.getElementById("gridRequest").clearTable();
	doXMLLoad();
	
}

function doXMLLoad(){
	var sXMLSourceUrl = null;
	var fileName = document.getElementById("txtFileName").value;	
	if (fileName==null || fileName==""){
		sXMLSourceUrl = "errorXML.jsp";
	} else {
		sXMLSourceUrl = "errorXML.jsp?fileName=" + fileName;
	}
	
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
	document.getElementById("moreData").style.display="none";
	document.getElementById("noData").style.display="none";
	if (xmlRoot.nodeName != "EXCEPTION") {
		if (xmlRoot.childNodes.length == 0) {
			document.getElementById("noData").style.display="block";
		} else {
			for(i=0;i<xmlRoot.childNodes.length;i++){
				if (i >= <%=Parameters.MAX_RESULT_MODAL %>) {
					document.getElementById("moreData").style.display="block";
					break;
				} else {
					xRow = xmlRoot.childNodes[i];
					var oTr = document.createElement("TR");
		
					if (i%2==0) {
						oTr.className="trOdd";
					}
	
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					var oTd2 = document.createElement("TD"); 
					var oTd3 = document.createElement("TD"); 
					var oTd4 = document.createElement("TD"); 
					
					if (xRow.childNodes[3].text == "true"){
					oTd0.innerHTML = "<input type='checkbox' name='chk' checked>";
					} else {
					oTd0.innerHTML = "<input type='checkbox' name='chk' >";
					}
					oTd0.id  = i;
					oTd1.innerText = xRow.childNodes[0].text;
					oTd2.innerText = xRow.childNodes[1].text;
					oTd3.innerText = xRow.childNodes[2].text;
					oTd4.innerText = xRow.childNodes[3].text;
			
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					oTr.appendChild(oTd3);
					oTr.appendChild(oTd4);
		
					document.getElementById("gridRequest").addRow(oTr);
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
	var i = 0;
	var result = new Array();
	var oRows = document.getElementById("gridRequest").selectedItems;
	if (oRows != null) {
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd = oRow.cells[0];
			result[i] = oTd.id;
		}
	}	
	return result;
}
function btnConf_click(){
	var result = new Array();
	result[0] = document.getElementById("txtFileName").value;	
	result[1] = getSelected();
	
	window.returnValue=result;
	window.close();
}
function btnExit_click(){
	window.returnValue=null;
	window.close();
}
</SCRIPT>
