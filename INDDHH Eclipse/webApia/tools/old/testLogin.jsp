<%@page import="com.dogma.DogmaConstants"%><%@page import="com.dogma.business.LogAccess"%><%@page import="java.util.Set"%><%@page import="com.dogma.UserData"%><%@page import="com.dogma.vo.UserVo"%><%@page import="biz.statum.sdk.util.StringUtil"%><%@page import="com.dogma.vo.EnvironmentVo"%><%@page import="com.dogma.DogmaException"%><%@page import="com.apia.core.CoreFacade"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.bean.security.LoginBean"%><%@page import="com.dogma.InactivityPeriod"%><html><head><title>Login testing</title><style type="text/css">
		body		{ font-family: verdana; font-size: 10px; }
		td			{ font-family: verdana; font-size: 10px; } 
		th			{ font-family: verdana; font-size: 10px; font-weight: normal;} 
		pre			{ font-family: verdana; font-size: 10px; }
		textarea	{ font-family: verdana; font-size: 10px; }
		input		{ font-family: verdana; font-size: 10px; }
		select		{ font-family: verdana; font-size: 10px; }
	</style></head><body><%!

public String getParStr(HttpServletRequest req, String name) {
	if (req.getParameter(name)!=null) {
		return req.getParameter(name).equals("")?null:req.getParameter(name);
	}
	return null;
}

public Object[] testLogin(HttpServletRequest request) throws Exception {
		int resultLogin = -99;
		String resultMessage = null;

		if(!InactivityPeriod.isActive()){
			resultMessage = "msgInactivityPeriod";
			resultLogin = LoginBean.LOGIN_ERROR;
		}
		
		
		String userFullId	= request.getParameter("txtUser");
		String userId 		= request.getParameter("txtUser");
		String userPwd 		= request.getParameter("txtPwd");
		String langId 		= null;
		
		if (Parameters.AUTHENTICATION_METHOD.equals(Parameters.AUTHENTICATION_EXT) && userFullId != null && userFullId.length() > 0 && userFullId.indexOf("@") != -1) {
			userId = userFullId.substring(0, userFullId.indexOf("@"));
		}
		
		Integer envId = null;
		
		if (getParStr(request,"cmbEnv") != null) {
			envId 	= Integer.valueOf(request.getParameter("cmbEnv"));
		} else if (getParStr(request,"txtEnv") != null){
			EnvironmentVo envVo = CoreFacade.getInstance().getEnvironment(getParStr(request,"txtEnv").toUpperCase());
			if (envVo != null) {
				envId = envVo.getEnvId();
			} else {
				resultMessage = DogmaException.SEC_LOGIN_USER_ENVIRONMENT_FAILED;
				resultLogin = LoginBean.LOGIN_ERROR;
			}
		}
		
		if(langId==null || langId.length() == 0) {
		    langId = Parameters.DEFAULT_LANG.toString();
		}
		
		//-------------------------------------------------
		
		if (userId != null) {
			userId = userId.toLowerCase();
		} else {
			userId = "";
		}
		
		//CHECK IF THE USER BELONGS TO THE ENVIRONMENT
		if (!CoreFacade.getInstance().checkUserEnv(userId,envId)) { 
			resultMessage = DogmaException.SEC_LOGIN_USER_ENVIRONMENT_FAILED;
			resultLogin = LoginBean.LOGIN_ERROR;
		}

		//SET USER DATA
		String dbUserId = StringUtil.sizeLimite(userId, 20, false);
		UserVo usrVo = CoreFacade.getInstance().getUser(dbUserId);
		
		if (usrVo == null) {
			resultLogin = LoginBean.LOGIN_ERROR;
			resultMessage = "errUsrNotInDatabase";
			return new Object[] {Integer.valueOf(resultLogin), resultMessage};
		}
		
		UserData uData = new UserData();
		uData.setUserId(dbUserId);
		uData.setUserFullId(userFullId);
		uData.setUserName(usrVo.getUsrName());
		uData.setEnvironmentId(envId);
		uData.setRemoteIp(request.getRemoteAddr());
		uData.setLocalAddr(request.getLocalAddr());
		uData.setLocalPort(request.getLocalPort());
		uData.setContextPath(request.getContextPath());
		uData.setSession(request.getSession());
		uData.setUserStyle(usrVo.getUsrStyle());
		uData.setPools(null);
		uData.setUserAgent(request.getHeader("user-agent"));
		
		//UserVo uVo = CoreFacade.getInstance().getUser(dbUserId);
		
		///TODO: en algun momento cambiar para que sea un campo propio del usuario.
		uData.setDigitalCertificateUserKey(usrVo.getUsrComments());
		
		//GET THE LABEL SET OF THE ENVIRONMENT AND LANGUAGE
		CoreFacade.getInstance().setEnvLabelSet(uData,Integer.valueOf(langId));
		
		//LOW Funcionalidades que no están en la lista de funcionalidades, y que el usuario debe poder acceder
		Set<String> actionsAllow = CoreFacade.getInstance().getActionsAllow(uData);
		actionsAllow.add("security.LoginAction");
		actionsAllow.add("DocumentAction");
		actionsAllow.add("execution.FormAction");
		actionsAllow.add("execution.TaskAction");
		actionsAllow.add("execution.NotificationAction");
		
		synchronized (request.getSession().getId()){
			uData.setActionsAllow(actionsAllow);
		}
		 
		
		//CHECK IF THE USER / PWD IS OK
		int res = CoreFacade.getInstance().doLogin(request, dbUserId, userFullId, userPwd);
		if (res == 1) {
			resultMessage = DogmaException.SEC_LOGIN_FAILED;
			resultLogin = LoginBean.LOGIN_ERROR;
		} else if (res ==2) {
			
			LogAccess la = new LogAccess(request.getServerName(), request.getServerPort());
			la.setUsrId(dbUserId);
			
			String candidateId = "";
			la.setCandidateId(candidateId);
			
		    //must change password
			resultLogin = LoginBean.LOGIN_CHANGE_PWD;
		} else if (res == 3){ //user expired
			resultMessage = DogmaException.SEC_LOGIN_USER_EXPIRED;
			resultLogin = LoginBean.LOGIN_USER_EXPIRED;
		} else if (res == 4) {
			
			if(usrVo!=null && usrVo.getUsrBlockDesc()!=null && usrVo.getUsrBlockDesc().length()>0){
				resultMessage = usrVo.getUsrBlockDesc();	
			} else{
				resultMessage = DogmaException.SEC_LOGIN_USER_BLOCKED;
			}
			resultLogin = LoginBean.LOGIN_USER_BLOCKED;
		}
		
		LogAccess la = new LogAccess(request.getServerName(), request.getServerPort());
		la.setUsrId(dbUserId);
	
		String candidateId = "";
		la.setCandidateId(candidateId);
		
		//UserService.getInstance().validateAutogeneratedPool(userId,uData);
		CoreFacade.getInstance().validateAutogeneratedPool(dbUserId, uData);
		
		uData.setPools(CoreFacade.getInstance().getUserEnvGlobalPools(uData.getUserId(), uData.getEnvironmentId(), uData));
		
		resultLogin = LoginBean.LOGIN_OK;
		
		return new Object[] {Integer.valueOf(resultLogin), resultMessage};
}
%><%

