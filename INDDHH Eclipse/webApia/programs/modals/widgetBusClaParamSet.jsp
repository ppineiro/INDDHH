<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body onload="doXMLLoad()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.WidgetBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titPar")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"titPar")%></DIV><div type="grid" id="gridParams" style="height:180px" onselect="enableConfirm()"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:30%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th style="width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblValue")%>"><%=LabelManager.getName(labelSet,"lblValue")%></th><th style="width:20%" title="<%=LabelManager.getToolTip(labelSet,"lblTip")%>"><%=LabelManager.getName(labelSet,"lblTip")%></th><th style="width:30%" title="<%=LabelManager.getToolTip(labelSet,"lblWidParValue")%>"><%=LabelManager.getName(labelSet,"lblWidParValue")%></th></tr></thead><tbody></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="rigth"><button type="button" disabled id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}	

function doXMLLoad(){
	var sXMLSourceUrl = "<%=Parameters.ROOT_PATH%>/programs/modals/busClaParameterXML.jsp?busClaId="+<%= request.getParameter("busClaId")%> + "&notParType=<%= request.getParameter("notParType")%>&name=";
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
	var foundNumericValue = false;
	var xmlRoot=getXMLRoot(sXmlResult);
	document.getElementById("moreData").style.display="none";
	document.getElementById("noData").style.display="none";
	var forAction = <%= request.getParameter("forAction")%>;
	var forZone = <%= request.getParameter("forZone")%>;
	if (xmlRoot.nodeName != "EXCEPTION") {
		if (xmlRoot.childNodes.length == 0) {
			document.getElementById("noData").style.display="block";
		} else {
			var alreadySet = false;
			
			for(i=0;i<xmlRoot.childNodes.length;i++){
				var forWidget = false;
				
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
					
					var busClaParId = xRow.childNodes[0].firstChild.nodeValue;
					var busClaParName = xRow.childNodes[1].firstChild.nodeValue;
					var busClaParType = xRow.childNodes[3].firstChild.nodeValue;
					var busClaParInOut = xRow.childNodes[4].firstChild.nodeValue;
					var busClaParValue = "";
					
					oTd0.innerHTML = "<input type='checkbox' name='chk' onClick='enableConfirm()'>";
					oTd0.setAttribute("busClaParId",busClaParId);
					oTd0.setAttribute("busClaParName",busClaParName);
					oTd0.setAttribute("busClaParType",busClaParType);
					
					busClaParValue = getParValue("<%=request.getParameter("busClaParValues")%>",busClaParId);
					if (!alreadySet){
						forWidget = isForWidget("<%=request.getParameter("busClaParValues")%>",busClaParId);
					}
					
					oTd1.innerHTML = busClaParName;
					//oTd2.innerHTML = "<input id='value' name='value' style='display:none' onChange='enableConfirm()'>";
					oTd2.innerHTML = "<input id='value' name='value' value='" + busClaParValue + "'>";
					if (busClaParType == "<%=AttributeVo.TYPE_NUMERIC%>"){
						oTd3.innerHTML = "<%=LabelManager.getName(labelSet,"lblNum")%>";
						if (forWidget == "true"){
							oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' checked onClick='unselOthers(this)'>";
							alreadySet = true;
						}else{
							if (forZone){
								if (busClaParInOut=="I" || busClaParInOut=="Z"){
									oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' onClick='unselOthers(this)'>";
								}else{
									oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' disabled onClick='unselOthers(this)'>";
								}
							}else{
								if (busClaParInOut=="O" || busClaParInOut=="Z"){
									oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' onClick='unselOthers(this)'>";
								}else{
									oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' disabled onClick='unselOthers(this)'>";
								}
							}
						}
						
						if (busClaParInOut=="O" || busClaParInOut=="Z"){
							foundNumericValue = true;
						}
					}else if (busClaParType == "<%=AttributeVo.TYPE_STRING%>"){
						oTd3.innerHTML = "<%=LabelManager.getName(labelSet,"lblStr")%>";
						oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' disabled>";
					}else if (busClaParType == "<%=AttributeVo.TYPE_DATE%>"){
						oTd3.innerHTML = "<%=LabelManager.getName(labelSet,"lblFec")%>";
						oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' disabled>";					
					}else if (busClaParType == "<%=AttributeVo.TYPE_INT%>"){
						oTd3.innerHTML = "<%=LabelManager.getName(labelSet,"lblInt")%>";
						if (forWidget == "true"){
							oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' checked onClick='unselOthers(this)'>";
						}else{
							if (forZone){
								if (busClaParInOut=="I" || busClaParInOut=="Z"){
									oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' onClick='unselOthers(this)'>";	
								}else{
									oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' disabled onClick='unselOthers(this)'>";	
								}
							}else{
								if (busClaParInOut=="O" || busClaParInOut=="Z"){
									oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' onClick='unselOthers(this)'>";	
								}else{
									oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' disabled onClick='unselOthers(this)'>";	
								}
							}
						}
						if (busClaParInOut=="O" || busClaParInOut=="Z"){
							foundNumericValue = true;
						}
					}
					
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					oTr.appendChild(oTd3);
					oTr.appendChild(oTd4);

					document.getElementById("gridParams").addRow(oTr);
				}
			}
		}
	}else{
		alert("error occurred");
	}
	if (!foundNumericValue && !forAction){
		window.returnValue="-1";
		window.close();
	}
	xmlRoot = "";
	sXmlResult = "";
}		

