<%@page import="com.dogma.Parameters"%><%@page import="com.dogma.vo.TskSchTemplateVo"%><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.TaskSchedulerBean"></jsp:useBean><HTML><head><script language="javascript">
function setCombo(){
	var options="";
	var cmb=window.parent.document.getElementById("selTemplate");
	var oldSize = cmb.length;
	cmb.innerHTML="";
	var opt = document.createElement("OPTION");
	opt.text="";
	opt.value="0";
	try {
			cmb.add(opt, null); // standards compliant; doesn't work in IE
	}catch(ex) {
		   	cmb.add(opt); // IE only
	}
	<%
	response.setCharacterEncoding(Parameters.APP_ENCODING);
	Collection colTemp = dBean.getTemplates();
	if (colTemp != null && colTemp.size()>0) {
		Iterator itTmp = colTemp.iterator();
		while (itTmp.hasNext()){
			TskSchTemplateVo tskSchTempVo = (TskSchTemplateVo) itTmp.next();%>
			opt=document.createElement("OPTION");
			opt.text="<%=tskSchTempVo.getTskSchTemName()%>";
			opt.value="<%=tskSchTempVo.getTskSchTemId().intValue()%>";
			try {
			    cmb.add(opt, null); // standards compliant; doesn't work in IE
			}catch(ex) {
		    	cmb.add(opt); // IE only
			}
		<%}
	}%>
	window.parent.document.getElementById("txtTemplate").value = "";
	window.parent.parent.document.getElementById("iframeMessages").style.display="none";
	alert("<%=request.getParameter("msgComplete")%>");
}
</script></head><body onload="setCombo()"></body></HTML>