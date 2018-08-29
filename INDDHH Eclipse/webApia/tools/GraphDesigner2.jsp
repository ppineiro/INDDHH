<%@page import="java.util.ArrayList" %>
<%@page import="java.util.Collection" %>
<%@page import="java.util.Collection" %>
<%@page import="java.util.HashMap" %>
<%@page import="java.util.Iterator" %>
<%@page import="com.dogma.dao.PoolDAO" %>
<%@page import="com.dogma.dao.ProEleDepInstanceDAO" %>
<%@page import="com.dogma.dao.ProEleDependencyDAO" %>
<%@page import="com.dogma.dao.ProEleInstanceDAO" %>
<%@page import="com.dogma.dao.ProElementDAO" %>
<%@page import="com.dogma.dao.ProcessDAO" %>
<%@page import="com.dogma.dao.RoleDAO" %>
<%@page import="com.dogma.dao.TaskDAO" %>
<%@page import="com.dogma.vo.OperatorVo" %>
<%@page import="com.dogma.vo.PoolVo" %>
<%@page import="com.dogma.vo.ProEleDepInstanceVo" %>
<%@page import="com.dogma.vo.ProEleDependencyVo" %>
<%@page import="com.dogma.vo.ProEleInstanceVo" %>
<%@page import="com.dogma.vo.ProInstanceVo" %>
<%@page import="com.dogma.vo.EnvironmentVo" %>
<%@page import="com.dogma.vo.ProElementVo" %>
<%@page import="com.dogma.vo.ProcessVo" %>
<%@page import="com.dogma.vo.RoleVo" %>
<%@page import="com.dogma.vo.TaskVo" %>
<%@page import="com.st.db.dataAccess.DBConnection" %>

<%!

public class GraphDesigner {

	//--- Private attribtues --------------------
	private Integer envId;
	private Integer proInstId;
	
	private DBConnection conn;
	
	private HashMap proEleInstFathers = new HashMap();
	
	boolean enablePools = true;
	boolean enableRoles = true;
	boolean enableTasks = true;
	boolean enableProcesses = true;
	boolean enableProElements = true;
	boolean enableProEleDependencies = true;
	
	private HashMap pools = new HashMap();
	private HashMap roles = new HashMap();
	private HashMap tasks = new HashMap();
	private HashMap processes = new HashMap();
	private HashMap proElements = new HashMap();
	private HashMap proEleDependencies = new HashMap();
	
	private HashMap proEleInstances = new HashMap();
	private Collection proEleDepInstances = new ArrayList();

	//--- Constructor ---------------------------
	public GraphDesigner() throws Exception {
		this.conn = DBManagerUtil.getApiaConnection();
	}

	public GraphDesigner(Integer envId, Integer proInstId) throws Exception {
		this.conn = DBManagerUtil.getApiaConnection();
		this.envId = envId;
		this.proInstId = proInstId;
	}
	
	//--- Private methods -----------------------
	private TaskVo getTask(Integer tskId) throws Exception {
		TaskVo tskVo = (TaskVo) this.tasks.get(tskId);
		if (this.enableTasks && tskVo == null && tskId != null) {
			tskVo = TaskDAO.getInstance().getTaskVo(this.conn, this.envId, tskId);
			this.tasks.put(tskId,tskVo);
		}
		return tskVo;
	}
	
	private ProcessVo getProcess(Integer proId) throws Exception {
		ProcessVo proVo = (ProcessVo) this.processes.get(proId);
		if (this.enableProcesses && proVo == null && proId != null) {
			proVo = ProcessDAO.getInstance().getProcessById(this.conn, this.envId, proId);
			this.processes.put(proId, proVo);
		}
		return proVo;
	}
	
	private PoolVo getPool(Integer poolId) throws Exception {
		PoolVo poolVo = (PoolVo) this.pools.get(poolId);
		if (this.enablePools && poolVo == null && poolId != null) {
			poolVo = PoolDAO.getInstance().getPoolVo(this.conn, poolId);
			this.pools.put(poolId,poolVo);
		}
		return poolVo;
	}
	
	private RoleVo getRole(Integer roleId) throws Exception {
		RoleVo roleVo = (RoleVo) this.roles.get(roleId);
		if (this.enableRoles && roleVo == null && roleId != null) {
			roleVo = RoleDAO.getInstance().getRoleVo(this.conn, this.envId, roleId);
			this.roles.put(roleId, roleVo);
		}
		return roleVo;
	}
	
