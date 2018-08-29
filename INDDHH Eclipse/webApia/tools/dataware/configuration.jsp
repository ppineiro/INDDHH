<%@page import="java.util.*"%><%@page import="com.st.db.dataAccess.*"%><HTML><HEAD><link href="../styles/default/css/workarea.css" rel="styleSheet" type="text/css" media="screen"></HEAD><body><b>Dataware configuration</b><br>
Type: <%= com.dogma.DatawareConf.DW_DB_TYPE %><br>
Connection string: <%= com.dogma.DatawareConf.DW_DB_STRING %><br>
Protocol: <%= com.dogma.DatawareConf.DW_DB_PROTOCOL %><br>
Driver: <%= com.dogma.DatawareConf.DW_DB_DRIVER %><br>
User: <%= com.dogma.DatawareConf.DW_DB_USER %><br>
Password: <%= com.dogma.DatawareConf.DW_DB_PASSWORD %><br><br><b>Cube properties</b><br>
Dataware cube count: <%= com.dogma.DatawareConf.CUBE_COUNT %><br><table border=1><tr><td><b>Name</b></td><td><b>Type</b></td><td><b>Description</b></td></tr><%
	for (int count = 1; count <= com.dogma.DatawareConf.CUBE_COUNT; count ++) { %><tr><td><%= com.dogma.DatawareConf.getCubeName(count) %></td><td><%= com.dogma.DatawareConf.getCubeType(count) %></td><td><%= com.dogma.DatawareConf.getCubeDescription(count) %></td></tr><% 
	}%></table></body></html>