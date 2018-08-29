<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><script language="javascript">

function shell_DoFSCommand(command, args) {

	if (command == "returnedXML") {
		document.getElementById("txtMap").value = args;
		document.getElementById("frmMain").action = "security.GroupHierarchyAction.do?action=confirm";
		submitForm(document.getElementById("frmMain"));
	}
	if(command == "hideFlash") {
		document.getElementById("txtMap").value=args;
		//var flashObj=getFlashObject("shell");
		var flashObj=document.getElementsByTagName("EMBED")[0];
		var flashVars=flashObj.getAttribute("flashVars");
		flashVars=flashVars.split("&stringModel=")[0];
		flashVars+=("&stringModel="+args);
		flashObj.setAttribute("flashVars",flashVars);
		hideAllContents();
		document.getElementById("tab"+listener.contentNumber).parentNode.className="here";
		document.getElementById("content"+listener.contentNumber).style.display="block";
		var continer=window.parent.document.getElementById(window.name);
		continer.style.display="none";
		continer.style.display="block";
	}
}

function getXml(){
	getFlashObject("shell").SetVariable("call", "getXML");
}
 

function getFlashObject(movieName){
 
	if (navigator.appName.indexOf("Microsoft Internet")==-1){
		if (document.embeds && document.embeds[movieName]){
			return document.embeds[movieName];
		}
	}else{ // if (navigator.appName.indexOf("Microsoft Internet")!=-1){
		return document.getElementById(movieName);
	}
}


</script></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.GroupHierarchyBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,dBean.isModeGlobal()?"titEstJer":"titEstJerEnv")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><%
			if (dBean.isModeGlobal() || "true".equals(EnvParameters.getEnvParameter(dBean.getEnvId(request),EnvParameters.ENV_USES_HIERARCHY))) { %><!--     LAYOUT FLASH         --><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"  
				 codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" 
					WIDTH="100%" 
					HEIGHT="96%" 
					style="/*border:1px solid black*/"
					id="shell" ALIGN="center" VALIGN="middle"><param name="allowScriptAccess" value="sameDomain" /><param name="movie" value="<%=Parameters.ROOT_PATH%>/flash/poolHierarchy/deploy/otree.swf" /><param name="FlashVars" value="inApia=true&isGlobal=<%=dBean.isModeGlobal()%>&msgDesBorNod=<%=LabelManager.getName(labelSet,"msgDesBorNod")%>&ok=<%=LabelManager.getName(labelSet,"btnCon")%>&modalTitle=<%=LabelManager.getName(labelSet,"lblAgrNod")%>&cancel=<%=LabelManager.getName(labelSet,"btnCan")%>&noMoveLabel=<%=LabelManager.getName(labelSet,"lblMovNod")%>&noDeleteLabel=<%=LabelManager.getName(labelSet,"lblEliNod")%>&mustSelect=<%=LabelManager.getName(labelSet,"lblSelNod")%>&nameCol=<%=LabelManager.getName(labelSet,"lblNom")%>&descCol=<%=LabelManager.getName(labelSet,"lblDes")%>&isAddedLabel=<%=LabelManager.getName(labelSet,"lblExiNod")%>&ttAdd=<%=LabelManager.getName(labelSet,"lblAgrNod")%>&ttDel=<%=LabelManager.getName(labelSet,"lblEliEle")%>&modal2Title=<%=LabelManager.getName(labelSet,"lblInf")%>&ambCol=<%=LabelManager.getName(labelSet,"lblEnvs")%>&idCol=<%=LabelManager.getName(labelSet,"lblId")%>&usrCol=<%=LabelManager.getName(labelSet,"titUsu")%>"/><param name="quality" value="high" /><param name="menu" value="false"/><param name="bgcolor" value="#efefef" /><embed id="shell" name="shell" menu="false" allowScriptAccess="sameDomain" src="<%=Parameters.ROOT_PATH%>/flash/poolHierarchy/deploy/otree.swf" quality="high" bgcolor="#efefef" width="100%" height="450" swLiveConnect="true"  align="middle" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" flashVars="inApia=true&isGlobal=<%=dBean.isModeGlobal()%>&msgDesBorNod=<%=LabelManager.getName(labelSet,"msgDesBorNod")%>&ok=<%=LabelManager.getName(labelSet,"btnCon")%>&modalTitle=<%=LabelManager.getName(labelSet,"lblAgrNod")%>&cancel=<%=LabelManager.getName(labelSet,"btnCan")%>&noMoveLabel=<%=LabelManager.getName(labelSet,"lblMovNod")%>&noDeleteLabel=<%=LabelManager.getName(labelSet,"lblEliNod")%>&mustSelect=<%=LabelManager.getName(labelSet,"lblSelNod")%>&nameCol=<%=LabelManager.getName(labelSet,"lblNom")%>&descCol=<%=LabelManager.getName(labelSet,"lblDes")%>&isAddedLabel=<%=LabelManager.getName(labelSet,"lblExiNod")%>&ttAdd=<%=LabelManager.getName(labelSet,"lblAgrNod")%>&ttDel=<%=LabelManager.getName(labelSet,"lblEliEle")%>&modal2Title=<%=LabelManager.getName(labelSet,"lblInf")%>&ambCol=<%=LabelManager.getName(labelSet,"lblEnvs")%>&idCol=<%=LabelManager.getName(labelSet,"lblId")%>&usrCol=<%=LabelManager.getName(labelSet,"titUsu")%>" /></object><TEXTAREA id="txtMap" name="txtMap" cols="100" rows="30" style="display:none"></TEXTAREA><%
			} else { %><%=LabelManager.getName(labelSet,"lblEnvHieNotActive")%><% } %></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><%if (dBean.isModeGlobal() || "true".equals(EnvParameters.getEnvParameter(dBean.getEnvId(request),EnvParameters.ENV_USES_HIERARCHY))) { %><button type="button" onclick="btnDow_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDow")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDow")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDow")%></button><button type="button" onclick="btnUpl_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnUpl")%>" title="<%=LabelManager.getToolTip(labelSet,"btnUpl")%>"><%=LabelManager.getNameWAccess(labelSet,"btnUpl")%></button><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><%}%><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/hierarchy/hierarchy.js'></script><SCRIPT LANGUAGE="VBScript">
	'Catch FS Commands in IE, and pass them to the corresponding JavaScript function.'
	Sub shell_FSCommand(ByVal command, ByVal args)
	    call shell_DoFSCommand(command, args)
	end sub
</SCRIPT>

