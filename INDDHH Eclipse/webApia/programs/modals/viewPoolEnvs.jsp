<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="gBean" scope="session" class="com.dogma.bean.GenericBean"></jsp:useBean><% 
boolean allEnvs = "true".equals(request.getParameter("allEnvs")); 
boolean showOnlyUsr = "true".equals(request.getParameter("showOnlyUsr"));
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,showOnlyUsr?"titUsu":"titAmb")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><BR><%
		if (! showOnlyUsr) { %><div type="grid" id="gridEnvs" style="height:100px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th></tr></thead><tbody><%
			   			Collection c = null;
			   			if (allEnvs) {
			   				c = gBean.getAllEnvs();
			   			} else {
			   				c = gBean.viewPoolEnvs(request);
			   			}
			   			if(c!=null){
			   				Iterator it = c.iterator();
				   			EnvironmentVo envVo = null;
			   				while(it.hasNext()){
			   					envVo = (EnvironmentVo) it.next(); %><TR onclick="loadPoolEnvUsers('<%= envVo.getEnvId() %>',this)"><TD><%= gBean.fmtHTML(envVo.getEnvName()) %></TD></TR><%
			   				}
			   			}
			   			%></tbody></table></div><br><br><%
		} %><div type="grid" id="gridUsers" style="height:100px"><table cellpadding="0" cellspacing="0"><thead><tr><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblUsu")%>"><%=LabelManager.getName(labelSet,"lblUsu")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th></tr></thead><tbody></tbody></table></div></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="rigth"><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCer")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCer")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCer")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnExit_click() {
	window.returnValue=null;
	window.close();
}
var trActual = null;

function loadPoolEnvUsers(envId,oTr){
	if (oTr == null){
		document.getElementById("gridEnvs").selectElement(document.getElementById("gridEnvs").rows[0]);
	}
		
	document.getElementById("gridUsers").clearTable();
	doXMLLoad(envId);
}

function doXMLLoad(envId){
	var sXMLSourceUrl = "viewPoolEnvsXML.jsp?envId=" + envId + "&poolId=<%= request.getParameter("poolId") %>";
	var listener=new Object();
	listener.onLoad=function(xml){
		if (isXMLOk(xml)) {
			readDocXML(xml);
		}
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}

function readDocXML(sXmlResult){
	var xmlRoot=getXMLRoot(sXmlResult);
	if (xmlRoot.nodeName != "EXCEPTION") {
		if (xmlRoot.childNodes.length > 0) {
			for(i=0;i<xmlRoot.childNodes.length;i++){
				xRow = xmlRoot.childNodes[i];
				var oTr = document.createElement("TR");
	
				var oTd0 = document.createElement("TD"); 
				var oTd1 = document.createElement("TD"); 

				oTd0.innerHTML = xRow.childNodes[1].firstChild.nodeValue;
				oTd1.innerHTML= xRow.childNodes[0].firstChild.nodeValue;
				
				oTr.appendChild(oTd0);
				oTr.appendChild(oTd1);
	
				document.getElementById("gridUsers").addRow(oTr);
			}
		}
	}else{
		alert("error occurred");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}

window.onload=function() {
	loadPoolEnvUsers(<%= gBean.getEnvId(request) %>);
}

</script>


