<%@page import="java.util.HashMap"%>
<%@page import="st.constants.Values"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%
String param_stepNum = request.getParameter("stepNum");

Integer stepNum = null;

if(param_stepNum != null && !param_stepNum.isEmpty()){
	stepNum = Integer.valueOf(param_stepNum);
}

if(stepNum != null && stepNum > 0){
	UserData uData = ThreadData.getUserData();
	String key = Values.PBAR_USR_ATTS_STEP_PRE + uData.getTokenId();
	if(uData.getUserAttributes() == null){
		uData.setUserAttributes(new HashMap<String, Object>());
	}
	uData.getUserAttributes().put(key, stepNum);
}
%>