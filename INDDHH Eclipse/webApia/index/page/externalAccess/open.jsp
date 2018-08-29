<%@page import="com.apia.execution.ExternalService"%><%@include file="../includes/startInc.jsp" %><%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.vo.EnvironmentVo"%><%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.UserData"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.ExternalAccessLoader"%><%

	//  * Abre la ventana de creación de instancias de entidad sin hacer login, ni seleccionar la entidad o proceso asociado
	//	* Parametros requeridos: user, pass, type, entCode
	//	* @param user				user
	//	* @param pass				password
	//  * @param logFromFile 		if (param user is null or param pass is null) and (logFromFile is true or Y), get user and pass from file externalAccessUsers.xml (if null --> false)
	//  * @param logFromSession		if (param user is null or param pass is null) and (logFromFile is false or N or null) and (logFromSession is true or Y), get user and pass from session (if null --> false)
	//  * @param askLogin 			if (param user is null or param pass is null) and (logFromFile is false or N or null) and (logFromSession is false or N or null) and (askLogin is true or Y) the application ask for a user and password. (Default if param user=null, pass=null and logFromFile=false
	//	* @param remoteUser			remote user (user that call the url)
	//	* @param env				environment (if null --> env = 1)
	//	* @param lang				language    (if null or wrong --> lang = 1)
	//	* @param type				type of instance creation ('E' o 'P')
	//	* @param entCode			entity code (asociated to the process in case type = P)
	//	* @param proCode			process code
	//	* @param proCancelCode		process to cancel code
	//  * @param onFinish			action on finish (1:close window (DEFAULT), 2:execute url again, 3:go to splash, 4:close tab)
	//  * @param sessionAtts		atributes and values to store in the http session (usage:  &sessionAtts=name,value,name,value)
	//  * @param eatt_STR|NUM|DTE_<name> atttribute of entity to set value to
	//  * @param patt_STR|NUM|DTE_<name> atttribute of process to set value to
	//	* @param encryptedPass		indicates if password is encrypted 

	// se pueden omitir: [user], [pass], [logFromFile], [logFromSession], [askLogin], [remoteUser], [env], [lang], [onFinish], [sessionAtts], [eatt_STR|NUM|DTE_<name>] y [patt_STR|NUM|DTE_<name>]
	//      ([proCode] y [proCancelCode] si [type] = 'E') y ([proCancelCode] si [proCode] no es de un proceso de cancelación)  

	//Nota: El parámetro de usuario remoto permitirá al desarrollador registrar en el formulario correspondiente, quien ejecutó la url para la creación de la instancia.
	
	//Ejemplos:
		//localhost:8080/Apia2.4/page/externalAccess/open.jsp?user=admin&pass=admin&env=1&type=E&entCode=1021
				
	//http://localhost:8080/ApiaDesarrollo/programs/login/open.jsp?env=1&lang=1&type=E&entCode=1005&onFinish=3		

	//http://localhost:8080/ApiaDesarrollo/programs/login/open.jsp?env=1&lang=1&type=P&entCode=1005&proCode=1018
	//http://localhost:8080/ApiaDesarrollo/programs/login/open.jsp?type=P&entCode=1005&proCode=1018 
	//http://localhost:8080/ApiaDesarrollo/programs/login/open.jsp?logFromSession=true&env=1&lang=1&type=E&entCode=1015&sessionAtts=valor1,3,valor2,5
	//http://localhost:8080/ApiaDesarrollo/programs/login/open.jsp?askLogin=true&env=1&lang=1&type=P&entCode=1005&proCode=1024&proCancelCode=1003&onFinish=1&eatt_STR_NOMBRE=SANTANDER&eatt_NUM_CODIGO=1234&patt_STR_CLIENTE=SHEPARD
	//http://localhost:8080/ApiaDesarrollo/programs/login/open.jsp?env=1&lang=1&type=E&entCode=1005
	//Ejecutar el proceso de cancelacion 1024 para cancelar el proceso 1003:		
	//--> http://localhost:8080/ApiaDesarrollo/programs/login/open.jsp?env=1&lang=1&type=P&entCode=1005&proCode=1024&proCancelCode=1003
	//--> http://localhost:8080/ApiaDesarrollo/programs/login/open.jsp?user=admin&pass=admin&env=1&lang=1&type=P&entCode=1005&proCode=1024&proCancelCode=1003
	//Ejecutar el proceso de alteración 1019 para alterar la entidad 1001:
	//--> http://localhost:8080/ApiaDesarrollo/programs/login/open.jsp?env=1&lang=1&type=P&entCode=1001&&proCode=1019

	String user = null;
	String pass = null;
	String logFromSession = "false"; //por defecto
	Integer env = null;
	Integer langId = null;
	Integer labelSet = Parameters.DEFAULT_LABEL_SET;
	String type = null;
	Integer entCode = null;
	Integer proCode = null;
	Integer proCancelCode = null;
	Integer onFinish = new Integer(1); //por defecto 
	String sessionAtts = null;
	boolean logged = false; //de uso interno
	
	String styleDirectory = "default";
	UserData userData = BasicBeanStatic.getUserDataStatic(request);
	if (userData!=null) {
		styleDirectory = EnvParameters.getEnvParameter(userData.getEnvironmentId(),EnvParameters.ENV_STYLE);
	}
	
	//Obtenemos user de la url
	if (request.getParameter("user") != null) {
		user = new String(request.getParameter("user"));
	}
	
	//Obtenemos pass de la url
	if (request.getParameter("pass") != null) {
		pass = new String(request.getParameter("pass"));
	}
	
	//Obtenemos parametro que indica si el password viene encriptada
	if (request.getParameter("encryptedPass")!=null && "true".equals(request.getParameter("encryptedPass"))){
		pass = ExternalService.decryptApia(request.getParameter("pass"));
	}
	
	//Obtenemos ambiente
	if (request.getParameter("env") != null	&& !"null".equals(request.getParameter("env"))) {
		try{
			env = new Integer(request.getParameter("env"));
		}catch(NumberFormatException e){
			String envName = request.getParameter("env");
			EnvironmentVo eVo = CoreFacade.getInstance().getEnvironment(envName);
			if(eVo!=null){
				env=eVo.getEnvId();
			}else{
				env = new Integer(1);
			}
		}
	} else {
		env = new Integer(1);
	}
	
	//Obtenemos codigoEntidad
	if (request.getParameter("entCode") != null && !"null".equals(request.getParameter("entCode"))) {
		entCode = new Integer(request.getParameter("entCode"));
	}
	//Obtenemos codigoProceso
	if (request.getParameter("proCode") != null && !"null".equals(request.getParameter("proCode"))) {
		proCode = new Integer(request.getParameter("proCode"));
	}
	
	//Verificamos si debemos obtener user y pass de archivo xml
	if (user == null || pass == null){
		if (request.getParameter("logFromFile") != null && ("true".equals(request.getParameter("logFromFile")) || "Y".equals(request.getParameter("logFromFile")))){
			ExternalAccessLoader.load();
			if(proCode!=null){
				user = ExternalAccessLoader.getUser(env,proCode,"P");
				pass = ExternalAccessLoader.getPassword(env,proCode,"P");
			} else {
				user = ExternalAccessLoader.getUser(env,entCode,"E");
				pass = ExternalAccessLoader.getPassword(env,entCode,"E");
			}
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
	//Obtenemos tipo
	if (request.getParameter("type") != null) {
		if (request.getParameter("type").equals("E") || request.getParameter("type").equals("F")) {
			type = new String("F");
		} else if (request.getParameter("type").equals("P")){
			type = new String("P");
		}
	}

	//Obtenemos codigoProceso a cancelar
	if (request.getParameter("proCancelCode") != null
			&& !"null".equals(request.getParameter("proCancelCode"))) {
		proCancelCode = new Integer(request.getParameter("proCancelCode"));
	}
	//Obtenemos acción final
	if (request.getParameter("onFinish") != null && !"null".equals(request.getParameter("onFinish")) && !"".equals(request.getParameter("onFinish"))) {
		onFinish = new Integer(request.getParameter("onFinish"));
	}
	
	//Obtenemos si ya esta logueado (de uso interno)
	if (request.getParameter("logged") != null && !"null".equals(request.getParameter("logged"))) {
		logged = "true".equals(request.getParameter("logged"));
	}
 
	Enumeration attParamsEnum = request.getParameterNames();
	String attParams = null;
	String errorMsg=null;
	if (userData == null){
		userData = new UserData();
		userData.setLangId(langId);
		userData.setLabelSetId(Parameters.DEFAULT_LABEL_SET);
	}
	
	if (request.getParameter("attParams")!=null && !"".equals(request.getParameter("attParams"))){
		attParams = request.getParameter("attParams");
	}else{
		while (attParamsEnum.hasMoreElements()) {
			String paramName = (String)attParamsEnum.nextElement();
			String arr [] = StringUtil.split(paramName,"_");
			if (arr[0].equals("eatt") || arr[0].equals("patt")) {
				String attType = arr[1].toUpperCase();
				if (!"STR".equals(attType) && !"NUM".equals(attType) && !"DTE".equals(attType)){
					errorMsg = LabelManager.getName(userData.getLabelSetId(),langId,"msgWrngAttType");
				}
				if (request.getParameter(paramName) != null && !"null".equals(request.getParameter(paramName))){
					if (attParams == null){
						attParams = paramName + "=" + new String(request.getParameter(paramName));
					}else {
						attParams = attParams + ";" + paramName + "=" + new String(request.getParameter(paramName));
					}
				}
			}
		}
	}
	
	if (request.getParameter("sessionAtts") != null && !"null".equals(request.getParameter("sessionAtts")) && !"".equals(request.getParameter("sessionAtts"))) {
		sessionAtts = request.getParameter("sessionAtts");
		String[] atts = sessionAtts.split(",");
		if(atts.length%2==0){
			for(int i=0;i<atts.length;i=i+2){
				String name= atts[i];
				String value= atts[i+1];
				request.getSession().setAttribute(name,value);
			}
		}else{
			//no es un numero par, entonces falta un valor
			errorMsg = "invalid value for parameter: sessionAtts";
		}
	}
	
	if (request.getParameter("error") != null) {
		if (request.getParameter("error").equals("1")) {
			//Usuario y/o Password incorrectos
			errorMsg = LabelManager.getName(userData.getLabelSetId(),langId,"msgLogUseEnvFailed");
	  } else if (request.getParameter("error").equals("2")) {
			//Usuario debe cambiar password.
	 	  	errorMsg = LabelManager.getName(userData.getLabelSetId(),langId,"msgMustChangePassword");
	  } else if (request.getParameter("error").equals("3")) {
			//Usuario expirado.
			errorMsg = LabelManager.getName(userData.getLabelSetId(),langId,"msgLogUserExpired");
	  } else if (request.getParameter("error").equals("4")) {
		  	//Usuario bloqueado
 		    errorMsg = LabelManager.getName(userData.getLabelSetId(),langId,"msgLogUserBlocked");
	  } else if (request.getParameter("error").equals("5")) {
		  //No hay ninguna tarea libre o adquirida
		  errorMsg = LabelManager.getName(userData.getLabelSetId(),langId,"msgEntIdNotFound");
	  }else if (request.getParameter("error").equals("6")) {
		  //No hay un usuario en session
		  errorMsg = LabelManager.getName(userData.getLabelSetId(),langId,"msgNotUsrInSession");
	  }
	} else if (type == null || (type.equals("F") && (request.getParameter("entCode")==null))){
			errorMsg = LabelManager.getName(userData.getLabelSetId(),langId,"msgMisParTypEntCode");
	} else if ((type == null) || (request.getParameter("entCode") == null)) {
//		Faltan parámetros obligatorios (type y/o entCode)
		errorMsg = LabelManager.getName(userData.getLabelSetId(),langId,"msgMisParTypEntCode");
	} else if ((!type.equals("F")) && (!type.equals("P"))) {
//		Type incorrecto, ingrese 'type=E' o 'type=P
		errorMsg = LabelManager.getName(userData.getLabelSetId(),langId,"msgWrngType");
	}  
	if (errorMsg != null){
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="java.util.Enumeration"%><%@page import="com.st.util.StringUtil"%><html><head><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css"></head><body onload="initPage()"><%  out.print("<TEXTAREA id=errorText style='display:none'>"+ errorMsg + "</TEXTAREA>");
			out.print("<SCRIPT language=javascript>");%>
			function initPage(){
				try{
				window.parent.document.getElementById("iframeMessages").showMessage('<%=errorMsg%>',null);
				}catch(e){alert('<%=errorMsg%>');}
			}
			<% out.print("</SCRIPT>");%></body></html><%}else{%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><%@include file="../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css"><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-more-1.4.0.1-compat.js"></script><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/generics.js"></script><script type="text/javascript">
			function initPage(){
				document.getElementById("workArea").style.height=getStageHeight()+"px";
				<% String tokenId = String.valueOf(System.currentTimeMillis());
				   if (request.getParameter("tokenId")!=null) tokenId = request.getParameter("tokenId");%>
				document.getElementById("workArea").src="<%=Parameters.ROOT_PATH%>/apia.security.LoginAction.run?action=redirect&external=true&txtUser=<%=user%>&txtPwd=<%=pass%>&logFromSession=<%=logFromSession%>&cmbEnv=<%=env%>&hidLangId=<%=langId%>&txtBusEntId=<%=entCode%>&txtBusEntAdm=<%=type%>&txtProId=<%=proCode%>&proInstCancelId=<%=proCancelCode%>&onFinish=<%=onFinish%>&attParams=<%=attParams%>&sessionAtts=<%=sessionAtts%>&logged=<%=logged%>&tokenId=<%=tokenId%>";
				document.getElementById("workArea").style.left="0px";
				document.getElementById("workArea").style.top="0px";
			}
			function showLoading() {
				SYS_PANELS.showLoading();
			}
		</script></head><body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" marginheight="0" marginwidth="0" onload="showLoading();"><iframe name="workArea" id="workArea" style="width:100%;height:100%;" scrolling="auto" frameborder="no" onload="SYS_PANELS.closeAll();"></body></html><%}%>

