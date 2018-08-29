<%@page import="com.dogma.vo.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %><% boolean onlyOne = request.getParameter("onlyOne") != null; %><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/grid.css" rel="styleSheet" type="text/css" media="screen"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/gridContextMenu.css" rel="styleSheet" type="text/css" media="screen"><script language="javascript" src="../../../scripts/grid/grids.js"></script></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titGru")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><div class="tableContainerNoHScroll" style="height:210px;" type="grid" id="grid"><table width="300px" cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr height="0px"><th class="sortable" style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"><input type="checkbox" onclick="chkAllGrid(event,'chk')" ></th><th class="sortable" style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblLog")%>"><%=LabelManager.getName(labelSet,"lblLog")%></th></tr></thead><tbody class="scrollContent"><tr style="visibility:hidden;"><td style="width:0px;display:none;" height="0px"><input type="checkbox"></td><td style="width:100%;" height="0px"><div></div></td></tr></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="right"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button></TD><TD align="right"><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../../components/scripts/server/endInc.jsp" %><script language="javascript">
window.onload=function(){
	document.getElementById("grid").clearTable();
	doXMLLoad();
}

function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}	


function clearTable(obj){
	var trs=obj.getElementsByTagName("TBODY")[0].getElementsByTagName("TR");
	for(var i=(trs.length-1);i>0;i--){
		var tr=trs[i].parentNode.removeChild(tr);
		tr.parentNode.removeChild(tr);
	}
}

function doXMLLoad(){
	var poolId = "<%= request.getParameter("poolId")%>";
	var sXMLSourceUrl = "<%=Parameters.ROOT_PATH%>/programs/security/usersSubstitutes/modals/substitutesXML.jsp?poolId=" + poolId;

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
					var oTr;
					oTr=document.createElement("TR");
					for(var a=0;a<2;a++){
						oTd=document.createElement("TD");
						oTr.appendChild(oTd);
					}
					document.getElementById("grid").updateScroll();
					oTr.style.visibility="";
					
					var oTd0 = oTr.getElementsByTagName("TD")[0]; 
					var oTd1 = oTr.getElementsByTagName("TD")[1]; 
					
					var valueChecked = xRow.childNodes[0].firstChild.nodeValue;
					if(valueChecked=='true'){
						oTd0.innerHTML = "<input type='checkbox' name='chk' checked>";
					}
					else{
						oTd0.innerHTML = "<input type='checkbox' name='chk' >";
					}
					oTd0.setAttribute("usrLogin",xRow.childNodes[1].firstChild.nodeValue);
					
					oTd1.innerHTML = xRow.childNodes[1].firstChild.nodeValue;
					document.getElementById("grid").addRow(oTr);
				}
			}
		}
	}else{
		alert("error occurred");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}		

function addRow(obj,otr){
	obj.getElementsByTagName("TBODY")[0].appendChild(otr);
}

function getSelected(){
	var oRows=document.getElementById("grid").selectedItems;
	if (oRows != null) {
		var result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd = oRow.cells[0];
			arr = new Array();
			arr[0] = oTd.getAttribute("usrLogin");
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