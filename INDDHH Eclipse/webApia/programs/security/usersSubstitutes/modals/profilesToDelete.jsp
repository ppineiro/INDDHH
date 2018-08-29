<%@page import="com.dogma.vo.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titPrf")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><div class="tableContainerNoHScroll" style="height:210px;" type="grid" id="grid"><table width="300px" cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr height="0px"><th class="sortable" style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"><input type="checkbox" onclick="chkAllGrid(event,'chk')" ></th><th class="sortable" style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th></tr></thead><tbody class="scrollContent"><tr style="visibility:hidden;"><td style="width:0px;display:none;" height="0px"><input type="checkbox"></td><td style="width:100%;" height="0px"><div></div></td></tr></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="right"><button type="button" id="btnViewFun" onclick="btnViewFun_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnViewFun")%>" title="<%=LabelManager.getToolTip(labelSet,"btnViewFun")%>"><%=LabelManager.getNameWAccess(labelSet,"btnViewFun")%></button></TD><TD align="right"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button></TD><TD align="right"><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../../components/scripts/server/endInc.jsp" %><script language="javascript">
window.onload=function(){
		document.getElementById("grid").clearTable();
		doXMLLoad();
}

function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}	


function doXMLLoad(){
	var sXMLSourceUrl = "<%=Parameters.ROOT_PATH%>/programs/security/usersSubstitutes/modals/poolProfilesXML.jsp?poolId=<%=request.getParameter("poolId")%>";

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
	var xmlRoot = getXMLRoot(sXmlResult);
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
					var oTr=document.createElement("TR");
					oTr.style.visibility="";
					for(var u=0;u<2;u++){
						var td=document.createElement("TD");
						oTr.appendChild(td);
					}
					var oTd0 = oTr.getElementsByTagName("TD")[0]; 
					var oTd1 = oTr.getElementsByTagName("TD")[1]; 
			
					
					var checked = xRow.childNodes[2].firstChild.nodeValue;
					if(checked=="true"){
						oTd0.innerHTML = "<input type='checkbox' name='chk' checked>";
					}
					else{
						oTd0.innerHTML = "<input type='checkbox' name='chk'>";
					}	
					
					var id=(xRow.childNodes[0] && xRow.childNodes[0].firstChild)?xRow.childNodes[0].firstChild.nodeValue:"";
					var name=(xRow.childNodes[1] && xRow.childNodes[1].firstChild)?xRow.childNodes[1].firstChild.nodeValue:"";
					oTd0.setAttribute("id", id);
					oTd0.setAttribute("name", name);

					oTd1.innerHTML = name;
					document.getElementById("grid").addRow(oTr);
				}
			}
		}
	}else{
		alert("An error occurred: " + xmlRoot.childNodes[0].nodeValue + " \nPlease contact system administrator.");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}		


function getSelected(){
	var oRows=document.getElementById("grid").selectedItems;
	if (oRows != null) {
		var result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd = oRow.cells[0];
			arr = new Array();
			arr[0] = oTd.getAttribute("id");
			arr[1] = oTd.getAttribute("name");
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

function btnViewFun_click(){
	var cant = chksChecked(document.getElementById("grid"));
	if(cant != 0) {
		var selected = document.getElementById("grid").selectedItems;
		var sel = selected[0];
		var prfId =	sel.getElementsByTagName("TD")[0].getAttribute("id");
		if(prfId!=null && !prfId==""){
			var ret = openModal("/security.UserSubstituteAction.do?action=openModal&prfId=" + prfId + windowId,450,500);
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

</script>