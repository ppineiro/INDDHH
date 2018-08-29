<%!


public java.util.Collection getEnvironments(com.dogma.bean.security.LoginBean bLogin) {
	java.util.Collection aux = bLogin.getAllEnvs();
	java.util.Collection result = null;
	
	if (aux != null) {
		result = new java.util.ArrayList(aux.size());
		for (java.util.Iterator it = aux.iterator(); it.hasNext(); ) {
			com.dogma.vo.EnvironmentVo vo = (com.dogma.vo.EnvironmentVo) it.next();
			result.add(new Environment(vo.getEnvId(), vo.getEnvName()));
		}
	}
	
	return result;
}

public static class Environment {
	
	public Integer id;
	public String name;
	
	public Environment(Integer id, String name) {
		this.id = id;
		this.name = name;
	}
}

public boolean containsForbiden(String envName){
	if(com.dogma.Configuration.FORBIDDEN_ENVIRONMENTS!=null){
		for(int i=0;i<com.dogma.Configuration.FORBIDDEN_ENVIRONMENTS.length;i++){
			if(envName.equalsIgnoreCase(com.dogma.Configuration.FORBIDDEN_ENVIRONMENTS[i])){
				return true;
			}
		}
	}
	return false;
}

%><%
boolean forceEnvironment = request.getParameter("envId")!=null;
boolean userCanSelectEnvironment = com.dogma.Parameters.LOGIN_SHOW_ENV_COMBO;
boolean hiddeSelectedEnvironment = request.getParameter("hiddeEnvSel") != null && "true".equals(request.getParameter("hiddeEnvSel"));

String forcedEnvironment = forceEnvironment ? null : request.getParameter("envId");
String selectedEnvironmentId = request.getParameter("cmbEnv");
String selectedEnvironmentName = request.getParameter("txtEnv");
java.util.Collection allEnvironments = (!forceEnvironment && userCanSelectEnvironment) ? this.getEnvironments(bLogin) : null;
%>