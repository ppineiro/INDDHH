<%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.UserData"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.ExternalAccessLoader"%><%

	//  * Ejecuta un cubo o dashboard desde otro servidor

	String user = null;
	String pass = null;
	String logFromSession = "false"; //por defecto
	Integer env = null;
	String from = null;
	Integer langId = null;
	Integer labelSet = Parameters.DEFAULT_LABEL_SET;
	String sessionAtts = null;
	boolean logged = false; //de uso interno
	
	String action = null;
	Integer schemaId = null;
	Integer cubeId = null;
	Integer dshId = null;
	boolean entityCube = false;
	boolean processCube = false;
	boolean envApiaGenCube = false;
	boolean allEnvApiaGenCube = false;
	boolean serverTest = false;
	Integer viewId = null;
	
	String styleDirectory = "default";
	com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
	if (uData!=null) {
		styleDirectory = EnvParameters.getEnvParameter(uData.getEnvironmentId(),EnvParameters.ENV_STYLE);
	}
	
	//Obtenemos user de la url
	if (request.getParameter("user") != null) {
		user = new String(request.getParameter("user"));
	}
	
	//Obtenemos pass de la url
	if (request.getParameter("pass") != null) {
		pass = new String(request.getParameter("pass"));
	}
	
	//Obtenemos action
	if (request.getParameter("action") != null) {
		action = new String(request.getParameter("action"));
	}
	
	//Obtenemos from
	if (request.getParameter("from") != null) {
		from = new String(request.getParameter("from"));
	}
	
	//Obtenemos ambiente
	if (request.getParameter("env") != null
		&& !"null".equals(request.getParameter("env"))) {
		env = new Integer(request.getParameter("env"));
	} else {
		env = new Integer(1);
	}
	
	//Obtenemos schemaId
	if (request.getParameter("schemaId") != null
		&& !"null".equals(request.getParameter("schemaId"))) {
		schemaId = new Integer(request.getParameter("schemaId"));
	} 
	
	//Obtenemos cubeId
	if (request.getParameter("cubeId") != null
		&& !"null".equals(request.getParameter("cubeId"))) {
		cubeId = new Integer(request.getParameter("cubeId"));
	} 
	
	//Obtenemos viewId
	if (request.getParameter("viewId") != null
		&& !"null".equals(request.getParameter("viewId"))) {
		viewId = new Integer(request.getParameter("viewId"));
	} 
	
	//Obtenemos dshId
	if (request.getParameter("dshId") != null
		&& !"null".equals(request.getParameter("dshId"))) {
		dshId = new Integer(request.getParameter("dshId"));
	} 
	
//	Obtenemos serverTest
	if (request.getParameter("serverTest") != null && !"null".equals(request.getParameter("serverTest"))) {
		serverTest = "true".equals(request.getParameter("serverTest"));
	}
	
//	Obtenemos entityCube
	if (request.getParameter("entityCube") != null && !"null".equals(request.getParameter("entityCube"))) {
		entityCube = "true".equals(request.getParameter("entityCube"));
	}

//	Obtenemos processCube
	if (request.getParameter("processCube") != null && !"null".equals(request.getParameter("processCube"))) {
		processCube = "true".equals(request.getParameter("processCube"));
	}

//	Obtenemos envApiaGenCube
	if (request.getParameter("envApiaGenCube") != null && !"null".equals(request.getParameter("envApiaGenCube"))) {
		envApiaGenCube = "true".equals(request.getParameter("envApiaGenCube"));
	}
	
//	Obtenemos allEnvApiaGenCube
	if (request.getParameter("allEnvApiaGenCube") != null && !"null".equals(request.getParameter("allEnvApiaGenCube"))) {
		allEnvApiaGenCube = "true".equals(request.getParameter("allEnvApiaGenCube"));
	}

