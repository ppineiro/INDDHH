<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

String defer=(request.getHeader("User-Agent").indexOf("MSIE")>=0)?" defer=\"true\"":"";

//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);
String styleDirectory = "default";
Integer environmentId = null;
String tl_div_height = " style=\"height:300px\" ";
String cmp_div_height= " style=\"height:400px\" ";
String currentLanguage = "";

boolean envUsesEntities = false;
com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	envUsesEntities = uData.isEnvUsesEntities();
	environmentId = uData.getEnvironmentId();
	labelSet = uData.getStrLabelSetId();
	currentLanguage = String.valueOf(uData.getLangId());
	styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
	if (session.getAttribute(com.dogma.DogmaConstants.SESSION_TL_HEIGHT)!=null) {
		tl_div_height = " style=\"height:" + (String)session.getAttribute(com.dogma.DogmaConstants.SESSION_TL_HEIGHT) + "px\" ";
	}
	if (session.getAttribute(com.dogma.DogmaConstants.SESSION_CMP_HEIGHT)!=null) {
		cmp_div_height = " style=\"height:" + (String)session.getAttribute(com.dogma.DogmaConstants.SESSION_CMP_HEIGHT) + "px\" ";
	}
}
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">