<%@page import="java.util.TimeZone"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@include file="_commonValidate.jsp" %>

<html>
<head>
	<title>Date verifier</title>
	<style type="text/css">
		<%@include file="_commonStyles.jsp" %>
		
		div.field span { width: 180px !important; }
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
	<div class="fieldGroup">
		<h3>Date information</h3><%
		TimeZone timezone = TimeZone.getDefault();
		int timeZoneHours = timezone.getRawOffset() / 60 / 60 / 1000;
		int timeZoneDaylight = timezone.getDSTSavings() / 60 / 60 / 1000;
		
		Date currentDate = new Date();
		Calendar calendar = GregorianCalendar.getInstance();
		calendar.setTime(currentDate);;
		calendar.add(Calendar.HOUR, -1 * (timeZoneHours + timeZoneDaylight));
		
		%><div class="field"><span>Use time zone:</span><span class="value"><%= com.dogma.Configuration.USE_TIMEZONE%></span></div>
		<div class="field"><span>Current time:</span><span class="value"><%= currentDate %></span></div>
		<div class="field"><span>GMT time:</span><span class="value"><%= calendar.getTime() %></span></div>
		
		<% if (com.dogma.Configuration.USE_TIMEZONE == 0) { %>
			<div class="clear">&nbsp;</div>
			<div class="field"><span>Timezone name:</span><span class="value"><%= timezone.getDisplayName() %></span></div>
			<div class="field"><span>Timezone offset:</span><span class="value"><%= timeZoneHours %></span></div>
			<div class="field"><span>Current time (daylight):</span><span class="value"><%=java.util.TimeZone.getDefault().inDaylightTime( new java.util.Date() ) %></span></div>
		<% } %>
	</div>
	
	<div class="fieldGroup">
		<h3>Timezones table</h3><%
		for (int i = -12; i <= 12; i++) {
			if (i == 0) continue;
			Calendar theCal = GregorianCalendar.getInstance();
			theCal.setTimeInMillis(calendar.getTimeInMillis());
			theCal.add(Calendar.HOUR, i); %>
			<div class="field"><span>Timezone <%= i %>:</span><span class="value"><%= theCal.getTime() %></span></div><%
		} %>
	</div><% 
} %>
</body>
</html>