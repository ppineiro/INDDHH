<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.business.*"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.dao.DataBaseDAO"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.business.querys.factory.*" %><%@page import="com.dogma.bean.query.AdministrationBean" %><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.simulation.simulator.Distribution"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.SimScenarioBean"></jsp:useBean><% SimSceProcessVo simSceProVo = dBean.getSimSceProVo(); %></head><body><TABLE class="pageTop"><TR><TD><%=LabelManager.getName(labelSet,"titSceGenerator")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtSceGenType")%></DIV><table class="tblFormLayout"><tr><td><input type="radio" name="genType" id="genType" onclick='changeGenType("<%=SimSceProcessVo.GEN_DISABLED%>")' <%=(SimSceProcessVo.GEN_DISABLED == simSceProVo.getSsproGenType().intValue())?"checked":""%> value=""><%=LabelManager.getName(labelSet,"lblSceDontStart")%></td><td></td><td></td></tr><tr><td><input type="radio" name="genType" id="genType" onclick='changeGenType("<%=SimSceProcessVo.GEN_ON_DEMAND%>")' <%=(SimSceProcessVo.GEN_ON_DEMAND == simSceProVo.getSsproGenType().intValue())?"checked":""%> value=""><%=LabelManager.getName(labelSet,"lblSceOnDemand")%></td><td></td><td></td></tr><tr><td><input type="radio" name="genType" id="genType" onclick="changeGenType('<%=SimSceProcessVo.GEN_CANT_TRANS%>')" <%=(SimSceProcessVo.GEN_CANT_TRANS == simSceProVo.getSsproGenType().intValue())?"checked":""%>><%=LabelManager.getName(labelSet,"lblSceCantTrans")%></td><td align="left"><input type="text" <%=(SimSceProcessVo.GEN_CANT_TRANS != simSceProVo.getSsproGenType().intValue())?"disabled":""%> maxlength="7" size="8" name="txtCantTran" p_numeric="true" value="<%=(SimSceProcessVo.GEN_CANT_TRANS == simSceProVo.getSsproGenType().intValue()) ? simSceProVo.getSsproGenVal1().toString() : ""%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblSceCantTrans")%>"/></td><td></td></tr><tr><td><input type="radio" name="genType" id="genType" onclick="changeGenType('<%=SimSceProcessVo.GEN_FRECUENCY%>')" <%=(SimSceProcessVo.GEN_FRECUENCY == simSceProVo.getSsproGenType().intValue())?"checked":""%> value=""><%=LabelManager.getName(labelSet,"lblSceDistGen")%>:</td><td align="left"><select <%=(SimSceProcessVo.GEN_FRECUENCY != simSceProVo.getSsproGenType().intValue())?"disabled":""%> name="selGenFrec" id="selGenFrec" onchange="changeGenTypeFrec(this)"><option value="0" <%=(simSceProVo.getSsproGenVal1() == null)?"selected":""%>></option><option value="<%=Distribution.DIST_CTE_ENT%>" <%=(simSceProVo.getSsproGenVal1()!=null && simSceProVo.getSsproGenVal1().intValue() == Distribution.DIST_CTE_ENT)?"selected":""%>><%=LabelManager.getNameWAccess(labelSet,"lblSceFrecDistCteEntera")%></option><option value="<%=Distribution.DIST_EMP_ENT%>" <%=(simSceProVo.getSsproGenVal1()!=null && simSceProVo.getSsproGenVal1().intValue() == Distribution.DIST_EMP_ENT)?"selected":""%>><%=LabelManager.getNameWAccess(labelSet,"lblSceFrecDistEmpEntera")%></option><option value="<%=Distribution.DIST_POISSON%>" <%=(simSceProVo.getSsproGenVal1()!=null && simSceProVo.getSsproGenVal1().intValue() == Distribution.DIST_POISSON)?"selected":""%>><%=LabelManager.getNameWAccess(labelSet,"lblSceFrecDistPoisson")%></option><option value="<%=Distribution.DIST_UNIF_ENT%>" <%=(simSceProVo.getSsproGenVal1()!=null && simSceProVo.getSsproGenVal1().intValue() == Distribution.DIST_UNIF_ENT)?"selected":""%>><%=LabelManager.getNameWAccess(labelSet,"lblSceFrecDistUnifEntera")%></option><option value="<%=Distribution.DIST_CTE_REAL%>" <%=(simSceProVo.getSsproGenVal1()!=null && simSceProVo.getSsproGenVal1().intValue() == Distribution.DIST_CTE_REAL)?"selected":""%>><%=LabelManager.getNameWAccess(labelSet,"lblSceFrecDistCteReal")%></option><option value="<%=Distribution.DIST_EMP_REAL%>" <%=(simSceProVo.getSsproGenVal1()!=null && simSceProVo.getSsproGenVal1().intValue() == Distribution.DIST_EMP_REAL)?"selected":""%>><%=LabelManager.getNameWAccess(labelSet,"lblSceFrecDistEmpReal")%></option><option value="<%=Distribution.DIST_EARLANG%>" <%=(simSceProVo.getSsproGenVal1()!=null && simSceProVo.getSsproGenVal1().intValue() == Distribution.DIST_EARLANG)?"selected":""%>><%=LabelManager.getNameWAccess(labelSet,"lblSceFrecDistErlang")%></option><option value="<%=Distribution.DIST_EXP%>" <%=(simSceProVo.getSsproGenVal1()!=null && simSceProVo.getSsproGenVal1().intValue() == Distribution.DIST_EXP)?"selected":""%>><%=LabelManager.getNameWAccess(labelSet,"lblSceFrecDistExpo")%></option><option value="<%=Distribution.DIST_NORMAL%>" <%=(simSceProVo.getSsproGenVal1()!=null && simSceProVo.getSsproGenVal1().intValue() == Distribution.DIST_NORMAL)?"selected":""%>><%=LabelManager.getNameWAccess(labelSet,"lblSceFrecDistNormal")%></option><option value="<%=Distribution.DIST_UNIF_REAL%>" <%=(simSceProVo.getSsproGenVal1()!=null && simSceProVo.getSsproGenVal1().intValue() == Distribution.DIST_UNIF_REAL)?"selected":""%>><%=LabelManager.getNameWAccess(labelSet,"lblSceFrecDistUnifReal")%></option></select></td><td align="left"><input type="text" title="<%=LabelManager.getName(labelSet,"lblFirstParam")%>" p_numeric="true" <%=(SimSceProcessVo.GEN_FRECUENCY == simSceProVo.getSsproGenType().intValue() && simSceProVo.isParam1Required())?"":"disabled"%> size="10" name="txtPar1" value="<%=(simSceProVo.getSsproGenVal2()!=null)?simSceProVo.getSsproGenVal2():""%>"/><input type="text" title="<%=LabelManager.getName(labelSet,"lblSecondParam")%>" p_numeric="true" <%=(SimSceProcessVo.GEN_FRECUENCY == simSceProVo.getSsproGenType().intValue() && simSceProVo.isParam2Required())?"":"disabled"%> size="10" name="txtPar2" value="<%=(simSceProVo.getSsproGenVal3()!=null)?simSceProVo.getSsproGenVal3():""%>"/></td></tr><tr><td><input type="radio" name="genType" id="genType" onclick='changeGenType("<%=SimSceProcessVo.GEN_HISTORY%>")' <%=(SimSceProcessVo.GEN_HISTORY == simSceProVo.getSsproGenType().intValue())?"checked":""%> value=""><%=LabelManager.getName(labelSet,"lblHistoric")%></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr><tr><td></td><td></td><td></td></tr><tr><td><input name="genTypeSelected" id="genTypeSelected" type="hidden" value="<%=simSceProVo.getSsproGenType().intValue()%>"></td><td></td><td></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button id="btnConf" onclick="btnConfGenerator_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button onclick="btnExitGenerator_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><iframe id="iframeSubmit" name="iframeSubmit" style="position:absolute;width:1px;height:1px;" border="none"></iframe></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script type="text/javascript">
var MSG_REQ = '<%=LabelManager.getName(labelSet,"msgReq")%>';

