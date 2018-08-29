<%@page import="com.apia.execution.ExternalService"%><%@page import="com.dogma.vo.EnvironmentVo"%><%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.vo.EnvironmentVo"%><%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@page import="java.util.*"%><%@page import="com.dogma.UserData"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.st.util.StringUtil"%><%@page import="com.dogma.ExternalAccessLoader"%><%
	//  * Abre el formulario de la primer tarea de la lista de tareas de un usuario sin hacer login, ni seleccionar la tarea, selecciona la primera, si no hay ninguna en la lista de tareas libres la saca de mis tareas
	//	* @param user				user
	//	* @param pass				password
	//  * @param logFromFile 		if (param user is null or param pass is null) and (logFromFile is true or Y), get user and pass from file externalAccessUsers.xml (if null --> false)
	//  * @param logFromSession		if (param user is null or param pass is null) and (logFromFile is false or N or null) and (logFromSession is true or Y), get user and pass from session (if null --> false)
	//  * @param askLogin 			if (param user is null or param pass is null) and (logFromFile is false or N or null) and (logFromSession is false or N or null) and (askLogin is true or Y) the application ask for a user and password. (Default if param user=null, pass=null and logFromFile=false
	//	* @param remoteUser			remote user (user that call the url)
	//	* @param env	environment (if null --> env = 1)
	//	* @param lang	language    (if null or wrong --> lang = 1)
	//	* @param encryptedPass		indicates if password is encrypted 

	// se pueden omitir [[user], [pass], [logFromFile], [logFromSession], [askLogin], [remoteUser],[env], [lang]

	//Ejemplos:
	//http://localhost:8080/ApiaDesarrollo/programs/login/workTask.jsp --> Abre la ventana de login (en lenguaje default) y luego captura la primer tarea de la lista de tareas libres o de las capturadas si no hay ninguna en las libres, al terminar cierra la ventana
	//http://localhost:8080/ApiaDesarrollo/programs/login/workTask.jsp?user=admin&pass=admin  --> Captura la primer tarea de la lista de tareas libres o de las capturadas si no hay ninguna en las libres
	//http://localhost:8080/ApiaDesarrollo/programs/login/workTask.jsp?user=admin&pass=admin&env=1&lang=2&onFinish=3 -->Idem anterior pero en portugues
	//http://localhost:8080/ApiaDesarrollo/programs/login/workTask.jsp?user=admin&pass=admin&nomTsk=TAREA_SUB_UNO --> Captura la primer tarea de nombre TAREA_SUB_UNO
	//http://localhost:8080/ApiaDesarrollo/programs/login/workTask.jsp?user=admin&pass=admin&nomTsk=TAREA_SUB_UNO&numInst=11 --> Captura la tarea TAREA_SUB_UNO cuyo numero de instancia es 11

//http://localhost:8080/Apia164Estable/programs/login/workTask.jsp?user=admin&pass=admin&nomTsk=TAREA2&eatt_num_att_ent=1234			
//http://localhost:8080/Apia164Estable/programs/login/workTask.jsp?user=admin&pass=admin&nomTsk=TAREA2&eatt_num_att_ent=1234&eatt_str_att_ent2=casa
//http://localhost:8080/Apia164Estable/programs/login/workTask.jsp?user=admin&pass=admin&nomTsk=TAREA2&eatt_num_att_ent=1234&patt_str_att_proc=casa
//http://localhost:8080/Apia164Estable/programs/login/workTask.jsp?user=admin&pass=admin&nomTsk=TAREA2&eatt_num_att_ent=1234&eatt_str_att_ent2=casaent&patt_str_att_proc=casaproc		
//http://localhost:8080/Apia164Estable/programs/login/workTask.jsp?user=admin&pass=admin&nomTsk=TAREA2&eatt_num_att_ent=1234&eatt_str_att_ent2=casaent&patt_str_att_proc=casaproc&onFinish=2		
//http://localhost:8080/Apia164Estable/programs/login/workTask.jsp?user=admin&pass=admin&env=1&lang=1&nomTsk=TAREA2&numInst=null&onFinish=2&eatt_dte_fecha=05/12/2008		
			
	String user = null;
	String pass = null;
	String logFromSession = "false"; //por defecto
	Integer env = null;
	boolean hiddeEnvSel = true;
	Integer langId = null;
	Integer labelSet = Parameters.DEFAULT_LABEL_SET;
	boolean logged = false; //de uso interno

	String styleDirectory = "default";
	com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
	if (uData!=null) {
		styleDirectory = EnvParameters.getEnvParameter(uData.getEnvironmentId(),EnvParameters.ENV_STYLE);
	}
	
