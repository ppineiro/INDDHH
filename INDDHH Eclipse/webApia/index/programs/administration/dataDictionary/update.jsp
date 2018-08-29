<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body onload="fncLoad()"><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.DataDictionaryBean"></jsp:useBean><%
AttributeVo attrVo = dBean.getDataDictionaryVo();
String actualUser = dBean.getActualUser(request);
boolean saveChanges = (attrVo.getAttId()==null)?true:dBean.hasWritePermission(request, attrVo.getAttId(), attrVo.getPrjId(), actualUser);
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titDicDat")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type ="tabElement" id="samplesTab" ontabswitch="tabSwitch()" <%=(request.getParameter("defaultTab")!=null?(" defaultTab='"+request.getParameter("defaultTab").toString()+"'"):"" )%>><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabDatGen")%>" tabText="<%=LabelManager.getName(labelSet,"tabDatGen")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatDic")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><!-- PROYECTOS --><%Collection colProj = dBean.getProjects(request);
   					boolean hasProject = (attrVo.getPrjId() != null && attrVo.getPrjId().intValue() != 0);%><td title="<%=LabelManager.getToolTip(labelSet,"titPrj")%>"><%=LabelManager.getNameWAccess(labelSet,"titPrj")%>:</td><td colspan=2><input type=hidden name="txtPrj" value=""><select name="selPrj" onchange="cmbProySel()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblPrj")%>"><%if (colProj != null && colProj.size()>0) {
			   					Iterator itPrj = colProj.iterator();
			   					ProjectVo prjVo = null;%><option value="0"></option><%while (itPrj.hasNext()) {
		   							prjVo = (ProjectVo) itPrj.next();%><option value="<%=prjVo.getPrjId()%>"
		   							<%if (hasProject) {
											if (prjVo.getPrjId().equals(attrVo.getPrjId())) {
												out.print ("selected");
											}%>
											><%=prjVo.getPrjName()%></option><%} else {%>
											><%=prjVo.getPrjName()%></option><%}
			   						}%></select><%}%></select></td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><%if(dBean.isDataUsed() || dBean.isDataQueryUsed()){%><input type="hidden" name="txtName" id="txtName" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" value="<%=dBean.fmtStr(attrVo.getAttName())%>"><input type="text" readonly class="txtReadOnly" value="<%=dBean.fmtStr(attrVo.getAttName())%>"><%}else{%><input name="txtName" id="txtName" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(attrVo!=null) {%>value="<%=dBean.fmtStr(attrVo.getAttName())%>"<%}%>></td><%}%></td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblLab")%>"><%=LabelManager.getNameWAccess(labelSet,"lblLab")%>:</td><td><input name="txtLabel" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblLab")%>" type="text" <%if(attrVo!=null) {%>value="<%=dBean.fmtStr(attrVo.getAttLabel())%>"<%}%>></td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblTipDat")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTipDat")%>:</td><td><%if(dBean.isDataUsed() || dBean.isDataQueryUsed()){%><input type="hidden" name="cmbType" id="cmbType" value="<%=attrVo.getAttType()%>"><input type="text" readonly class="txtReadOnly" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTipDat")%>" 
		   						<%if(attrVo!=null && AttributeVo.TYPE_NUMERIC.equals(attrVo.getAttType())) { %> value="<%=LabelManager.getName(labelSet,"lblNum")%>" <% }%><%if(attrVo!=null && AttributeVo.TYPE_STRING.equals(attrVo.getAttType())) { %> value="<%=LabelManager.getName(labelSet,"lblStr")%>" <% }%><%if(attrVo!=null && AttributeVo.TYPE_DATE.equals(attrVo.getAttType())) { %> value="<%=LabelManager.getName(labelSet,"lblFec")%>" <% }%>
			   				><%} else {%><select name="cmbType" onchange="cmbType_change()" p_required="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTipDat")%>"><option value="<%=AttributeVo.TYPE_STRING%>" <%if(attrVo!=null && AttributeVo.TYPE_STRING.equals(attrVo.getAttType())) { out.print("selected"); }%>><%=LabelManager.getName(labelSet,"lblStr")%></option><option value="<%=AttributeVo.TYPE_NUMERIC%>" <%if(attrVo!=null && AttributeVo.TYPE_NUMERIC.equals(attrVo.getAttType())) { out.print("selected"); }%>><%=LabelManager.getName(labelSet,"lblNum")%></option><option value="<%=AttributeVo.TYPE_DATE%>" <%if(attrVo!=null && AttributeVo.TYPE_DATE.equals(attrVo.getAttType())) { out.print("selected"); }%>><%=LabelManager.getName(labelSet,"lblFec")%></option></select><%}%></td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblLar")%>"><%=LabelManager.getNameWAccess(labelSet,"lblLar")%>:</td><td><input id="txtLength" name="txtLength" maxlength="5" p_numeric="true" integer="true" onchange="ChanGeValue()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblLar")%>" type="text"
		   			 <%if(attrVo!=null) {
		   			 	 if (attrVo.getAttLength() == null || dBean.isDataUsed()) {
		   			 	 	%>readonly class="txtReadOnly"<%
		   			 	 }
		   			 	 	%>value="<%=dBean.fmtInt(attrVo.getAttLength())%>"
		   			 	 
		   			 	<%}%>
		   			 ></td><td><input name="txtLength_aux" maxlength="5" p_numeric="true"  type="hidden" integer="true" type="text" <%if(attrVo!=null) {%>value="<%=dBean.fmtInt(attrVo.getAttLength())%>"<%}%>></td></td><td>&nbsp;</td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDes")%>:</td><td colspan=3><input name="txtDesc" size="72" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDes")%>" type="text" <%if(attrVo!=null) {%>value="<%=dBean.fmtStr(attrVo.getAttDesc())%>"<%}%>></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMas")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMas")%>:</td><td><input name="txtMask" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMas")%>" type="text"  <%if(dBean.isDataUsed() && (attrVo!=null && AttributeVo.TYPE_DATE.equals(attrVo.getAttType()))){%> readonly class="txtReadOnly"<%}%><%if(attrVo!=null) {%>value="<%=dBean.fmtStr(attrVo.getAttMask())%>"<%}%>></td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblExpReg")%>"><%=LabelManager.getNameWAccess(labelSet,"lblExpReg")%>:</td><td><input name="txtRegExp" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblExpReg")%>" type="text" <%-- <%if(dBean.isDataUsed()){%> readonly class="txtReadOnly" <%}%> --%><%if(attrVo!=null) {%>value="<%=dBean.fmtStr(attrVo.getAttRegExp())%>"<%}%>></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblTest")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTest")%>:</td><td><input type=text name="toTest" id="toTest" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTest")%>" <%--<%if(dBean.isDataUsed()){%> readonly class="txtReadOnly"<%}%>--%>><button type="button" onclick="test();" <%-- <%if(dBean.isDataUsed()){%>disabled<%}%>--%> id="btnTest" title="<%=LabelManager.getToolTip(labelSet,"btnTest")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnTest")%>"><%=LabelManager.getNameWAccess(labelSet,"btnTest")%></button></td><td></td><td></td></tr><tr><input type="hidden" name="hidUsrCanWrite" value="<%=saveChanges%>"></tr></table></div><!--      PERMISOS          --><div type="tab" style="visibility:hidden" style="visibility:hidden;" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabAttPer")%>" tabText="<%=LabelManager.getName(labelSet,"tabAttPer")%>"><%@ include file="permissions.jsp" %></div></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" <%=(!saveChanges)?"disabled":"" %> onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" >
