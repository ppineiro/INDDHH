<%@page import="com.dogma.controller.ThreadData"%><%@page import="com.apia.execution.ExternalService"%><%@include file="../includes/startInc.jsp" %><%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.vo.EnvironmentVo"%><%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.UserData"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.ExternalAccessLoader"%><%

	String force = request.getParameter("force");
	String ua = request.getHeader("User-Agent").toLowerCase();

	if (!"full".equals(force) && ua.matches("(?i).*((android|bb\\d+|meego).+mobile|avantgo|bada\\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\\.(browser|link)|vodafone|wap|windows ce|xda|xiino).*")||ua.substring(0,4).matches("(?i)1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\\-(n|u)|c55\\/|capi|ccwa|cdm\\-|cell|chtm|cldc|cmd\\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\\-s|devi|dica|dmob|do(c|p)o|ds(12|\\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\\-|_)|g1 u|g560|gene|gf\\-5|g\\-mo|go(\\.w|od)|gr(ad|un)|haie|hcit|hd\\-(m|p|t)|hei\\-|hi(pt|ta)|hp( i|ip)|hs\\-c|ht(c(\\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\\-(20|go|ma)|i230|iac( |\\-|\\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\\/)|klon|kpt |kwc\\-|kyo(c|k)|le(no|xi)|lg( g|\\/(k|l|u)|50|54|\\-[a-w])|libw|lynx|m1\\-w|m3ga|m50\\/|ma(te|ui|xo)|mc(01|21|ca)|m\\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\\-2|po(ck|rt|se)|prox|psio|pt\\-g|qa\\-a|qc(07|12|21|32|60|\\-[2-7]|i\\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\\-|oo|p\\-)|sdk\\/|se(c(\\-|0|1)|47|mc|nd|ri)|sgh\\-|shar|sie(\\-|m)|sk\\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\\-|v\\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\\-|tdg\\-|tel(i|m)|tim\\-|t\\-mo|to(pl|sh)|ts(70|m\\-|m3|m5)|tx\\-9|up(\\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\\-|your|zeto|zte\\-")) {
		session.setAttribute("mobile", "true");
	} else {
		session.removeAttribute("mobile");
	}

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
	//	* @param entInstId			entity instance id
	//	* @param proCode			process code
	//	* @param proCancelCode		process to cancel code
	//  * @param onFinish			action on finish (1:close window (DEFAULT), 2:execute url again, 4:close tab. 5: gotoUrl, 100: customOnFinish)
	//  * @param onFinishURL		url to navigate on finish
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
	String logFromFile = "false"; //por defecto
	Integer env = null;
	Integer langId = null;
	Integer labelSet = Parameters.DEFAULT_LABEL_SET;
	String type = null;
	String entInstId = null;
	Integer entCode = null;
	Integer proCode = null;
	Integer proCancelCode = null;
	Integer onFinish = new Integer(1); //por defecto 
	String onFinishURL = "";
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
	
	
	if (request.getParameter("entInstId") != null && !"null".equals(request.getParameter("entInstId"))) {
		entInstId = request.getParameter("entInstId");
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
	
	if (request.getParameter("logFromFile") != null && ("true".equals(request.getParameter("logFromFile")) || "Y".equals(request.getParameter("logFromFile")))){
		logFromFile = "true";
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
	
	//onFinishURL
	if (request.getParameter("onFinishURL") != null && !"null".equals(request.getParameter("onFinishURL")) && !"".equals(request.getParameter("onFinishURL"))) {
		onFinishURL = request.getParameter("onFinishURL");
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
%><!DOCTYPE html><%@page import="java.util.Enumeration"%><%@page import="com.st.util.StringUtil"%><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><system:util show="baseStyles" /></head><body onload="initPage()"><%  out.print("<TEXTAREA id=errorText style='display:none'>"+ errorMsg + "</TEXTAREA>");
			out.print("<SCRIPT language=javascript>");%>
			function initPage(){
				try{
				window.parent.document.getElementById("iframeMessages").showMessage('<%=errorMsg%>',null);
				}catch(e){alert('<%=errorMsg%>');}
			}
			<% out.print("</SCRIPT>");%></body></html><%}else{%><!DOCTYPE html><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%ThreadData.getUserData().setUserStyle("default");%><%@include file="../includes/headInclude.jsp" %><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-more-1.4.0.1-compat.js"></script><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/generics.js"></script><script type="text/javascript">
			function initPage(){
				document.getElementById("workArea").style.height = (getStageHeight() - 2) + "px";
				<% String tokenId = String.valueOf(System.currentTimeMillis());
				   if (request.getParameter("tokenId")!=null) tokenId = request.getParameter("tokenId");%>
				document.getElementById("workArea").src="<%=Parameters.ROOT_PATH%>/apia.security.LoginAction.run?action=redirect&external=true&txtUser=<%=user%>&txtPwd=<%=pass%>&logFromSession=<%=logFromSession%>&logFromFile=<%=logFromFile%>&cmbEnv=<%=env%>&hidLangId=<%=langId%>&txtBusEntId=<%=entCode%>&txtBusEntAdm=<%=type%>&txtProId=<%=proCode%>&proInstCancelId=<%=proCancelCode%>&onFinish=<%=onFinish%>&attParams=<%=attParams%>&sessionAtts=<%=sessionAtts%>&logged=<%=logged%>&tokenId=<%=tokenId%>&onFinishURL=<%=onFinishURL%>&entInstId=<%=entInstId%>";
				document.getElementById("workArea").style.left="0px";
				document.getElementById("workArea").style.top="0px";
			}
			function showLoading() {
				SYS_PANELS.showLoading();
			}
		</script></head><body style="margin: 0px;" onload="showLoading();" class="no-padding"><iframe title="open" name="workArea" id="workArea" onload="SYS_PANELS.closeAll();" style="width:100%;height:100%;border:0px;" <%= request.getHeader("user-agent").contains("MSIE 8.0") ? "scrolling=\"auto\" frameBorder=0" : ""%>></iframe></body></html><%}%>

