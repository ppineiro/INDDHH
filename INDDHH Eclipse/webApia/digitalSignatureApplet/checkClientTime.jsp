<%@page import="java.util.Date"%><%
Long clientTime = Long.valueOf(request.getParameter("clientTime"));
Date clientDate = new Date(clientTime);
Date min, max;   
long diff = 60000;
long currentTime = System.currentTimeMillis();
min = new Date(currentTime - diff);
max = new Date(currentTime + diff);
if(clientDate.after(min) && clientDate.before(max)){
	out.clear();
	out.print("OK");	
} else {
	out.clear();
	out.print("ERROR");
}
%>