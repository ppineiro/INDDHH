<%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%
//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);
String styleDirectory = "default";
boolean envUsesEntities = false;
Integer environmentId = null;
com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	envUsesEntities = uData.isEnvUsesEntities();
	environmentId = uData.getEnvironmentId();
	labelSet = uData.getStrLabelSetId();
	if(uData.getEnvironmentId()!=null){
		styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
	}
}

try {
%>