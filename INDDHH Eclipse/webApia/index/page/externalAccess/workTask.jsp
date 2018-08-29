<%@include file="../includes/startInc.jsp" %><%@page import="com.apia.execution.ExternalService"%><%@page import="com.dogma.vo.EnvironmentVo"%><%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@page import="java.util.*"%><%@page import="com.dogma.UserData"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.st.util.StringUtil"%><%@page import="com.dogma.ExternalAccessLoader"%><%
	//  * Abre el formulario de la primer tarea de la lista de tareas de un usuario sin hacer login, ni seleccionar la tarea, selecciona la primera, si no hay ninguna en la lista de tareas libres la saca de mis tareas
	//	* @param user				user
	//	* @param pass				password
	//  * @param logFromFile 		if (param user is null or param pass is null) and (logFromFile is true or Y), get user and pass from file externalAccessUsers.xml (if null --> false)
	//  * @param logFromSession		if (param user is null or param pass is null) and (logFromFile is false or N or null) and (logFromSession is true or Y), get user and pass from session (if null --> false)
	//  * @param askLogin 			if (param user is null or param pass is null) and (logFromFile is false or N or null) and (logFromSession is false or N or null) and (askLogin is true or Y) the application ask for a user and password. (Default if param user=null, pass=null and logFromFile=false
	//	* @param remoteUser			remote user (user that call the url)
	//	* @param env	environment (if null --> env = 1)
	//	* @param lang	language    (if null or wrong --> lang = 1)
	//  * @param nomTsk	Task name   (if null take the first one in the list)
    //  * @param numInst Instance number of the process (if null take the first one in the list)
	//  * @param onFinish	action on finish (1:close window (DEFAULT), 2:execute url again, 3:go to splash, 4:closeTab (when is a Apia3.0 call)))
	//  * @param sessionAtts		atributes and values to store in the http session (usage:  &sessionAtts=name,value,name,value)
	//  * @param eatt_typ_nom (TYP could be 'str','num' or 'dte' and NOM the name of the attribute, ex: eatt_num_suc)
	//  * @param patt_typ_nom (TYP could be 'str','num' or 'dte' and NOM the name of the attribute, ex: patt_num_suc)
	//	* @param encryptedPass		indicates if password is encrypted 

	// se pueden omitir [[user], [pass], [logFromFile], [logFromSession], [askLogin], [remoteUser],[env], [lang], [onFinish], [sessionAtts], [nomTsk], [numInst], [nomProc], [eatt_typ_nom]

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
	String nomTsk = null;
	Integer numInst = null;
	Integer onFinish = new Integer(1); //por defecto 
	String sessionAtts = null;
	boolean logged = false; //de uso interno

	String styleDirectory = "default";
	UserData usrData = BasicBeanStatic.getUserDataStatic(request);
	if (usrData!=null) {
		styleDirectory = EnvParameters.getEnvParameter(usrData.getEnvironmentId(),EnvParameters.ENV_STYLE);
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
	
	//Obtenemos nombre de la tarea
	if (request.getParameter("nomTsk") != null
			&& !"null".equals(request.getParameter("nomTsk"))) {
		nomTsk = new String(request.getParameter("nomTsk"));
	}
	
	//Obtenemos numero de instancia de la tarea
	if (request.getParameter("numInst") != null && !"null".equals(request.getParameter("numInst"))) {
		numInst = new Integer(request.getParameter("numInst"));
	}
	
	//Obtenemos acción final
	if (request.getParameter("onFinish") != null && !"null".equals(request.getParameter("onFinish")) && !"".equals(request.getParameter("onFinish"))) {
		onFinish = new Integer(request.getParameter("onFinish"));
	}
	
	//Obtenemos parametro que indica si el password viene encriptada
	if (request.getParameter("encryptedPass")!=null && "true".equals(request.getParameter("encryptedPass"))){
		pass = ExternalService.decryptApia(request.getParameter("pass"));
	}
	
	Enumeration attParamsEnum = request.getParameterNames();
	String attParams = null;
	String errorMsg=null;
	
	if (usrData == null){
		usrData = new UserData();
		usrData.setLangId(langId);
		usrData.setLabelSetId(Parameters.DEFAULT_LABEL_SET);
		BasicBeanStatic.saveUserDataStatic(request, usrData);
//		request.getSession().setAttribute(Parameters.SESSION_ATTRIBUTE,usrData);
	}
	
	while (attParamsEnum.hasMoreElements()) {
		String paramName = (String)attParamsEnum.nextElement();
		String arr [] = StringUtil.split(paramName,"_");
		if (arr[0].equals("eatt") || arr[0].equals("patt")) {
			String attType = arr[1].toUpperCase();
			if (!"STR".equals(attType) && !"NUM".equals(attType) && !"DTE".equals(attType)){
				errorMsg = LabelManager.getName(usrData.getLabelSetId(),langId,"msgWrngAttType");
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
	
	//Obtenemos si ya esta logueado (de uso interno)
	if (request.getParameter("logged") != null && !"null".equals(request.getParameter("logged"))) {
		logged = "true".equals(request.getParameter("logged"));
	}

	if (request.getParameter("error") != null) {
		if (request.getParameter("error").equals("1")) {
			//Usuario y/o Password incorrectos
			errorMsg = LabelManager.getName(usrData.getLabelSetId(),langId,"msgLogUseEnvFailed");
	  } else if (request.getParameter("error").equals("2")) {
			//Usuario debe cambiar password.
	 	  	errorMsg = LabelManager.getName(usrData.getLabelSetId(),langId,"msgMustChangePassword");
	  } else if (request.getParameter("error").equals("3")) {
			//Usuario expirado.
			errorMsg = LabelManager.getName(usrData.getLabelSetId(),langId,"msgLogUserExpired");
	  } else if (request.getParameter("error").equals("4")) {
		  	//Usuario bloqueado
 		    errorMsg = LabelManager.getName(usrData.getLabelSetId(),langId,"msgLogUserBlocked");
	  } else if (request.getParameter("error").equals("5")) {
		  //No hay ninguna tarea libre o adquirida
		  errorMsg = LabelManager.getName(usrData.getLabelSetId(),langId,"msgTskNotAvailable");
	  } else if (request.getParameter("error").equals("6")) {
		  //No hay ninguna tarea libre o adquirida
		  errorMsg = LabelManager.getName(usrData.getLabelSetId(),langId,"msgAttNotInTask");
	  } else if (request.getParameter("error").equals("7")) {
		  //No se encontro la tarea
		  errorMsg = LabelManager.getName(usrData.getLabelSetId(),langId,"msgTskNotExi");
	  }
	} 
	if (errorMsg != null){
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="java.util.Enumeration"%><%@page import="com.st.util.StringUtil"%><html><head></head><body onload="init()"><%  out.print("<TEXTAREA id=errorText style='display:none'>"+ errorMsg + "</TEXTAREA>");
			out.print("<SCRIPT language=javascript>");%>
			function init(){
				try{
					window.parent.document.getElementById("iframeMessages").showMessage('<%=errorMsg%>',null);
				}catch(e){alert('<%=errorMsg%>');}
			}
			function initPage() {}
			<% out.print("</SCRIPT>");%></body></html><%}else{%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><%@include file="../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css"><script type="text/javascript">
			function init(){
				document.getElementById("workArea").style.height=getStageHeight()+"px";
				<% String tokenId = String.valueOf(System.currentTimeMillis());
				   if (request.getParameter("tokenId")!=null) tokenId = request.getParameter("tokenId");%>
				document.getElementById("workArea").src="<%=Parameters.ROOT_PATH%>/apia.security.LoginAction.run?action=redirectToTask&external=true&txtUser=<%=user%>&txtPwd=<%=pass%>&logFromSession=<%=logFromSession%>&cmbEnv=<%=env%>&hidLangId=<%=langId%>&nomTsk=<%=nomTsk%>&numInst=<%=numInst%>&onFinish=<%=onFinish%>&attParams=<%=attParams%>&sessionAtts=<%=sessionAtts%>&logged=<%=logged%>&hiddeEnvSel=<%=hiddeEnvSel%>&tokenId=<%=tokenId%>";
				document.getElementById("workArea").style.left="0px";
				document.getElementById("workArea").style.top="0px";
			}
			function showLoading() {
				SYS_PANELS.showLoading();
			}
			function initPage() {}
		</script></head><body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" marginheight="0" marginwidth="0" onload="init();showLoading();"><iframe name="workArea" id="workArea" style="width:100%;height:100%;" scrolling="auto" frameborder="no" onload="SYS_PANELS.closeAll();"></body></html><%}%>