function btnExitGenerator_click() {
	window.returnValue=null;
	window.close();
}
function btnConfGenerator_click(){
	if (verifyRequiredObjects()) {
		if (verifyReqObjects()) { //El verifyRequiredObjects no anda bien cuando se asigna el p_required por scripting
			document.getElementById("frmMain").action = "administration.SimScenarioAction.do?action=confGenModal&values="+getValues() + windowId;
			document.getElementById("frmMain").target="iframeSubmit";
			document.getElementById("frmMain").submit();
			//submitForm(document.getElementById("frmMain"));
		}
	}
}

//Posibles resultados: [1], [2,val], [3,1->11,val1,val2]
//Posicion 0 del array significa tipo de generador
//Si posicion 0 es 1 --> on demand
//Si posicion 0 es 2 --> cant.trans, posicion 1 es la cantidad
//Si posicion 0 es 3 --> frecuencia, posision 1 es tipo de frecuencia, pos 2 es el valor1, pos3 es el valor 2
function getValues(){
	arr = new Array();
	var genTypeSel = document.getElementById("genTypeSelected").value;
	arr[0] = genTypeSel;
	
	if (genTypeSel == <%=SimSceProcessVo.GEN_CANT_TRANS%>){
		arr[1] = document.getElementById("txtCantTran").value;
	}else if (genTypeSel == <%=SimSceProcessVo.GEN_FRECUENCY%>){
		var genTypeFrecSel = document.getElementById("selGenFrec").value;
		arr[1] = genTypeFrecSel;
		if (genTypeFrecSel == <%=Distribution.DIST_CTE_ENT%>){ //dist. constante entera
			arr[2] = document.getElementById("txtPar1").value;
			arr[3] = "";
		}else if (genTypeFrecSel == <%=Distribution.DIST_EMP_ENT%>){ //dist. empirica entera
			arr[2] = "";
			arr[3] = "";			
		}else if (genTypeFrecSel == <%=Distribution.DIST_POISSON%>){ //dist. poisson
			arr[2] = document.getElementById("txtPar1").value;
			arr[3] = "";
		}else if (genTypeFrecSel == <%=Distribution.DIST_UNIF_ENT%>){ //dist. uniforme entera
			arr[2] = document.getElementById("txtPar1").value;
			arr[3] = document.getElementById("txtPar2").value;		
		}else if (genTypeFrecSel == <%=Distribution.DIST_CTE_REAL%>){ //dist. constante real
			arr[2] = document.getElementById("txtPar1").value;
			arr[3] = "";		
		}else if (genTypeFrecSel == <%=Distribution.DIST_EMP_REAL%>){ //dist. empirica real
			arr[2] = "";
			arr[3] = "";		
		}else if (genTypeFrecSel == <%=Distribution.DIST_EARLANG%>){ //dist. erlang
			arr[2] = document.getElementById("txtPar1").value;
			arr[3] = document.getElementById("txtPar2").value;		
		}else if (genTypeFrecSel == <%=Distribution.DIST_EXP%>){ //dist. exponencial
			arr[2] = document.getElementById("txtPar1").value;
			arr[3] = "";		
		}else if (genTypeFrecSel == <%=Distribution.DIST_NORMAL%>){ //dist. normal
			arr[2] = document.getElementById("txtPar1").value;
			arr[3] = document.getElementById("txtPar2").value;		
		}else if (genTypeFrecSel == <%=Distribution.DIST_UNIF_REAL%>){ //dist. uniforme real
			arr[2] = document.getElementById("txtPar1").value;
			arr[3] = document.getElementById("txtPar2").value;
		}
	}
	return arr;
}

