<%@page import="com.dogma.Configuration"%>
<%@page import="biz.statum.apia.web.bean.security.LoginBean"%>
<%@page import="java.util.Enumeration"%>
<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%>
<%@page import="com.dogma.UserData"%>
<%@page import="biz.statum.sdk.util.StringUtil"%>
<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
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

String ua = request.getHeader("User-Agent").toLowerCase();
String force = request.getParameter("force");	
if ("mobile".equals(force) || !"full".equals(force) && ua.matches("(?i).*((android|bb\\d+|meego).+mobile|avantgo|bada\\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\\.(browser|link)|vodafone|wap|windows ce|xda|xiino).*")||ua.substring(0,4).matches("(?i)1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\\-(n|u)|c55\\/|capi|ccwa|cdm\\-|cell|chtm|cldc|cmd\\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\\-s|devi|dica|dmob|do(c|p)o|ds(12|\\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\\-|_)|g1 u|g560|gene|gf\\-5|g\\-mo|go(\\.w|od)|gr(ad|un)|haie|hcit|hd\\-(m|p|t)|hei\\-|hi(pt|ta)|hp( i|ip)|hs\\-c|ht(c(\\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\\-(20|go|ma)|i230|iac( |\\-|\\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\\/)|klon|kpt |kwc\\-|kyo(c|k)|le(no|xi)|lg( g|\\/(k|l|u)|50|54|\\-[a-w])|libw|lynx|m1\\-w|m3ga|m50\\/|ma(te|ui|xo)|mc(01|21|ca)|m\\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\\-2|po(ck|rt|se)|prox|psio|pt\\-g|qa\\-a|qc(07|12|21|32|60|\\-[2-7]|i\\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\\-|oo|p\\-)|sdk\\/|se(c(\\-|0|1)|47|mc|nd|ri)|sgh\\-|shar|sie(\\-|m)|sk\\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\\-|v\\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\\-|tdg\\-|tel(i|m)|tim\\-|t\\-mo|to(pl|sh)|ts(70|m\\-|m3|m5)|tx\\-9|up(\\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\\-|your|zeto|zte\\-")) {
	session.setAttribute("mobile", "true");		
} else {
	session.removeAttribute("mobile");
}

