<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body onload="doXMLLoad()"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titQryFilters")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtFilters")%></DIV><div type="grid" id="gridParams" style="height:180px" onselect="enableConfirm()"><table width="600px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"lblQryColName")%>"><%=LabelManager.getName(labelSet,"lblQryColName")%></th><th style="width:80px" title="<%=LabelManager.getToolTip(labelSet,"lblType")%>"><%=LabelManager.getName(labelSet,"lblType")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblValue")%>"><%=LabelManager.getName(labelSet,"lblValue")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblReq")%>"><%=LabelManager.getName(labelSet,"lblReq")%></th></tr></thead><tbody></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="rigth"><button type="button" disabled id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	var ret = getSelected();
	if (ret != "ERROR"){
		window.returnValue= ret;
		window.close();
	}
}	

function doXMLLoad(){
	var sXMLSourceUrl = "<%=Parameters.ROOT_PATH%>/programs/modals/queryUserFiltersXML.jsp?qryId="+<%= request.getParameter("qryId")%>;
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
	var isNew = "true" == "<%= request.getParameter("isNew")%>";
	var foundParValue = false;
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
	
					var oTd0 = document.createElement("TD"); //sel
					var oTd1 = document.createElement("TD"); //colName 
					var oTd2 = document.createElement("TD"); //colType
					var oTd3 = document.createElement("TD"); //colvalue
					var oTd4 = document.createElement("TD"); //colRequired
					
					var qryColId = xRow.childNodes[0].firstChild.nodeValue;
					var qryColName = xRow.childNodes[1].firstChild.nodeValue;
					var qryColType = xRow.childNodes[2].firstChild.nodeValue;
					var qryColValue = "";
					if (isNew && xRow.childNodes[3].firstChild != null) qryColValue =  xRow.childNodes[3].firstChild.nodeValue;
					var qryColRequired = xRow.childNodes[4].firstChild.nodeValue;
					var qryFilterValue = "";
				
					oTd0.innerHTML = "<input type='checkbox' name='chk' onClick='enableConfirm()'>";
					oTd0.setAttribute("qryColId", qryColId);
					oTd0.setAttribute("qryColName", qryColName);
					oTd0.setAttribute("qryColType", qryColType);
					oTd0.setAttribute("qryColValue", qryColValue);
					oTd0.setAttribute("qryColRequired", qryColRequired);
					
					if (qryColRequired == "true"){
						oTd0.setAttribute("qryColReqTranslated","<%=LabelManager.getName(labelSet,"lblYes")%>");
					}else{
						oTd0.setAttribute("qryColReqTranslated","<%=LabelManager.getName(labelSet,"lblNo")%>");
					}
					
					oTd1.innerHTML = qryColName;
					var type = qryColType;
					
					if (qryColType == "<%=AttributeVo.TYPE_STRING%>"){
						qryColType = "<%=LabelManager.getName(labelSet,"lblStr")%>";
					}else if (qryColType == "<%=AttributeVo.TYPE_NUMERIC%>"){
						qryColType = "<%=LabelManager.getName(labelSet,"lblNum")%>";
					}else {
						qryColType = "<%=LabelManager.getName(labelSet,"lblFec")%>";
					}
					oTd2.innerHTML = qryColType;
					
					qryFilterValue = getFilterValue("<%=request.getParameter("filterParams")%>",qryColId, qryColValue);
					
					if (type == "<%=AttributeVo.TYPE_NUMERIC%>"){
						oTd3.innerHTML = "<input id='value' name='value' p_numeric='true' onChange='enableConfirm()' value='" + qryFilterValue + "'>";
					}else{
						oTd3.innerHTML = "<input id='value' name='value' onChange='enableConfirm()' value='" + qryFilterValue + "'>";
					}
					
					oTd4.innerHTML = qryColRequired;
			
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
	
	xmlRoot = "";
	sXmlResult = "";
}		

//values: "qryColId-qryColType-qryColValue,qryColId-qryColType-qryColValue,.."
function getFilterValue(values, parId, defValue){
	var fin = 0;
	var control = 0;// Control por si la funcion llega a quedar en loop
	while (values.indexOf("-")>0){
		if (control == 100) return "";
		var qryColId = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var qryColName = values.substring(0,values.indexOf("-"));
		values = values.substring(values.indexOf("-")+1, values.length);
		var qryColType = values.substring(0,values.indexOf("-"));
		if (qryColId == parId){
			values = values.substring(values.indexOf("-")+1, values.length);
			if (values.indexOf(",")>=0){
				return values.substring(0,values.indexOf(","));
			}else{
				return values;
			}
		}else{
			if (values.indexOf(",")>0){
				values = values.substring(values.indexOf(",")+1, values.length);
			}else return defValue;
		}
		control = control + 1;
	}
	return defValue;
}

function getSelected(){
	var oRows = document.getElementById("gridParams").rows;
	var filValues = "";
	if (oRows != null) {
		var result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd = oRow.cells[0];
			arr = new Array();
			arr[0] = oTd.getAttribute("qryColId");
			arr[1] = oTd.getAttribute("qryColName");
			arr[2] = oTd.getAttribute("qryColType");
			arr[3] = oRow.getElementsByTagName("INPUT")[1].value;
			var req = oTd.getAttribute("qryColRequired");
			
			if (arr[3] == "" && (req == "true" || req==true)){
				alert('<%=LabelManager.getName(labelSet,"msgMusEntColValue")%>'.replace("<TOK1>",arr[1]));
				return "ERROR";
			}
			result[i] = arr;
			
			if (filValues==""){
				filValues = arr[0] + "-" + arr[1] + "-" + arr[2] + "-" + arr[3];
			}else{
				filValues = filValues + "," + arr[0] + "-" + arr[1] + "-" + arr[2] + "-" + arr[3];			
			}
		}
		saveFiltersInBean(filValues);
		return result;
	} else {
		return null;
	}
}

function saveFiltersInBean(filterValues){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "biDesigner.WidgetAction.do?action=saveFilterVals"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	
	var str = "filterValues=" + filterValues;
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

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>