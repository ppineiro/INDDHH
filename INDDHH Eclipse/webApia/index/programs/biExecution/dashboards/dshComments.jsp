<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.BIParameters"%><%@include file="../../../components/scripts/server/startInc.jsp"%><jsp:useBean id="wBean" scope="session" class="com.dogma.bean.administration.WidgetBean"></jsp:useBean><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp"%><% Integer widId = null;
   Integer dshId = null;
   Collection comCol = null;
   WidgetVo widVo = null;
   
   if (request.getParameter("dshId") != null){ 
	   dshId = new Integer(request.getParameter("dshId"));
   }
   if (request.getParameter("widId") != null){ //from widgtet of type cube or query
	   widId = new Integer(request.getParameter("widId"));
   }else if (request.getParameter("gaugeID") != null){ //from widget of type kpi
	   widId = new Integer(request.getParameter("gaugeID"));
   }
   comCol = wBean.getWidComments(dshId, widId);
   widVo = wBean.getWidgetVo(widId);
%><title><%=LabelManager.getName(labelSet,"titWidComments").replace("<TOK1>", " '" + widVo.getWidTitle())+ "' "%></title></head><body style="overflow:auto" onload='document.getElementById("commentTable").scrollTop=document.getElementById("commentTable").scrollHeight;'><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titWidComments").replace("<TOK1>", " '" + widVo.getWidTitle())+ "' "%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div><div id="commentTable" style="height:230px;overflow:auto"><table><%=wBean.getGridOfComments(dshId, widId)%></table></div><table><tr><td><textarea name="txtComment" p_maxlength="true" value="" maxlength="255" onkeypress ="return pulsar(event)" cols=80 rows=6 title="<%=LabelManager.getToolTip("lblTxtAreComments")%>"></textarea></td><td><button type="button" onclick="btnAddComment_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet, "btnAgr")%></button></td><td><button type="button" onclick="btnDelAllComments_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDeleteAll")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDeleteAll")%>"><%=LabelManager.getNameWAccess(labelSet, "btnDeleteAll")%></button></td></tr></table></div></form></div><iframe name="gridSubmit" id="gridSubmit" style="display:none"></iframe><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD colspan=3 align="right"><button type="button" onclick="window.close()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp"%><script language='javascript'>
var MSG_DEL_ALL_COMMENTS = "<%=LabelManager.getName("msgDelAllComments")%>";
</script><script language='javascript'>

function pulsar(e){
	if (e.keyCode==13){
		return false;
	}else {
		return true;
	}

}

function btnDelAllComments_click(){
	if (confirm(MSG_DEL_ALL_COMMENTS)){
		var frm=document.getElementById("frmMain");
		var action=frm.action;
		var target=frm.target;
		frm.action="biExecution.DashboardAction.do?action=deleteAllComments&executeHere=true&dshId=<%=dshId%>&widId=<%=widId%>";
		frm.target="gridSubmit";
		frm.submit();
		frm.action=action;
		frm.target=target;
	}
}

function btnDelComments_click(){
	var frm=document.getElementById("frmMain");
	var action=frm.action;
	var target=frm.target;
	frm.action="biExecution.DashboardAction.do?action=deleteComments&executeHere=true&dshId=<%=dshId%>&widId=<%=widId%>";
	frm.target="gridSubmit";
	frm.submit();
	frm.action=action;
	frm.target=target;
}

function btnAddComment_click(){
	var text = document.getElementById("txtComment").value;
	if (text!="" && text != " "){
		var frm=document.getElementById("frmMain");
		var action=frm.action;
		var target=frm.target;
		frm.action="biExecution.DashboardAction.do?action=saveNewComment&executeHere=true&dshId=<%=dshId%>&widId=<%=widId%>";
		frm.target="gridSubmit";
		frm.submit();
		frm.action=action;
		frm.target=target;
	}
}

function afterAction(result){
	if (result.indexOf("NOK")<0){
		document.getElementById("commentTable").innerHTML = "<table>"+result+"</table>";
		document.getElementById("txtComment").value = "";
	}else {
		var msg = result.substring(4,result.length);
		alert(msg);
	}
	
	document.getElementById("commentTable").scrollTop=document.getElementById("commentTable").scrollHeight;
}
</script>
