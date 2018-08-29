<%@ page import="com.dogma.Parameters"%><%@ page import="com.dogma.vo.*"%><%@ page import="com.dogma.bean.execution.TaskBean"%><%@ page import="com.st.util.XMLUtils"%><%@ page import="com.st.util.labels.LabelManager"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><% TaskBean dBean = (TaskBean) session.getAttribute("dBean"); %><%@include file="../../../components/scripts/server/frmTargetStart.jsp" %><script>var autoClose="false";</script><div id=divMsg style="height:197px;"><table class="tblTitulo"><tr><td><%=LabelManager.getName(labelSet,langId,"titEvaPool")%></td></tr></table><!--     ----------------------------START CONTENT---------------               --><div class="divContent" id="divContent" style="width:340px; height:147px;overflow:auto;"><form id="frmMain" name="frmMain" method="POST"><table><tr><td id="preMsg" width="320" style="word-wrap: break-word"><%
				//- Build task/pool list from XML and XSL
				out.print(XMLUtils.transform(dBean.getEnvId(request),dBean.getEvalPath().getEvalPoolsAsXML(),"/programs/execution/tasks/evalGroup.xsl"));
			%></td></tr></table></form></div><!--     -------START BUTTONBAR-----------------------------------               --><table id="btnsBar" class="btnsBar" width="100%"><tr><td></td><td align="right"><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnCon")%></button> &nbsp;
				<button type="button" onclick="enableButtons()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnSal")%></button></td></tr></table></div><!--     -------END BUTTONBAR------------------------               --></body></html><%@include file="../../../components/scripts/server/frmTargetEnd.jsp" %><script language="javascript">

function enableButtons(){
	var win=window.parent.document.getElementById(window.name).submitWindow;
	try{
		win.document.getElementById("btnLast").disabled = false;
	} catch(e){}
	try{
		win.document.getElementById("btnNext").disabled = false;
	} catch(e){}
	try{
		win.document.getElementById("btnConf").disabled = false;
	} catch(e){}
	try{
		win.document.getElementById("btnSave").disabled = false;
	} catch(e){}
	try{
		win.document.getElementById("btnPrint").disabled = false;
	} catch(e){}
	window.parent.document.getElementById('iframeResult').hideResultFrame();
}

function btnConf_click(){
	document.getElementById("frmMain").action = "execution.TaskAction.do?action=confirmPool";
	submitTargetForm();
}
</script>