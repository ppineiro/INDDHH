<%@include file="../../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.bi.BIConstants"%><%@page import="com.dogma.bi.BIEngine"%><%@page import="java.util.Collection"%><jsp:useBean id="cBean" scope="session" class="com.dogma.bean.administration.CubeViewBean"></jsp:useBean><%@page import="java.util.Iterator"%><%@page import="com.dogma.vo.CubeViewVo"%><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp"%><script language="javascript">

var MSG_BI_IMPL_NOT_FOUND = "<%=LabelManager.getName(labelSet,BIConstants.MSG_BI_IMPL_NOT_FOUND)%>"; //BIDB_IMPLMENTATION
var MSG_BI_WRNG_IMPLEMENTATION = "<%=LabelManager.getName(labelSet,BIConstants.MSG_BI_WRNG_IMPLEMENTATION)%>"; //WRONG BIDB_IMPLMENTATION 
var MSG_BI_URL_NOT_FOUND = "<%=LabelManager.getName(labelSet,BIConstants.MSG_BI_URL_NOT_FOUND)%>"; //BIDB_URL
var MSG_BI_PWD_NOT_FOUND = "<%=LabelManager.getName(labelSet,BIConstants.MSG_BI_PWD_NOT_FOUND)%>"; //BIDB_PWD
var MSG_BI_USR_NOT_FOUND = "<%=LabelManager.getName(labelSet,BIConstants.MSG_BI_USR_NOT_FOUND)%>"; //BIDB_USR

var ERROR = "<%=request.getParameter("error")%>";

</script><script language="javascript">
function init(){
	var win=window.parent;
	while(!win.document.getElementById('iframeMessages') && win!=win.parent){
		win=win.parent;
	}
	win.document.getElementById("iframeResult").hideResultFrame();
	if (ERROR == "1"){
		win.document.getElementById("iframeMessages").showMessage(MSG_BI_IMPL_NOT_FOUND,document.body);
	}else if (ERROR == "2"){//BIDB_IMPLMENTATION not oracle, postgres or sqlserver
		win.document.getElementById("iframeMessages").showMessage(MSG_BI_WRNG_IMPLEMENTATION,document.body);
	}else if (ERROR == "3"){//BIDB_URL
		win.document.getElementById("iframeMessages").showMessage(MSG_BI_URL_NOT_FOUND,document.body);
	}else if (ERROR == "4"){//BIDB_PWD
		win.document.getElementById("iframeMessages").showMessage(MSG_BI_PWD_NOT_FOUND,document.body);
	}else if (ERROR == "5"){//BIDB_USR
		win.document.getElementById("iframeMessages").showMessage(MSG_BI_USR_NOT_FOUND,document.body);
	}
}

</script></head><body onload="init()"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent cube"></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script></script>