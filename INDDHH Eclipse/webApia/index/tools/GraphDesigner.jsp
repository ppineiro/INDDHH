<%@page import="java.util.ArrayList" %>
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
<%@page import="com.dogma.dataAccess.DogmaDBManager" %>
<%@page import="com.dogma.vo.OperatorVo" %>
<%@page import="com.dogma.vo.PoolVo" %>
<%@page import="com.dogma.vo.ProEleDepInstanceVo" %>
<%@page import="com.dogma.vo.ProEleDependencyVo" %>
<%@page import="com.dogma.vo.ProEleInstanceVo" %>
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
	public GraphDesigner(Integer envId, Integer proInstId) throws Exception {
		this.conn = DogmaDBManager.getConnection();
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
	public String generateGravitzConfigurationFile() throws Exception {
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
		this.conn.close();
	}
}
%>

<% 
Integer envId = null;
Integer proInstId = null;

try { envId = new Integer(request.getParameter("envId")); } catch (Exception e) {}
try { proInstId = new Integer(request.getParameter("proInstId")); } catch (Exception e) {}

GraphDesigner d = null;
if (envId != null && proInstId != null) {
	d = new GraphDesigner(envId, proInstId);
} %>
<%= (d != null)?d.generateGravitzConfigurationFile():"Use: GraphDesigner.jsp?envId=####&proInstId=####" %>
<% if (d != null) { d.close(); }%>