//values: "busClaParId-busClaParName-busClaParType-busClaParForWidget-busClaParValue,busClaParId-busClaParName-busClaParType-busClaParForWidget-busClaParValue,.."
function getParValue(values, parId){
	var fin = 0;
	var control = 0;// Control por si la funcion llega a quedar en loop
	while (values.indexOf("-")>0){
		if (control == 100) return "";
		var busClaParId = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParName = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParType = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParForWidget = values.substring(0,values.indexOf("-"));
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

function isForWidget(values, parId){
	var fin = 0;
	var control = 0;// Control por si la funcion llega a quedar en loop
	while (values.indexOf("-")>0){
		if (control == 100) return "";
		var busClaParId = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParName = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParType = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var busClaParForWidget = values.substring(0,values.indexOf("-"));
		if (busClaParId == parId){
			return busClaParForWidget;
		}else{
			if (values.indexOf(",")>0){
				values = values.substring(values.indexOf(",")+1, values.length);
			}else return false;
		}
		control = control + 1;
	}
	return "";
}

function getSelected(){
	var oRows = document.getElementById("gridParams").rows;
	var parValues = "";
	if (oRows != null) {
		var result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd = oRow.cells[0];
			var oTdChk = oRow.cells[4];
			var chkbox = oTdChk.getElementsByTagName("INPUT")[0];
			arr = new Array();
			arr[0] = oTd.getAttribute("busClaParId");
			arr[1] = oTd.getAttribute("busClaParName");
			arr[2] = oTd.getAttribute("busClaParType");
			arr[3] = chkbox.checked;
			arr[4] = oRow.getElementsByTagName("INPUT")[1].value;
			result[i] = arr;
			
			if (parValues==""){
				parValues = arr[0] + "-" + arr[1] + "-" + arr[2] + "-" + arr[3] + "-" + arr[4];
			}else{
				parValues = parValues + "," + arr[0] + "-" + arr[1] + "-" + arr[2] + "-" + arr[3] + "-" + arr[4];			
			}
		}
		saveParamsInBean(parValues);
		return result;
	} else {
		return null;
	}
}

function saveParamsInBean(busClaParValues){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "biDesigner.WidgetAction.do?action=saveBusClaPar"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	
	var str = "busClaParValues=" + busClaParValues;
	http_request.send(str);
	    
	//if (http_request.readyState == 4) {
   	//   if (http_request.status == 200) {
    //       if(http_request.responseText != "NOK"){
    //          
	//		}
	//	} else {
    //          return "NOK";
    //       }
	//}else{
    //     return "Could not contact the server.";  
	//}
}

function enableConfirm() {
	var oRows = document.getElementById("gridParams").selectedItems;
	document.getElementById("btnConf").disabled = (oRows == null) || (oRows.length == 0);
}

function unselOthers(el){
	var oRows = document.getElementById("gridParams").rows;
	if (oRows != null) {
		var result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd = oRow.cells[4];
			var input=oTd.getElementsByTagName("INPUT")[0];
			if(input && input!=el){
				input.checked=false;
			}
		}
	}
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>