<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %><% boolean onlyOne = request.getParameter("onlyOne") != null; %></head><body onload="doXMLLoad(1)"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titVwProAttsAsoc")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"titAtr")%></DIV><div multiSelect="false" type="grid" id="gridForms" style="height:280px" onselect="enableConfirm()"><table width="800px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblAtt")%>"><%=LabelManager.getName(labelSet,"lblAtt")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getName(labelSet,"lblDes")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblTip")%>"><%=LabelManager.getName(labelSet,"lblTip")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblFomEnt")%>"><%=LabelManager.getName(labelSet,"lblFomEnt")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"titObligatory")%>"><%=LabelManager.getName(labelSet,"titObligatory")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMapEntity")%>"><%=LabelManager.getName(labelSet,"lblMapEntity")%></th><th style="width:400px" title="<%=LabelManager.getToolTip(labelSet,"titTar")%>"><%=LabelManager.getName(labelSet,"titTar")%></th></tr></thead><tbody></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><COL class="col5"><COL class="col6"><COL class="col7"><COL class="col8"><TR><TD><button type="button" id="getFirst" onclick="btnGetFirst()" disabled title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>"><<</button></TD><TD><button type="button" id="getPrev" onclick="btnGetPrev()" disabled title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>"><</button></TD><TD><input name="pageNum" id="pageNum" type="hidden" name="page" value="1"></input></TD><td><input id="actPage" value="1" style="width:22px;max-width:22px;text-align:right;" name="goToPage" onkeypress="goToPage(event)"></input></td><td id="ofPages"><td><TD><button type="button" id="getNext" onclick="btnGetNext()" disabled title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>">></button></TD><TD><button type="button" id="getLast" onclick="btnGetLast()" disabled title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>">>></button></TD><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="rigth"><button type="button" disabled id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"lblAddAsDim")%>"><%=LabelManager.getNameWAccess(labelSet,"lblAddAsDim")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}
function btnSearch_click(){
	document.getElementById("gridForms").clearTable();
	doXMLLoad(1);
}

