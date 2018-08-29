<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="com.dogma.busClass.object.Parameter"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.st.util.labels.LabelManager"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.EntitiesBean"></jsp:useBean><script language="javascript">
	var attCodigueraLabel = "<%=dBean.getCodigueraAttLabel(uData.getEnvironmentId(), uData.getLangId())%>";
	var frmCodigueraLabel = "<%=dBean.getCodigueraFrmLabel(uData.getEnvironmentId(), uData.getLangId())%>";
</script><%
dBean.loadBusinessEntity(uData.getEnvironmentId(), new Integer(request.getParameter("busEntId"))); //Cargamos la info de la entidad seleccionada
BusEntityVo entityVo = dBean.getBusinessEntityVo();
String frmCodigueraLabel = dBean.getCodigueraFrmLabel(uData.getEnvironmentId(), uData.getLangId());
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titExport")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><div id="loadFromFile"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td><%=LabelManager.getName(labelSet,"lblExpTo")%>:</td><td><input type="radio" checked id="format" name="format" value="excel"><%=LabelManager.getName(labelSet,"lblExcel")%></input></td><td></td><td></td></tr><tr><td></td><td><input type="radio" id="format" name="format" value="csv"><%=LabelManager.getName(labelSet,"lblCsv")%></input></td><td></td><td></td></tr><tr><td></td><td><input type="radio" id="format" name="format" value="xml"><%=LabelManager.getName(labelSet,"lblXml")%></input></td><td></td><td></td></tr></table><div><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtForEnt")%></DIV><div type="grid" id="gridForms" height="100"><table id="tblForms" class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblFor")%>"><%=LabelManager.getName(labelSet,"lblFor")%></th><th style="width:150px" title="<%=LabelManager.getToolTip(labelSet,"titRecAllAtts")%>"><%=LabelManager.getName(labelSet,"titRecAllAtts")%></th></tr></thead><tbody id="tblFormBody"><%
						if (entityVo.getBusEntForms() != null){
						Iterator it = entityVo.getBusEntForms() .iterator();
 						while (it.hasNext()) {
   							BusEntFormVo frm = (BusEntFormVo)it.next(); %><tr<%if(entityVo.getBusEntFormProcessMap().get(frm.getFrmId()) != null){%> x_disabled="true"<%}%>><td style="width:0px;display:none;"><input type="hidden" name="chkFormSel"><input type=hidden name="chkForm" id="chkForm" value="<%=dBean.fmtInt(frm.getFrmId())%>"></td><%if(frm.getFrmId().equals(new Integer(2))){ %><td><%=frmCodigueraLabel%></td><%}else{%><td><%=dBean.fmtStr(frm.getFrmName())%></td><% } %><td align="center"><input type="checkbox" name="showForm<%=dBean.fmtInt(frm.getFrmId())%>" value="true"></td></tr><%
   						}
 					}%></tbody></table></div><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtAttEntNeg")%></DIV><div type="grid" id="gridAtts" height="125px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th></tr></thead><tbody></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><TD></TD><td><button type="button" onclick="btnAddAttribute_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnAgr")%>" title="<%=LabelManager.getToolTip(labelSet,"btnAgr")%>"><%=LabelManager.getNameWAccess(labelSet,"btnAgr")%></button><button type="button" onclick="btnDelAttribute_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="center" style="width:100%"></TD><TD align="rigth"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">

function btnAddAttribute_click() {
	var rets = openModal("/programs/modals/atts.jsp?onlyOne=true",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				var trows=document.getElementById("gridAtts").rows;
				
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
								
					oTd0.innerHTML = "<input type='checkbox' name='chkAttSel'><input type='hidden' name='chkAtt'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.align="center";
			
					oTd1.innerHTML = ret[1];
			
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					
					document.getElementById("gridAtts").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function btnDelAttribute_click(){
	if (document.getElementById("gridAtts").selectedItems.length >= 0){
		var selItem = document.getElementById("gridAtts").selectedItems[0].rowIndex-1;
		document.getElementById("gridAtts").removeSelected();
	}
}

function btnConf_click() {
	//1. Recuperamos el formato seleccionado
	var result = new Array();
	var formats=new Array();
	for(var i=0;i<document.getElementsByTagName("INPUT").length;i++){
		if(document.getElementsByTagName("INPUT")[i].id=="format"){
			formats.push(document.getElementsByTagName("INPUT")[i]);
		}
	}
	for (i = 0; i < formats.length && result[0] == null; i++) {
		if (formats[i].checked) {
			result[0] = formats[i].value;
		}
	}
	
	//2. Recuperamos los formularios seleccionados
	var trows=document.getElementById("gridForms").rows;
	var arrFrms = new Array();
	for (i=0;i<trows.length;i++) {
		if (trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].checked){
			arrFrms[arrFrms.length] = trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
		}
	}
	result[1] = arrFrms;
	
	//3. Recuperamos los atributos agregados
	trows=document.getElementById("gridAtts").rows;
	var arrAtts = new Array();
	for (i=0;i<trows.length;i++) {
		arrAtts[arrAtts.length] = trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
	}
	result[2] = arrAtts;
	
	//4. Verificamos se haya seleccionado almenos un formulario o se haya ingresado almenos un atributo
	if (result[1].length==0 && result[2].length==0){
		alert("<%=LabelManager.getName(labelSet,"msgEntExpMisData")%>");
		return;
	}
	
	window.returnValue = result;
	window.close();
}	

function enableConfirm() {
	var oRows = document.getElementById("gridForms").selectedItems;
	document.getElementById("btnConf").disabled = (oRows == null) || (oRows.length == 0);
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>
