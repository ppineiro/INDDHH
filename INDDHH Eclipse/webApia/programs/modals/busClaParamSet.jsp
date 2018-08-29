<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body onload="doXMLLoad()"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titPar")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"titPar")%></DIV><div type="grid" id="gridParams" style="height:180px" onselect="enableConfirm()"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:200px" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblValue")%>"><%=LabelManager.getName(labelSet,"lblValue")%></th></tr></thead><tbody></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="rigth"><button type="button" disabled id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}	

function doXMLLoad(){
	var sXMLSourceUrl = "busClaParameterXML.jsp?busClaId="+<%= request.getParameter("busClaId")%> + "&notParType=<%= request.getParameter("notParType")%>&name=";
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
					
					var busClaParId = xRow.childNodes[0].firstChild.nodeValue;
					var busClaParName = xRow.childNodes[1].firstChild.nodeValue;
					var busClaParType = xRow.childNodes[3].firstChild.nodeValue;
					var busClaParValue = "";
				
					oTd0.innerHTML = "<input type='checkbox' name='chk' onClick='enableConfirm()'>";
					oTd0.setAttribute("busClaParId",busClaParId);
					oTd0.setAttribute("busClaParType",busClaParType);
					
					busClaParValue = getParValue("<%=request.getParameter("busClaParValues")%>",busClaParId);
					oTd1.innerHTML = xRow.childNodes[1].firstChild.nodeValue;
					if (busClaParValue == null || busClaParValue == 'null'){
						busClaParValue = "";
					}					
					oTd2.innerHTML = "<input id='value' name='value' onChange='enableConfirm()' value='" + busClaParValue + "'>";
			
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);

					document.getElementById("gridParams").addRow(oTr);
				}
			}
		}
	}else{
		alert("error occurred");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}		

//values: "busClaParId-busClaParType-busClaParValue,busClaParId-busClaParType-busClaParValue,.."
function getParValue(values, parId){
	var fin = 0;
	var control = 0;// Control por si la funcion llega a quedar en loop
	while (values.indexOf("-")>0){
		if (control == 100) return "";
		var busClaParId = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParType = values.substring(0,values.indexOf("-"));
		if (busClaParId == parId){
			values = values.substring(values.indexOf("-")+1, values.length);
			if (values.indexOf(",")>=0){
				return values.substring(0,values.indexOf(","));
			}else{
				return values;
			}
		}else{
			if (values.indexOf(",")>0){
				values = values.substring(values.indexOf(",")+1, values.length);
			}else return "";
		}
		control = control + 1;
	}
	return "";
}

function getSelected(){
	var oRows = document.getElementById("gridParams").rows;
	if (oRows != null) {
		var result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd = oRow.cells[0];
			arr = new Array();
			arr[0] = oTd.getAttribute("busClaParId");
			arr[1] = oTd.getAttribute("busClaParType");
			arr[2] = oRow.getElementsByTagName("INPUT")[1].value;
			result[i] = arr;
		}
		return result;
	} else {
		return null;
	}
}

function enableConfirm() {
	var oRows = document.getElementById("gridParams").selectedItems;
	document.getElementById("btnConf").disabled = (oRows == null) || (oRows.length == 0);
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>