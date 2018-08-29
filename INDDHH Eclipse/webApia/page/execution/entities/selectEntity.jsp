<%@page import="biz.statum.apia.web.action.execution.EntInstanceListAction"%><%@page import="biz.statum.apia.web.bean.execution.EntInstanceListBean"%><%@page import="biz.statum.apia.web.action.BasicAction"%><%@page import="com.dogma.vo.BusEntityVo"%><%@page import="java.util.Iterator"%><%@page import="com.dogma.UserData"%><%@page import="com.st.util.translator.TranslationManager"%><%@page import="biz.statum.apia.web.bean.BeanUtils"%><% 
//EntInstanceListBean dBean = (EntInstanceListBean) session.getAttribute(BasicAction.BEAN_ADMIN_NAME);
EntInstanceListBean dBean = EntInstanceListAction.getBean(request,response);
%><%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/execution/entities/selectEntity.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script>
		var ADMIN_BOTH = "<%=BusEntityVo.ADMIN_BOTH%>";
		var ADMIN_PROCESS = "<%=BusEntityVo.ADMIN_PROCESS%>";
	 	var URL_REQUEST_AJAX = "/apia.execution.EntInstanceListAction.run";
	</script></head><body><div class="body" id="bodyDiv"><form id="frmData" action="" method="post"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="mnuManEntGlo" /></div><div class="content divFncDescription"><div class="fncDescriptionImgUsers"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmGloEnt" /></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><div class="fncPanel options"></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div><div class="fieldGroup"><div class="title"><system:label show="text" label="titEjeCreEnt" /></div></div><div class="fieldGroup"><div class="field required"><label title="<system:label show="tooltip" label="lblEjeTipEnt" />"><system:label show="text" label="lblEjeTipEnt" />:</label><%
							if (dBean.isGlobalAdministration() && dBean.getBusEntId() == null) { %><select name="busEntId" id="cmbBusEntId" class="validate['required']"><option></option><%  
									Collection col = dBean.getBusEntities(request);
			   						if (col != null) {
				   						Iterator it = col.iterator();
										BusEntityVo entVo = null;
				   						while (it.hasNext()) {
				   						 	entVo = (BusEntityVo) it.next();
				   						 	if (!entVo.getFlagValue(BusEntityVo.FLAG_NOT_CREATE_NEW_INST)) {
				   						 		entVo.setLanguage(BasicBeanStatic.getUserDataStatic(request).getLangId());
				   								TranslationManager.setTranslationByNumber(entVo);%><option value="<%=BeanUtils.fmtInt(entVo.getBusEntId())%>" proType="<%=BeanUtils.fmtStr(entVo.getBusEntAdminType())%>" <%= (dBean.getBusEntId() != null && dBean.getBusEntId().equals(entVo.getBusEntId())) ? "selected" : "" %>  ><%=BeanUtils.fmtHTML(entVo.getBusEntTitle())%></option><%
				   						 	}											
										}
				   					}%></select><%
					   		} else { %><input type="hidden" name="busEntId" id="cmbBusEntId" value="<%=BeanUtils.fmtInt(dBean.getBusEntityVo().getBusEntId())%>" busEntInstId="<%=dBean.getBusEntInstId()%>" proType="<%=BeanUtils.fmtStr(dBean.getBusEntityVo().getBusEntAdminType())%>"><span style="display:block;margin: 4px 5px;"><b><%=BeanUtils.fmtHTML(dBean.getBusEntityVo().getBusEntTitle())%></b></span><% } %></div><div class="field hidden" id="processes"><label title="<system:label show="tooltip" label="lblEjeNomPro" />"><system:label show="text" label="lblEjeNomPro" />:</label><select id="selPro" name="txtProId"></select></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><%@include file="../../includes/footer.jsp" %></body></html>
	 

