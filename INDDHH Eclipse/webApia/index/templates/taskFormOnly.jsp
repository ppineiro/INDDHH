<%@ taglib uri='regions' prefix='region'%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.*"%><%@page import="com.dogma.bean.query.MonitorProcessesBean"%><%@page import="java.util.*"%><%@include file="../components/scripts/server/startInc.jsp"%><HTML XMLNS:CONTROL><head><%@include file="../components/scripts/server/headInclude.jsp"%></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><region:render section='title' /></TD><TD align="right"><button onclick="showDocs_click()"
					accesskey="<%=LabelManager.getAccessKey(labelSet, "sbtEjeDoc")%>"
					title="<%=LabelManager.getToolTip(labelSet, "sbtEjeDoc")%>"><%=LabelManager.getNameWAccess(labelSet, "sbtEjeDoc")%></button></TD></TR></TABLE><div id="divContent" <region:render section='divHeight'/>><form id="frmMain" name="frmMain" target="iframeResult" method="POST"><%
			Integer selCalId = null;
			if (session.getAttribute("dBean") instanceof TaskBean) {
				TaskBean dBean = (TaskBean) session.getAttribute("dBean");
				selCalId = dBean.getSelectedCalendar(); 
			} else if (session.getAttribute("dBean") instanceof MonitorProcessesBean) {
				MonitorProcessesBean dBean = (MonitorProcessesBean) session.getAttribute("dBean");
				selCalId = dBean.getSelectedCalendar(); 
			}
			%><input type="hidden" name="selCal" value="<%= (selCalId == null) ? "" : selCalId.toString() %>"><div type="tabElement" id="samplesTab" ontabswitched="tabSwitch()"
				<%if (request.getParameter("selTab") != null) {%>
				defaultTab="<%=request.getParameter("selTab")%>" <%}%>><div type="tab" style="visibility: hidden"
					tabTitle="<%=LabelManager.getToolTip(labelSet, "tabEjeFor")%>"
					tabText="<%=LabelManager.getName(labelSet, "tabEjeFor")%>"><region:render section='entityForms' /><region:render section='processForms' /></div><div type="tab" style="visibility: hidden" id="tabObs"
					tabTitle="<%=LabelManager.getToolTip(labelSet, "tabEjeObs")%>"
					tabText="<%=LabelManager.getName(labelSet, "tabEjeObs")%>"><region:render section='taskComments' /></div></div></FORM></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><region:render section='buttons' /></TD></TR></TABLE></body></html><script>
	function showDocs_click() {
		openModal("/programs/documents/docExecutionModal.jsp?a=a" + windowId,
				500, 300);
	}
</script>

