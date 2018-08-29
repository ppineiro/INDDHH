<%@page import="biz.statum.apia.web.bean.monitor.TasksBean"%><%@page import="biz.statum.apia.web.bean.monitor.BusinessBean"%><%@page import="biz.statum.apia.web.bean.monitor.ProcessesBean"%><%@page import="biz.statum.apia.web.bean.BeanUtils"%><%@page import="com.dogma.vo.UsrSignsVo"%><%@include file="../includes/startInc.jsp" %><%
biz.statum.apia.web.bean.BasicBean basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_EXEC_NAME);

if(basicBean==null){
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_ADMIN_NAME);
}

if(basicBean==null){
	basicBean = biz.statum.apia.web.action.BasicAction.staticRetrieveBean(request, response, biz.statum.apia.web.action.BasicAction.BEAN_MONITOR_TASK);
}

biz.statum.apia.web.bean.execution.ExecutionBean aBean = null;

if(basicBean instanceof biz.statum.apia.web.bean.execution.EntInstanceListBean){
	aBean = ((biz.statum.apia.web.bean.execution.EntInstanceListBean)basicBean).getEntInstanceBean();
} else if (basicBean instanceof biz.statum.apia.web.bean.execution.TaskBean){
	aBean = (biz.statum.apia.web.bean.execution.TaskBean)basicBean;
} else if (basicBean instanceof biz.statum.apia.web.bean.monitor.EntitiesBean){
	aBean = (biz.statum.apia.web.bean.monitor.EntitiesBean)basicBean;
} else if (basicBean instanceof ProcessesBean) {
	aBean = (ProcessesBean)basicBean;
} else if (basicBean instanceof BusinessBean) {
	if("E".equals(request.getParameter("frmParent"))) {
		aBean = ((BusinessBean)basicBean).getEntInstanceBean();
		if(aBean == null)
			aBean = ((BusinessBean)basicBean).getMonitorProcessesBean().getEntInstanceBean();
	} else if("P".equals(request.getParameter("frmParent"))) {
		aBean = ((BusinessBean)basicBean).getMonitorProcessesBean().getProInstanceBean();
	}
} else if (basicBean instanceof TasksBean) {
	if("P".equals(request.getParameter("frmParent"))) {
		aBean = ((TasksBean)basicBean).getProInstanceBean();
	} else {
		aBean = ((TasksBean)basicBean).getEntInstanceBean();
	}
}


biz.statum.apia.web.bean.execution.FormBean fBean = aBean.getFormBean(request);

Collection<UsrSignsVo> formSignatures = fBean.getFormSignatures(request);

%><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../includes/headInclude.jsp" %><script type="text/javascript">
			function  initPage(){
				
			}
			
			function downloadPKCS7(signId){
				document.getElementById("ifrDownload").src="apia.execution.FormAction.run?action=downloadPKCS7&signId=" + signId + "&frmId=<%=fBean.getFormId()%>&frmParent=<%=fBean.getParentBeanDesc()%>" + TAB_ID_REQUEST;
			}
			
			function checkSign(signId){
				var submitUrl = 'apia.execution.FormAction.run?action=verifySignature&signId=' + signId + "&frmId=<%=request.getParameter("frmId")%>&frmParent=<%=fBean.getParentBeanDesc()%>" + TAB_ID_REQUEST;
				var request = new Request({
					method: 'post',
					url: submitUrl,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
				
			}
	 	</script></head><body><div class="mdlVerifySignContainer"><div class="mdlHeader"><system:label show="text" label="titVerSignatures" /></div><div class="mdlBody"><div class="gridHeader"><!-- Cabezal y filtros --><table><thead><tr class="header"><th title="<system:label show="tooltip" label="lblSigUsu" />"><div style="width:200px"><system:label show="text" label="lblSigUsu" /></div></th><th title="<system:label show="tooltip" label="lblSigDate" />"><div style="width:200px"><system:label show="text" label="lblSigDate" /></div></th><th title="<system:label show="tooltip" label="lblVerSig" />"><div style="width:100px"><system:label show="text" label="lblVerSig" /></div></th><th title="PKCS7"><div style="width:100px">PKCS7</div></th></tr></thead></table></div><div class="gridBody" id="gridBodyFormEnt"><!-- Cuerpo de la tabla --><table><thead><tr><th width="200px"></th><th width="200px"></th><th width="100px"></th><th width="100px"></th></tr></thead><tbody class="tableData"  ><%if(formSignatures!=null) {
								int i=1;
						   		for(UsrSignsVo vo : formSignatures){%><tr <%if(i++ % 2 ==0){out.print(" class='trOdd' ");} %>><td><div style='width: 200px;text-align: center'><%=BeanUtils.fmtStr(vo.getUsrSignLogin()) %></div></td><td><div style='width: 200px;text-align: center'><%=BeanUtils.fmtDateAMPM(vo.getUsrSignDate()) %></div></td><td><div style='width: 100px;text-align: center'><img style="cursor:pointer" src="<system:util show="context" />/css/base/img/signCheck.gif" onclick="checkSign('<%=BeanUtils.fmtInt(vo.getUsrSignId()) %>')"></div></td><td><div style='width: 100px;text-align: center'><% if (vo.getUsrSignPkcs7() != null) { %><div class="button" onclick="downloadPKCS7(<%=vo.getUsrSignId() %>)"><system:label show="text" label="btnDow"/></div><% } %></div></td></tr><%}
							}%></tbody></table></div></div></div><iframe style="display:none" id="ifrDownload"></iframe></body></html>
