
<%@page import="java.io.File"%><%@page import="com.st.util.log.Log"%><meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>"><%@page import="com.dogma.bean.DogmaAbstractBean"%><meta http-equiv="X-UA-Compatible" content="IE=7" /><%@include file="/components/scripts/server/messages.jsp" %><%if(Parameters.CUSTOM_JS.length()>0){
	File f = new File(Parameters.APP_PATH + Parameters.CUSTOM_JS);
	if(f.exists()){%><script language="javascript" src="<%=Parameters.ROOT_PATH + Parameters.CUSTOM_JS%>"></script><%}else{
		Log.debug("The javascript file setted in the parameter CUSTOM JAVASCRIPT with value: " + Parameters.CUSTOM_JS + " was not found");
	}
}

%><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/workArea.css" rel="styleSheet" type="text/css" media="screen"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/tabElement.css" rel="styleSheet" type="text/css" media="screen"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/printArea.css" rel="styleSheet" type="text/css" media="print"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/printTabElement.css" rel="styleSheet" type="text/css" media="print"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/tree.css" rel="styleSheet" type="text/css" media="screen"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/grid.css" rel="styleSheet" type="text/css" media="screen"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/gridContextMenu.css" rel="styleSheet" type="text/css" media="screen"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/dtPicker.css" rel="styleSheet" type="text/css" media="screen"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/tabs.css" rel="styleSheet" type="text/css" media="screen"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/imageViewer.css" rel="styleSheet" type="text/css" media="screen"><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/tabs.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/grid/grids.js"<%=defer%>></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/imageBrowser.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/requiredFields.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/maxLength.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js"<%=defer%>></script><script src="<%=Parameters.ROOT_PATH%>/scripts/util.js"<%=defer%>></script><script src="<%=Parameters.ROOT_PATH%>/scripts/val.js"<%=defer%>></script><script src="<%=Parameters.ROOT_PATH%>/scripts/xml.js"<%=defer%>></script><script src="<%=Parameters.ROOT_PATH%>/scripts/ajax.js"<%=defer%>></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/mask/tjmlib.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/mask/calendar.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/mask/maskedInput.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/checkBoxes.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/numeric.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/winSizer.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/selBind.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/filter.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/readOnly.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/fileInput.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/scriptBehaviors.js"<%=defer%>></script><script  language="javascript"><%DogmaAbstractBean tmpBean2 = null;
	if (session.getAttribute("dBean") != null) {
		tmpBean2=(DogmaAbstractBean) session.getAttribute("dBean");
	}else if (session.getAttribute("qBean") != null){
		tmpBean2=(DogmaAbstractBean) session.getAttribute("qBean");
	}%><%if(tmpBean2!=null && tmpBean2.getId()!= null){ %>
	var listGridId="<%=tmpBean2.getId()%>";
	<%}else{%>
	var listGridId="";
	<%}%><%
String windowId = "";
if(request.getParameter("windowId")!=null){
 windowId        = "&windowId=" + request.getParameter("windowId");
}else{
 windowId        = "";
}
%>


var windowId        = "<%=windowId%>";
var executionMode = false;


var req_align = <%=Parameters.REQUIRED_ASTERISK_POSITION%>;
var req_align_after =	<%=Parameters.REQUIRED_ASTERISK_POSITION_AFTER%>;
var req_align_before =	<%=Parameters.REQUIRED_ASTERISK_POSITION_BEFORE%>;
</script>