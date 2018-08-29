<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bean.execution.EntInstanceBean"%><%@include file="../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body onLoad="onLoadHtml();"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.EntInstanceBean"></jsp:useBean><%
String urlAction = request.getParameter("action");
boolean showFilter = urlAction != null && urlAction.length() > 0 && "init".equals(urlAction) && dBean.getEntType() == null;
%><%boolean blnProcess = false;
	  boolean blnStatus = false;
	  boolean blnSpecific = dBean.getSpecificEntity()!= null; %><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEjeEnt")%><%if (blnSpecific) {%> : <%=dBean.getEntityType().getBusEntTitle()%><%}%></TD><TD></TD></TR></TABLE><%@include file="../includes/entityAdminList.jsp" %><table class="navBar"><COL class="col1"><COL class="col2"><tr><%@include file="../../includes/navButtons.jsp" %><td><button type="button" onclick="btnClo_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnClo")%>" title="<%=LabelManager.getToolTip(labelSet,"btnClo")%>"><%=LabelManager.getNameWAccess(labelSet,"btnClo")%></button><button type="button" onclick="btnNew_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCre")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCre")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCre")%></button><button type="button" onclick="btnMod_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMod")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMod")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMod")%></button><button type="button" onclick="btnDel_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button><button type="button" onclick="btnDep_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDep")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDep")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDep")%></button></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script src="<%=Parameters.ROOT_PATH%>/programs/execution/entities/entities.js"></script><script>
	var internalDivType = "<%=com.dogma.DogmaConstants.SESSION_CMP_HEIGHT%>";
	var userConfirm = "<%=dBean.userConfirm%>";
	<% dBean.userConfirm = false; %>
	var msgUsrConfDel = '<%=LabelManager.getName(labelSet,DogmaException.EXE_BUS_ENT_INST_CANT_DELETE_REL_ASK)%>';
	if (document.addEventListener) {
	    document.addEventListener('DOMContentLoaded', fnStartDocInit, false);
	}else{
		window.document.onreadystatechange=fnStartDocInit;
	}
	function fnStartDocInit(){
		if (document.readyState=='complete' || (window.navigator.appVersion.indexOf("MSIE")<0)){
			if(userConfirm == "true"){
				var ret = confirm(msgUsrConfDel);
				if(ret==true){
					document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=remove&overrideRelations=true";
					submitForm(document.getElementById("frmMain"));
				}
			}
		}
	}

	function onLoadHtml() {
	<% if (showFilter) { %>
		toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>);
	<% } %>
	}

</script><%@include file="../../../components/scripts/server/endInc.jsp" %>