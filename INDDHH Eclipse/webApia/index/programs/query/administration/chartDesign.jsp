<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.business.*"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.dao.DataBaseDAO"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.business.querys.factory.*" %><%@page import="com.dogma.bean.query.AdministrationBean" %><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.AdministrationBean"></jsp:useBean><%
QryChartVo chartVo = dBean.getQryChartVo();
boolean isPieType = chartVo!=null && chartVo.getQryChtType()!=null && Integer.valueOf(chartVo.getQryChtType()).intValue() == QryChartVo.PIE;
%></head><body><TABLE class="pageTop"><TR><TD><%=LabelManager.getName(labelSet,"titDesign")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtChtType")%></DIV><table class="tblFormLayout"><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblType")%>"><%=LabelManager.getNameWAccess(labelSet,"lblType")%>:</td><td><select name="chtType" id="chtType" onchange="chtTypeChange()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblType")%>"></select></td><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblSubType")%>"><%=LabelManager.getNameWAccess(labelSet,"lblSubType")%>:</td><td><select name="chtSubType" id="chtSubType" onchange="chtSubTypeChange()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblSubType")%>"></select></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtChtDefinition")%></DIV><table id="tableForm" class="tblFormLayout"><tr><td></td><td></td><td></td><td></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblTit")%>"><%=LabelManager.getNameWAccess(labelSet,"lblTit")%>:</td><td><input name="chtTitle" id="chtTitle" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTit")%>" value="<%= dBean.fmtStr(chartVo.getQryChtTitle()) %>" p_required=true size="40"></td><td></td><td></td></tr><tr><td align="right" valign="top" title="<%=LabelManager.getToolTip(labelSet,"lblTitY")%>" <%if (isPieType){%>style="display:none"<%}%>><%=LabelManager.getNameWAccess(labelSet,"lblTitY")%>:</td><td valign="top"><input name="chtTitleY" id="chtTitleY" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTitY")%>" value="<%= dBean.fmtStr(chartVo.getQryChtTitleY()) %>" <%if (isPieType){%>style="display:none"<%}%>></td><td></td><td align="center"><img src="" id="imgSample"></td></tr><tr><td align="right" title="<%=(isPieType)?LabelManager.getName(labelSet,"lblCateg"):LabelManager.getToolTip(labelSet,"lblEjeX")%>"><%=(isPieType)?LabelManager.getName(labelSet,"lblCateg"):LabelManager.getToolTip(labelSet,"lblEjeX")%>:</td><td><select name="chtColX" id="chtColX" p_required=true onchange="lockSerie()" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblEjeX")%>"><option value=""></option><%
						Collection columns = dBean.getActualQueryColumns();
						if (columns != null) {
							for (Iterator it = columns.iterator(); it.hasNext(); ) {
								QryColumnVo colVo = (QryColumnVo) it.next(); 
								String optValue = dBean.fmtStr(colVo.getQryColName());
								if (colVo.getAttId()!=null){
									optValue = optValue + "·" + dBean.fmtInt(colVo.getAttId());
									if (colVo.getBusClaParId()!=null){
										optValue = optValue + "·" + dBean.fmtInt(colVo.getBusClaParId());
									}
								}else if (colVo.getBusClaParId()!=null){
									optValue = optValue + "·" + "·" + dBean.fmtInt(colVo.getBusClaParId());
								}%><option value="<%=optValue%>" <% if (chartVo.isQryColumnX(colVo)) {%>selected<%}%>><%=dBean.fmtStr(colVo.getQryColName())%></option><%
							}
						}
					%></select></td><td align="right" title="<%=LabelManager.getToolTip(labelSet,"lblTitX")%>" <%if (isPieType){%>style="display:none"<%}%>><%=LabelManager.getNameWAccess(labelSet,"lblTitX")%>:</td><td><input name="chtTitleX" id="chtTitleX" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblTitX")%>" value="<%= dBean.fmtStr(chartVo.getQryChtTitleX()) %>" <%if (isPieType){%>style="display:none"<%}%>></td></tr></table><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtChtSeries")%></DIV><div class="tableContainerNoHScroll" style="height:100px;" type="grid" id="gridSerie" docBean=""><table id="tblSerie" class="tblDataGrid" cellpadding="0" cellspacing="0"><thead><tr><th min_width="70px" style="min-width:70px;width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th><th min_width="180px" style="width:180px" title="<%=LabelManager.getToolTip(labelSet,"lblColor")%>"><%=LabelManager.getName(labelSet,"lblColor")%></th><th min_width="50px" style="width:50px" title="<%=LabelManager.getToolTip(labelSet,"lblShow")%>"><%=LabelManager.getName(labelSet,"lblShow")%></th></tr></thead><tbody ><%
					if (chartVo.getSeries() != null) {
						for (Iterator it = chartVo.getSeries().iterator(); it.hasNext(); ) {
							QryChtSerieVo serVo = (QryChtSerieVo) it.next();
							if (serVo.getColumnVo().getQryColDataType().equals(AttributeVo.TYPE_NUMERIC)){
							%><tr><td style="min-width:70px"><input type="hidden" name="chtSerColSelected" id="chtSerColSelected" value=""><input type="hidden" name="chtSerColName" id="chtSerColName" value="<%=dBean.fmtStr(serVo.getColName())%>"><input type="hidden" name="chtSerColId" id="chtSerColId" value="<%= dBean.fmtInt(serVo.getQryColId()) %>"><input type="hidden" name="chtSerAttId" id="chtSerAttId" value="<%= dBean.fmtInt(serVo.getAttId()) %>"><input type="hidden" name="chtSerBusClaParId" id="chtSerBusClaParId" value="<%= dBean.fmtInt(serVo.getBusClaParId()) %>"><%=dBean.fmtStr(serVo.getColName())%></td><td><input type="input" name="chtSerColor" class="txtReadonly" readonly value="<%= dBean.fmtStr(serVo.getQryChtSerColor()) %>"><a href="#" onclick="colorPicker(this)"><img width="15" height="13" border="0" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/palette.gif"></a><input type="text" size="2" readonly style="background-color:<%= serVo.getQryChtSerColor() %>; border:0px"></td><td><input type="hidden" name="chtSerShow" value="<%= (serVo.isConfirmed())?"true":"false" %>"><input type="checkbox" name="chkChtSerShow" value="" <% if (serVo.isConfirmed()) { %>checked<% } %> onclick="showChecked(this)"></td></tr><%}
						}
					}
					%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><td><button onclick="upSerie_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnUp")%>" title="<%=LabelManager.getToolTip(labelSet,"btnUp")%>"><%=LabelManager.getNameWAccess(labelSet,"btnUp")%></button><button onclick="downSerie_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnDown")%>" title="<%=LabelManager.getToolTip(labelSet,"btnDown")%>"><%=LabelManager.getNameWAccess(labelSet,"btnDown")%></button></td><td><input type="button" style="display:none" value="" id="btnColorSelected" onClick="colorSelected()"></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button id="btnConf" onclick="btnConfChartDesign_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button onclick="btnExitChartDesign_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/query/administration/update.js'></script><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/query/administration/updateCharts.js'></script><script language="javascript" defer>

