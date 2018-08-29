<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%>

<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %>
<%@ taglib uri='regions' prefix='region' %>
<%@ page import="com.dogma.Parameters"%>
<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<!DOCTYPE html>
<html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>">
	<meta name="theme-color" content="#2A467A">
	<title><%=Parameters.DISPLAY_TITLE%></title>
<%-- 	<region:render section='linkCssDefaultLogin'/> --%>
<%-- 	<region:render section='linkCssDefaultMessage'/> --%>
<%-- 	<region:render section='linkCssDefaultSpinner'/> --%>
	<region:render section='linkCss'/>
	
	<link rel="shortcut icon" href="<system:util show="context" />/css/<system:util show="defaultStyle" />/favicon.ico">
	
	<region:render section='scriptJs'/>
	
	<script type="text/javascript">
		<region:render section='javascriptVariables'/>
	</script>
	
</head>

<body>
	<div class="header">
		<region:render section='htmlLanguages'/>
	</div>

	<region:render section='htmlLogo'/>
	
	<div class="body" id="bodyDiv">
		<div style="clear: both;">
			<region:render section='htmlForm'/>
			<region:render section='htmlMessages'/>
		</div>

		<div style="clear: both;">
			<region:render section='htmlCampaign'/>
		</div>
	</div>
		
	<region:render section='htmlFooter'/>
	
</body>

</html>