//	Obtenemos ambiente
	if (request.getParameter("env") != null
		&& !"null".equals(request.getParameter("env"))) {
		env = new Integer(request.getParameter("env"));
	} else {
		env = new Integer(1);
	}
	
	//Verificamos si debemos obtener user y pass de archivo xml
	if (user == null || pass == null){
		if (request.getParameter("logFromFile") != null && ("true".equals(request.getParameter("logFromFile")) || "Y".equals(request.getParameter("logFromFile")))){
			ExternalAccessLoader.load();
			//user = ExternalAccessLoader.getUser(env,entCode,"E");
			//pass = ExternalAccessLoader.getPassword(env,entCode,"E");
		}else{
			//Si estamos aqui es o porque el usuario y pass se sacan de session o se va a abrir la ventana de login 
		}
	}
	
	//Obtenemos logFromSession
	if (request.getParameter("logFromSession") != null){
		logFromSession = new String (request.getParameter("logFromSession"));
	}

	//Obtenemos lenguaje
	if (request.getParameter("lang") != null
			&& !"null".equals(request.getParameter("lang"))) {
		langId = new Integer(request.getParameter("lang"));
	} else {
		langId = Parameters.DEFAULT_LANG;
	}

	//Obtenemos si ya esta logueado (de uso interno)
	if (request.getParameter("logged") != null && !"null".equals(request.getParameter("logged"))) {
		logged = "true".equals(request.getParameter("logged"));
	}
 
	String errorMsg=null;
	UserData udata = (UserData)request.getSession().getAttribute(Parameters.SESSION_ATTRIBUTE);
	if (udata == null){
		udata = new UserData();
		udata.setLangId(langId);
		udata.setLabelSetId(Parameters.DEFAULT_LABEL_SET);
	}
	
	if (request.getParameter("loginError") != null) {
		if (request.getParameter("loginError").equals("1")) {
			//Usuario y/o Password incorrectos
			errorMsg = "NOK-" + LabelManager.getName(udata.getLabelSetId(),langId,"msgLogUseEnvFailed");
	  	} else if (request.getParameter("loginError").equals("2")) {
			//Usuario debe cambiar password.
	 	  	errorMsg = "NOK-" + LabelManager.getName(udata.getLabelSetId(),langId,"msgMustChangePassword");
	 	} else if (request.getParameter("loginError").equals("3")) {
			//Usuario expirado.
			errorMsg = "NOK-" + LabelManager.getName(udata.getLabelSetId(),langId,"msgLogUserExpired");
	  	} else if (request.getParameter("loginError").equals("4")) {
		  	//Usuario bloqueado
 		    errorMsg = "NOK-" + LabelManager.getName(udata.getLabelSetId(),langId,"msgLogUserBlocked");
	  	} else if (request.getParameter("loginError").equals("6")) {
		  	//No hay un usuario en session
		  	errorMsg = "NOK-" + LabelManager.getName(udata.getLabelSetId(),langId,"msgNotUsrInSession");
	  	} 
	} 
	
	if (request.getParameter("serverTest") != null){
		out.clear();
		if (request.getParameter("loginError") == null || (request.getParameter("loginError") != null && request.getParameter("loginError").equals("0"))){
			out.print("OK");
		}else {
			out.print("NOK-" + errorMsg);
		}
	}else if (errorMsg != null){
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="java.util.Enumeration"%><%@page import="com.st.util.StringUtil"%><html><head></head><body onload="init()"><%  out.print("<TEXTAREA id=errorText style='display:none'>"+ errorMsg + "</TEXTAREA>");
			out.print("<SCRIPT language=javascript>");%>
			function init(){
				try{
				window.parent.document.getElementById("iframeMessages").showMessage('<%=errorMsg%>',null);
				}catch(e){alert('<%=errorMsg%>');}
			}
			<% out.print("</SCRIPT>");%></body></html><%}else{
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><style>
.feedBackFrame{
	POSITION: absolute;
	DISPLAY:none;
	WIDTH:350px;
	HEIGHT:200px;
	OVERFLOW:hidden;
	z-index:9999999;
}

</style><title><%=LabelManager.getName(udata.getLabelSetId(),langId,"titApiaUrlEnt")%></title><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js"
	language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js"
	language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/frames/frames.js"
	language="Javascript" defer="true"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/feedBackFrame.js"
	language="Javascript" defer="true"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/modalController.js"
	language="Javascript" defer="true"></script><script language="javascript">
	function sizeContent(){
		document.getElementById("workArea").style.height=getStageHeight()+"px";
	}
	function init(){
		document.getElementById("workArea").src="<%=Parameters.ROOT_PATH%>/login/security.LoginAction.do?action=redirectToBI&origAction=<%=action%>&from=<%=from%>&schemaId=<%=schemaId%>&dshId=<%=dshId%>&cubeId=<%=cubeId%>&viewId=<%=viewId%>&serverTest=<%=serverTest%>&entityCube=<%=entityCube%>&processCube=<%=processCube%>&envApiaGenCube=<%=envApiaGenCube%>&allEnvApiaGenCube=<%=allEnvApiaGenCube%>&txtUser=<%=user%>&txtPwd=<%=pass%>&logFromSession=<%=logFromSession%>&cmbEnv=<%=env%>&hidLangId=<%=langId%>&sessionAtts=<%=sessionAtts%>&logged=<%=logged%>";
		document.getElementById("workArea").style.left="0px";
		document.getElementById("workArea").style.top="0px";
		document.getElementById("iframeMessages").showResultFrame(document.body);	
	}
</script><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/frames.css" rel="styleSheet" type="text/css" media="screen"></head><body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" marginheight="0" marginwidth="0" onload="sizeContent();init();"><iframe name="workArea" id="workArea"
	style="width:100%;height;100%;" scrolling="auto" frameBorder="0">
Su browser no acepta frames. </iframe><iframe name="tocArea" id="tocArea" src="" style="display:none;"
	scrolling="NO" TABINDEX=-1 frameBorder="0"></iframe><iframe name="iframeMessages" id="iframeMessages"
	src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp"
	class="feedBackFrame"
	style="display:none;"
	frameBorder="0"></iframe><iframe name="iframeResult" id="iframeResult" class="feedBackFrame"
	frameBorder="0"
	style="display:none;"></iframe></body></html><script language="javascript">
	if(document.all){
		try{
		sizeContent();
		}catch(e){}
	}
</script><%
}
%>