function doXMLLoad(page){
	var sXMLSourceUrl = "processAttsForBIXML.jsp?proId=" + <%= request.getParameter("proId") %> + "&busEntId=" + <%= request.getParameter("busEntId") %> + "&envId=" +  <%= request.getParameter("envId") %> + "&page="+page;
	var listener=new Object();
	listener.onLoad=function(xml){
		if (isXMLOk(xml)) {
			readDocXML(page,xml);
		}
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}
var cantPages;
var cantRows;
var actPage;

function readDocXML(page,XmlResult){
	document.getElementById("gridForms").clearTable();
	var xmlRoot=getXMLRoot(XmlResult);
	//Si estamos en la ultima pagina deshabilitamos el boton siguiente y ultimo
	if (<%=Parameters.MAX_RESULT_MODAL %> >= xmlRoot.childNodes.length){
		document.getElementById("getNext").disabled = true;
		document.getElementById("getLast").disabled = true;
	}
	//Si estamos en la primer pagina deshabilitamos el boton anterior
	if (page == 1){
		document.getElementById("getPrev").disabled = true;
		document.getElementById("getFirst").disabled = true;
		actPage=1;
	}
	document.getElementById("moreData").style.display="none";
	document.getElementById("noData").style.display="none";
	if (xmlRoot.nodeName != "EXCEPTION") {
		if (xmlRoot.childNodes.length == 0) {
			document.getElementById("noData").style.display="block";
		} else {
			xRow = xmlRoot.childNodes[0];
			cantPages = xRow.childNodes[0].firstChild.nodeValue; //Cant pages
			cantRows = xRow.childNodes[1].firstChild.nodeValue; //Cant rows
			for(i=1;i<xmlRoot.childNodes.length;i++){
				if (i >= <%=Parameters.MAX_RESULT_MODAL %>) {
					document.getElementById("moreData").style.display="block";
					document.getElementById("getNext").disabled = false;
					document.getElementById("actPage").value = page;
					document.getElementById("ofPages").innerHTML = "<span style='white-space:nowrap;'><%=LabelManager.getName(labelSet,"lblNavOf")%>" + " " + cantPages+"</span>";
					document.getElementById("getLast").disabled = false;
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
					var oTd5 = document.createElement("TD"); 
					var oTd6 = document.createElement("TD"); 
					var oTd7 = document.createElement("TD"); 
					var oTd8 = document.createElement("TD"); 
				
					oTd0.innerHTML = "<input type='hidden' onClick='enableConfirm()' name='chk' <% if (onlyOne) { %>onclick='selectOneChk(this)'<% } %>>";
					oTd0.setAttribute("attId",xRow.childNodes[0].firstChild.nodeValue);
					oTd0.innerHTML = xRow.childNodes[0].firstChild.nodeValue;
					oTd0.style.display="none";
					
					oTd1.setAttribute("attName",xRow.childNodes[1].firstChild.nodeValue);
					oTd1.innerHTML = xRow.childNodes[1].firstChild.nodeValue;
					
					if (xRow.childNodes[2].firstChild != null){
						oTd2.setAttribute("attDesc",xRow.childNodes[2].firstChild.nodeValue);
						oTd2.innerHTML = xRow.childNodes[2].firstChild.nodeValue;
					}else{
						oTd2.setAttribute("attDesc",null);
						oTd2.innerHTML = "";
					}
					
					oTd3.setAttribute("attType",xRow.childNodes[3].firstChild.nodeValue);
					if ("S" == xRow.childNodes[3].firstChild.nodeValue){
						oTd3.innerHTML = "<%=LabelManager.getName(labelSet,"lblStr")%>";				
					}else if ("N" == xRow.childNodes[3].firstChild.nodeValue){
						oTd3.innerHTML = "<%=LabelManager.getName(labelSet,"lblNum")%>";
					}else{
						oTd3.innerHTML = "<%=LabelManager.getName(labelSet,"lblFec")%>";
					}
					
					
					if (xRow.childNodes[4].firstChild != null){
						oTd4.setAttribute("attForm",xRow.childNodes[4].firstChild.nodeValue);
						oTd4.innerHTML = xRow.childNodes[4].firstChild.nodeValue;
					}else{
						oTd4.setAttribute("attForm",null);
						oTd4.innerHTML = "";
					}
					
					if (xRow.childNodes[5].firstChild != null){
						oTd5.setAttribute("attOblig",xRow.childNodes[5].firstChild.nodeValue);
						oTd5.innerHTML = xRow.childNodes[5].firstChild.nodeValue;
						if ("true"==oTd5.innerHTML){
							oTd5.style.color="red";
						}
					}else{
						oTd5.setAttribute("attOblig",null);
						oTd5.innerHTML = "";
					}
					
					if (xRow.childNodes[6].firstChild != null){
						oTd6.setAttribute("attMapEntId",xRow.childNodes[6].firstChild.nodeValue);
						oTd6.innerHTML = xRow.childNodes[6].firstChild.nodeValue;
					}else{
						oTd6.setAttribute("attMapEntId",null);
						oTd6.innerHTML = "";
					}
					oTd6.style.display="none";
					
					if (xRow.childNodes[7].firstChild != null){
						oTd7.setAttribute("attMapEnt",xRow.childNodes[7].firstChild.nodeValue);
						oTd7.innerHTML = xRow.childNodes[7].firstChild.nodeValue;
					}else{
						oTd7.setAttribute("attMapEnt",null);
						oTd7.innerHTML = "";
					}
					
					if (xRow.childNodes[8].firstChild != null){
						oTd8.setAttribute("attProTsks",xRow.childNodes[8].firstChild.nodeValue);
						oTd8.innerHTML = xRow.childNodes[8].firstChild.nodeValue;
					}else{
						oTd8.setAttribute("attProTsks",null);
						oTd8.innerHTML = "";
					}
				
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					oTr.appendChild(oTd3);
					oTr.appendChild(oTd4);
					oTr.appendChild(oTd5);
					oTr.appendChild(oTd6);
					oTr.appendChild(oTd7);
					oTr.appendChild(oTd8);

					document.getElementById("gridForms").addRow(oTr);
				}
			}
		}
	}else{
		alert("error occurred");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}

function btnGetFirst(){
	//document.getElementById("pageNum").value = 	1;
	actPage = 1;
	doXMLLoad(actPage);
	document.getElementById("getPrev").disabled = true;
	document.getElementById("getLast").disabled = false;
	document.getElementById("getNext").disabled = false;
	document.getElementById("getFirst").disabled = true;
}		

function btnGetPrev(){
	//document.getElementById("pageNum").value = 	parseInt(document.getElementById("pageNum").value) - 1;
	actPage = parseInt(actPage) - 1;
	doXMLLoad(actPage);
	document.getElementById("getNext").disabled = false;
}

function btnGetNext(){
	//document.getElementById("pageNum").value = 	parseInt(document.getElementById("pageNum").value) + 1;
	actPage = parseInt(actPage) + 1;
	doXMLLoad(actPage);
	document.getElementById("getPrev").disabled = false;
	document.getElementById("getFirst").disabled = false;
}

function btnGetLast(){
	//document.getElementById("pageNum").value = cantPages;
	actPage = cantPages;
	doXMLLoad(actPage);
	document.getElementById("getLast").disabled = true;
	document.getElementById("getNext").disabled = true;
	document.getElementById("getPrev").disabled = false;
	document.getElementById("getFirst").disabled = false;
}	

function getSelected(){
	var oRows = document.getElementById("gridForms").selectedItems;
	if (oRows != null) {
		var result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd0 = oRow.getElementsByTagName("TD")[0]; //Id del atributo
			var oTd1 = oRow.getElementsByTagName("TD")[1]; //Nombre del atributo
			var oTd2 = oRow.getElementsByTagName("TD")[2]; //Desc del atributo
			var oTd3 = oRow.getElementsByTagName("TD")[3]; //Tipo del atributo
			var oTd6 = oRow.getElementsByTagName("TD")[6]; //Id de la entidad de mapeo
			var oTd7 = oRow.getElementsByTagName("TD")[7]; //nombre de la entidad de mapeo
			
			arr = new Array();
			
			arr[0] = oTd0.getAttribute("attId");
			arr[1] = oTd1.getAttribute("attName");
			arr[2] = oTd2.getAttribute("attLabel");
			arr[3] = oTd3.getAttribute("attType");
			arr[4] = oTd6.getAttribute("attMapEntId");
			arr[5] = oTd7.getAttribute("attMapEnt");
			
			result[i] = arr;
		}
		return result;
	} else {
		return null;
	}
}

function enableConfirm() {
	var oRows = document.getElementById("gridForms").selectedItems;
	document.getElementById("btnConf").disabled = (oRows == null) || (oRows.length == 0);
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}

function goToPage(evt){
	var input=getEventSource(evt);
	evt=getEventObject(evt);
	evt.cancelBubble=true;
	input.focus();
	var value=parseInt(input.value);
	if(evt.keyCode == 13){
		if (value != 1){
			document.getElementById("getPrev").disabled = false;
			document.getElementById("getFirst").disabled = false;
		}else{
			document.getElementById("getPrev").disabled = true;
			document.getElementById("getFirst").disabled = true;
		}
		if(value && parseInt(input.value)!=0){
			if(value<1 || value>parseInt(cantPages)){
				value=cantPages;
			}
			actPage = value;
			document.getElementById("actPage").value = actPage;
			doXMLLoad(actPage);
		}
	}else{
		var func=function(){if( ((input.value*0)!=0) || (input.value<=0) || (input.value==0) ){input.value=cantPages;}}
		setTimeout(func,300);
	}
}
</script>