//Para agregar un nuevo subtipo a un tipo ya existente:
// 1.agregue una variable (ej:NEW_SUBTYPE)
// 2.agregue la variable en el array del tipo correspondiente (ej:var typSubType1 = new Array(BAR_HOR_TYPE,b2D_SUBTYPE,b3D_SUBTYPE, NEW_SUBTYPE);)

//Para agregar un nuevo tipo:
// 1.agregue una variable (ej:NEW_TYPE)
// 2.agregue todas las variables segun cantidad de subtipos tenga (ej:NEW_SUBTYPE)
// 3.cree un array para los nuevos tipos y sus subtipos (ej: var typSubtypeX = new Array(NEW_TYPE,NEW_SUBTYPE1,NEW_SUBTYPE2,..)
// 3.agregue el array anterior en el array typSubtypes

//Para agregar una nueva imagen:
// 1.agregue una variable con la ruta y nombre de la imagen (ej:lines2d)
// 2.agregue la variable anterior en el array correpondiente segun el tipo de la grafica

//Definicion de tipos
var BAR_HOR_TYPE 		= "<%=LabelManager.getName(labelSet,"txtBarHorType")%>";
var BAR_VER_TYPE		= "<%=LabelManager.getName(labelSet,"txtBarVerType")%>";
var LIN_TYPE			= "<%=LabelManager.getName(labelSet,"txtLineType")%>";
var WFALL_TYPE			= "<%=LabelManager.getName(labelSet,"txtWFallType")%>";
var PIE_TYPE			= "<%=LabelManager.getName(labelSet,"txtPieType")%>";
//var NEW_TYPE			= "<%=LabelManager.getName(labelSet,"newTxtType")%>";
var MSG_NO_SERIE		= "<%=LabelManager.getName(labelSet,"msgNoSeries")%>";

