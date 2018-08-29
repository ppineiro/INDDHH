<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE html><html><head><title>Apia</title><%@include file="../common/headInclude.jsp" %><!-- Script --><script type="text/javascript" src="<system:util show="context" />/miniSite/classic/index.js"></script><!-- CSS --><link rel="stylesheet" href="<system:util show="context" />/miniSite/css/default/index.css"><script type="text/javascript">
		var CONTEXT					= "<system:util show="context" />";
		var WAIT_A_SECOND			= "<system:label show="text" label="lblEspUnMom" />";
		var LOGIN_OK				= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_OK"/>";
		var LOGIN_ERROR				= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_ERROR"/>";
		var LOGIN_CHANGE_PWD		= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_CHANGE_PWD"/>";
		var LOGIN_USER_EXPIRED		= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_USER_EXPIRED"/>";
		var LOGIN_USER_BLOCKED		= "<system:edit show="constant" from="biz.statum.apia.web.bean.security.LoginBean" field="LOGIN_USER_BLOCKED"/>";
		var LBL_YES					= "<system:label show="text" label="lblSi" forScript='true'  forHtml='true' />";
		var LBL_NO					= "<system:label show="text" label="lblNo" forScript='true'  forHtml='true' />";
		var TOKENID					= "1";
		var langId 					= "<%=BasicBeanStatic.getUserDataStatic(request).getLangId()%>";
		var LBL_REQ					= '<system:label show="text" label="msgReqFields" forScript="true"  forHtml="true" />';
		
	</script></head><body id="body"><!--div class="header"><div class="logo"></div></div--><div class="logo"></div><div class="message hidden" id="messageContainer"></div><div class="content"><form id="loginForm"><div class="login"><div class="fieldset"><input type="text" id="loginUsr"><input type="password" id="loginPassword"><select id="loginEnvironment"><system:util show="prepareEnvironments" saveOn="environments" /><system:edit show="iteration" from="environments" saveOn="environment"><option value="<system:edit show="value" from="environment" field="envId"/>"><system:edit show="value" from="environment" field="envName"/></option></system:edit></select></div><div class="remember"><label title="<system:label show="tooltip" label="lblRec" />"><system:label show="text" label="lblRec" /></label><input type="checkbox" id="chkRemember"></div><div class="minisiteLanguages"><system:util show="prepareLanguages" saveOn="languages" /><system:util show="prepareUserLanguage" saveOn="usrLanguage" /><system:edit show="iteration" from="languages" saveOn="language"><label class="language"><a href="<system:util show="context" />/apia.security.LoginAction.run?action=languageMinisite&langId=<system:edit show="value" from="language" field="langId" />"><system:edit show="ifValue" from="language" field="langId" value="with:usrLanguage"><b></system:edit><system:edit show="value" from="language" field="langName" /><system:edit show="ifValue" from="language" field="langId" value="with:usrLanguage"></b></system:edit></a></label></system:edit></div><div class="fullSite"><a href="<system:util show="context" />/apia.security.LoginAction.run?action=init&force=full"><system:label show="text" label="lblFullSite" /></a></div><div id="btnLogin">
					Login
				</div></div></form></div></body></html>

