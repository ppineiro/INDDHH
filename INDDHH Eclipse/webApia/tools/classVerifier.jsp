<%@page import="java.net.URL"%>
<%@page import="java.net.URI"%>
<%@page import="java.lang.reflect.Method"%>
<%@page import="java.lang.reflect.Modifier"%>
<%@page import="com.st.util.ClassUtil"%>
<%@page import="java.lang.reflect.Field"%>
<%@page import="biz.statum.sdk.util.StringUtil"%>
<%@page import="com.dogma.DogmaException"%>
<%@page import="com.dogma.vo.BusClaParBindingVo"%>
<%@page import="com.dogma.dao.BusClaParBindingDAO"%>
<%@page import="com.dogma.dao.gen.GenericDAO"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%@ page contentType="text/html; charset=iso-8859-1" language="java"%>
<%@ page import="com.st.db.dataAccess.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@page import="java.io.File"%>

<%@include file="_commonValidate.jsp" %>

<%!

final static String ENTER = "\r\n";

public static String verifie(String className) throws Exception {
	Class aClass = Class.forName(className);
	Object aInstance = null;
	
	try {
		aInstance = aClass.newInstance();
	} catch (Exception e) {}
	
	StringBuffer buffer = new StringBuffer();
	
	buffer.append("Location: " + ClassUtil.getClassLocation(aClass) + ENTER);
	
	Field[] fields = aClass.getFields();
	
	buffer.append(ENTER);
	if (fields != null) {
		buffer.append("Fields: " + fields.length + ENTER);
		for (Field field : fields) {
			int modifiers = field.getModifiers();
			
			buffer.append("(" + modifiers + ") ");
			
			if (Modifier.isPrivate(modifiers)) buffer.append("private ");
			if (Modifier.isProtected(modifiers)) buffer.append("protected ");
			if (Modifier.isPublic(modifiers)) buffer.append("public ");
			if (Modifier.isFinal(modifiers)) buffer.append("final ");
			if (Modifier.isStatic(modifiers)) buffer.append("static ");
			if (Modifier.isAbstract(modifiers)) buffer.append("abstract ");
			
			buffer.append(field.getType().getName() + " ");
			buffer.append(field.getName());
			try {
				buffer.append( " = ");
				field.setAccessible(true);
				buffer.append(field.get(aInstance).toString());
			} catch (Exception e) {}
			buffer.append(ENTER);
		}
	} else {
		buffer.append("Fields: n/a" + ENTER);
	}
	
	Method[] methods = aClass.getMethods();
	
	buffer.append(ENTER);
	if (methods != null) {
		buffer.append("Methods: " + methods.length + ENTER);
		for (Method method : methods) {
			int modifiers = method.getModifiers();
			
			buffer.append("(" + modifiers + ") ");
			
			if (Modifier.isPrivate(modifiers)) buffer.append("private ");
			if (Modifier.isProtected(modifiers)) buffer.append("protected ");
			if (Modifier.isPublic(modifiers)) buffer.append("public ");
			if (Modifier.isFinal(modifiers)) buffer.append("final ");
			if (Modifier.isStatic(modifiers)) buffer.append("static ");
			if (Modifier.isAbstract(modifiers)) buffer.append("abstract ");
			
			buffer.append(method.getReturnType().getName() + " ");
			buffer.append(method.getName() + "(");
			
			Class<?>[] params = method.getParameterTypes();
			
			if (params != null) {
				boolean addComa = false;
				for (Class param : params) {
					if (addComa) buffer.append(", ");
					buffer.append(param.getName());
					addComa = true;
				}
			}
			
			buffer.append(")");
			
			Class<?>[] exceptions = method.getExceptionTypes();
			
			if (exceptions != null && exceptions.length > 0) {
				buffer.append("throws ");
				boolean addComa = false;
				for (Class exception : exceptions) {
					if (addComa) buffer.append(", ");
					buffer.append(exception.getName());
					addComa = true;
				}
			}
			
			buffer.append(ENTER);
		}
	} else {
		buffer.append("Methods: n/a" + ENTER);
	}
	return buffer.toString();
}

%>

<html>
<head>
	<title>Class verifier</title>
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
		String classToVerifie = request.getParameter("aClass");
		String result = "";
		
		if (classToVerifie == null) classToVerifie = "";
		
		if (classToVerifie.length() > 0) {
			try {
				result = verifie(classToVerifie);
			} catch (Exception e) {
				result = StringUtil.toString(e);
			}
		}
		
		String webInf = request.getParameter("webInf");
		if (webInf == null) webInf = "false";
		if ("true".equals(webInf)) {
			try {
				URL url = biz.statum.sdk.util.ClassUtil.class.getProtectionDomain().getCodeSource().getLocation();
				result += "URL: " + url + ENTER;
				result += "URL path: " + url.getPath() + ENTER;
				File file = new java.io.File(url.getPath());
				result += "File: " + file + ENTER;
				String webinfpath = file.getAbsolutePath();
				result += "WEB-INF location: " + webinfpath + ENTER;
			} catch (Exception e) {
				result += ENTER + ENTER + "Errro found: " + e.getMessage();
				result = StringUtil.toString(e);
			}
		} %>

		<div class="mainHeader">
			<form action="?" method="get">
				Class: <input type="text" name="aClass" value="<%= classToVerifie %>"><input type="submit" value="Check">
				<a href="?webInf=true">[ Check WEB-INF location ]</a>
				<%@include file="_commonLogout.jsp" %>
			</form>
		</div>
		<div class="workarea" id="workarea">
			<br>
			<pre><%if (result != null) { %><%= result %><% } %></pre>
		</div><%
	} %>
</body>
</html>
	