	private ProElementVo getProElement(Integer proId, Integer proVerId, Integer proEleId) throws Exception {
		ProElementVo proEleVo = (ProElementVo) this.proElements.get(proEleId);
		if (this.enableProElements && proEleVo == null && proEleId != null) {
			proEleVo = ProElementDAO.getInstance().getProElementVo(this.conn, this.envId, proId, proVerId, proEleId);
			this.proElements.put(proEleId, proEleVo);
		}
		return proEleVo;
	}
	
	private ProEleDependencyVo getProEleDep(Integer proId, Integer proVerId, Integer idFrom, Integer idTo) throws Exception {
		String key = idFrom.toString() + "-" + idTo.toString();
		ProEleDependencyVo proEleDepVo = (ProEleDependencyVo) this.proEleDependencies.get(key);
		if (this.enableProEleDependencies && proEleDepVo == null) {
			proEleDepVo = ProEleDependencyDAO.getInstance().getProEleDependencyVo(this.conn, this.envId, proId, proVerId, idFrom, idTo);
			this.proEleDependencies.put(key,proEleDepVo);
		}
		return proEleDepVo;
	}
	
	private void loadDepInstances() throws Exception {
		this.proEleDepInstances = ProEleDepInstanceDAO.getInstance().getProEleDependencies(this.conn, this.envId, this.proInstId);
	}
	
	private void loadEleInstances() throws Exception {
		Collection instances = ProEleInstanceDAO.getInstance().getProEleInstances(this.conn, this.envId, this.proInstId);
		
		this.proEleInstances = new HashMap();
		for (Iterator it = instances.iterator(); it.hasNext(); ) {
			ProEleInstanceVo proEleInstVo = (ProEleInstanceVo) it.next();
			this.proEleInstances.put(proEleInstVo.getProEleInstId(), proEleInstVo);
			
			if (!this.proEleInstFathers.containsKey(proEleInstVo.getProEleInstFather())) {
				this.proEleInstFathers.put(proEleInstVo.getProEleInstFather(),new ArrayList());
			}
			
			Collection childs = (Collection) this.proEleInstFathers.get(proEleInstVo.getProEleInstFather());
			childs.add(proEleInstVo.getProEleInstId());
		}
	}
	
	private String generateNode(ProEleDepInstanceVo proEleDepInstVo) throws Exception {
		StringBuffer buffer = new StringBuffer();
		String label = proEleDepInstVo.getProEleDepInstStatus(); 
		
		ProEleDependencyVo proEleDepVo = this.getProEleDep(proEleDepInstVo.getProId(),proEleDepInstVo.getProVerId(),proEleDepInstVo.getProEleIdFrom(), proEleDepInstVo.getProEleIdTo());
		if (proEleDepVo != null && proEleDepVo.getProEleDepName() != null) {
			label = "(" + label + ") " + proEleDepVo.getProEleDepName();
		}
		
		buffer.append("[label=\"" + label + "\"");
		if (ProEleDepInstanceVo.DEP_STATUS_EVAL_TRUE.equals(proEleDepInstVo.getProEleDepInstStatus())) buffer.append(",color=red");
		buffer.append("]");
		
		return buffer.toString();
	}

