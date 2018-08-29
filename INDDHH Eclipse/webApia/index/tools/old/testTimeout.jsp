<%

Integer time = null;

try { time = Integer.valueOf(request.getParameter("theTime")); } catch (Exception e) {}

java.util.Date start = new java.util.Date();

if (time != null) {
	try { Thread.sleep(time.intValue() * 1000 * 60); } catch (Exception e) {};
}

java.util.Date end = new java.util.Date();

%><html><head><title>Timeout test</title><style type="text/css">
		body { font-family: verdana; font-size: 10px; }
		td { font-family: verdana; font-size: 10px; }
		pre { font-family: verdana; font-size: 10px; }
		input { font-family: verdana; font-size: 10px; }
		select { font-family: verdana; font-size: 10px; }
		a { text-decoration: none; color: blue; }
	</style></head><body><form action="?" method="post">
	Time: <input type="text" name="theTime" value=""> (in minutes) <input type="submit" value="Wait..."></form><%
if (time != null) { %><hr>
	Start: <b><%= start %></b><br>
	Wait: <b><%= time %> minutes</b><br>
	End: <b><%= end %></b><br><% } %></body></html>