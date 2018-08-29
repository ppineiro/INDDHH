<%@page import="biz.statum.sdk.util.StringUtil"%>
<%@include file="_commonValidate.jsp" %>

<html>
	<head>
		<title>Password generator</title>

		<style type="text/css">
			<%@include file="_commonStyles.jsp" %>
			.fieldGroup { display: inline-block; margin-right: 10px; vertical-align: top; }
		</style>
		
		<%@include file="_commonInclude.jsp" %>
		
		<script type="text/javascript">
			<%@include file="_commonScript.jsp" %>
		</script>
	</head>
<body>


	<%@include file="_commonLogin.jsp" %>
	
	<% if (_logged) { %>
		<%@include file="_commonLogout.jsp" %>
		<div class="fieldGroup">
			<h3>Database password</h3>
			<form action="?" method="post">
				<input type="hidden" name="generate" value="db">
				Password: <input type="text" value="" name="pwd">
				Action: <select name="method"><option value="encrypt">encrypt</option><option value="descrypt">decrypt</option></select> 
				<input type="submit" value="Generate">
			</form><% 
			
			boolean generateDbPwd = "db".equals(request.getParameter("generate"));
			if (generateDbPwd) { 
				String dbPwd = request.getParameter("pwd");
				String dbMethod = request.getParameter("method");
				boolean doEncryption = "encrypt".equals(dbMethod); %>
				<h3>Database password - <%= doEncryption ? "Encryption" : "Decryption" %></h3>
				Password: <b><%= dbPwd %></b><br>
				<%= doEncryption ? "Ecnrypted" : "Decrypted" %>: <b><%= doEncryption ? com.st.util.CryptUtils.encript(dbPwd) : com.st.util.CryptUtils.decript(dbPwd) %></b><br>
			<% } %>
		</div>
		
		<div class="fieldGroup">
			<h3>User password</h3>
			<form action="?" method="post">
				<input type="hidden" name="generate" value="user">
				User: <input type="text" value="" name="usr"> 
				Password: <input type="text" value="" name="pwd"> 
				<input type="submit" value="Generate">
			</form><%
			
			boolean generateUsrPwd = "user".equals(request.getParameter("generate"));

			if (generateUsrPwd) {
				String usrUsr = request.getParameter("usr");
				String usrPwd = request.getParameter("pwd"); %>
				<h3>User password - generation</h3>
				User: <b><%= usrUsr %></b><br>
				Password: <b><%= usrPwd %></b><br>
				Encrypted: <b><%= com.st.util.CryptUtils.makePasswordDigest(usrUsr, usrPwd) %></b><br>
			<% } %>
		</div>
	<% } %>

</body>
</html>