<%@page import="com.dogma.vo.OrgRoleProfileVo"%><%@page import="com.dogma.vo.OrgRolePoolVo"%><%@page import="biz.statum.apia.web.action.administration.OrganizationalRoleAction"%><%@page import="com.dogma.vo.OrganizationalRoleVo"%><%@page import="biz.statum.apia.web.bean.administration.OrganizationalRoleBean"%><%@page import="com.dogma.vo.OrgUnitAdminsVo"%><%@page import="com.dogma.vo.OrganizationalUnitVo"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.administration.OrganizationalUnitAction"%><%@page import="biz.statum.apia.web.bean.administration.OrganizationalUnitBean"%><%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/administration/orgRole/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/profiles.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.administration.OrganizationalRoleAction.run';
		var currentEnvId = "<system:edit show="value" from="theBean" field="currentEnvironmentId"/>";
		var ADDITIONAL_INFO_IN_TABLE_DATA = false;
		var ERR_AT_DOC_ROLE_CHANGE = '<system:label show="text" label="errAtDocRoleChange" forScript="true" />';
		var POOL_IDS = [<%
			OrganizationalRoleBean dBean = (OrganizationalRoleBean)OrganizationalRoleAction.staticRetrieveBean(new HttpServletRequestResponse(request, response));
			OrganizationalRoleVo vo = dBean.getEditionObject();
			Collection<OrgRolePoolVo> pools = vo.getOrgRolePools();
			if(pools != null) {
				int i = 0;
				for(OrgRolePoolVo pool : pools) {
					out.write("[" + pool.getPoolId() + ", \"" + pool.getPoolVo().getPoolName() + "\"]");
					if(i < pools.size() - 1)
						out.write(", ");
					i++;
				}
			}
		%>];
		var PRF_IDS = [<%
   			Collection<OrgRoleProfileVo> profiles = vo.getOrgRoleProfiles();
   			if(profiles != null) {
   				int i = 0;
   				for(OrgRoleProfileVo profile : profiles) {
   					out.write("[" + profile.getPrfId() + ", \"" + profile.getProfileVo().getPrfName() + "\"]");
   					if(i < profiles.size() - 1)
   						out.write(", ");
   					i++;
   				}
   			}
   		%>];
		var isCreate = <system:edit show="ifValue" from="theBean" field="modeCreate" value="true">true</system:edit><system:edit show="ifValue" from="theBean" field="modeCreate" value="false">false</system:edit>;
	</script></head><body><div id="exec-blocker"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="mnuOrgRole" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncOrgRole"/></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><system:edit show="ifValue" from="theBean" field="modeCreate" value="false"><div id="divAdminActEdit" class="fncPanel buttons"><div class="title"><system:label show="text" label="mnuOpc"/></div><div class="content"><div id="optionGenerateChangeDoc" class="button" title="<system:label show="tooltip" label="btnGenOrgRoleChangeDoc"/>"><system:label show="text" label="btnGenOrgRoleChangeDoc"/></div></div></div></system:edit><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="tabDatGen" /></div><div class="contentTab"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtDat" /></div><div class="field fieldTwoFifths required"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:</label><input type="text" name="orgRoleName" id="orgRoleName" maxlength="255" class="validate['required','~validName']"  value="<system:edit show="value" from="theEdition" field="orgRoleName"/>"></div><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblDes" />"><system:label show="text" label="lblDes" />:</label><textarea name="orgRoleDesc" id="orgRoleDesc" maxlength="255" cols=80 rows=3><system:edit show="value" from="theEdition" field="orgRoleDesc"/></textarea></div></div><div class="fieldGroup"><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblPool" />"><system:label show="text" label="lblPool" />:</label><div class="modalOptionsContainer" id="poolsContainter"><div class="element" id="addPool" data-helper="true"><div class="option optionAdd"><system:label show="text" label="btnAgr" /></div></div></div></div></div><div class="fieldGroup"><div class="field fieldFull"><label title="<system:label show="tooltip" label="titPer" />"><system:label show="text" label="titPer" />:</label><div class="modalOptionsContainer" id="prfsContainter"><div class="element" id="addPrf" data-helper="true"><div class="option optionAdd"><system:label show="text" label="btnAgr" /></div></div></div></div></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><!-- MODALS --><%@include file="../../modals/pools.jsp" %><%@include file="../../modals/profiles.jsp" %><%@include file="../../includes/footer.jsp" %></body></html>