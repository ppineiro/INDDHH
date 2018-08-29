<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %><% boolean onlyOne = request.getParameter("onlyOne") != null; %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titUsu")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtFil")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblLog")%>"><%=LabelManager.getNameWAccess(labelSet,"lblLog")%>:</td><td><input name="txtLog" id="txtLog" maxlength="20" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblLog")%>"></td><%if(request.getParameter("external")==null){%><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtNom" id="txtNom" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>"></td><%} else {%><td><input type=hidden name="txtNom" id="txtNom" id="txtNom"></td><td></td><%}%></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")%></DIV><div class="tableContainerNoHScroll" style="height:130px;" type="grid" id="grid" onselect="enableConfirm()"><table width="300px" cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:60px" title="<%=LabelManager.getToolTip(labelSet,"lblLog")%>"><%=LabelManager.getName(labelSet,"lblLog")%></th><th style="width:110px" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblEma")%>"><%=LabelManager.getName(labelSet,"lblEma")%></th></tr></thead><tbody class="scrollContent"></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD><button type="button" onclick="btnSearch_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></TD><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="right"><button type="button" disabled id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button></TD><TD align="right"><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
var external = <%=request.getParameter("external")%>;
var onlyActive = <%=request.getParameter("onlyActive")%>;

function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}	

function btnSearch_click(){
	document.getElementById("grid").clearTable();
	doXMLLoad();
}

function doXMLLoad(){
	var sXMLSourceUrl = "<%=Parameters.ROOT_PATH%>/programs/modals/usersXML.jsp?login=" + escape(document.getElementById("txtLog").value) + "&name=" + escape(document.getElementById("txtNom").value) + "&external=<%=request.getParameter("external")%>&environment=<%=request.getParameter("environment")%>&usrLogin=<%=request.getParameter("usrLogin")%>&currentUser=<%=request.getParameter("currentUser")%>&startDate=<%=request.getParameter("startDate")%>&endDate=<%=request.getParameter("endDate")%>";
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
					for(var u=0;u<4;u++){
						var td=document.createElement("TD");
						oTr.appendChild(td);
					}
					var oTd0 = oTr.getElementsByTagName("TD")[0]; 
					var oTd1 = oTr.getElementsByTagName("TD")[1]; 
					var oTd2 = oTr.getElementsByTagName("TD")[2]; 
					var oTd3 = oTr.getElementsByTagName("TD")[3]; 
			
					oTd0.innerHTML = "<input type='hidden' name='chk'>";
					
					var login=(xRow.childNodes[1] && xRow.childNodes[1].firstChild)?xRow.childNodes[1].firstChild.nodeValue:"";
					var name=(xRow.childNodes[0] && xRow.childNodes[0].firstChild)?xRow.childNodes[0].firstChild.nodeValue:"";
					var email=(xRow.childNodes[2] && xRow.childNodes[2].firstChild)?xRow.childNodes[2].firstChild.nodeValue:"";
					var comm;
					var active="true";
					if (external==null){
						active=(xRow.childNodes[3] && xRow.childNodes[3].firstChild)?xRow.childNodes[3].firstChild.nodeValue:"true";
					}else {
						comm=(xRow.childNodes[3] && xRow.childNodes[3].firstChild)?xRow.childNodes[3].firstChild.nodeValue:"";
					}
					oTd0.setAttribute("usrLogin", login);
					oTd0.setAttribute("usrName",name);
					if(xRow.childNodes[2].childNodes.length>0){
						oTd0.setAttribute("usrEmail",email);
						oTd3.innerHTML = email;
					}else{
						oTd0.setAttribute("usrEmail","");
						oTd3.innerHTML = "&nbsp;";
					}
					if(external!=null){
						oTd0.setAttribute("usrComm",comm);
					}
			
					oTd1.innerHTML = login;
					oTd2.innerHTML = name;
					if (onlyActive!=null && onlyActive && active=="false"){
						continue;
					}else {
						document.getElementById("grid").addRow(oTr);
					}
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
			arr[0] = oTd.getAttribute("usrLogin");
			arr[1] = oTd.getAttribute("usrName");
			arr[2] = oTd.getAttribute("usrEmail");
			if(external!=null){
				arr[3] = oTd.getAttribute("usrComm");
			}
			result[i] = arr;
		}
		return result;
	} else {
		return null;
	}
}

function enableConfirm() {
	var oRows = document.getElementById("grid").selectedItems;
	document.getElementById("btnConf").disabled = (oRows == null) || (oRows.length == 0);
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>