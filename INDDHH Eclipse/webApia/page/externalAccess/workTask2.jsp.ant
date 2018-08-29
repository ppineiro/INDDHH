<%@include file="../includes/startInc.jsp" %><%@page import="com.apia.execution.ExternalService"%><%@page import="com.dogma.vo.EnvironmentVo"%><%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.Parameters"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.bean.execution.ListTaskBean"%><%@page import="java.util.*"%><%@page import="com.dogma.UserData"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.st.util.StringUtil"%><%@page import="com.dogma.ExternalAccessLoader"%><%

	String force = request.getParameter("force");
	String ua = request.getHeader("User-Agent").toLowerCase();
	
	if (!"full".equals(force) && ua.matches("(?i).*((android|bb\\d+|meego).+mobile|avantgo|bada\\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\\.(browser|link)|vodafone|wap|windows ce|xda|xiino).*")||ua.substring(0,4).matches("(?i)1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\\-(n|u)|c55\\/|capi|ccwa|cdm\\-|cell|chtm|cldc|cmd\\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\\-s|devi|dica|dmob|do(c|p)o|ds(12|\\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\\-|_)|g1 u|g560|gene|gf\\-5|g\\-mo|go(\\.w|od)|gr(ad|un)|haie|hcit|hd\\-(m|p|t)|hei\\-|hi(pt|ta)|hp( i|ip)|hs\\-c|ht(c(\\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\\-(20|go|ma)|i230|iac( |\\-|\\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\\/)|klon|kpt |kwc\\-|kyo(c|k)|le(no|xi)|lg( g|\\/(k|l|u)|50|54|\\-[a-w])|libw|lynx|m1\\-w|m3ga|m50\\/|ma(te|ui|xo)|mc(01|21|ca)|m\\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\\-2|po(ck|rt|se)|prox|psio|pt\\-g|qa\\-a|qc(07|12|21|32|60|\\-[2-7]|i\\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\\-|oo|p\\-)|sdk\\/|se(c(\\-|0|1)|47|mc|nd|ri)|sgh\\-|shar|sie(\\-|m)|sk\\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\\-|v\\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\\-|tdg\\-|tel(i|m)|tim\\-|t\\-mo|to(pl|sh)|ts(70|m\\-|m3|m5)|tx\\-9|up(\\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\\-|your|zeto|zte\\-")) {
		session.setAttribute("mobile", "true");
	} else {
		session.removeAttribute("mobile");
	}
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
	String logFromFile = "false"; 
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
	
	if (request.getParameter("attParams")!=null && !"".equals(request.getParameter("attParams"))){
		attParams = request.getParameter("attParams");
	}else{
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
%><!DOCTYPE html><%@page import="java.util.Enumeration"%><%@page import="com.st.util.StringUtil"%><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head></head><body onload="init()"><%  out.print("<TEXTAREA id=errorText style='display:none'>"+ errorMsg + "</TEXTAREA>");
			out.print("<SCRIPT language=javascript>");%>
			function init(){
				try{
					window.parent.document.getElementById("iframeMessages").showMessage('<%=errorMsg%>',null);
				}catch(e){alert('<%=errorMsg%>');}
			}
			function initPage() {}
			<% out.print("</SCRIPT>");%></body></html><%}else{%><!DOCTYPE html><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../includes/headInclude.jsp" %><script type="text/javascript">
			function init(){
				document.getElementById("workArea").style.height = (getStageHeight() - 2) + "px";
				<% String tokenId = String.valueOf(System.currentTimeMillis());
				   if (request.getParameter("tokenId")!=null) tokenId = request.getParameter("tokenId");%>
				document.getElementById("workArea").src="<%=Parameters.ROOT_PATH%>/apia.security.LoginAction.run?action=redirectToTask&external=true&txtUser=<%=user%>&txtPwd=<%=pass%>&logFromSession=<%=logFromSession%>&logFromFile=<%=logFromFile%>&cmbEnv=<%=env%>&hidLangId=<%=langId%>&nomTsk=<%=nomTsk%>&numInst=<%=numInst%>&onFinish=<%=onFinish%>&attParams=<%=attParams%>&sessionAtts=<%=sessionAtts%>&logged=<%=logged%>&hiddeEnvSel=<%=hiddeEnvSel%>&tokenId=<%=tokenId%>";
				document.getElementById("workArea").style.left="0px";
				document.getElementById("workArea").style.top="0px";
			}
			function showLoading() {
				SYS_PANELS.showLoading();
			}
			function initPage() {}
		</script></head><body style="margin: 0px;" onload="init();showLoading();" class="no-padding"><iframe title="workTask" name="workArea" id="workArea" onload="SYS_PANELS.closeAll();" style="width:100%;height:100%;border:0px;" <%= request.getHeader("user-agent").contains("MSIE 8.0") ? "scrolling=\"auto\" frameBorder=0" : ""%>></iframe></body></html><%}%>

