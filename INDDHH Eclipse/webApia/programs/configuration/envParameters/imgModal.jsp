<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><script>

var LBL_ADDIMAGE		="<%=LabelManager.getName(labelSet,"sbtImages")%>";
var LBL_NAME			="<%=LabelManager.getName(labelSet,"lblNom")%>";
var LBL_DESCRIPTION		="<%=LabelManager.getNameWAccess(labelSet,"lblDes")%>";
var LBL_FILE			="<%=LabelManager.getName(labelSet,"lblBrowse")%>";
var LBL_CONFIRM			="<%=LabelManager.getNameWAccess(labelSet,"btnCon")%>";
var LBL_CANCEL			="<%=LabelManager.getNameWAccess(labelSet,"btnSal")%>";

function btnUpld_click(){
	document.getElementById("imgList").uploadImage("","","");
}
function btnDel_click(){
	document.getElementById("imgList").deleteSelected();
}
function refresh(){
	document.getElementById("imgList").refresh();
}
function btnConf_click(){
	window.returnValue=getSelected();
	window.close();
}
function getSelected(){
	var obj=null;
	if(document.getElementById("imgList").selectedItems.length){
		obj=document.getElementById("imgList").selectedItems[0].getObject();
	}
	return obj;
}
</script></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.configuration.EnvParametersBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titImages")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImages")%></DIV></br><div type="imageBrowser" imageToolTip="true" nameField="true" id="imgList" style="height:220px" addUrl="configuration.EnvParametersAction.do?action=addSplashImg" listUrl="configuration.EnvParametersAction.do?action=splashImgList" removeUrl="configuration.EnvParametersAction.do?action=removeSplashImg"></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><td></td><td style="width:0px"><button type="button" onclick="btnUpld_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCre")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCre")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCre")%></button><button type="button" onclick="btnDel_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button><button type="button" type="button" onclick="refresh()" id="btnRefresh" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRef")%>" title="<%=LabelManager.getToolTip(labelSet,"btnRef")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRef")%></button></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %>
