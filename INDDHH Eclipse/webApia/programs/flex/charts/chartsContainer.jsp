<%@page import="com.dogma.Parameters"%><% 
   String width = "100%";
   String height = "100%";
   String error = "0";
   if (request.getParameter("width") != null){ 
	   width = request.getParameter("width") + "px";
   }
   if (request.getParameter("height") != null){
	   height = request.getParameter("height") + "px";
   }
   if (request.getParameter("error") != null){
	   error = request.getParameter("error");
   }
%><%@page import="com.st.util.labels.LabelManager"%><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="es" lang="es"><head><script language="javascript"><%if("-2".equals(error)){%>
		alert("<%=LabelManager.getName("msgErrorRetMetas")%>");
	<%}%></script></head><body style="background:transparent;"><div><!--URL utilizadas en la película--><!--Texto utilizado en la película--><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="<%=width%>" height="<%=height%>" id="chart" align="middle"><param name="allowScriptAccess" value="sameDomain" /><param name="movie" value="<%=Parameters.ROOT_PATH%>/programs/flex/charts/chart.swf" /><param name="quality" value="high" /><param name="bgcolor" value="#ffffff" /><param name="wmode" value="transparent" /><param name="flashVars" value='xmlUrl=<%=Parameters.ROOT_PATH%>/programs/flex/charts/chart.jsp&xmlNewValueUrl=<%=Parameters.ROOT_PATH%>/programs/flex/charts/chartNewValue.jsp'/><embed src="<%=Parameters.ROOT_PATH%>/programs/flex/charts/chart.swf" wmode="transparent" quality="high" bgcolor="#ffffff" flashvars="xmlUrl=<%=Parameters.ROOT_PATH%>/programs/flex/charts/chart.jsp&xmlNewValueUrl=<%=Parameters.ROOT_PATH%>/programs/flex/charts/chartNewValue.jsp" xmlUrl="<%=Parameters.ROOT_PATH%>/programs/flex/charts/chart.jsp" width="<%=width%>" height="<%=height%>" name="chart" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" /></object></div></body></html>