function styleRed(objName){
	document.getElementById(objName).style.border = "3px solid #F62E09";
}

function remStyleRed(objName){
	document.getElementById(objName).style.border = "1px solid #CCCCCC";
}

function verifyReqObjects(){
	var genTypeSel = document.getElementById("genTypeSelected").value;
	if (genTypeSel == <%=SimSceProcessVo.GEN_CANT_TRANS%>){
		if (document.getElementById("txtCantTran").value == ""){
			fieldReqAlert("<%=LabelManager.getName(labelSet,"lblSceCantTrans")%>");
			styleRed("txtCantTran");
			return false;
		}
	}else if (genTypeSel == <%=SimSceProcessVo.GEN_FRECUENCY%>){
		var genTypeFrecSel = document.getElementById("selGenFrec").value;
		if (genTypeFrecSel == 0){
			fieldReqAlert("<%=LabelManager.getName(labelSet,"lblSceDistGen")%>");
			styleRed("selGenFrec");
			return false;
		}else if (genTypeFrecSel == <%=Distribution.DIST_CTE_ENT%>){
			if (document.getElementById("txtPar1").value == ""){
				fieldReqAlert("<%=LabelManager.getName(labelSet,"lblPar1")%>");
				styleRed("txtPar1");
				return false;
			}
		}else if (genTypeFrecSel == <%=Distribution.DIST_EMP_ENT%>){
			return true;
		}else if (genTypeFrecSel == <%=Distribution.DIST_POISSON%>){
			if (document.getElementById("txtPar1").value == ""){
				fieldReqAlert("<%=LabelManager.getName(labelSet,"lblPar1")%>");
				styleRed("txtPar1");
				return false;
			}
		}else if (genTypeFrecSel == <%=Distribution.DIST_UNIF_ENT%>){
			if (document.getElementById("txtPar1").value == ""){
				fieldReqAlert("<%=LabelManager.getName(labelSet,"lblPar1")%>");
				styleRed("txtPar1");
				return false;
			}
			if (document.getElementById("txtPar2").value == ""){
				fieldReqAlert("<%=LabelManager.getName(labelSet,"lblPar2")%>");
				remStyleRed("txtPar1");
				styleRed("txtPar2");
				return false;
			}
		}else if (genTypeFrecSel == <%=Distribution.DIST_CTE_REAL%>){
			if (document.getElementById("txtPar1").value == ""){
				fieldReqAlert("<%=LabelManager.getName(labelSet,"lblPar1")%>");
				styleRed("txtPar1");
				return false;
			}
		}else if (genTypeFrecSel == <%=Distribution.DIST_EMP_REAL%>){
			return true;
		}else if (genTypeFrecSel == <%=Distribution.DIST_EARLANG%>){
			if (document.getElementById("txtPar1").value == ""){
				fieldReqAlert("<%=LabelManager.getName(labelSet,"lblPar1")%>");
				styleRed("txtPar1");
				return false;
			}
			if (document.getElementById("txtPar2").value == ""){
				fieldReqAlert("<%=LabelManager.getName(labelSet,"lblPar2")%>");
				remStyleRed("txtPar1");
				styleRed("txtPar2");
				return false;
			}
		}else if (genTypeFrecSel == <%=Distribution.DIST_EXP%>){
			if (document.getElementById("txtPar1").value == ""){
				fieldReqAlert("<%=LabelManager.getName(labelSet,"lblPar1")%>");
				styleRed("txtPar1");
				return false;
			}
		}else if (genTypeFrecSel == <%=Distribution.DIST_NORMAL%>){
			if (document.getElementById("txtPar1").value == ""){
				fieldReqAlert("<%=LabelManager.getName(labelSet,"lblPar1")%>");
				styleRed("txtPar1");
				return false;
			}
			if (document.getElementById("txtPar2").value == ""){
				fieldReqAlert("<%=LabelManager.getName(labelSet,"lblPar2")%>");
				remStyleRed("txtPar1");
				styleRed("txtPar2");
				return false;
			}
		}else if (genTypeFrecSel == <%=Distribution.DIST_UNIF_REAL%>){
			if (document.getElementById("txtPar1").value == ""){
				fieldReqAlert("<%=LabelManager.getName(labelSet,"lblPar1")%>");
				styleRed("txtPar1");
				return false;
			}
			if (document.getElementById("txtPar2").value == ""){
				fieldReqAlert("<%=LabelManager.getName(labelSet,"lblPar2")%>");
				remStyleRed("txtPar1");
				styleRed("txtPar2");
				return false;
			}
		}
	}
	return true;
}