Object paramLogged = request.getSession().getAttribute("logged");
Boolean logged = null;
if (paramLogged instanceof Boolean) logged = (Boolean) paramLogged;

if (logged == null) logged = new Boolean(false);
if (request.getParameter("logout") != null) logged = new Boolean(false);

if (! logged.booleanValue()) {
	String user = request.getParameter("user");
	String pwd = request.getParameter("pwd");
	
	logged = new Boolean("admin".equals(user) && "admin22".equals(pwd));
	request.getSession().setAttribute("logged",logged);
}

if (logged == null || ! logged.booleanValue()) { %><form action="" method="post"><b>Login is require to continue</b><br>
		User: <input type="text" name="user"><br>
		Password: <input type="password" name="pwd"><br><input type="submit" value="Login"></form><%} else { %><form action="" method="post"><b>Test login for user</b><br>
		User: <input type="text" name="txtUser"><br>
		Password: <input type="password" name="txtPwd"><br>
		Environment: <input type="text" name="txtEnv"><br><input type="submit" value="Test login"></form><hr><%
	
	try {%><b>Testing login for user...</b><br><%
		Object[] result = this.testLogin(request);
		if (result == null) {
			%>No result return<%
		} else {
			%>Code: <%= result[0] %><br>
			Message: <%= result[1] %><%
		}
	} catch (Exception e) { %><b>Error found while testing:</b><br><%= StringUtil.toString(e, true) %><%
	}
}%><hr><b>Result codes</b>
	LOGIN_OK = 0<br>
	LOGIN_ERROR = 1<br>
	LOGIN_CHANGE_PWD = 2<br>
	LOGIN_USER_EXPIRED = 3<br>
	LOGIN_USER_BLOCKED = 4

</body></html>