//Definicion de subtipos
var b2D_SUBTYPE			= "<%=LabelManager.getName(labelSet,"txt2DSubType")%>";
var b3D_SUBTYPE			= "<%=LabelManager.getName(labelSet,"txt3DSubType")%>";
//var NEW_SUBTYPE		= "<%=LabelManager.getName(labelSet,"newTxtSubType")%>";

//Definicion de ejemplos de graficas
var barsVert2d          = "<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/barsVert2d.gif";
var barsHor2d			= "<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/barsHor2d.gif";
var barsVert3d			= "<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/barsVert3d.gif";
var barsHor3d 			= "<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/barsHor3d.gif";
var lines2d				= "<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/lines2d.gif";
var waterFall2d			= "<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/waterFall2D.gif";
var pie2d				= "<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/pie2d.gif";
var pie3d				= "<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/pie3d.gif";

//Definicion de arrays con tipos y subtipos
var typSubtype1 = new Array(BAR_VER_TYPE,b2D_SUBTYPE,b3D_SUBTYPE);
//var typSubType1 = new Array(BAR_VER_TYPE,b2D_SUBTYPE,b3D_SUBTYPE, NEW_SUBTYPE);
var typSubtype2 = new Array(BAR_HOR_TYPE,b2D_SUBTYPE,b3D_SUBTYPE);
var typSubtype3 = new Array(LIN_TYPE,b2D_SUBTYPE);
var typSubtype4 = new Array(WFALL_TYPE,b2D_SUBTYPE);
var typSubtype5 = new Array(PIE_TYPE,b2D_SUBTYPE,b3D_SUBTYPE);

//Definicion de array con samples de graficas
var typSample1  = new Array(BAR_VER_TYPE,barsVert2d,barsVert3d);
var typSample2  = new Array(BAR_HOR_TYPE,barsHor2d,barsHor3d);
var typSample3  = new Array(LIN_TYPE,lines2d);
var typSample4  = new Array(WFALL_TYPE,waterFall2d);
var typSample5  = new Array(PIE_TYPE,pie2d,pie3d);

var lblCategoria = "<%=LabelManager.getToolTip(labelSet,"lblCateg")%>";
var lblEjeX = "<%=LabelManager.getToolTip(labelSet,"lblEjeX")%>";

//Definicion del array que contiene los arrays con tipo y subtipos
var typSubtypes = new Array(typSubtype1,typSubtype2,typSubtype3,typSubtype4,typSubtype5);

//Definicion del array con los tipos y sus graficas de ejemplo
var typSamples  = new Array(typSample1,typSample2,typSample3,typSample4,typSample5);

