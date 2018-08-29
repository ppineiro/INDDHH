<%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.*"%><%@page import="java.util.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><% 

	TaskBean dBean = new TestTaskBean();
	BusEntInstanceVo beInstVo = new BusEntInstanceVo();
	BusEntityVo beVo = new BusEntityVo();
	Collection beRelCol = null;
	
	ProcessVo proVo =  new ProcessVo();
	proVo.setProAction(ProcessVo.PROCESS_ACTION_CREATION);
	ProInstanceVo proInstVo = new ProInstanceVo();
	
	EntInstanceBean entityBean = dBean.getEntInstanceBean();
	ProInstanceBean processBean = dBean.getProInstanceBean();
	
	String template = request.getParameter("template");
%><region:render template='<%=template%>'><region:put section='title'><%=LabelManager.getName(labelSet,"titEjeTar")%> : <%=dBean.fmtHTML(dBean.getCurrentElement().getTskName())%></region:put><region:put section='entityMain'><%@include file="../execution/includes/entityMain.jsp" %></region:put><region:put section='entityRelations'><%@include file="../execution/includes/entityRelations.jsp" %></region:put><region:put section='entityDocuments' content="/programs/documents/documents.jsp?docBean=entity"/><region:put section='processMain'><%@include file="../execution/includes/processMain.jsp"%></region:put><region:put section='processHistory'><%@include file="../execution/includes/entityProHistory.jsp"%></region:put><region:put section='processDocuments' content="/programs/documents/documents.jsp?docBean=process"/><region:put section='entityForms'><DIV class="subTit"><%=LabelManager.getName(labelSet,"tabEjeFor")%></DIV><DIV id="divFrm1251" style="display:block"><!---------------------------- START FORM ----------------------------><TABLE  class='tblFormLayout' border=0 ><COL class='col1'><COL class='col2'><COL class='col3'><COL class='col4'><TR><TD></TD><TD></TD><TD></TD><TD></TD></TR><TR><TD rowspan='1' title='Field 1'>Field 1:</TD><TD rowspan='1'  colspan='1'><SELECT name='frm_E_1251_2136_S_2' id='FORMULARIOAPROBADOR_TIPOCOMPLEJIDAD'  p_required='true' ><OPTION value='' selected ></OPTION></SELECT></TD><TD>&nbsp;</TD><TD>&nbsp;</TD></TR><TR><TD rowspan='1' title='Field 2'>Field 2:</TD><TD rowspan='1' colspan='1'><INPUT name='frm_E_1251_2137_N_1' id='FORMULARIOAPROBADOR_MINESTAPROBADOR' value='' maxlength='10' p_required='true'  ></TD><TD>&nbsp;</TD><TD>&nbsp;</TD></TR></TABLE></DIV><BR></region:put><region:put section='processForms'><DIV class="subTit"><%=LabelManager.getName(labelSet,"tabEjeForPro")%></DIV><DIV id="divFrm1252" style="display:block"><!---------------------------- START FORM ----------------------------><TABLE  class='tblFormLayout' border=0 ><COL class='col1'><COL class='col2'><COL class='col3'><COL class='col4'><TR><TD></TD><TD></TD><TD></TD><TD></TD></TR><TR><TD rowspan='1' title='Field 1'>Field 1:</TD><TD rowspan='1'  colspan='1'><SELECT name='frm_E_1252_2136_S_2' id='FORMULARIOAPROBADOR_TIPOCOMPLEJIDAD'  p_required='true' ><OPTION value='' selected ></OPTION></SELECT></TD><TD>&nbsp;</TD><TD>&nbsp;</TD></TR><TR><TD rowspan='1' title='Field 2'>Field 2:</TD><TD rowspan='1' colspan='1'><INPUT name='frm_E_1252_2137_N_1' id='FORMULARIOAPROBADOR_MINESTAPROBADOR' value='' maxlength='10' p_required='true'  ></TD><TD>&nbsp;</TD><TD>&nbsp;</TD></TR></TABLE></DIV><BR></region:put><region:put section='taskComments'><%@include file="../execution/includes/taskComments.jsp"%></region:put><region:put section='buttons'><button type="button" id="exit" onclick="window.close()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></region:put></region:render><%@include file="../../components/scripts/server/endInc.jsp" %><SCRIPT>
function tabSwitch(){
}

window.onload=function() {
	var inputs = document.getElementsByTagName("INPUT");
	for (i = 0; i < inputs.length; i++) {
		if (inputs[i].type == "button" || inputs[i].type == "submit" || inputs[i].type == "reset") {
			inputs[i].disabled = true;
		}
	}
	
	var buttons = document.getElementsByTagName("BUTTON");
	for (i = 0; i < buttons.length; i++) {
		if (buttons[i].title.indexOf("(alt+") == -1) {
			buttons[i].disabled = true;
		}
		if(buttons[i].id == "exit"){
			buttons[i].disabled = false;
		}
	}
}
</SCRIPT>