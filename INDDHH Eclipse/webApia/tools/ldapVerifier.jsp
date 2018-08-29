<%@page import="biz.statum.sdk.util.CollectionUtil"%>
<%@page import="com.dogma.busClass.userValidation.UserData"%>
<%@page import="java.util.Collection"%>
<%@page import="com.dogma.util.LDAPAccessor"%>
<%@page import="com.dogma.Parameters"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@page import="biz.statum.sdk.util.StringUtil"%>

<%@include file="_commonValidate.jsp" %>

<%!

final static String ENTER = "\r\n";

public static String verifie(Integer amount) throws ClassNotFoundException {
	if (amount == null) amount = new Integer(3);
	StringBuffer buffer = new StringBuffer();

	try {
		buffer.append("Creating object..." + ENTER);
		LDAPAccessor ldapAcc = new LDAPAccessor();
		
		buffer.append("Loading users..." + ENTER);
		long start = System.currentTimeMillis();
		Collection<UserData> col = ldapAcc.getLDAPUsers("");
		long end = System.currentTimeMillis();
		
		buffer.append("Users " + CollectionUtil.size(col) + " loaded in " + (end - start) + " ms" + ENTER);
		
		if (CollectionUtil.notEmpty(col)) {
			buffer.append("Showing information for the first <b>" + amount.intValue() + "</b> users:" + ENTER);
			int i = 0;
			for (UserData ldapUsr : col) {
				buffer.append("Login: " + ldapUsr.getUserLogin() + ENTER);
				buffer.append("Name: " + ldapUsr.getUserName() + ENTER);
				buffer.append("Email: " + ldapUsr.getUserEMail() + ENTER);
				buffer.append("Comments: " + ldapUsr.getUserComments() + ENTER);
				buffer.append(ENTER);
				
				if (++i == amount.intValue()) break;
			}
		}
		
	} catch (Exception e) {
		buffer.append(StringUtil.toString(e));
	}
	
	return buffer.toString();
}

%>

<html>
<head>
	<title>LDAP Verifier</title>
	<style type="text/css">
		<%@include file="_commonStyles.jsp" %>
	</style>
	
	<%@include file="_commonInclude.jsp" %>
	
	<script type="text/javascript">
		<%@include file="_commonScript.jsp" %>
	</script>
	
</head>
<body>
	<%@include file="_commonLogin.jsp" %>

<% if (_logged) {
	String ldap = request.getParameter("ldap");
	Integer amount = new Integer(3);
	try { amount = new Integer(request.getParameter("amount")); } catch (Exception e) { amount = new Integer(3); }
	String result = "";
	
	if (ldap != null && ldap.length() > 0) {
		try {
			result = verifie(amount);
		} catch (Exception e) {
			result = StringUtil.toString(e);
		}
	}
	
	%>
	
	<%@include file="_commonLogout.jsp" %>
	<h3>Parameters</h3>
	<% boolean useLdapAuth = Parameters.AUTHENTICATION_METHOD.equals(Parameters.AUTHENTICATION_APIA_LDAP) || Parameters.AUTHENTICATION_METHOD.equals(Parameters.AUTHENTICATION_LDAP); %>
	LDAP Authentication: <b><%= useLdapAuth %></b><br>
	User: <b><%= Parameters.LDAP_ROOT_USER %></b><br>
	Password: <b><%= StringUtil.notEmpty(Parameters.LDAP_ROOT_PWD) %></b><br>
	Provider: <b><%= Parameters.LDAP_PROVIDER %></b><br>
	Organization: <b><%= Parameters.LDAP_ORGANIZATION %></b><br>
	Use @: <b><%= Parameters.LDAP_AD_ARROBA_DOMAIN %></b><br>
	AD Domain: <b><%= Parameters.LDAP_AD_DOMAIN %></b><br><br>
	Attribute for login: <b><%= Parameters.LDAP_ATT_LOGIN %></b><br>
	Attribute for name: <b><%= Parameters.LDAP_ATT_NAME %></b><br>
	Attribute for mail: <b><%= Parameters.LDAP_ATT_MAIL %></b><br>
	Attribute for comments: <b><%= Parameters.LDAP_ATT_COMM %></b><br>
	
	<% if (useLdapAuth) {%>
		<br>
		<form action="?">
			<h3>Test users</h3>
			Amount to show: <input type="text" name="amount" value="<%= amount.intValue() %>">
			<input type="hidden" value="true" name="ldap">
			<input type="submit" value="Check LDAP access">
		</form>
		<hr>
		<pre><%if (result != null) { %><%= result %><% } %></pre>
	<% }
} %>
</body>
</html>
	