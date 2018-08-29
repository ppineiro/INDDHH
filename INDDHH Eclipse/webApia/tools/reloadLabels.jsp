<%com.st.util.labels.LabelManager.loadLabels();%>


<%@include file="_commonValidate.jsp" %>

<html>
<head>
	<title>Reload parameters and labels</title>
	<style type="text/css">
		<%@include file="_commonStyles.jsp" %>
		
		.toolActive { font-weight: bold; cursor: pointer; }
		.toolInactive { color: gray; }
	</style>
	
	<%@include file="_commonInclude.jsp" %>
	
	<script type="text/javascript">
		<%@include file="_commonScript.jsp" %>
	</script>
</head>
<body>

	<%@include file="_commonLogin.jsp" %>
	
	<% if (_logged) { %>
		Reloading labels ... <%com.st.util.labels.LabelManager.loadLabels();%> (labels loaded)<br>
		Reloading parameters ... <% com.dogma.Parameters.reloadParameters(); %> (parameter loaded)<br>
		Reloading environment parameters ... <% com.dogma.EnvParameters.reloadParameters(); %> (environment parameters loaded)<br>
		Reloading translations <% com.st.util.translator.TranslationManager.reloadStructure(); %> (translations loaded)<br>
	<% } %>

</body>
</html>