	private String generateNode(ProEleInstanceVo proEleInstVo, ProElementVo proEleVo) throws Exception {
		if (proEleVo == null) return "";
		
		StringBuffer buffer = new StringBuffer();
		buffer.append("[");
		if (proEleVo.getProEleStart() != null) {
			buffer.append("shape=box,color=blue,label=" + proEleInstVo.getProEleInstId());
		} else if (proEleVo.getProEleEnd() != null) {
			buffer.append("shape=box,color=red,label=" + proEleInstVo.getProEleInstId());
		} else if (proEleVo.getOpeId() != null) {
			buffer.append("shape=diamond,color=");
			switch (proEleVo.getOpeId().intValue()) {
				case OperatorVo.OPE_TYPE_AND:
					buffer.append("green");
					break;
				case OperatorVo.OPE_TYPE_OR:
					buffer.append("red");
					break;
				case OperatorVo.OPE_TYPE_XOR:
					buffer.append("yellow");
					break;
			}
			buffer.append(",label=" + proEleInstVo.getProEleInstId());
		} else if (proEleVo.getTskId() != null) {
			TaskVo taskVo = this.getTask(proEleVo.getTskId());
			PoolVo poolVo = this.getPool(proEleInstVo.getPoolId());
			RoleVo roleVo = this.getRole(proEleVo.getRolId());
			String label = "";
			if (taskVo != null) label += taskVo.getTskName();
			if (label.length() > 0 && poolVo != null) label += "\\n";
			if (poolVo != null) label += "Pool: " + poolVo.getPoolName();
			if (label.length() > 0 && poolVo == null && roleVo != null) label += "\\n";
			if (poolVo == null && roleVo != null) label += "Role: " + roleVo.getRolName();
			
			label = "(" + proEleInstVo.getProEleInstId() + ") " + label;
			
			if (ProEleInstanceVo.ELE_STATUS_COMPLETED.equals(proEleInstVo.getProEleInstStatus()) || ProEleInstanceVo.ELE_STATUS_ROLLBACK.equals(proEleInstVo.getProEleInstStatus()) || ProEleInstanceVo.ELE_STATUS_UNDO.equals(proEleInstVo.getProEleInstStatus())) {
				label = "(" + proEleInstVo.getProEleInstStatus() + ") " + label;
			}
			
			buffer.append("shape=box,label=\"" + label + "\"");
		} else { //Subproceso
			ProcessVo proVo = this.getProcess(proEleVo.getProEleProId());
			if (proVo != null) buffer.append("label=\"(" + proEleInstVo.getProEleInstId() + ") (" + proEleVo.getProEleProType() + ") " + proVo.getProName() + "\"");
		}
		
		if (ProEleInstanceVo.ELE_STATUS_COMPLETED.equals(proEleInstVo.getProEleInstStatus()) || ProEleInstanceVo.ELE_STATUS_ROLLBACK.equals(proEleInstVo.getProEleInstStatus()) || ProEleInstanceVo.ELE_STATUS_UNDO.equals(proEleInstVo.getProEleInstStatus())) {
			if (buffer.length() > 1) buffer.append(",");
			buffer.append("style=filled");
		} else if (ProEleInstanceVo.ELE_STATUS_ACQUIRED.equals(proEleInstVo.getProEleInstStatus()) || ProEleInstanceVo.ELE_STATUS_READY.equals(proEleInstVo.getProEleInstStatus())) {
			if (buffer.length() > 1) buffer.append(",");
			buffer.append("style=dotted");
		} else if (ProEleInstanceVo.ELE_STATUS_READY.equals(proEleInstVo.getProEleInstStatus())) {
			if (buffer.length() > 1) buffer.append(",");
			buffer.append("style=bold");
		} else if (ProEleInstanceVo.ELE_STATUS_SKIPPED.equals(proEleInstVo.getProEleInstStatus())) {
			if (buffer.length() > 1) buffer.append(",");
			buffer.append("fontcolor=grey");
		}
		buffer.append("]");
		return buffer.toString();
	}
	
	//--- Public methods ------------------------
	public Collection getEnvironments() throws Exception {
		return EnvironmentDAO.getInstance().getAllEnvs(this.conn);
	}
	
	public Collection getProcesses() throws Exception {
		if (this.envId == null) return null;
		return ProcessDAO.getInstance().getAllProcesses(this.conn, this.envId);
	}
	
	public ProInstanceVo getProInstanceVo(Integer proId, Integer proInstNameNum) throws Exception {
		if (this.envId == null) return null;
		if (proId == null) return null;
		if (proInstNameNum == null) return null;
		
		Integer proVerId = ProcessDAO.getInstance().getLastActiveProVersion(this.conn, this.envId, proId);
		if (proVerId == null) return null;
		
		ProcessVo proVo = ProcessDAO.getInstance().getProcessVo(this.conn, this.envId, proId, proVerId);
		if (proVo == null) return null;
		
		ProInstanceVo proInstVo = ProInstanceDAO.getInstance().getProByDesig(this.conn, this.envId, proVo.getProName(), null, proInstNameNum, null);
		return proInstVo;
	}
	
