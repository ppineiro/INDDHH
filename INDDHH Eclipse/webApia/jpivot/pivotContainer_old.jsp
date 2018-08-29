<%@include file="../page/includes/startInc.jsp" %><%@page import="com.dogma.Parameters"%><%
boolean busy=((Boolean)(  (request.getSession().getAttribute("busy")!=null?request.getSession().getAttribute("busy"):new Boolean(false))    )    ).booleanValue();
int intentos = 0;
if (request.getSession().getAttribute("biIntents")!=null && !"".equals(request.getSession().getAttribute("biIntents"))){
	intentos = (Integer) (request.getSession().getAttribute("biIntents"));
}
%><html style="height:100%"><head><%@include file="../page/includes/headInclude.jsp" %><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/util.js" language="Javascript"></script><link href="<system:util show="context" />/js/progressBars/progressBar.css" rel="stylesheet" type="text/css"><script type="text/javascript" src="<system:util show="context" />/js/progressBars/progressBar.js"></script><script language="javascript">
//navigator.language="en-en";

var URL_ROOT_PATH		 	="<%=Parameters.ROOT_PATH%>";
function init(){
	document.getElementById('jPivotForm').submit() 
}
</script><%
if (busy && intentos <= 6){ //Si alguien marco la flag busy en true le damos tiempo a que termine durante 30 segundos, sino forzamos la carga de este cubo
 intentos = intentos + 1;
 request.getSession().setAttribute("biIntents", Integer.valueOf(intentos));%><meta http-equiv="REFRESH" content="5"><%//Hacemos que en 5 segundos intente nuevamente hasta 6 veces%></head><body></body><%}else { //Forzamos la carga de este cubo (por si quedo trancado el que estaba cargando)
 request.getSession().setAttribute("biIntents", Integer.valueOf(0));
 request.getSession().setAttribute("busy",new Boolean(true));%><style type="text/css">
	/*
 	#box { 
 		border:1px solid #ccc; 
 		width:20%; height:20px;
 		margin-left: 40%;
 		top: 49% ;
 		position: absolute;
 	}
	#perc			{ background:#ccc; height:20px; }
	*/
 </style><script type="text/javascript">
 function initPage() {
	new ProgressBar('apia.administration.BIAction.run');
	testCube();
 }
 
 function testCube() {
 	var request = new Request({
		method: 'post',			
		url: CONTEXT + URL_REQUEST_AJAX+'?action=testCube&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) { processXMLtestResult(resXml); }
	}).send();
 }
 
 //Recibe un xml con el resultado del test 
 function processXMLtestResult(ajaxCallXml){
	 
	 if(responseXML && responseXML.childNodes && responseXML.childNodes.length) {
 		var response = responseXML.childNodes.length == 1 ? responseXML.childNodes[0] : responseXML.childNodes[1];
 		
 		if(response.tagName == 'result' && response.getAttribute('testresult')) {
 			
 			var result = Number.from(response.getAttribute('testresult'));
 			
 			if (0 == result) {
 				//Abrir schemaLoader.jsp
 			}else if (500 == result){
 				//El cubo es de entidad y no esta actualizado
 				//return new ActionForward(mapping.findForward(BIAction.FORWARD_ENT_CBE_REL).getPath()+"?mode=navigator" + this.retrieveBean(http).getParams(http) + "&tabId=" + HttpRequestUtil.getStaticParameterAsString(http, BasicAction.TAB_ID), false);
 			}else { //dio error
 				//Abrir errroBI.jsp
 			}
 			
 		}
 	}
 }
 </script></head><body onload="init()" style="padding:0px;margin:0px;overflow:hidden;height:100%" scroll="no"><form accept-language="en-us" id="jPivotForm" action="<%=Parameters.ROOT_PATH%>/jpivot/schemaLoader.jsp?schemaId=<%=request.getParameter("schemaId")%>&cubeId=<%=request.getParameter("cubeId")%>&viewId=<%=request.getParameter("viewId")%>&entityCube=<%=request.getParameter("entityCube")%>&tabId=<%=request.getParameter("tabId")%>" method="POST" target="jpivot"></form><iframe name="jpivot" frameborder="no" style="position:absolute;top:0px;height:100%;width:100%;" scrolling="no"></iframe><div id="progress-container" style="height: 100%"></div></body><%}%></html>