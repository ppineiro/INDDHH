<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><script>
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
</script></head><body><jsp:useBean id="imagePickerBean" scope="session" class="com.dogma.bean.administration.ImagesBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titImages")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtImages")%></DIV></br><div type="imageBrowser" id="imgList" style="height:180px" addUrl="administration.ImagesAction.do?action=add" listUrl="administration.ImagesAction.do?action=list" removeUrl="administration.ImagesAction.do?action=remove"></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %>