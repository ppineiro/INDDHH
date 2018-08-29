<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %><% 
   String props = request.getParameter("props"); 
   String prpsArr[] = props.split(";");
   String agrupationName = prpsArr[0];
%></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titDimProperties")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"titProps")%></DIV><table class="tblFormLayout"><tr><td title="<%=LabelManager.getToolTip(labelSet,"flaPropAllMemberName")%>"><%=LabelManager.getNameWAccess(labelSet,"flaPropAllMemberName")%>:</td><td><input p_required=true name="txtAllMemberName" id="txtAllMemberName" maxlength="50" onChange="checkAllMembName()" accesskey="<%=LabelManager.getAccessKey(labelSet,"flaPropAllMemberName")%>" type="text" value="<%=agrupationName%>"></td></tr></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="rigth"><button type="button" <%=(agrupationName=="")?"disabled":""%> id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" id="btnExit" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script>
MSG_MUST_ENT_ALL_MEM_NAME = "<%=LabelManager.getName(labelSet,"msgAllMemNamNotFound")%>";

</script><script language="javascript">

function checkAllMembName(){
	if (document.getElementById("txtAllMemberName").value != ""){
		document.getElementById("btnConf").disabled = false;
		document.getElementById('btnExit').focus() 
	}else {
		document.getElementById("btnConf").disabled = true;
	}
}

function btnConf_click() {
	if (checkProps()){
		window.returnValue=getSelected();
		window.close();
	}
}	

function isAValidName(s){
	var re = new RegExp("^[a-z A-Z0-9_./]*$");
	if (!s.match(re)) {
		alert(GNR_INVALID_NAME);
		return false;
	}
	return true;
}

function checkProps() {
// 	if (document.getElementById("txtAllMemberName").value == ""){
// 		alert(MSG_MUST_ENT_ALL_MEM_NAME);
// 		return false;
// 	}
	
	if(!isAValidName(document.getElementById("txtAllMemberName").value)){
		return false;
	}
	
	return true;
}

function getSelected(){
	var prps = document.getElementById("txtAllMemberName").value;
	//Cuando haya mas props devolverlas separadas por ;
	return prps;
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>