//	Obtenemos user
	if (request.getParameter("user") != null) {
		user = new String(request.getParameter("user"));
	}
	
	//Obtenemos pass
	if (request.getParameter("pass") != null) {
		pass = new String(request.getParameter("pass"));
	}

	//Obtenemos ambiente, se necesita más adelante.
	if (request.getParameter("env") != null && !"null".equals(request.getParameter("env"))) {
		try{
			env = new Integer(request.getParameter("env"));
		}catch(NumberFormatException e){
			String envName = request.getParameter("env");
			EnvironmentVo eVo = CoreFacade.getInstance().getEnvironment(envName);
			if(eVo!=null){
				env=eVo.getEnvId();
			}else{
				env = new Integer(1);
				hiddeEnvSel = false;
			}
		}
	} else {
		env = new Integer(1);
		hiddeEnvSel = false;
	}

	//Verificamos si debemos obtener user y pass de archivo xml
	if (user == null || pass == null){ //Obtenemos parametro logFromFile
		//Obtenemos parametro logFromFile
		if(request.getParameter("logFromFile") != null && ("true".equals(request.getParameter("logFromFile"))||"Y".equals(request.getParameter("logFromFile")))){
			ExternalAccessLoader.load();
			//Obtenemos user y pass from file externalAccessUsers.xml
			user = ExternalAccessLoader.getUser(env,null,"W");
			pass = ExternalAccessLoader.getPassword(env,null,"W");
		}
	}

	//Obtenemos parametro logFromSession
	if (request.getParameter("logFromSession") != null) {
		logFromSession = new String(request.getParameter("logFromSession"));
	}

	//Obtenemos lenguaje
	if (request.getParameter("lang") != null
			&& !"null".equals(request.getParameter("lang"))) {
		langId = new Integer(request.getParameter("lang"));
	} else {
		langId = Parameters.DEFAULT_LANG;
	}
	
	
	//Obtenemos parametro que indica si el password viene encriptada
	if (request.getParameter("encryptedPass")!=null && "true".equals(request.getParameter("encryptedPass"))){
		pass = ExternalService.decryptApia(request.getParameter("pass"));
	}
	
	Enumeration attParamsEnum = request.getParameterNames();
	String attParams = null;
	String errorMsg=null;
	
	UserData udata = (UserData)request.getSession().getAttribute(Parameters.SESSION_ATTRIBUTE);
	if (udata == null){
		udata = new UserData();
		udata.setLangId(langId);
		udata.setLabelSetId(Parameters.DEFAULT_LABEL_SET);
		request.getSession().setAttribute(Parameters.SESSION_ATTRIBUTE,udata);
	}
	
	
	//Obtenemos si ya esta logueado (de uso interno)
	if (request.getParameter("logged") != null && !"null".equals(request.getParameter("logged"))) {
		logged = "true".equals(request.getParameter("logged"));
	}

	if (request.getParameter("error") != null) {
		if (request.getParameter("error").equals("1")) {
			//Usuario y/o Password incorrectos
			errorMsg = LabelManager.getName(udata.getLabelSetId(),langId,"msgLogUseEnvFailed");
	  } else if (request.getParameter("error").equals("2")) {
			//Usuario debe cambiar password.
	 	  	errorMsg = LabelManager.getName(udata.getLabelSetId(),langId,"msgMustChangePassword");
	  } else if (request.getParameter("error").equals("3")) {
			//Usuario expirado.
			errorMsg = LabelManager.getName(udata.getLabelSetId(),langId,"msgLogUserExpired");
	  } else if (request.getParameter("error").equals("4")) {
		  	//Usuario bloqueado
 		    errorMsg = LabelManager.getName(udata.getLabelSetId(),langId,"msgLogUserBlocked");
	  }
	} 
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="com.dogma.EnvParameters"%><html><head><style>
.feedBackFrame{
	POSITION: absolute;
	DISPLAY:none;
	WIDTH:350px;
	HEIGHT:200px;
	OVERFLOW:hidden;
	z-index:99999999;
}

</style><title><%=LabelManager.getName(udata.getLabelSetId(),langId,"titApiaUrlTsk")%></title><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js"
	language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js"
	language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/frames/frames.js"
	language="Javascript" defer="true"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/feedBackFrame.js"
	language="Javascript" defer="true"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/modalController.js"
	language="Javascript" defer="true"></script><script language="javascript">
	function sizeContent(){
		document.getElementById("workArea").style.height=getStageHeight()+"px";
	}
	function init(){
		<%if (errorMsg != null){%>
		window.parent.document.getElementById("iframeMessages").showMessage('<%=errorMsg%>',null);
		<%}else{%>
		document.getElementById("workArea").src="<%=Parameters.ROOT_PATH%>/login/security.LoginAction.do?action=redirectToFormDesign&txtUser=<%=user%>&txtPwd=<%=pass%>&logFromSession=<%=logFromSession%>&cmbEnv=<%=env%>&hidLangId=<%=langId%>&logged=<%=logged%>&hiddeEnvSel=<%=hiddeEnvSel%>";
		<%}%>
		document.getElementById("workArea").style.left="0px";
		document.getElementById("workArea").style.top="0px";
		
		addListener(window,"unload",killSession);
	}
	function killSession(){
		sendVars("security.LoginAction.do?action=logout","");
	}
</script><script type="text/javascript">
	function showLoading() {
		document.getElementById("iframeMessages").showWaitMsg();
		document.getElementById("iframeMessages").style.display = "block";
	}
</script><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/frames.css" rel="styleSheet" type="text/css" media="screen"></head><body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" marginheight="0" marginwidth="0" onload="sizeContent();init();showLoading();"><iframe name="workArea" id="workArea"
	style="width:100%;height;100%;" height="100%" scrolling="auto" frameborder="no">
Su browser no acepta frames. </iframe><iframe name="tocArea" id="tocArea" src="" style="display:none;"
	scrolling="NO" TABINDEX=-1 FRAMEBORDER=0></iframe><iframe name="iframeMessages" id="iframeMessages"
	src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp"
	class="feedBackFrame"
	style="display:none;"
	frameborder="no"></iframe><iframe name="iframeResult" id="iframeResult" class="feedBackFrame"
	frameborder="no"
	style="display:none;"></iframe></body></html><script language="javascript">
	if(document.all){
		sizeContent();
	}
</script>
