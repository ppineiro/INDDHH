<%@page import="java.util.*"%><%@page import="com.st.db.dataAccess.*"%><HTML><HEAD><link href="../styles/default/css/workarea.css" rel="styleSheet" type="text/css" media="screen"></HEAD><body><% 

	DBConnViewer conView = new DBConnViewer();
	Collection col = conView.getAllPoolInfo();
	
	DBConnViewer.PoolInfo pool = null;
	DBConnViewer.PoolInfo.ConnInfo conn = null;
	
	Collection col2 = null;
	
	if (col != null) {
		for (Iterator it = col.iterator(); it.hasNext();) {
			pool = (DBConnViewer.PoolInfo) it.next();
			%><H1><%=pool.name%> (<%=pool.type%>)</H1><TABLE class="tblPoolInfo"><TR><TD align="right"><B>MIN-MIN CON:</B></TD><TD><%=pool.minCon%> - <%=pool.maxCon%></TD></TR><TR><TD align="right"><B>ACT CON: </B></TD><TD><%=pool.actCon%></TD></TR><TR><TD align="right"><B>VECTORS: </B></TD><TD><%=pool.vectorSize1%>, <%=pool.vectorSize2%></TD></TR><TR><TD align="right"><B>TIMEOUT: </B></TD><TD><%=pool.timeout%></TD></TR></TABLE><H2>Free Connections</H2><TABLE class="tblConns"><TR><TD><B>Identifier</TD><TD><B>Time (S) </TD><TD><B>Millis</TD></TR><%for (Iterator it2 = pool.col1.iterator();it2.hasNext();) {
					conn = (DBConnViewer.PoolInfo.ConnInfo) it2.next();
					%><TR><TD><%=conn.name.substring(conn.name.lastIndexOf(".")+1)%> - <%=conn.conName.substring(conn.conName.lastIndexOf(".")+1)%></TD><TD><%=(System.currentTimeMillis()-conn.startTime)/1000%></TD><TD><%=conn.startTime%></TD></TR><%}%></TABLE><H2>In Use Connections</H2><TABLE class="tblConns"><TR><TD><B>Identifier</TD><TD><B>Time (S) </TD><TD><B>Millis</TD></TR><%for (Iterator it2 = pool.col2.iterator();it2.hasNext();) {
					conn = (DBConnViewer.PoolInfo.ConnInfo) it2.next();
					%><TR><TD><%=conn.name.substring(conn.name.lastIndexOf(".")+1)%></TD><TD><%=(System.currentTimeMillis()-conn.startTime)/1000%></TD><TD><%=conn.startTime%></TD></TR><%}%></TABLE><%	}
	}
%></body></html>