	public String generateGravitzConfigurationFile() throws Exception {
		if (this.envId == null) return null;
		if (this.proInstId == null) return null;
		
		StringBuffer buffer = new StringBuffer();
		buffer.append("digraph abstract {\r\n");
		buffer.append("Gcharset=latin1\r\n");
		buffer.append("size=\"30,30\"\r\n");
		
		this.loadDepInstances();
		this.loadEleInstances();
		
		//--- Generar la definicion de elementos
		for (Iterator it = this.proEleInstFathers.keySet().iterator(); it.hasNext(); ) {
			Integer parentId = (Integer) it.next();
			Collection childs = (Collection) this.proEleInstFathers.get(parentId);
			
			if (parentId != null) {
				buffer.append("subgraph cluster_" + parentId.toString() + " {\r\n");
			}
			
			for (Iterator itInsts = childs.iterator(); itInsts.hasNext(); ) {
				Integer proEleInstId = (Integer) itInsts.next();
				//if (this.proEleInstFathers.keySet().contains(proEleInstId)) continue;
				
				ProEleInstanceVo proEleInstVo = (ProEleInstanceVo) this.proEleInstances.get(proEleInstId);
				ProElementVo proEleVo = this.getProElement(proEleInstVo.getProId(), proEleInstVo.getProVerId(), proEleInstVo.getProEleId());
				
				buffer.append(proEleInstId);
				buffer.append(this.generateNode(proEleInstVo,proEleVo));
				buffer.append(";\r\n");
			}
			
			if (parentId != null) {
				ProEleInstanceVo proEleInstVo = (ProEleInstanceVo) this.proEleInstances.get(parentId);
				String subProName = parentId.toString();
				ProElementVo proEleVo = this.getProElement(proEleInstVo.getProId(), proEleInstVo.getProVerId(), proEleInstVo.getProEleId());
				if (proEleVo != null) {
					ProcessVo proVo = this.getProcess(proEleVo.getProEleProId());
					if (proVo != null) {
						subProName += " " + proVo.getProName();
					}
				}
				buffer.append("label=\"" + subProName + "\";\r\n");
				buffer.append("}\r\n");
			}
		}
		
		//--- Generar las dependencias
		for (Iterator it = this.proEleDepInstances.iterator(); it.hasNext(); ) {
			ProEleDepInstanceVo proEleDepInstVo = (ProEleDepInstanceVo) it.next();
			buffer.append(proEleDepInstVo.getProEleInstIdFrom());
			buffer.append("->");
			buffer.append(proEleDepInstVo.getProEleInstIdTo());
			buffer.append(this.generateNode(proEleDepInstVo));
			buffer.append(";\r\n");
		}

		buffer.append("}");
		
		return buffer.toString();
	}
	
	public void close() {
		DBManagerUtil.close(this.conn);
	}
	
	//--- Getters and Setters -------------------
	public void setEnvId(Integer envId) { this.envId = envId; }
	public void setProInstId(Integer proInstId) { this.proInstId = proInstId; }
}
%>

