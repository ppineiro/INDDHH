<%@page import="java.util.Date"%>
<%!

public static final int MAX_DATA = 70;

%>

<%@include file="_commonValidate.jsp" %>

<%
String delete = request.getParameter("delete");
boolean doDelete = delete != null && delete.length() > 0 && delete.equals("delete");

if (! _logged) {
	session.setAttribute("arrMemFree",null);
	session.setAttribute("arrMemAlloc",null);
	doDelete = true;
}


%>
<html>
<head>
	<title>View memory</title>
	<% if (! doDelete) {%><meta http-equiv="refresh" content="5"><% } %>
	<style type="text/css">
		<%@include file="_commonStyles.jsp" %>
		
		.chart1 { display: inline-block; width: 10px; background-color: gray; }
		.chart2 { display: inline-block; width: 10px; background-color: #F58F8F; }
		td { white-space: pre-line; }
	</style>
	
	<%@include file="_commonInclude.jsp" %>
	
	<script type="text/javascript">
		<%@include file="_commonScript.jsp" %>
	</script>
</head>
<body>
	<%@include file="_commonLogin.jsp" %>
	
	<% if (_logged) {
		
		// Get current size of heap in bytes
		long heapSize = Runtime.getRuntime().totalMemory();
		
		// Get maximum size of heap in bytes. The heap cannot grow beyond this size.
		// Any attempt will result in an OutOfMemoryException.
		long heapMaxSize = Runtime.getRuntime().maxMemory();
		
		// Get amount of free memory within the heap in bytes. This size will increase
		// after garbage collection and decrease as new objects are created.
		long heapFreeSize = Runtime.getRuntime().freeMemory();
		
		//out.println("Used Java Memory" + heapSize/factor);
		//out.println("Max Java Memory" + heapMaxSize/factor);
		//out.println("Free Java Memory" + heapFreeSize/factor);
		
		Object o1 = session.getAttribute("arrMemFree");
		Object o2 = session.getAttribute("arrMemAlloc");
		java.util.ArrayList<Long> arrFree = null;
		java.util.ArrayList<Long> arrAlloc = null;
		if(o1==null){
			arrFree = new java.util.ArrayList<Long>();
			session.setAttribute("arrMemFree",arrFree);
		} else {
			arrFree = (java.util.ArrayList<Long>)o1;
		}
		if(o2==null){
			arrAlloc = new java.util.ArrayList<Long>();
			session.setAttribute("arrMemAlloc",arrAlloc);
		} else {
			arrAlloc = (java.util.ArrayList<Long>)o2;
		}
		
		arrFree.add(new Long(heapFreeSize));
		arrAlloc.add(new Long(heapSize));
		
		while (arrFree.size() > MAX_DATA) arrFree.remove(0);
		while (arrAlloc.size() > MAX_DATA) arrAlloc.remove(0);
		
		if (doDelete) {
			session.setAttribute("arrMemFree",null);
			session.setAttribute("arrMemAlloc",null);
		}
		
		String unit = "KB";
		long factor = 1024;
		
		if ((heapSize / 1024) > 100000) {
			unit = "MB";
			factor = 1024 * 1024;
		}
		
		if (! doDelete) {%>
			<p align="center">
				Current In use Heap Memory: <b><%=(heapSize - heapFreeSize)/factor%> <%= unit %></b>
				| Current Free Heap Memory: <b><%=heapFreeSize/factor%> <%= unit %></b>
				| Current Allocated Heap Memory: <b><%=heapSize/factor%> <%= unit %></b>
				| Max Heap Memory: <b><%=heapMaxSize/factor%> <%= unit %></b>
				| Amount of data: <b><%=arrFree.size()%> (max: <%= MAX_DATA %>)</b>
				<%@include file="_commonLogout.jsp" %>
			</p>
			
			<table>
				<tr align="left">
					<td>M<br>e<br>m.<br> <br>u<br>s<br>a<br>g<br>e</td>
					<%
					boolean foundOver = false;
					for(int i=(arrFree.size() - 1);i>=0 && ! foundOver;i--){
						long height = ((Long)arrFree.get(i)).longValue()/factor;
						if (height >= 1000) foundOver = true;
					}
					for(int i=(arrFree.size() - 1);i>=0 ;i--){ 
						long heightF = ((Long)arrFree.get(i)).longValue()/factor;
						long heightA = ((Long)arrAlloc.get(i)).longValue()/factor; 
						long heightDiff = heightA - heightF;
						heightF = heightF / 2;
						heightA = heightA / 2;
						heightDiff = heightDiff / 2;
						if (foundOver) heightF = heightF / 10; 
						if (foundOver) heightA = heightA / 10; 
						if (foundOver) heightDiff = heightDiff / 10;  %>
						<td align="left" valign="bottom">
							<div class="chart2" title="<%= (((Long)arrAlloc.get(i)).longValue() - ((Long)arrFree.get(i)).longValue())/factor %> <%= unit %>" style="height:<%= heightDiff %>px"></div>
							<div class="chart1" title="<%= ((Long)arrFree.get(i)).longValue()/factor %> <%= unit %>" style="height: <%= heightF %>px"></div>
						</td>
					<%} %>
				</tr>
			</table>
						
			<p align="center">Automatic refresh en 5 seconds. Before you exit this page, please click <a href="?delete=delete">here</a> to release your memory. <%= new Date() %></p>
		<% } else { %>
			<p>Now you can exit the page.
		<% } 
	} %>
</body>
</html>