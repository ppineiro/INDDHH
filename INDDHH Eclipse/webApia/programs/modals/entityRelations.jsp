<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.EntitiesBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEntNeg")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblRolA")%>"><%=LabelManager.getNameWAccess(labelSet,"lblRolA")%>:</td><td><input p_required=true name="txtRolA" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblRolA")%>" type="text"></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblCarA")%>"><%=LabelManager.getNameWAccess(labelSet,"lblCarA")%>:</td><td><select name="cmbCarA"><option value="<%=BusEntityVo.CARD_1%>"><%=BusEntityVo.CARD_1%></option><option value="<%=BusEntityVo.CARD_0_1%>"><%=BusEntityVo.CARD_0_1%></option><option value="<%=BusEntityVo.CARD_1_N%>"><%=BusEntityVo.CARD_1_N%></option><option value="<%=BusEntityVo.CARD_0_N%>"><%=BusEntityVo.CARD_0_N%></option><option value="<%=BusEntityVo.CARD_N_N%>"><%=BusEntityVo.CARD_N_N%></option></select></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblCarB")%>"><%=LabelManager.getNameWAccess(labelSet,"lblCarB")%>:</td><td><select name="cmbCarB"><option value="<%=BusEntityVo.CARD_1%>"><%=BusEntityVo.CARD_1%></option><option value="<%=BusEntityVo.CARD_0_1%>"><%=BusEntityVo.CARD_0_1%></option><option value="<%=BusEntityVo.CARD_1_N%>"><%=BusEntityVo.CARD_1_N%></option><option value="<%=BusEntityVo.CARD_0_N%>"><%=BusEntityVo.CARD_0_N%></option><option value="<%=BusEntityVo.CARD_N_N%>"><%=BusEntityVo.CARD_N_N%></option></select></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblRolB")%>"><%=LabelManager.getNameWAccess(labelSet,"lblRolB")%>:</td><td><input p_required=true name="txtRolB" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblRolB")%>" type="text"></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblEntB")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEntB")%>:</td><td><select name="cmbEntB"><%
						Collection col = dBean.getAllBusEntities(request);
						if(col!=null){
							Iterator it = col.iterator();
							while(it.hasNext()){
								BusEntityVo vo = (BusEntityVo)it.next();
								%><option value="<%=dBean.fmtInt(vo.getBusEntId())%>"><%=dBean.fmtStr(vo.getBusEntName())%></option><%
							}
						}
						%></select></td><td></td><td></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" disabled id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	if (verifyRequiredObjects()) {
		arr = new Array();
		arr[0] = document.getElementById("txtRolA").value.toUpperCase();
		arr[1] = document.getElementById("cmbCarA").value;
		arr[2] = document.getElementById("cmbCarB").value;
		arr[3] = document.getElementById("txtRolB").value.toUpperCase();
		arr[4] = document.getElementById("cmbEntB").value;
		arr[5] = document.getElementById("cmbEntB").options(document.getElementById("cmbEntB").selectedIndex).text;
		window.returnValue= arr;
		window.close();
	}
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>