<%@page import="com.dogma.dao.EnvironmentDAO"%>
<%@page import="com.dogma.dao.ProInstanceDAO"%>
<%@page import="com.dogma.dataAccess.DBManagerUtil"%><html>
<head>
	<title>GrpahDesigner 2</title>
	<style type="text/css">
		body		{ font-family: verdana; font-size: 10px; }
		td			{ font-family: verdana; font-size: 10px; } 
		th			{ font-family: verdana; font-size: 10px; font-weight: normal;} 
		pre			{ font-family: verdana; font-size: 10px; }
		textarea	{ font-family: verdana; font-size: 10px; }
		input		{ font-family: verdana; font-size: 10px; }
		select		{ font-family: verdana; font-size: 10px; }
		
		table.conns									{ border-width: 0px; background-color: #FFFFFF; }
		table.conns	thead tr th						{ background-color: #EEEEEE; border-width: 1px; border-color: #EEEEEE; border-style: solid; }
		table.conns	thead tr th:hover				{ background-color: #EEEEEE; background-color: #DDDDDD; border-color: #DDDDDD; }
		table.conns	thead tr th.noHover:hover		{ background-color: #EEEEEE; background-color: #EEEEEE; }
		table.conns tbody tr td				 		{ border-color: #FFFFFF; border-style: solid; border-width: thin; padding: 1px; }
		table.conns tbody tr:hover 					{ background-color: #EEEEEE; }
		table.conns tbody tr:hover td				{ border-color: #EEEEEE; border-top-color: #DDDDDD; border-bottom-color: #DDDDDD; }
		table.conns tbody tr:hover td:hover 		{ background-color: #DDDDDD; border-color: #DDDDDD; border-top-color: #DDDDDD; border-bottom-color: #DDDDDD; }
		table.conns tbody tr:hover td.noHover:hover { background-color: #EEEEEE; border-color: #EEEEEE; border-top-color: #DDDDDD; border-bottom-color: #DDDDDD; }
		table.conns tbody tr:hover td.bold			{ font-weight: bold; border-top-color: #DDDDDD; border-bottom-color: #DDDDDD; }
		
		table.sql 									{ border-width: 0px; background-color: #FFFFFF; }
		table.sql thead th							{ border-style: solid; border-color: #000000; border-width: thin; background-color: #DDDDDD; font-weight: bold; text-align: center; }
		table.sql tbody td							{ border-style: solid; border-color: #DDDDDD; border-width: thin; white-space: nowrap; padding-left: 2px; padding-right: 5px; }
		table.sql thead tr th						{ border-style: solid; border-color: #DDDDDD; border-width: thin; }
		table.sql tbody tr:hover 					{ background-color: #DDDDDD; }
		table.sql tbody tr:hover td.noHover:hover	{ background-color: #FFFFFF; border-color: #FFFFFF; }
		table.sql tbody tr td.noHover				{ background-color: #FFFFFF; border-color: #FFFFFF; }
		
		div.code {border-width: 1px; border-color: black; border-style: solid; padding: 5px; }
		
		a			{ text-decoration: none; color: blue; }
	</style>
</head>
<%
Boolean logged = (Boolean) request.getSession().getAttribute("logged");

if (logged == null) logged = new Boolean(false);
if (request.getParameter("logout") != null) logged = new Boolean(false);

if (! logged.booleanValue()) {
	String user = request.getParameter("user");
	String pwd = request.getParameter("pwd");
	
	logged = new Boolean("admin".equals(user) && "admin22".equals(pwd));
	request.getSession().setAttribute("logged",logged);
}
%>
<body>

<%
if (logged.booleanValue()) {
	Integer envId = null;
	Integer proId = null;
	Integer proInstNameNum = null;

	String doGraph = request.getParameter("doGraph");
	
	try { envId = new Integer(request.getParameter("envId")); } catch (Exception e) {}
	try { proId = new Integer(request.getParameter("proId")); } catch (Exception e) {}
	try { proInstNameNum = new Integer(request.getParameter("proInstNameNum")); } catch (Exception e) {}

	GraphDesigner d = new GraphDesigner();
	d.setEnvId(envId);
	
	Collection environments = d.getEnvironments();
	Collection processes = d.getProcesses();
	ProInstanceVo proInstVo = d.getProInstanceVo(proId, proInstNameNum); 
	
	if (proInstVo != null) d.setProInstId(proInstVo.getProInstId());
	
	%>
	
	<form action="" method="post" id="frmAction">
		<b>Required information</b><br>
		Environment: <select name="envId" <%= (envId != null) ? "onchange=\"document.getElementById('btnShowProcesses').click(); \"" : "" %>>
			<option value=""></option>
			<% if (environments != null) {
				for (Iterator it = environments.iterator(); it.hasNext(); ) {
					EnvironmentVo envVo = (EnvironmentVo) it.next();
					if (envVo.getRegStatus().intValue() == 1) continue;
					boolean selected = envId != null && envId.equals(envVo.getEnvId()); %>
					<option value="<%= envVo.getEnvId() %>" <%= selected ? "selected" : "" %>><%= envVo.getEnvName() %></option><%
				}
			} %>
		</select> <input type="submit" id="btnShowProcesses" value="Show processes"><br>
		<% if (envId != null) { %>
			<br>
			Process: <select name="proId">
				<option value=""></option>
				<% if (processes != null) {
					for (Iterator it = processes.iterator(); it.hasNext(); ) {
						ProcessVo proVo = (ProcessVo) it.next();
						if (proVo.getRegStatus().intValue() == 1) continue;
						boolean selected = proId != null && proId.equals(proVo.getProId()); %>
						<option value="<%= proVo.getProId() %>" <%= selected ? "selected" : "" %>><%= proVo.getProName() %></option><%
					}
				} %>
			</select><br>
			Instance number: <input type="text" name="proInstNameNum" value="<%= (proInstNameNum ==null) ? "" : proInstNameNum.toString() %>"></input>
			<input type="submit" value="Check process instance"><br>

			<% if (proInstVo != null) { %>
				<br><b>Process instance found</b><br>
				User created: <%= proInstVo.getProInstCreateUser() %><br>
				Date created: <%= proInstVo.getProInstCreateDate() %><br>
				Status: <%= proInstVo.getProInstStatus() %><br>	
				Confirm graph creation: <input type="checkbox" value="true" name="doGraph"><input type="submit" value="Create">
			<% } %>
		<% } %>
	</form>
	<%
	if (proInstVo != null && doGraph != null && doGraph.equals("true")) {
		String graph = d.generateGravitzConfigurationFile();
		if (graph != null) { %>
			<div class="code"><pre><%= graph %></pre></div>
			Send previous information to support.<%
		}
	}
	d.close(); 
} else { %>
	<form action="" method="post">
		<b>Login is require to continue</b><br>
		User: <input type="text" name="user"><br>
		Password: <input type="password" name="pwd"><br>
		<input type="submit" value="Login">
	</form>
<% } %>

</body>
</html>
