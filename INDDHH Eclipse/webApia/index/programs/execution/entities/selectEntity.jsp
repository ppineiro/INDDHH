<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.translator.TranslationManager"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.EntInstanceBean"></jsp:useBean><body onload="doOnLoad()"><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEjeCreEnt")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeSelTipEnt")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeTipEnt")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeTipEnt")%>:</td><td colspan=3><% if (dBean.getSpecificEntityInst() != null) {%><input type="hidden" value="<%= dBean.fmtInt(dBean.getSpecificEntityInst()) %>" name="txtEntId"><input type="hidden" name="txtEntId0" value="<%=request.getParameter("busEntInstId")%>"><input type="hidden" name="txtBusEntInstNum0" value="<%=request.getParameter("busEntInstId")%>"><input type="hidden" name="chkSel0" value="on"><% } %><select name="txtBusEntId" id="txtBusEntId" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeTipEnt")%>" onchange="changeEntity(this)" <%= (dBean.getSpecificEntity() != null)?"disabled":"" %> p_required=true><option><%  Collection col = dBean.getBusEntities(request);
	   						if (col != null) {
		   						Iterator it = col.iterator();
								BusEntityVo entVo = null;
		   						while (it.hasNext()) {
		   						 	entVo = (BusEntityVo) it.next(); 
		   							entVo.setLanguage(uData.getLangId());
		   							TranslationManager.setTranslationByNumber(entVo);%><option value="<%=dBean.fmtInt(entVo.getBusEntId())%>" type="<%=dBean.fmtStr(entVo.getBusEntAdminType())%>" <%= (dBean.getSpecificEntity() != null && dBean.getSpecificEntity().equals(entVo.getBusEntId()))?"selected":"" %>><%=dBean.fmtHTML(entVo.getBusEntTitle())%><%	}
		   					}%></select></td></tr><tr id="trProcess" style="visibility:hidden"><td title="<%=LabelManager.getToolTip(labelSet,"lblEjeNomPro")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEjeNomPro")%>:</td><td colspan=3><div type="selbind" required=true id="cmbProcess" name="txtProId" sParams="" sXMLSource="execution.EntInstanceAction.do"><select accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeNomPro")%>" id="selPro" name="txtProId"></select></div></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="startProcCreation()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><SCRIPT>
var QUERY_ADMIN = <%= dBean.isQueryAdministration() %>;
var QUERY_GO_BACK = <%= dBean.isQueryGoBack() %>;
var SPECIFIC_ADMIN = <%= dBean.isGlobalAdministration() %>;
var CAN_CONFIRMUPDATE = false;
</SCRIPT><script src="<%=Parameters.ROOT_PATH%>/programs/execution/entities/entities.js" ></script><script language="javascript">
function changeEntityOnLoad() {
changeEntity(null);
}
function changeEntity(obj) {
	if (obj == null) {
		obj = document.getElementById("txtBusEntId");
	}
	if (obj.options[obj.selectedIndex].getAttribute("type") == "<%=BusEntityVo.ADMIN_BOTH%>" || 
		obj.options[obj.selectedIndex].getAttribute("type") == "<%=BusEntityVo.ADMIN_PROCESS%>") {
		if (obj.options[obj.selectedIndex].getAttribute("type") == "<%=BusEntityVo.ADMIN_PROCESS%>") {
			document.getElementById("selPro").setAttribute("p_required","true");
		} else {
			document.getElementById("selPro").setAttribute("p_required","false");
		}
		document.getElementById("trProcess").style.visibility="visible";
		document.getElementById("selPro").style.visibility="visible";
		document.getElementById("selPro").disabled=false;
		<% /* %> document.getElementById("cmbProcess").setAttribute("sParams","action=getProcess&busEntId="+obj.value+"&type="+obj.options[obj.selectedIndex].type+"&proAct=<%=ProcessVo.PROCESS_ACTION_CREATION%>");<% */ %>
		document.getElementById("cmbProcess").setAttribute("sParams","action=getProcess&busEntId="+obj.value+"&type="+obj.options[obj.selectedIndex].getAttribute("type")+"&proAct=<%= dBean.getProAction() %>");
		document.getElementById("cmbProcess").load();
	} else {
		document.getElementById("trProcess").style.visibility="hidden";
		document.getElementById("selPro").style.visibility="hidden";
		document.getElementById("selPro").disabled=true;
		document.getElementById("selPro").setAttribute("p_required","false");
	}
}
function doOnLoad(){
<% if (dBean.getSpecificEntity() != null) { %>
	changeEntityOnLoad();
<% } %>
}
</script>