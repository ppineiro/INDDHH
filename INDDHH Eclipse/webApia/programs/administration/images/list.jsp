<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><script>
var LBL_ADDIMAGE		="<%=LabelManager.getName(labelSet,"sbtImages")%>";
var LBL_NAME			="<%=LabelManager.getName(labelSet,"lblNom")%>";
var LBL_DESCRIPTION		="<%=LabelManager.getNameWAccess(labelSet,"lblDes")%>";
var LBL_FILE			="<%=LabelManager.getName(labelSet,"lblBrowse")%>";
var LBL_CONFIRM			="<%=LabelManager.getNameWAccess(labelSet,"btnCon")%>";
var LBL_CANCEL			="<%=LabelManager.getNameWAccess(labelSet,"btnSal")%>";
var MSG_COULD_NOT_DELETE="<%=LabelManager.getName(labelSet,"msgImagesNotDeleted")%>";

function btnUpld_click(){
	document.getElementById("imgList").uploadImage("","","");
}
function btnDel_click(){
	document.getElementById("imgList").deleteSelected();
}
function refresh(){
	document.getElementById("imgList").refresh();
}
</script></head><body><jsp:useBean id="imagePickerBean" scope="session" class="com.dogma.bean.administration.ImagesBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titImages")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImages")%></DIV></br><div type="imageBrowser" id="imgList" imageToolTip="true" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px" addUrl="administration.ImagesAction.do?action=add" listUrl="administration.ImagesAction.do?action=list" multiSelect="true" removeUrl="administration.ImagesAction.do?action=remove"></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><td></td><td style="width:0px"><button type="button" onclick="btnUpld_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCre")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCre")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCre")%></button><button type="button" onclick="btnDel_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button><button type="button" type="button" onclick="refresh()" id="btnRefresh" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnRef")%>" title="<%=LabelManager.getToolTip(labelSet,"btnRef")%>"><%=LabelManager.getNameWAccess(labelSet,"btnRef")%></button></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %>
