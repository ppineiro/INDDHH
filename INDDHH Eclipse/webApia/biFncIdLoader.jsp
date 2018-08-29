<%@page language="java"%><%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.DogmaException"%><html><body><font face="Comic Sans MS" size=4><blockquote><center><%
	try{	
		CoreFacade.getInstance().generateFunctionalitiesIds("admin"); %><h1><font color=red>Functionalities updated succesfully!</font></h1></center><%}catch (DogmaException d){%><h1><font color=red>Error</font></h1></center></font><p><font face="Comic Sans MS" size=2><%=(d.getMessage()!=null)?d.getMessage():d.getCompleteStackTrace()%><%}%></blockquote></font></body></html>
