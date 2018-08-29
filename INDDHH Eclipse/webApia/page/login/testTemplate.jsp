<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %>
<%@ taglib uri='regions' prefix='region' %>
<%@ page import="com.dogma.Parameters"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Apia</title>
	
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
	<table>
		<tr>
			<td>
				<div class="header">
					<region:render section='htmlLanguages'/>
				</div>
			
				<region:render section='htmlLogo'/>
				
				<div class="body" id="bodyDiv">
					<region:render section='htmlForm'/>
			
					<region:render section='htmlMessages'/>
				</div>
			</td>
			<td>
				pepe
			</td>
		</tr>
	</table>
	<region:render section='htmlFooter'/>
	
</body>

</html>