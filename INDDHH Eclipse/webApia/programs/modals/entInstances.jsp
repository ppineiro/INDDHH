<%@page import="com.dogma.vo.*"%><%@page import="java.util.ArrayList"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %><jsp:useBean id="gBean" scope="session" class="com.dogma.bean.GenericBean"></jsp:useBean><% 

boolean onlyOne = request.getParameter("onlyOne") != null; 
Integer busEntId = new Integer(request.getParameter("busEntId")); 

//--- get the attributes setted for this entity
BusEntityVo busEntVo = gBean.getBusEntityVo(environmentId,busEntId);

ArrayList arrAtts = new ArrayList();

if(busEntVo.getAttStr1Name()!=null){
	String[] arr = {busEntVo.getAttStr1Name(),"attStr1"};
	arrAtts.add(arr);
}
if(busEntVo.getAttStr2Name()!=null){
	String[] arr = {busEntVo.getAttStr2Name(),"attStr2"};
	arrAtts.add(arr);
}
if(busEntVo.getAttStr3Name()!=null){
	String[] arr = {busEntVo.getAttStr3Name(),"attStr3"};
	arrAtts.add(arr);
}
if(busEntVo.getAttStr4Name()!=null){
	String[] arr = {busEntVo.getAttStr4Name(),"attStr4"};
	arrAtts.add(arr);
}
if(busEntVo.getAttStr5Name()!=null){
	String[] arr = {busEntVo.getAttStr5Name(),"attStr5"};
	arrAtts.add(arr);
}

if(busEntVo.getAttNum1Name()!=null){
	String[] arr = {busEntVo.getAttNum1Name(),"attNum1"};
	arrAtts.add(arr);
}
if(busEntVo.getAttNum2Name()!=null){
	String[] arr = {busEntVo.getAttNum2Name(),"attNum2"};
	arrAtts.add(arr);
}
if(busEntVo.getAttNum3Name()!=null){
	String[] arr = {busEntVo.getAttNum3Name(),"attNum3"};
	arrAtts.add(arr);
}

if(busEntVo.getAttDte1Name()!=null){
	String[] arr = {busEntVo.getAttDte1Name(),"attDte1"};
	arrAtts.add(arr);
}
if(busEntVo.getAttDte2Name()!=null){
	String[] arr = {busEntVo.getAttDte2Name(),"attDte2"};
	arrAtts.add(arr);
}
if(busEntVo.getAttDte3Name()!=null){
	String[] arr = {busEntVo.getAttDte3Name(),"attDte3"};
	arrAtts.add(arr);
}


%></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titInsEnt")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtFil")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeIdeEnt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeIdeEnt")%>:</td><td><input name="txtPre" size=5 maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPre")%>"><input name="txtNum" size=9 maxlength="9" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNumero")%>"><input name="txtSuf" size=5 maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblSuf")%>"></td><td></td><td></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")%></DIV><div type="grid" id="gridForms" style="height:80px" onselect="enableConfirm()"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:50px" title="<%=LabelManager.getToolTip(labelSet,"lblPre")%>"><%=LabelManager.getName(labelSet,"lblPre")%></th><th style="width:80px" title="<%=LabelManager.getToolTip(labelSet,"lblNumero")%>"><%=LabelManager.getName(labelSet,"lblNumero")%></th><th style="width:50px" title="<%=LabelManager.getToolTip(labelSet,"lblSuf")%>"><%=LabelManager.getName(labelSet,"lblSuf")%></th><%
				   				for(int i=0; i<arrAtts.size(); i++) {
				   					out.println("<td style='width:100px' title='" + ((String[])(arrAtts.get(i)))[0] + "'>" + ((String[])(arrAtts.get(i)))[0] + "</td>");
				   				}
								%></tr></thead><tbody ></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD><button type="button" onclick="btnSearch_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></TD><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="rigth"><button type="button" disabled id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}	

function btnSearch_click(){
	document.getElementById("gridForms").clearTable();
	doXMLLoad();
}

function doXMLLoad(){
	var sXMLSourceUrl = "entInstancesXML.jsp?busEntId=<%=busEntId%>";
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
					var oTdPre = document.createElement("TD");
					var oTdNum = document.createElement("TD");
					var oTdPos = document.createElement("TD");
					<%
						for(int i=0; i<arrAtts.size(); i++) {
				   			out.println("var oTd" + (i+1) + " = document.createElement(\"TD\");");
				   		}
					%>
	
					 
					
				
					oTd0.innerHTML = "<input type='checkbox' onClick='enableConfirm()' name='chk' <% if (onlyOne) { %>onclick='selectOneChk(this)'<% } %>>";
					oTd0.formId = xRow.childNodes[0].text;
					oTd0.formName = xRow.childNodes[1].text;
				
					oTdPre.innerText = xRow.childNodes[0].text;
					oTdNum.innerText = xRow.childNodes[1].text;
					oTdPos.innerText = xRow.childNodes[2].text;
					<%
						for(int i=0; i<arrAtts.size(); i++) {
				   			out.println("oTd" + (i+1) + ".innerText = xRow.childNodes[" + (i+3) + "].text;");
				   		}
					%>
			
			
					oTr.appendChild(oTd0);
					oTr.appendChild(oTdPre);
					oTr.appendChild(oTdNum);
					oTr.appendChild(oTdPos);
					
					<%
						for(int i=0; i<arrAtts.size(); i++) {
				   			out.println("oTr.appendChild(oTd" + (i+1) + ");");
				   		}
					%>
					

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


function getSelected(){
	var oRows = document.getElementById("gridForms").selectedItems;
	if (oRows != null) {
		var result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd = oRow.cells[0];
			arr = new Array();
			
			arr[0] = oTd.formId;
			arr[1] = oTd.formName;
			
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
</script>