///////////////////Cargamos tipos/////////////////////
for (i = 0; i < typSubtypes.length;i++){
	var oOpt = document.createElement("OPTION");
	oOpt.value = i;
	oOpt.innerHTML = typSubtypes[i][0];
	if (<%=chartVo.getQryChtType()%> == i){
		oOpt.setAttribute("selected",true);
	}
	document.getElementById("chtType").appendChild(oOpt);
}

///////////////////Cargamos subtipos/////////////////////
if (<%=chartVo.getQryChtType()%> != null){
	for (j = 1; j < typSubtypes[<%=chartVo.getQryChtType()%>].length;j++){
		var oOpt = document.createElement("OPTION");
		oOpt.value = j;
		oOpt.innerHTML = typSubtypes[0][j];
		if (<%=chartVo.getQryChtSubtype()%> == j){
			oOpt.setAttribute("selected",true);
		}
		document.getElementById("chtSubType").appendChild(oOpt);
	}
}else{
	for (j = 1; j < typSubtypes[0].length;j++){
		var oOpt = document.createElement("OPTION");
		oOpt.value = j;
		oOpt.innerHTML = typSubtypes[0][j];
		if (<%=chartVo.getQryChtSubtype()%> == j){
			oOpt.setAttribute("selected",true);
		}
		document.getElementById("chtSubType").appendChild(oOpt);
	}
}

/////////////////Cargamos la grafica por defecto/////////
if ((<%=chartVo.getQryChtType()%> != null) && (<%=chartVo.getQryChtSubtype()%> != null)){
	document.getElementById("imgSample").src=typSamples[<%=chartVo.getQryChtType()%>][<%=chartVo.getQryChtSubtype()%>];
}else {
	document.getElementById("imgSample").src=typSamples[0][1];
}

function chtTypeChange(){
	var opts=document.getElementById("chtSubType").getElementsByTagName("OPTION");
	while(opts.length!=0){
		document.getElementById("chtSubType").removeChild(opts[0]);
	}
	for (j = 1; j < typSubtypes[document.getElementById("chtType").value].length;j++){
		var oOpt = document.createElement("OPTION");
		oOpt.value = j;
		oOpt.innerHTML = typSubtypes[document.getElementById("chtType").value][j];
		document.getElementById("chtSubType").appendChild(oOpt);
	}
	//Mostramos la grafica de ejemplo correspondiente
	document.getElementById("imgSample").src=typSamples[document.getElementById("chtType").value][document.getElementById("chtSubType").value];
	var selected = document.getElementById("chtType").options[document.getElementById("chtType").selectedIndex].text;
	if (selected == PIE_TYPE){
		document.getElementById("chtTitleX").style.display='none';
		document.getElementById("chtTitleY").style.display='none';
		document.getElementById("tableForm").rows[2].cells[0].style.display='none';
		document.getElementById("tableForm").rows[3].cells[2].style.display='none';
		document.getElementById("tableForm").rows[3].cells[0].innerHTML = "<%=LabelManager.getName(labelSet,"lblCateg")%>";
		//document.getElementById("tableForm").rows[3].cells[0].childNodes[1].nodeValue = "<%=LabelManager.getName(labelSet,"lblCateg")%>";
		
	}else{
		document.getElementById("chtTitleX").style.display='block';
		document.getElementById("chtTitleY").style.display='block';
		document.getElementById("tableForm").rows[2].cells[0].style.display='block';
		document.getElementById("tableForm").rows[3].cells[2].style.display='block';
		document.getElementById("tableForm").rows[3].cells[0].innerHTML= "<%=LabelManager.getName(labelSet,"lblEjeX")%>";;
		//document.getElementById("tableForm").rows[3].cells[0].childNodes[1].nodeValue= "<%=LabelManager.getName(labelSet,"lblEjeX")%>";;
	}
}
function chtSubTypeChange(){
	//Mostramos la grafica de ejemplo correspondiente
	document.getElementById("imgSample").src=typSamples[document.getElementById("chtType").value][document.getElementById("chtSubType").value];
}

</script><script>
if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", lockSerie, false);
}else{
	document.body.onload=lockSerie;
}
</script>
