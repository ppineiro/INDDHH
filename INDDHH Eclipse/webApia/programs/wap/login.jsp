<%@page import="com.dogma.Parameters"%><%@page import="com.dogma.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><jsp:useBean id="bLogin" scope="session" class="com.dogma.bean.security.LoginBean"></jsp:useBean><%String agent=request.getHeader("User-Agent");
boolean tables=true;

if(agent.contains("Opera Mini") || agent.contains("MSIE 4.01")){
	tables=false;	
}

Integer langId = Parameters.DEFAULT_LANG;
Integer labelSet = Parameters.DEFAULT_LABEL_SET;
if (request.getParameter("langId") != null && !"null".equals(request.getParameter("langId"))) {
	langId = new Integer(request.getParameter("langId"));
} 

UserData uData = bLogin.getUserData(request);

Collection languages = bLogin.getLabelSetLanguages(labelSet);
if (languages == null || languages.size() == 0) {
	langId = Parameters.DEFAULT_LANG;
} else {
	Iterator iterator = languages.iterator();
	LanguageVo langVo = null;
	while (iterator.hasNext() && langVo == null) {
		langVo = (LanguageVo) iterator.next();
		if (langVo.getLangId().equals(langId)) {
			break;
		} else {
			langVo = null;
		}
	}
	
	if (langVo == null) {
		langId = Parameters.DEFAULT_LANG;
	} else if (uData != null) {
		uData.setLabelSetId(labelSet);
		uData.setLangId(langId);
	}
}
String defaultEnviroment=EnvParameters.getEnvParameter(new Integer(1),EnvParameters.ENV_STYLE);
%><?xml version="1.0"?><!DOCTYPE wml PUBLIC "-//WAPFORUM//DTD WML 1.2//EN" "http://www.wapforum.org/DTD/wml12.dtd"><wml><style>
p{font-size:8pt;}
</style><card title="Login"><p><form action="WapAction.do" name="f"><img style="width:100%" src="<%=Parameters.ROOT_PATH%>/styles/<%=defaultEnviroment%>/images/apiaHeader2.jpg" alt="APIA"/><br/><%if("true".equals(request.getParameter("error"))){%>
					LOGGING ERROR
					</br><%}%><%=LabelManager.getNameWAccess(labelSet,langId,"lblUsu")%>:
				<br/><input type="text" name="txtUser" value="" /><br/><%=LabelManager.getNameWAccess(labelSet,langId,"lblPwd")%>:
				<br/><input type="password" name="txtPwd" value="" /><br/><% Collection col = bLogin.getAllEnvs();
          			if (Parameters.LOGIN_SHOW_ENV_COMBO){
	          			if(col!=null && col.size() == 1) { 
	          				Iterator it = col.iterator();
	          				EnvironmentVo eVo = (EnvironmentVo) it.next(); %><input type="hidden" name="cmbEnv" value="<%= eVo.getEnvId() %>"><%
	          				} else { %><select name="cmbEnv" ><%
		          			if (col != null) {
								Iterator it = col.iterator();
								EnvironmentVo eVo = null;
								while (it.hasNext()) {
									eVo = (EnvironmentVo)it.next();
									%><option value="<%=eVo.getEnvId()%>"><%=bLogin.fmtHTML(eVo.getEnvName())%></option><%
								}
							} %></select><%} 
		          		} else {
	          				if(col!=null && col.size() == 1) { 
	          					Iterator it = col.iterator();
	          					EnvironmentVo eVo = (EnvironmentVo) it.next(); %><input type="hidden" id="cmbEnv" name="cmbEnv" value="<%= eVo.getEnvId() %>"><%
	          					} else { %><input type="text" name="txtEnv" size="15" maxlength="50" accesskey="<%= LabelManager.getAccessKey(labelSet,langId,"lblAmb")%>" <%if(request.getParameter("txtEnv")!=null){ out.print(" value='" + request.getParameter("txtEnv") + "' "); }%>><%}%><%}%><br/><%if(tables){%><anchor>OK
					<go method="post" href="WapAction.do?action=login"><postfield name="txtUser" value="$(txtUser)"/><postfield name="txtPwd" value="$(txtPwd)"/><postfield name="cmbEnv" value="$(cmbEnv)"/></go></anchor><br/><%}else{%><br/><input type="hidden" name="action" value="login"></input><input type="submit" value="OK"></input><br/><%}%><font style="font-size:5pt;"><%=com.dogma.DogmaConstants.COPYRIGHT_NOTICE%></font></form></p></card></wml><%
	int intErrors = 0;
	String errMessage = null;
	if (session.getAttribute("bLogin") != null) {
		DogmaAbstractBean tmpBean;
		tmpBean= (DogmaAbstractBean) session.getAttribute("bLogin");
		String strMessageShow = "";
		if (tmpBean.getMessages() != null) {
			Iterator it = tmpBean.getMessages().iterator();
			while(it.hasNext()){
				ErrMessageVo errMsg = (ErrMessageVo) it.next();
				String strAux = LabelManager.getName(labelSet,langId,errMsg.getMsg());
				strMessageShow += "(*) " + com.st.util.StringUtil.parseMessage(strAux,errMsg.getParams()) + "\n";
			}
			
		} 
		if (tmpBean.getDogmaException() != null) {
			strMessageShow += "Exception Info:" + tmpBean.getDogmaException().getCompleteStackTrace();
			com.dogma.bean.DogmaAbstractBean.logError(request, tmpBean.getDogmaException().getCompleteStackTrace());
		}
		tmpBean.clearMessages();	
		if (!strMessageShow.equals("")) {
			out.print("<TEXTAREA id=errorText style='display:none'>"+ strMessageShow + "</TEXTAREA>");
		}	
	}
%>