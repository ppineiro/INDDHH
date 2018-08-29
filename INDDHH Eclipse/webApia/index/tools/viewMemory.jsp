<%


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
java.util.ArrayList arrFree = null;
java.util.ArrayList arrAlloc = null;
if(o1==null){
	arrFree = new java.util.ArrayList();
	session.setAttribute("arrMemFree",arrFree);
} else {
	arrFree = (java.util.ArrayList)o1;
}
if(o2==null){
	arrAlloc = new java.util.ArrayList();
	session.setAttribute("arrMemAlloc",arrAlloc);
} else {
	arrAlloc = (java.util.ArrayList)o2;
}

arrFree.add(new Long(heapFreeSize));
arrAlloc.add(new Long(heapSize));

String delete = request.getParameter("delete");
boolean doDelete = delete != null && delete.length() > 0 && delete.equals("delete");
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

%>
<html>
	<head>
		<% if (! doDelete) {%><meta http-equiv="refresh" content="5"><% } %>
		<style type="text/css">
			body		{ font-family: verdana; font-size: 10px; }
			td			{ font-family: verdana; font-size: 10px; } 
			th			{ font-family: verdana; font-size: 10px; font-weight: normal;} 
			pre			{ font-family: verdana; font-size: 10px; }
			textarea	{ font-family: verdana; font-size: 10px; }
			input		{ font-family: verdana; font-size: 10px; }
			select		{ font-family: verdana; font-size: 10px; }
		</style>
	</head>
	<body>
		<% if (! doDelete) {%>
			<table>
				<tr>
					<td>Current In use Heap Memory: <b><%=(heapSize - heapFreeSize)/factor%> <%= unit %></b></td>
					<td>| Current Free Heap Memory: <b><%=heapFreeSize/factor%> <%= unit %></b></td>
					<td>| Current Allocated Heap Memory: <b><%=heapSize/factor%> <%= unit %></b></td>
					<td>| Max Heap Memory: <b><%=heapMaxSize/factor%> <%= unit %></b></td>
				</tr>
			</table>
			
			<table>
				<tr align="left">
					<td>F<br>r<br>e<br>e<br><br>M.</td>
					<%
					boolean foundOver = false;
					for(int i=(arrFree.size() - 1);i>=0 && ! foundOver;i--){
						long height = ((Long)arrFree.get(i)).longValue()/factor;
						if (height >= 100) foundOver = true;
					}
					for(int i=(arrFree.size() - 1);i>=0 ;i--){ 
						long height = ((Long)arrFree.get(i)).longValue()/factor; 
						if (foundOver) height = height / 10; %>
						<td align="left" valign="bottom"><img src="cubo.gif" width="10px" title="<%= ((Long)arrFree.get(i)).longValue()/factor %> <%= unit %>" height="<%= height %>px"></td>
					<%} %>
				</tr>
				<tr align="left">
					<td>A<br>l<br>l<br>o<br>c<br>a<br>t<br>e<br>d<br><br>M.</td>
					<%
					foundOver = false;
					for(int i=(arrAlloc.size() - 1);i>=0 && ! foundOver;i--){
						long height = ((Long)arrAlloc.get(i)).longValue()/factor;
						if (height >= 100) foundOver = true;
					}
					for(int i=(arrAlloc.size() - 1);i>=0 ;i--){ 
						long height = ((Long)arrAlloc.get(i)).longValue()/factor; 
						if (foundOver) height = height / 10; %>
						<td align="left" valign="top"><img src="cubo.gif" width="10px" title="<%= ((Long)arrAlloc.get(i)).longValue()/factor %> <%= unit %>" height="<%= height %>px"></td>
					<%} %>
				</tr>
			</table>
			
			<p>Automatic refresh en 5 seconds.</p>
			<p>Before you exit this page, please click <a href="?delete=delete">here</a> to release your memory</p>
		<% } else { %>
			<p>Now you can exit the page.
		<% } %>
	</body>
</html>