<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body onload="doXMLLoad()"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titQryColumns")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtCol")%></DIV><div type="grid" id="gridParams" style="height:180px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblQryColName")%>"><%=LabelManager.getName(labelSet,"lblQryColName")%></th><th style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblType")%>"><%=LabelManager.getName(labelSet,"lblType")%></th><th style="width:70px" title="<%=LabelManager.getToolTip(labelSet,"lblHidden")%>"><%=LabelManager.getName(labelSet,"lblHidden")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblWidParValue")%>"><%=LabelManager.getName(labelSet,"lblWidParValue")%></th></tr></thead><tbody></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="rigth"><button type="button" disabled id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}	

function doXMLLoad(){
	var sXMLSourceUrl = "queryUserColumnsXML.jsp?qryId="+<%= request.getParameter("qryId")%>;
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
	if (xmlRoot.nodeName != "EXCEPTION") {
		if (xmlRoot.childNodes.length == 0) {
			document.getElementById("noData").style.display="block";
		} else {
			
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
	
					var oTd0 = document.createElement("TD"); //Id oculto
					var oTd1 = document.createElement("TD"); //Columna
					var oTd2 = document.createElement("TD"); //Tipo
					var oTd3 = document.createElement("TD"); //Oculta
					var oTd4 = document.createElement("TD"); //Usa widget
					
					var qryColumnId = xRow.childNodes[0].firstChild.nodeValue;
					var qryColumnName = xRow.childNodes[1].firstChild.nodeValue;
					var qryColumnType = xRow.childNodes[2].firstChild.nodeValue;
					var qryColumnHidden = xRow.childNodes[3].firstChild.nodeValue;
				
					oTd0.innerHTML = "<input type='checkbox' name='chk'>";
					oTd0.setAttribute("qryColumnId",qryColumnId);
					oTd0.setAttribute("qryColumnName",qryColumnName);
					oTd0.setAttribute("qryColumnType",qryColumnType);
					oTd0.setAttribute("qryColumnHidden",qryColumnHidden);
					
					oTd1.innerHTML = qryColumnName;

					if (qryColumnHidden == "true"){
						oTd3.innerHTML = "<input type='checkbox' name='chkHidden' checked disabled>";
					}else{
						oTd3.innerHTML = "<input type='checkbox' name='chkHidden' disabled>";
					}
					
					if (qryColumnType == "<%=AttributeVo.TYPE_NUMERIC%>"){
						foundNumericValue = true;
						oTd2.innerHTML = "<%=LabelManager.getName(labelSet,"lblNum")%>";
						if (qryColumnName == "<%=request.getParameter("widQryCol")%>"){
							oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' checked onClick='unselOthers(this)'>";
						}else{
							oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' onClick='unselOthers(this)'>";
						}
					}else if (qryColumnType == "<%=AttributeVo.TYPE_STRING%>"){
						oTd2.innerHTML = "<%=LabelManager.getName(labelSet,"lblStr")%>";
						oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' disabled>";
					}else if (qryColumnType == "<%=AttributeVo.TYPE_DATE%>"){
						oTd2.innerHTML = "<%=LabelManager.getName(labelSet,"lblFec")%>";
						oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' disabled>";					
					}else if (qryColumnType == "<%=AttributeVo.TYPE_INT%>"){
						oTd2.innerHTML = "<%=LabelManager.getName(labelSet,"lblInt")%>";
						if (forWidget == "true"){
							oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' checked onClick='unselOthers(this)'>";					
						}else{
							oTd4.innerHTML = "<input type='checkbox' name='chkWidParVal' onClick='unselOthers(this)'>";	
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
	
	if (!foundNumericValue){
		window.returnValue="-1";
		window.close();
	}
	xmlRoot = "";
	sXmlResult = "";
}		

function getSelected(){
	var oRows = document.getElementById("gridParams").rows;
	if (oRows != null) {
		var result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd = oRow.cells[0];
			var oTdChk = oRow.cells[4];
			var chkbox = oTdChk.getElementsByTagName("INPUT")[0];
			arr = new Array();
			if (chkbox.checked){
				arr[0] = oTd.getAttribute("qryColumnName");
				result[0] = arr;
				return result;
			}
		}
		
	} else {
		return null;
	}
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
	enableConfirm();
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>