function fieldReqAlert(msg){
	alert(MSG_REQ.replace("<TOK1>", msg));
}

function changeGenType(val){
	if (val == <%=SimSceProcessVo.GEN_DISABLED%>){//dont start
		document.getElementById("genTypeSelected").value = <%=SimSceProcessVo.GEN_DISABLED%>;
		//Input de cantidad de transacciones
		document.getElementById("txtCantTran").disabled=true;
		document.getElementById("txtCantTran").value = "";
		document.getElementById("txtCantTran").p_required=false;
		remStyleRed("txtCantTran");	
		//Frecuencia
		document.getElementById("selGenFrec").selectedIndex=0;
		document.getElementById("selGenFrec").disabled=true;
		document.getElementById("txtPar1").disabled=true;
		document.getElementById("txtPar2").disabled=true;
		document.getElementById("selGenFrec").p_required=false;
		document.getElementById("txtPar1").p_required=false;
		document.getElementById("txtPar2").p_required=false;
		document.getElementById("txtPar1").value="";
		document.getElementById("txtPar2").value="";
		remStyleRed("txtPar1");
		remStyleRed("txtPar2");	
	}else if (val == <%=SimSceProcessVo.GEN_ON_DEMAND%>){//on demand
		document.getElementById("genTypeSelected").value = <%=SimSceProcessVo.GEN_ON_DEMAND%>;
		//Input de cantidad de transacciones
		document.getElementById("txtCantTran").disabled=true;
		document.getElementById("txtCantTran").value = "";
		document.getElementById("txtCantTran").p_required=false;
		remStyleRed("txtCantTran");	
		//Frecuencia
		document.getElementById("selGenFrec").selectedIndex=0;
		document.getElementById("selGenFrec").disabled=true;
		document.getElementById("txtPar1").disabled=true;
		document.getElementById("txtPar2").disabled=true;
		document.getElementById("selGenFrec").p_required=false;
		document.getElementById("txtPar1").p_required=false;
		document.getElementById("txtPar2").p_required=false;
		document.getElementById("txtPar1").value="";
		document.getElementById("txtPar2").value="";
		remStyleRed("txtPar1");
		remStyleRed("txtPar2");	
	}else if (val == <%=SimSceProcessVo.GEN_CANT_TRANS%>){
		document.getElementById("genTypeSelected").value = <%=SimSceProcessVo.GEN_CANT_TRANS%>;
		//Input de cantidad de transacciones
		document.getElementById("txtCantTran").disabled=false;
		document.getElementById("txtCantTran").p_required="true";
		//Frecuencia
		document.getElementById("selGenFrec").selectedIndex=0;
		document.getElementById("selGenFrec").disabled=true;
		document.getElementById("txtPar1").disabled=true;
		document.getElementById("txtPar2").disabled=true;
		document.getElementById("selGenFrec").p_required=false;
		document.getElementById("txtPar1").p_required=false;
		document.getElementById("txtPar2").p_required=false;
		document.getElementById("txtPar1").value="";
		document.getElementById("txtPar2").value="";
		remStyleRed("txtPar1");
		remStyleRed("txtPar2");	
	}else if (val == <%=SimSceProcessVo.GEN_FRECUENCY%>){
		document.getElementById("genTypeSelected").value = <%=SimSceProcessVo.GEN_FRECUENCY%>;
		//Input de cantidad de transacciones
		document.getElementById("txtCantTran").disabled=true;
		document.getElementById("txtCantTran").value = "";
		document.getElementById("txtCantTran").p_required=false;
		remStyleRed("txtCantTran");	
		//Frecuencia
		document.getElementById("selGenFrec").disabled=false;
		document.getElementById("txtPar1").disabled=true;
		document.getElementById("txtPar2").disabled=true;
		document.getElementById("selGenFrec").p_required=true;
		document.getElementById("txtPar1").p_required=false;
		document.getElementById("txtPar2").p_required=false;
	}else if (val == <%=SimSceProcessVo.GEN_HISTORY%>){//historic
		document.getElementById("genTypeSelected").value = <%=SimSceProcessVo.GEN_HISTORY%>;
		//Input de cantidad de transacciones
		document.getElementById("txtCantTran").disabled=true;
		document.getElementById("txtCantTran").value = "";
		document.getElementById("txtCantTran").p_required=false;
		remStyleRed("txtCantTran");	
		//Frecuencia
		document.getElementById("selGenFrec").selectedIndex=0;
		document.getElementById("selGenFrec").disabled=true;
		document.getElementById("txtPar1").disabled=true;
		document.getElementById("txtPar2").disabled=true;
		document.getElementById("selGenFrec").p_required=false;
		document.getElementById("txtPar1").p_required=false;
		document.getElementById("txtPar2").p_required=false;
		document.getElementById("txtPar1").value="";
		document.getElementById("txtPar2").value="";
		remStyleRed("txtPar1");
		remStyleRed("txtPar2");	
	}
}

