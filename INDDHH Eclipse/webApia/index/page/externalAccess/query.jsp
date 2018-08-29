<%@include file="../includes/startInc.jsp" %><%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@page import="com.apia.execution.ExternalService"%><%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.vo.EnvironmentVo"%><%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@page import="java.util.*"%><%@page import="com.dogma.UserData"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.st.util.StringUtil"%><%@page import="com.dogma.ExternalAccessLoader"%><%
	//  * Ejecuta la query pasada por parametro sin hacer login.
	//	* Parametros requeridos: qryId
	//	* @param user	   				user login
	//	* @param pass	   				user pass
    //  * @param logFromFile 			get user and pass from file externalAccessUsers.xml (if null --> false)
	//  * @param logFromSession			get user and pass from session (if null --> false)
	//	* @param askLogin 			if (param user is null or param pass is null) and (logFromFile is false or N or null) and (logFromSession is false or N or null) and (askLogin is true or Y) the application ask for a user and password. (Default if param user=null, pass=null and logFromFile=false
	//	* @param remoteUser			remote user (user that call the url)
	//	* @param env					environment (if null --> env = 1)
	//	* @param lang					language    (if null or wrong --> lang = 1)
	//  * @param qryId					query Id
	//	* @param onlyGrid  				view only grid (if null --> false)
	//	* @param onlyChart 				view only chart (if null --> false) 
	//  * @param onFinish 				action on finish (1:close window (DEFAULT), 2:go to splash, 4:close tab)
	//  * @param sessionAtts			atributes and values to store in the http session (usage:  &sessionAtts=name,value,name,value)
	//	* @param encryptedPass			indicates if password is encrypted 
	//  * @param filter_<filterName>   	filterValue
	//  * @param filter_<filterName>   	filterValue
	//     .        	 .             			 .
	//     .         	 .             			 .
	

	// se pueden omitir [user], [pass], [logFromFile], [logFromSession], [env], [lang], [onlyGrid], [onlyChart], [onFinish] y los filters

	//Nota: El parámetro de usuario remoto permitirá al desarrollador registrar en el formulario correspondiente, quien ejecutó la url para la creación de la instancia.
	
	//Ejemplos:
		//http://localhost:8080/ApiaDesa/programs/login/query.jsp?qryId=1076 --> Abre la ventana de login (en lenguaje default) y luego ejecuta la query con queryId 1001	
		//http://localhost:8080/ApiaDesa/programs/login/query.jsp?user=admin&pass=adminbi&qryId=1076 --> ejecuta la query con queryId 1001					
		//http://localhost:8080/ApiaDesa/programs/login/query.jsp?user=admin&pass=adminbi&qryId=1076&onlyGrid=true --> ejecuta la query con queryId 1001 y solo muestra la grilla de resultados
		//http://localhost:8080/Apia2.3/programs/login/query.jsp?user=admin&pass=admin&qryId=1142&onlyChart=true --> ejecuta la query con queryId 1001 y solo muestra el grafico
		//http://localhost:8080/Apia2.3/programs/login/query.jsp?qryId=1142&onlyChart=true&logFromSession=true --> usando el usuario actual, ejecuta la query con queryId 1142 y muestra solo el gráfico
		//http://localhost:8080/Apia2.3/programs/login/query.jsp?qryId=1142&onlyChart=true&logFromSession=true&filter_CLIENTE_ID=3 --> usando el usuario actual, ejecuta la query con queryId 1142 y filtro CLIENTE_ID = 3 y muestra solo el gráfico
	
	String user = null;
	String pass = null;
	String logFromSession = "false"; //por defecto
	Integer env = null;
	Integer langId = null;
	Integer qryId = null;
	String onlyGrid = "false";//por defecto
	String onlyChart = "false";//por defecto
	Integer onFinish = new Integer(1); //por defecto 
	String filters = ""; //por defecto
	String sessionAtts = null;
	boolean logged = false; //uso interno
	String errorMsg=null;

	//Obtenemos user
	if (request.getParameter("user") != null) {
		user = new String(request.getParameter("user"));
	}
	
	//Obtenemos pass
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

	//Verificamos si debemos obtener user y pass de archivo xml
	if (user == null || pass == null){ //Obtenemos parametro logFromFile
		//Obtenemos parametro logFromFile
		if(request.getParameter("logFromFile") != null && ("true".equals(request.getParameter("logFromFile"))||"Y".equals(request.getParameter("logFromFile")))){
			ExternalAccessLoader.load();
			//Obtenemos user y pass from file externalAccessUsers.xml
			user = ExternalAccessLoader.getUser(env,null,"Q");
			pass = ExternalAccessLoader.getPassword(env,null,"Q");
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
	
	//Obtenemos numero de instancia de la tarea
	if (request.getParameter("qryId") != null
			&& !"null".equals(request.getParameter("qryId"))) {
		qryId = new Integer(request.getParameter("qryId"));
	}
	
	//Obtenemos onlyGrid
	if (request.getParameter("onlyGrid") != null 
			&& !"null".equals(request.getParameter("onlyGrid"))) {
		onlyGrid = new String(request.getParameter("onlyGrid"));
	}
	
	//Obtenemos onlyChart
	if (request.getParameter("onlyChart") != null 
			&& !"null".equals(request.getParameter("onlyChart"))) {
		onlyChart = new String(request.getParameter("onlyChart"));
	}
		
	//Obtenemos acción final
	if (request.getParameter("onFinish") != null && !"null".equals(request.getParameter("onFinish")) && !"".equals(request.getParameter("onFinish"))) {
		onFinish = new Integer(request.getParameter("onFinish"));
	}
	
	//Obtenemos los filtros
	Enumeration e = request.getParameterNames(); //Obtenemos todos los parametros
	while(e.hasMoreElements())	{ //recorremos todos los parametros
		String s_param = e.nextElement().toString();
		if (s_param.startsWith("filter_")){ //si el parametro comienza con filter_ entonces es un filtro
			//String filterValue = request.getParameter(s_param);
			//filters = filters + "&" + s_param + "="+ filterValue;
			String[] filterValues = request.getParameterValues(s_param);
			for(int i = 0; i < filterValues.length; i++) {
				filters = filters + "&" + s_param + "="+ filterValues[i];
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
	
	UserData udata = BasicBeanStatic.getUserDataStatic(request);
	if (udata == null){
		udata = new UserData();
		udata.setLangId(langId);
		udata.setLabelSetId(Parameters.DEFAULT_LABEL_SET);
		BasicBeanStatic.saveUserDataStatic(request, udata);
//		request.getSession().setAttribute(Parameters.SESSION_ATTRIBUTE,udata);
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
	  }else if (request.getParameter("error").equals("6")) {
		  //No hay un usuario en session
		  errorMsg = LabelManager.getName(udata.getLabelSetId(),langId,"msgNotUsrInSession");
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
			<% out.print("</SCRIPT>");%></body></html><%}else{%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><%@include file="../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css"><script type="text/javascript">
			function init(){
				document.getElementById("workArea").style.height=getStageHeight()+"px";
				<% String tokenId = String.valueOf(System.currentTimeMillis());
				   if (request.getParameter("tokenId")!=null) tokenId = request.getParameter("tokenId");%>
				document.getElementById("workArea").src="<%=Parameters.ROOT_PATH%>/apia.security.LoginAction.run?action=redirectToQuery&external=true&txtUser=<%=user%>&txtPwd=<%=pass%>&logFromSession=<%=logFromSession%>&cmbEnv=<%=env%>&hidLangId=<%=langId%>&query=<%=qryId%>&onlyGrid=<%=onlyGrid%>&onlyChart=<%=onlyChart%>&onFinish=<%=onFinish%><%=filters%>&sessionAtts=<%=sessionAtts%>&logged=<%=logged%>&tokenId=<%=tokenId%>";
				document.getElementById("workArea").style.left="0px";
				document.getElementById("workArea").style.top="0px";
			}
			function showLoading() {
				SYS_PANELS.showLoading();
			}
			function initPage(){}
		</script></head><body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" marginheight="0" marginwidth="0" onload="showLoading();init();"><iframe name="workArea" id="workArea" style="width:100%;height:100%;" scrolling="auto" frameborder="no" onload="SYS_PANELS.closeAll();"></body></html><%}%>

		