%>
<region:render template='<%=template%>'>
	
	<region:put section='linkCss'>	
		<system:util show="baseLoginStyles" />
		
		<%if("true".equals(session.getAttribute("mobile")) ) {%>		
			<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<%}%>
		
	</region:put>
	
	<region:put section='scriptJs'>
		<script type="text/javascript" src="<system:util show="context" />/js/modernizr.custom.js"></script>
		<script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script>
		<script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script>
		<script type="text/javascript" src="<system:util show="context" />/js/generics.js"></script>
		
		<%com.dogma.UserData uDataAux = biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request);%>
		<script type="text/javascript" src="<system:util show="context" />/js/formcheck/lang/<%=uDataAux.getLangCode()%>.js"> </script>
	
		
		<script type="text/javascript" src="<system:util show="context" />/js/formcheck/formcheck.js"> </script>
		<script type="text/javascript" src="<system:util show="context" />/page/login/classic/login.js"></script>
		<script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script>
		<script type="text/javascript" src="<system:util show="context" />/js/aes/aes.js"></script>
		
		<%if("true".equals(session.getAttribute("mobile"))) {%>
		<script type="text/javascript" src="<system:util show="context" />/js/modal.js"></script>
		<% } %>
	</region:put>
	
	<region:put section='javascriptVariables'>
		var CONTEXT					= "<system:util show="context" />";
		var LOGIN_OK				= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_OK"/>";
		var LOGIN_ERROR				= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_ERROR"/>";
		var LOGIN_CHANGE_PWD		= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_CHANGE_PWD"/>";
		var LOGIN_USER_EXPIRED		= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_USER_EXPIRED"/>";
		var LOGIN_USER_BLOCKED		= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_USER_BLOCKED"/>";
		var LOGIN_ERROR_CAPTCHA		= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_ERROR_CAPTCHA"/>";
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
		var ON_FINISH_URL = "<system:edit show="value" from="theRequest" field="onFinishURL"/>";
		var ENT_INST_ID="<system:edit show="value" from="theRequest" field="entInstId"/>";
		var ATT_PARAMS = "<system:edit show="value" from="theRequest" field="attParams"/>";
		var QRY_ID = "<system:edit show="value" from="theRequest" field="qryId" />" != "null" ? "<system:edit show="value" from="theRequest" field="qryId" />" : "<system:edit show="value" from="theRequest" field="query" />";
		var ENV_ID = "<system:edit show="value" from="theRequest" field="envId" />"  != "" ? "<system:edit show="value" from="theRequest" field="envId" />" : "<system:edit show="value" from="theRequest" field="cmbEnv" />";
		var NOM_TASK = "<system:edit show="value" from="theRequest" field="nomTsk" />";
		var NUM_INST = "<system:edit show="value" from="theRequest" field="numInst" />";
		
		var TAB_ID = "<%=System.currentTimeMillis() %>";
		var TOKEN_ID = TAB_ID;
		
		var isAuthenticated = <%=isAuthenticated %>;
		
		var LBL_CAPTCHA = "<system:label show="text" label="lblVerifCode" forHtml="true"/>";
		
		var MOBILE = <%= "true".equals(session.getAttribute("mobile")) ? "true" : "false" %>;
		var BTN_CLOSE = '<system:label show="text" label="btnCer" forHtml="true" forScript="true"/>';
		
		if (MOBILE){ $(window.document.html).addClass("mobile-mode"); }
		
		var iv 				= '<%=biz.statum.apia.utils.AES.IV%>';
		var salt 			= '<%=biz.statum.apia.utils.AES.SALT%>';
		var keySize 		= 128;
		var iterationCount	= 100;
		var passPhrase		= '<%=uData.getPassPhrase() %>';
		
		
		
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

	<region:put section="htmlLanguages">
		<div class="languages <%="true".equals(session.getAttribute(LoginBean.SESSION_ATT_USE_CAPTCHA)) ? "captchaActive" : ""%>">
			<system:util show="prepareLanguages" saveOn="languages" />
			<system:util show="prepareUserLanguage" saveOn="usrLanguage" />
			
			<system:edit show="iteration" from="languages" saveOn="language">
				
				<system:edit show="ifValue" from="language" field="langId" value="with:usrLanguage">
					<span class="language currentLanguage lang_<system:edit show="value" from="language" field="langName" />">
						<a href="#"><system:edit show="value" from="language" field="langTitle" /></a>
					</span>
				</system:edit>
				<system:edit show="ifNotValue" from="language" field="langId" value="with:usrLanguage">
					<span class="language lang_<system:edit show="value" from="language" field="langName" />">
						<a href="<system:util show="context" />/apia.security.LoginAction.run?action=language&langId=<system:edit show="value" from="language" field="langId" />"><system:edit show="value" from="language" field="langTitle" /></a>
					</span>
				</system:edit>
					
				
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
			<form id="loginForm" action="" method="get">
				<div class="loginContainer">
					<div class="section sec1">
						<div class="field required">
							<label title="<system:label show="tooltip" label="lblUsu" />" for="loginUsr"><system:label show="text" label="lblUsu" />:</label>
							<c:choose>
								<c:when test="${isAuthenticated=='true'}">
									<input type="text" id="loginUsr" value="<%=remoteUser %>" disabled="disabled" class="readonly" autocomplete="off">
								</c:when>
								<c:otherwise>
									<input type="text" id="loginUsr" class="validate['required']" autocomplete="off">
								</c:otherwise>
							</c:choose>
						</div>
						<c:choose>
							<c:when test="${isAuthenticated=='true'}">
								<div class="field required"></div>
							</c:when>
							<c:otherwise>
								<div class="field required fieldLast">
									<label title="<system:label show="tooltip" label="lblPwd" />" for="loginPassword"><system:label show="text" label="lblPwd" />:</label>
									<input type="password" id="loginPassword" class="validate['required']" autocomplete="off">
								</div>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="section sec2">
						<div class="field required fieldEnvironment">
							<c:if test="${showEnvCombo=='true'}">
								<label title="<system:label show="tooltip" label="lblAmb" />" for="loginEnvironment"><system:label show="text" label="lblAmb" /></label>
								<select id="loginEnvironment">
									<system:util show="prepareEnvironments" saveOn="environments" />
									<system:edit show="iteration" from="environments" saveOn="environment">
										<option value="<system:edit show="value" from="environment" field="envId"/>"><system:edit show="value" from="environment" field="envTitle"/></option>
									</system:edit>
								</select>
							</c:if>
							<c:if test="${showEnvCombo!='true'}">
								<label title="<system:label show="tooltip" label="lblAmb" />" for="loginEnvironmentName"><system:label show="text" label="lblAmb" /></label>
								<input type="text" id="loginEnvironmentName"  class="validate['required']" autocomplete="off">
							</c:if>
						</div>
					</div>
					<% if("true".equals(session.getAttribute(LoginBean.SESSION_ATT_USE_CAPTCHA))) { %>
					<div class="section sec3">
						<div class="field required fieldCaptcha">				
							<label title="<system:label show="tooltip" label="lblVerifCode" />" for="captchaText"><system:label show="text" label="lblVerifCode" /></label>
							<img id="captchaImg" src="<system:util show="context" />/captchaImg" />
							<input type="text" id="captchaText"  class="validate['required']">
							<br/>
						</div>
					</div>
					<% } %>
					<div class="section loginBtn">	
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
					
					<div class="section fullSite" style="display: none;">
						<a href="<system:util show="context" />/index.jsp?force=full">
							<system:label show="text" label="lblFullSite" />
						</a>
					</div>
				</div>
			</form>
		</c:if>
		<c:if test="${customLoginForm}">
			<jsp:include page="<%=Parameters.LOGIN_JSP_LOGIN  %>"/>
		</c:if>
		
		<!-- CHANGE PASSWORD FORM -->
		<c:if test="${!customChangePwdForm}">
			<form id="passwordForm" class="hidden" action="" method="get">
				<div class="loginContainer">
					<div class="section sec4">
						<div class="field required">
							<label title="<system:label show="tooltip" label="lblPwd" />" for="currentPassword"><system:label show="text" label="lblPwdAct" />:</label>
							<input type="password" id="currentPassword" class="validate['required']">
						</div>
						<div class="field required">
							<label title="<system:label show="tooltip" label="lblPwdNew" />" for="newPassword"><system:label show="text" label="lblPwdNew" />:</label>
							<input type="password" id="newPassword" name="newPassword" class="validate['required','~fieldRegExp']" data-regExp="<c:out value="${passwordRegExp}"/>" data-regExpMessage="<system:label show="text" label="msgInvRegExpPwd"   />" title="<system:label show="text" label="lblPwdNew" />" >
						</div>
						<div class="field required">
							<label title="<system:label show="tooltip" label="lblConPwd" />" for="newPasswordConf"><system:label show="text" label="lblConPwd" />:</label>
							<input type="password" id="newPasswordConf" name="newPasswordConf" class="validate['required','confirm:newPassword']">
						</div>
					</div>
					<div class="section sec5">
						<div class="field">
							<br>
							<div class="validate['submit']" id="changePwd" title="<system:label show="tooltip" label="btnLog" />"><system:label show="text" label="btnLog" /></div>
						</div>
						<div class="field">
							<br>
							<div class="validate['submit']" id="cancelChangePwd" title="<system:label show="tooltip" label="btnCan" />"><system:label show="text" label="btnCan" /></div>
						</div>
					</div>
				</div>
			</form>
		</c:if>
		<c:if test="${customChangePwdForm}">
			<jsp:include page="<%= Parameters.LOGIN_JSP_CHANGE_PWD %>"/>
		</c:if>
		<!-- REQUEST PASSWORD FORM -->
		<c:if test="${!customRequestPwdForm}">
			<form id="requestForm" class="hidden" action="" method="get">
				<div class="loginContainer">
					<div class="section sec6">
						<div class="field required">
							<label title="<system:label show="tooltip" label="lblUsu" />" for="rememberUser"><system:label show="text" label="lblUsu" />:</label>
							<input type="text" id="rememberUser" class="validate['required']" autocomplete="off">
						</div>
						<div class="field required fieldLast">
							<label title="<system:label show="tooltip" label="lblEma" />" for="rememberEmail"><system:label show="text" label="lblEma" />:</label>
							<input type="text" id="rememberEmail" class="validate['required']" autocomplete="off">
						</div>
					</div>
					<div class="section genPassBtn">
						<div class="field">
							<br>
							<div class="validate['submit']" id="rememberBtn" title="<system:label show="tooltip" label="btnRemPwd" />"><system:label show="text" label="btnRemPwd" /></div>
						</div>
					</div>
					<div class="section loginRemember">
						<a title="<system:label show="tooltip" label="btnLog" />" id="doLogin" href="#"><system:label show="text" label="btnLog" /></a>
					</div>
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