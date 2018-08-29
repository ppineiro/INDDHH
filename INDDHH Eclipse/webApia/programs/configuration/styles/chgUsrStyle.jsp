<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body onload="tryReload()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.configuration.StylesBean"></jsp:useBean><%
Collection stylesCol = dBean.getUserStyles(request);
String userStyle = dBean.getUserStyle(request);
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titSty")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtSty")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td><%=LabelManager.getNameWAccess(labelSet,"lblStyle")%>:</td><td><select name="selStyle" id="selStyle"><option value="" <%=(userStyle==null || "".equals(userStyle))?"selected":"" %>></option><%
						if (stylesCol != null) {
							String styleName = null;
							Iterator iterator = stylesCol.iterator();
							while (iterator.hasNext()) {
								styleName = ((UsrStylesVo) iterator.next()).getStyleName(); %><option value="<%= styleName %>" <%= styleName.equals(userStyle)?"selected":"" %>><%= dBean.fmtHTML(styleName)%></option><%
							}
						} %></select></td><td></td><td></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">
var RELOAD_STYLE = <%= dBean.isReloadStyle() %>;
<% dBean.setReloadStyle(false); %>

function tryReload(){
	if (RELOAD_STYLE && windowId=="") {
		window.parent.frames[0].window.location = "FramesAction.do?action=top"; //header
		window.parent.frames[2].window.location.reload(); //menu
		//window.parent.frames[3].window.location.reload(); //result
		//window.parent.frames[4].window.location.reload(); //hidden frame
	}else if (RELOAD_STYLE && windowId!=""){
		window.parent.logout();
	}
}

</script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/configuration/styles/chgUsrStyle.js'></script>

