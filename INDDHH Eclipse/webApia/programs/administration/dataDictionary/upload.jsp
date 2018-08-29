<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.DataDictionaryBean"></jsp:useBean><%
AttributeVo attrVo = dBean.getDataDictionaryVo();
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titDicDat")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST" enctype="multipart/form-data"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatDic")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblLoadFrom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblLoadFrom")%>:</td><td><select name="loadFrom" id="loadFrom" onChange="cmbLoadFrom_change()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblLoadFrom")%>"><option value="<%= dBean.LOAD_FROM_FILE %>" <%=(dBean.LOAD_FROM_FILE.equals(dBean.getLoadFrom()))?" selected":""%>><%=LabelManager.getName(labelSet,"lblFile")%></option><option value="<%= dBean.LOAD_FROM_DB %>" <%=(dBean.LOAD_FROM_DB.equals(dBean.getLoadFrom()))?" selected":""%>><%=LabelManager.getName(labelSet,"lblDb")%></option></select></td><td></td><td></td></tr></table><div id="loadFromFile"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDicDat")%>"><%=LabelManager.getNameWAccess(labelSet,"lblDicDat")%>:</td><td colspan="3"><input type="FILE" p_required="true" length="150" name="txtUpload" size="70" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblDicDat")%>" title="<%=LabelManager.getToolTip(labelSet,"lblBrowse")%>"></td><td></td><td></td></tr></table></div><div id="loadFromDb" style="display=none"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDbCon")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryDbNom")%>:</td><td colspan="3"><select onchange="cmbDbConId_change()" name="cmbDbConId" id="cmbDbConId" p_required="true"><%
			   				if (dBean.getDbConId() == null) { %><option value="" selected></option><%
			   				}
			   				if (dBean.getDbConnections() != null) {
			   					Iterator iterator = dBean.getDbConnections().iterator();
			   					while (iterator.hasNext()) {
			   						DbConnectionVo dbVo = (DbConnectionVo) iterator.next(); %><option value="<%= dbVo.getDbConId() %>" <%= dbVo.getDbConId().equals(dBean.getDbConId())?"selected":"" %>><%= dbVo.getDbConName() %></option><%
			   					}
			   				} %></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblDbTabVie")%>"><%=LabelManager.getNameWAccess(labelSet,"lblQryView")%>:</td><td colspan="3"><select name="cmbDbTable" id="cmbDbTable" multiple size="6"><%
			   				if (dBean.getDbTables() != null) {
			   					Iterator iterator = dBean.getDbTables().iterator();
			   					while (iterator.hasNext()) { 
			   						String table = (String) iterator.next(); %><option value="<%= table %>"><%= table.split("·")[1]%></option><%
								}
							} %></select></td></tr></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
var LOAD_FROM_FILE = "<%= dBean.LOAD_FROM_FILE %>";
var LOAD_FROM_DB = "<%= dBean.LOAD_FROM_DB %>";
</script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/dataDictionary/upload.js" ></script><script>
cmbLoadFrom_change();
</script>


