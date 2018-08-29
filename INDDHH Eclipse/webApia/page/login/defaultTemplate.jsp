<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %>
<%@ taglib uri='regions' prefix='region' %>
<%@ page import="com.dogma.Parameters"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
	<title>Apia</title>
	
	<region:render section='linkCssDefaultLogin'/>
	<region:render section='linkCssDefaultMessage'/>
	<region:render section='linkCssDefaultSpinner'/>
	<region:render section='linkCss'/>
	
	<link rel="shortcut icon" href="<system:util show="context" />/css/<system:util show="defaultStyle" />/favicon.ico">
	
	<region:render section='scriptJs'/>
	
	<script type="text/javascript">
		<region:render section='javascriptVariables'/>
	</script>

	<style type="text/css">
		<region:render section='styleCode'/>
	</style>
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