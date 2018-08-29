<%@page import="java.util.Enumeration"%>
<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%>
<%@page import="com.dogma.UserData"%>
<%@page import="biz.statum.sdk.util.StringUtil"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %>
<%@ taglib prefix='region'  uri='/WEB-INF/regions.tld' %>

<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.dogma.Parameters"%>

<%

boolean isAuthenticated = false;
String remoteUser="";
if(request.getRemoteUser()!=null){
	isAuthenticated = true;
	remoteUser = request.getRemoteUser();
}

UserData uData = BasicBeanStatic.getUserDataStatic(request);
String template = Parameters.LOGIN_JSP_TEMPLATE;
if (StringUtil.isEmpty(template) || "toApiaTemplate".equals(request.getParameter("forceDefaultTemplate"))) template = "/page/login/classic/defaultTemplate.jsp";

%>
<region:render template='<%=template%>'>
	<region:put section='linkCssDefaultLogin'><link href="<system:util show="context" />/css/<system:util show="defaultStyle" />/login.css" rel="stylesheet" type="text/css" ></region:put>
	<region:put section='linkCssDefaultMessages'><link href="<system:util show="context" />/css/<system:util show="defaultStyle" />/messages.css" rel="stylesheet" type="text/css" ></region:put>
	<region:put section='linkCssDefaultSpinner'><link href="<system:util show="context" />/css/<system:util show="defaultStyle" />/spinner.css" rel="stylesheet" type="text/css" ></region:put>
	<region:put section='linkCss'>
		<link rel="stylesheet" href="<system:util show="context" />/js/tooltips/js/sexy-tooltips/blue.css" type="text/css" media="all" id="theme">
		<link rel="stylesheet" href="<system:util show="context" />/js/formcheck/theme/classic/formcheck.css" type="text/css" media="screen" >
	</region:put>
	
	<region:put section='scriptJs'>
		<script type="text/javascript" src="<system:util show="context" />/js/modernizr.custom.js"></script>
		<script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script>
		<script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script>
		<script type="text/javascript" src="<system:util show="context" />/js/generics.js"></script>
		
		<%
		com.dogma.UserData uDataAux = biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request);
		Integer langIdAux = 3;
		if (uDataAux!=null) langIdAux = uDataAux.getLangId();
			
		if(langIdAux == 1) {%>
			<script type="text/javascript" src="<system:util show="context" />/js/formcheck/lang/es.js"> </script>
		<%} else if(langIdAux == 2) {%>
			<script type="text/javascript" src="<system:util show="context" />/js/formcheck/lang/pt.js"> </script>
		<%} else {%>
			<script type="text/javascript" src="<system:util show="context" />/js/formcheck/lang/en.js"> </script>
		<%}%>
		
		<script type="text/javascript" src="<system:util show="context" />/js/formcheck/formcheck.js"> </script>
		<script type="text/javascript" src="<system:util show="context" />/js/tooltips/js/sexy-tooltips.v1.2.mootools.js"></script>
		<script type="text/javascript" src="<system:util show="context" />/page/login/classic/login.js"></script>
		<script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script>
	</region:put>
	
	<region:put section='javascriptVariables'>
		var CONTEXT					= "<system:util show="context" />";
		var LOGIN_OK				= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_OK"/>";
		var LOGIN_ERROR				= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_ERROR"/>";
		var LOGIN_CHANGE_PWD		= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_CHANGE_PWD"/>";
		var LOGIN_USER_EXPIRED		= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_USER_EXPIRED"/>";
		var LOGIN_USER_BLOCKED		= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_USER_BLOCKED"/>";
		var CAPS_TITLE				= "<system:label show="text" label="msgBloqMay" forScript="true" />";
		var LOGIN_REMEMBER_TITLE	= '<system:label show="tooltip" label="btnRemPwd" forScript="true" />';
		var WAIT_A_SECOND			= '<system:label show="text" label="lblEspUnMom" forScript="true" />';
		var REMEMBER_MAIL_SENDED	= "<system:label show="text" label="msgMailEnv" forScript="true" />";
		var DO_LOGIN				= '<system:label show="text" label="btnLog" forScript="true" />';
		var SHOW_ENV_COMBO			= "<system:edit show="constant" from="com.dogma.Parameters" field="LOGIN_SHOW_ENV_COMBO"/>";
		var USER_LANGUAGE_SELECION	= '<%=uData.getLangId() %>';
		<!-- external access section -->
		var IS_EXTERNAL = "<system:edit show="value" from="theRequest" field="external" />";
		var EXTERNAL_TYPE = "<system:edit show="value" from="theRequest" field="externalType" />";
		var LANG_ID = "<system:edit show="value" from="theRequest" field="hidLangId" />";
		var FROM_OPEN_URL = "<system:edit show="value" from="theRequest" field="fromOpenUrl" />";
		var LOG_FROM_SESSION = "<system:edit show="value" from="theRequest" field="logFromSession"/>";
		var TYPE = "<system:edit show="value" from="theRequest" field="type"/>";
		var ENT_CODE = "<system:edit show="value" from="theRequest" field="entCode"/>";
		var PRO_CODE = "<system:edit show="value" from="theRequest" field="proCode"/>";
		var PRO_CANCEL_CODE = "<system:edit show="value" from="theRequest" field="proCancelCode"/>";
		var SESSION_ATTS = "<system:edit show="value" from="theRequest" field="sessionAtts"/>";
		var ON_FINISH = "<system:edit show="value" from="theRequest" field="onFinish"/>";
		var ATT_PARAMS = "<system:edit show="value" from="theRequest" field="attParams"/>";
		var QRY_ID = "<system:edit show="value" from="theRequest" field="qryId" />" != "null" ? "<system:edit show="value" from="theRequest" field="qryId" />" : "<system:edit show="value" from="theRequest" field="query" />";
		var ENV_ID = "<system:edit show="value" from="theRequest" field="envId" />";
		var NOM_TASK = "<system:edit show="value" from="theRequest" field="nomTsk" />";
		var NUM_INST = "<system:edit show="value" from="theRequest" field="numInst" />";
		
		var TAB_ID = "<%=System.currentTimeMillis() %>";
		var TOKEN_ID = TAB_ID;
		
		var isAuthenticated = <%=isAuthenticated %>;
		
		var filters = "<%
				String filters = "";
				Enumeration e = request.getParameterNames(); //Obtenemos todos los parametros
				while(e.hasMoreElements())	{ //recorremos todos los parametros
					String s_param = e.nextElement().toString();
					if (s_param.startsWith("filter_")){ //si el parametro comienza con filter_ entonces es un filtro
						//String filterValue = request.getParameter(s_param);
						//filters = filters + "&" + s_param + "="+ filterValue;
						String[] filterValues = request.getParameterValues(s_param);
						for(int i = 0; i < filterValues.length; i++) {
							filters = filters + "&" + s_param + "="+ filterValues[i];
						}
					}
				}
				out.print(filters);
			%>";
		<!-- end external access section -->
	</region:put>

	<region:put section='styleCode'>
		
	</region:put>

	<region:put section="htmlLanguages">
		<div class="languages">
			<system:util show="prepareLanguages" saveOn="languages" />
			<system:util show="prepareUserLanguage" saveOn="usrLanguage" />
			
			<system:edit show="iteration" from="languages" saveOn="language">
				<label class="language">
					<system:edit show="ifNotValue" from="language" field="langId" value="with:usrLanguage"><a href="<system:util show="context" />/apia.security.LoginAction.run?action=language&langId=<system:edit show="value" from="language" field="langId" />"></system:edit>
					<system:edit show="value" from="language" field="langName" />
					<system:edit show="ifNotValue" from="language" field="langId" value="with:usrLanguage"></a></system:edit>
				</label>
			</system:edit>
		</div>
	</region:put>

	<region:put section="htmlLogo">
		<div class="divImage">
			<div class="logoB"></div>
			<div class="logoA"></div>
		</div>
	</region:put>

	<region:put section="htmlForm">
		<c:set var="customLoginForm"		value="<%= !(Parameters.LOGIN_JSP_LOGIN == null || Parameters.LOGIN_JSP_LOGIN.length() == 0)  %>" />
		<c:set var="customChangePwdForm"	value="<%= !(Parameters.LOGIN_JSP_CHANGE_PWD == null || Parameters.LOGIN_JSP_CHANGE_PWD.length() == 0)  %>" />
		<c:set var="customRequestPwdForm"	value="<%= !(Parameters.LOGIN_JSP_REQUEST_PWD == null || Parameters.LOGIN_JSP_REQUEST_PWD.length() == 0)  %>" />
		<c:set var="passwordRegExp"			value="<%= Parameters.PWD_REG_EXP%>" />
		<c:set var="showEnvCombo"			value="<%= Parameters.LOGIN_SHOW_ENV_COMBO%>" />
		<c:set var="showGenPwd"				value="<%= Parameters.LOGIN_SHOW_GEN_PWD && !isAuthenticated%>" />
		<c:set var="isAuthenticated"		value="<%= isAuthenticated %>" />
		
		<!-- LOGIN FORM -->
		<c:if test="${!customLoginForm}">
			<form id="loginForm" action="">
				<div class="section">
					<div class="field required">
						<label title="<system:label show="tooltip" label="lblUsu" />"><system:label show="text" label="lblUsu" />:</label>
						<c:choose>
							<c:when test="${isAuthenticated=='true'}">
								<input type="text" id="loginUsr" value="<%=remoteUser %>" disabled="true" class="readonly" >
							</c:when>
							<c:otherwise>
								<input type="text" id="loginUsr" class="validate['required']" >
							</c:otherwise>
						</c:choose>
					</div>
					<c:choose>
						<c:when test="${isAuthenticated=='true'}">
							<div class="field required"></div>
						</c:when>
						<c:otherwise>
							<div class="field required">
								<label title="<system:label show="tooltip" label="lblPwd" />"><system:label show="text" label="lblPwd" />:</label>
								<input type="password" id="loginPassword" class="validate['required']">
							</div>
						</c:otherwise>
					</c:choose>
				</div>
				<div class="section">
					<div class="field required">
						<label title="<system:label show="tooltip" label="lblAmb" />"><system:label show="text" label="lblAmb" /></label>
						<c:if test="${showEnvCombo=='true'}">
							<select id="loginEnvironment" style="width: 100%">
								<system:util show="prepareEnvironments" saveOn="environments" />
								<system:edit show="iteration" from="environments" saveOn="environment">
									<option value="<system:edit show="value" from="environment" field="envId"/>"><system:edit show="value" from="environment" field="envName"/></option>
								</system:edit>
							</select>
						</c:if>
						<c:if test="${showEnvCombo!='true'}">
							<input type="text" id="loginEnvironmentName"  class="validate['required']">
						</c:if>
					</div>
				</div>
				<div class="section">	
					<div class="field">
						<br/>
						<div id="login" title="<system:label show="tooltip" label="btnLog" />" class='validate["submit"]'>
							<system:label show="text" label="btnLog" />
						</div>
					</div>
				</div>
				<c:if test="${showGenPwd=='true'}">
					<div class="section  loginRemember">
						<a href="#" id="loginRemember" title="<system:label show="tooltip" label="btnRemPwd" />"><system:label show="text" label="btnRemPwd" /></a>
					</div>
				</c:if>
			</form>
		</c:if>
		<c:if test="${customLoginForm}">
			<jsp:include page="<%=Parameters.LOGIN_JSP_LOGIN  %>"/>
		</c:if>
		
		<!-- CHANGE PASSWORD FORM -->
		<c:if test="${!customChangePwdForm}">
			<form id="passwordForm" class="hidden" action="">
				<div class="section">
					<div class="field required">
						<label title="<system:label show="tooltip" label="lblPwd" />"><system:label show="text" label="lblPwdAct" />:</label>
						<input type="password" id="currentPassword" class="validate['required']">
					</div>
					<div class="field required">
						<label title="<system:label show="tooltip" label="lblPwdNew" />"><system:label show="text" label="lblPwdNew" />:</label>
						<input type="password" id="newPassword" name="newPassword" class="validate['required','~fieldRegExp']" regExp="<c:out value="${passwordRegExp}"/>" regExpMessage="mensaje de exp regular" title="<system:label show="text" label="lblConPwd" />" >
					</div>
					<div class="field required">
						<label title="<system:label show="tooltip" label="lblConPwd" />"><system:label show="text" label="lblConPwd" />:</label>
						<input type="password" id="newPasswordConf" class="validate['required','confirm:newPassword']">
					</div>
				</div>
				<div class="section">
					<div class="field">
						<br>
						<div class="validate['submit']" id="changePwd" title="<system:label show="tooltip" label="btnLog" />"><div class="genericDivBtn " tabindex="0"><span class=""><system:label show="text" label="btnLog" /></span></div></div>
					</div>
					<div class="field">
						<br>
						<div class="validate['submit']" id="cancelChangePwd" title="<system:label show="tooltip" label="btnCan" />"><div class="genericDivBtn " tabindex="0"><span class=""><system:label show="text" label="btnCan" /></span></div></div>
					</div>
				</div>
			</form>
		</c:if>
		<c:if test="${customChangePwdForm}">
			<jsp:include page="<%= Parameters.LOGIN_JSP_CHANGE_PWD %>"/>
		</c:if>
		<!-- REQUEST PASSWORD FORM -->
		<c:if test="${!customRequestPwdForm}">
			<form id="requestForm" class="hidden" action="">
				<div class="section">
					<div class="field required">
						<label title="<system:label show="tooltip" label="lblUsu" />"><system:label show="text" label="lblUsu" />:</label>
						<input type="text" id="rememberUser" class="validate['required']">
					</div>
					<div class="field required">
						<label title="<system:label show="tooltip" label="lblEma" />"><system:label show="text" label="lblEma" />:</label>
						<input type="text" id="rememberEmail" class="validate['required']">
					</div>
				</div>
				<div class="section">
					<div class="field">
						<br>
						<div class="validate['submit']" id="rememberBtn"><div class="genericDivBtn " tabindex="0"><span class=""><system:label show="text" label="btnRemPwd" /></span></div></div>
					</div>
				</div>
				<div class="section loginRemember">
					<a title="" id="doLogin" href="#"><system:label show="text" label="btnLog" /></a>
				</div>
			</form>
		</c:if>
		<c:if test="${customRequestPwdForm}">
			<jsp:include page="<%= Parameters.LOGIN_JSP_REQUEST_PWD %>"/>
		</c:if>
	</region:put>

	<region:put section="htmlCampaign">
		<system:campaign inLogin="true" inSplash="false" />
	</region:put>
	
	<region:put section="htmlMessages">
		<div class="message hidden" id="messageContainer">
			
		</div>
		<system:util show="ifInvalidVersion" >
			<div class="message fatalError">
				<b>ERROR IN DATABASE VERSION (<system:util show="versionDb" />) <br>AND CODE VERSION (<system:util show="versionApia" />)</b><br>
				Please contact the administrator
			</div>
		</system:util>
	</region:put>
		
	<region:put section="htmlFooter">
		<%@include file="../../includes/footer.jsp" %>
	</region:put>
</region:render>