function changeGenTypeFrec(object){
	var val = object.value;
	remStyleRed("txtPar1");
	remStyleRed("txtPar2");
	if (val==<%=Distribution.DIST_CTE_ENT%>){//Distribuida constante entera
		document.getElementById("txtPar1").disabled=false;
		document.getElementById("txtPar2").disabled=true;
		document.getElementById("txtPar1").p_required=true;
		document.getElementById("txtPar2").p_required=false;
		document.getElementById("txtPar2").value="";
	}else if (val==<%=Distribution.DIST_EMP_ENT%>){//Distribuida empirica entera
		document.getElementById("txtPar1").disabled=true;
		document.getElementById("txtPar2").disabled=true;
		document.getElementById("txtPar1").p_required=false;
		document.getElementById("txtPar2").p_required=false;
		document.getElementById("txtPar1").value="";
		document.getElementById("txtPar2").value="";
	}else if (val==<%=Distribution.DIST_POISSON%>){//Distribuida poisson
		document.getElementById("txtPar1").disabled=false;
		document.getElementById("txtPar2").disabled=true;
		document.getElementById("txtPar1").p_required=true;
		document.getElementById("txtPar2").p_required=false;
		document.getElementById("txtPar2").value="";
	}else if (val==<%=Distribution.DIST_UNIF_ENT%>){//Distribuida uniforme entera
		document.getElementById("txtPar1").disabled=false;
		document.getElementById("txtPar2").disabled=false;
		document.getElementById("txtPar1").p_required=true;
		document.getElementById("txtPar2").p_required=true;
	}else if (val==<%=Distribution.DIST_CTE_REAL%>){//Distribuida constante real
		document.getElementById("txtPar1").disabled=false;
		document.getElementById("txtPar2").disabled=true;
		document.getElementById("txtPar1").p_required=true;
		document.getElementById("txtPar2").p_required=false;
		document.getElementById("txtPar2").value="";
	}else if (val==<%=Distribution.DIST_EMP_REAL%>){//Distribuida empirica real
		document.getElementById("txtPar1").disabled=true;
		document.getElementById("txtPar2").disabled=true;
		document.getElementById("txtPar1").p_required=false;
		document.getElementById("txtPar2").p_required=false;
		document.getElementById("txtPar1").value="";
		document.getElementById("txtPar2").value="";
	}else if (val==<%=Distribution.DIST_EARLANG%>){//Distribuida erlang
		document.getElementById("txtPar1").disabled=false;
		document.getElementById("txtPar2").disabled=false;
		document.getElementById("txtPar1").p_required=true;
		document.getElementById("txtPar2").p_required=true;
	}else if (val==<%=Distribution.DIST_EXP%>){//Distribuida exponencial
		document.getElementById("txtPar1").disabled=false;
		document.getElementById("txtPar2").disabled=true;
		document.getElementById("txtPar1").p_required=true;
		document.getElementById("txtPar2").p_required=false;
		document.getElementById("txtPar2").value="";
	}else if (val==<%=Distribution.DIST_NORMAL%>){//Distribuida normal
		document.getElementById("txtPar1").disabled=false;
		document.getElementById("txtPar2").disabled=false;
		document.getElementById("txtPar1").p_required=true;
		document.getElementById("txtPar2").p_required=true;
	}else if (val==<%=Distribution.DIST_UNIF_REAL%>){//Distribuida uniforme real
		document.getElementById("txtPar1").disabled=false;
		document.getElementById("txtPar2").disabled=false;
		document.getElementById("txtPar1").p_required=true;
		document.getElementById("txtPar2").p_required=true;
	}
}
</script>