var dataTypeNumber 	= "<%=AttributeVo.TYPE_NUMERIC%>";
var dataTypeString 	= "<%=AttributeVo.TYPE_STRING%>";
var dataTypeDate   	= "<%=AttributeVo.TYPE_DATE%>";

var MSG_ATT_QUERY_USED = "<%=LabelManager.getName(labelSet,"lblAttHasQryDep")%>";
var dataQueryUsed = <%= dBean.isDataQueryUsed() %>;
var dataUsed = <%=dBean.isDataUsed() %>;
var oldName = "<%= dBean.fmtStr(attrVo.getAttName()) %>";

var errRegExpFail 	= "<%=LabelManager.getName(labelSet,"msgExpRegFal")%>";
var errRegExpOk		= "<%=LabelManager.getName(labelSet,"msgExpRegOk")%>";
var errAttLenNotAll = "<%=LabelManager.getName(labelSet,"msgAttLenNotAllowed")%>";

var DATE_LENGTH = "<%=AttributeVo.DATE_LENGTH%>";
var DATE_MASK	= "<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>";
var MSG_PERMISSIONS_ERROR = "<%=LabelManager.getName(labelSet,"msgPermError")%>";
var MSG_MUST_SEL_ONE = "<%=LabelManager.getName(labelSet,"msgDebSelUno")%>";
var MSG_PERM_WILL_BE_LOST = "<%=LabelManager.getName(labelSet,"msgPermDefWillBeLost")%>";
var MSG_USE_PROY_PERMS = "<%=LabelManager.getName(labelSet,"msgUseProyPerms")%>";

function ChanGeValue(){
<%if(dBean.isDataUsed()){%> 
	if(document.getElementById("txtLength_aux").value=="" && document.getElementById("txtLength").value!=""){
		alert("<%=dBean.fmtScriptStr(LabelManager.getName(labelSet,"msgAttLenNotAllowed"))%>");
		document.getElementById("txtLength").value = "";
		return;
	}
	if (parseInt(document.getElementById("txtLength_aux").value) > parseInt(document.getElementById("txtLength").value)){
		alert("<%=dBean.fmtScriptStr(LabelManager.getName(labelSet,"msgAttLenNotAllowed"))%>");
		document.getElementById("txtLength").value = document.getElementById("txtLength_aux").value;
		document.getElementById("txtLength").blur();
		document.getElementById("txtLength").select();
	}
<%}%>
}
</script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/dataDictionary/update.js" ></script><script language="javascript" defer="true">
var clearValues = false;

function fncLoad(){
	cmbType_change();
}
</script>