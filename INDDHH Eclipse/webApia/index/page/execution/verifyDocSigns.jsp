<%@page import="com.dogma.UserData"%><%@page import="com.dogma.vo.DocumentVo"%><%@page import="com.dogma.vo.custom.DocumentationVo"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.bean.IDocumentBean"%><%@page import="biz.statum.apia.web.bean.monitor.TasksBean"%><%@page import="biz.statum.apia.web.bean.monitor.BusinessBean"%><%@page import="biz.statum.apia.web.bean.monitor.ProcessesBean"%><%@page import="biz.statum.apia.web.bean.BeanUtils"%><%@page import="com.dogma.vo.UsrSignsVo"%><%@include file="../includes/startInc.jsp" %><%
UserData userData = BasicBeanStatic.getUserDataStatic(request);
biz.statum.apia.web.bean.BasicBean basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_EXEC_NAME);

if(basicBean==null){
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_ADMIN_NAME);
}

if(basicBean==null){
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_MONITOR_TASK);
}

// biz.statum.apia.web.bean.execution.ExecutionBean aBean = null;

// if(basicBean instanceof biz.statum.apia.web.bean.execution.EntInstanceListBean){
// 	aBean = ((biz.statum.apia.web.bean.execution.EntInstanceListBean)basicBean).getEntInstanceBean();
// } else if (basicBean instanceof biz.statum.apia.web.bean.execution.TaskBean){
// 	aBean = ((biz.statum.apia.web.bean.execution.TaskBean)basicBean);
// } else if (basicBean instanceof biz.statum.apia.web.bean.monitor.EntitiesBean){
// 	aBean = (biz.statum.apia.web.bean.monitor.EntitiesBean)basicBean;
// } else if (basicBean instanceof ProcessesBean) {
// 	aBean = (ProcessesBean)basicBean;
// } else if (basicBean instanceof BusinessBean) {
// 	aBean = ((BusinessBean)basicBean).getEntInstanceBean();
// 	if(aBean == null)
// 		aBean = ((BusinessBean)basicBean).getMonitorProcessesBean().getEntInstanceBean();
// } else if (basicBean instanceof TasksBean) {
// 	aBean = ((TasksBean)basicBean).getEntInstanceBean();
// }


Collection<UsrSignsVo> docSignatures = null;
String docId = request.getParameter("docId");
String prefix = request.getParameter("prefix");

String URL_REQUEST = "";
if(basicBean instanceof biz.statum.apia.web.bean.execution.EntInstanceListBean) {
	docSignatures = ((biz.statum.apia.web.bean.execution.EntInstanceListBean)basicBean).getDocSignatures(new HttpServletRequestResponse(request, response), userData);
	URL_REQUEST = "apia.execution.EntInstanceListAction.run";
} else if (basicBean instanceof biz.statum.apia.web.bean.execution.TaskBean) {
	docSignatures = ((biz.statum.apia.web.bean.execution.TaskBean)basicBean).getDocSignatures(new HttpServletRequestResponse(request, response), userData);
	URL_REQUEST = "apia.execution.TaskAction.run";
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.ProcessesBean) {
	docSignatures = ((biz.statum.apia.web.bean.monitor.ProcessesBean)basicBean).getDocSignatures(new HttpServletRequestResponse(request, response), userData);
	URL_REQUEST = "apia.monitor.ProcessesAction.run";
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.TasksBean) {
	docSignatures = ((biz.statum.apia.web.bean.monitor.TasksBean)basicBean).getDocSignatures(new HttpServletRequestResponse(request, response), userData);
	URL_REQUEST = "apia.monitor.TasksAction.run";
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.BusinessBean) {
	docSignatures = ((biz.statum.apia.web.bean.monitor.BusinessBean)basicBean).getDocSignatures(new HttpServletRequestResponse(request, response), userData);
	URL_REQUEST = "apia.monitor.BusinessAction.run";
}
%><html><head><%@include file="../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript">
			function  initPage(){
			}
			
			function downloadPKCS7(signId) {
				document.getElementById("ifrDownload").src="<%=URL_REQUEST%>?action=downloadPKCS7&signId=" + signId + "&docId=<%=docId%>&prefix=<%=prefix%>" + TAB_ID_REQUEST;
			}
			
			function checkSign(signId) {			    
				var submitUrl = '<%=URL_REQUEST%>?action=verifySignature&signId=' + signId + "&docId=<%=docId%>&prefix=<%=prefix%>" + TAB_ID_REQUEST;
				var request = new Request({
					method: 'post',
					url: submitUrl,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
	 	</script></head><body><div class="mdlVerifySignContainer"><div class="mdlHeader"><system:label show="text" label="titVerSignatures" /></div><div class="mdlBody"><div class="gridHeader"><!-- Cabezal y filtros --><table cellpadding="0" cellspacing="0"><thead><tr class="header"><th title="<system:label show="tooltip" label="lblSigUsu" />"><div style="width:200px"><system:label show="text" label="lblSigUsu" /></div></th><th title="<system:label show="tooltip" label="lblSigDate" />"><div style="width:200px"><system:label show="text" label="lblSigDate" /></div></th><th title="<system:label show="tooltip" label="lblVerSig" />"><div style="width:100px"><system:label show="text" label="lblVerSig" /></div></th><th title="PKCS7"><div style="width:100px">PKCS7</div></th></tr></thead></table></div><div class="gridBody" id="gridBodyFormEnt"><!-- Cuerpo de la tabla --><table cellpadding="0" cellspacing="0"><thead><tr><th width="200px"></th><th width="200px"></th><th width="100px"></th><th width="100px"></th></tr></thead><tbody class="tableData"  ><%if(docSignatures != null) {
								int i = 1;
						   		for(UsrSignsVo vo : docSignatures) { %><tr <% if(i++ % 2 == 0) { out.print(" class='trOdd' "); } %>><td><div style='width: 200px;text-align: center'><%=BeanUtils.fmtStr(vo.getUsrSignLogin()) %></div></td><td><div style='width: 200px;text-align: center'><%=BeanUtils.fmtDateAMPM(vo.getUsrSignDate()) %></div></td><td><div style='width: 100px;text-align: center'><img style="cursor:hand" src="<system:util show="context" />/css/<system:util show="currentStyle" />/img/signCheck.gif" onclick="checkSign('<%=BeanUtils.fmtInt(vo.getUsrSignId()) %>')"></div></td><td><div style='width: 100px;text-align: center'><div class="button" onclick="downloadPKCS7(<%=vo.getUsrSignId() %>)"><system:label show="tooltip" label="btnDow"/></div></div></td></tr><%}
							}%></tbody></table></div></div></div><iframe style="display:none" id="ifrDownload"></iframe></body></html>
