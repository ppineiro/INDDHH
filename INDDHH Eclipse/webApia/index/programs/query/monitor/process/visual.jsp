<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.*"%><%@page import="com.dogma.vo.custom.ProDefinitionVo"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorProcessesBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMon")%>: <%= dBean.getMonProInstanceVo().getProTitle() %> (<%= dBean.getMonProInstanceVo().getProcessIdentification() %>)</TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><TABLE WIDTH="100%" HEIGHT="100%" BORDER=0 cellspacing=0><TR><TD VALIGN="middle" ALIGN="center"><!--     ------------------------------------------------------------------               --><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"  
				 codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" 
					WIDTH="100%" 
					HEIGHT="100%" 
					style="/*border:1px solid blue*/"
					id="shell" ALIGN="center" VALIGN="middle"><param name="allowScriptAccess" value="sameDomain" /><!--     -<param name="movie" value="../flash/process_4/deploy/shell.swf" />         --><param name="movie" value="<%=Parameters.ROOT_PATH%>/flash/process/deploy/shell.swf" /><param name="FlashVars" value="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&IN_APIA=true&SWF_OBJ_PATH=<%=Parameters.ROOT_PATH%>/flash/process/deploy/"/><param name="quality" value="high" /><param name="menu" value="false"><param name="bgcolor" value="#EFEFEF" /><param name="WMODE" value="transparent" /><embed wmode="transparent" menu="false" allowScriptAccess="sameDomain" src="<%=Parameters.ROOT_PATH%>/flash/process/deploy/shell.swf" quality="high" bgcolor="#efefef" width="100%" height="450" swLiveConnect="true" id="shell" name="shell" align="middle" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" flashVars="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&IN_APIA=true&SWF_OBJ_PATH=<%=Parameters.ROOT_PATH%>/flash/process/deploy/" /></object><!--   sassssssssssssssssss  ------------------------------------------------------------------               --></TD></TR></TABLE></FORM></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD align="left"><button type="button" onclick="showFlashInput()">Reorganize</button></TD><TD><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" id="btnSalir" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><SCRIPT LANGUAGE="VBScript">
'Catch FS Commands in IE, and pass them to the corresponding JavaScript function.
Sub shell_FSCommand(ByVal command, ByVal args)
    call shell_DoFSCommand(command, args)
end sub
</SCRIPT><SCRIPT>

function changeIdePos(val) {
	document.document.getElementById("txtIdePos").disabled = val; 
	if (val) {
		document.getElementById("txtIdePos").p_required = 'false';
	} else {
		document.getElementById("txtIdePos").p_required = 'true';
	}
}

function changeIdePre(val) {
	document.getElementById("txtIdePre").disabled = val; 
	if (val) {
		document.getElementById("txtIdePre").p_required = 'false';
	} else {
		document.getElementById("txtIdePre").p_required = 'true';
	}
}

</SCRIPT>