<%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.DocumentBean"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.bean.execution.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><%! private DogmaAbstractBean gBean = null; %><%
String windowID = request.getParameter("windowId");
HashMap beansHash = null;
//obtener el hash de beans
if(windowID!=null){
	if(request.getSession().getAttribute("beansHash")!=null){
		beansHash = (HashMap)request.getSession().getAttribute("beansHash");
	} 
}
if(windowID!=null){
	gBean = (DogmaAbstractBean)beansHash.get(windowID); 
}else if (request.getSession().getAttribute("dBean") instanceof TaskBean) {
	gBean = (DogmaAbstractBean) request.getSession().getAttribute("dBean");
}else if (request.getSession().getAttribute("dBean") instanceof EntInstanceBean) {
	gBean = (DogmaAbstractBean) request.getSession().getAttribute("dBean");
}

 

EntInstanceBean eBean = null;
TaskBean tBean = null;


if (gBean instanceof EntInstanceBean) {
	eBean = (EntInstanceBean) gBean;
}
if (gBean instanceof TaskBean) {
	tBean = (TaskBean) gBean;
}

Collection docst = null;
Collection docse = null;
Collection docsEnv = null;
boolean areDocs = false;

%><%! 
private String processCollection(Collection docs) {
	if (docs != null) {
		Iterator iterator = docs.iterator();
		StringBuffer buffer = new StringBuffer();
		while (iterator.hasNext()) {
			DocumentVo docVo = (DocumentVo) iterator.next();
			buffer.append("<li>");
			buffer.append("<A href='#nowhere' onclick=\"downloadDocument('" + docVo.getDocId().toString() + "')\">" + docVo.getDocName() + "</a>");
		}
		return buffer.toString();
	} else {
		return "";
	}
}
%><html><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><iframe id="docFrame" style="display:none"></iframe><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><td><%= gBean.fmtHTML(LabelManager.getName(labelSet,"sbtEjeDoc")) %></td><td></td></TR></TABLE><DIV id="divContent" class="divContent"><% if (tBean != null) { 
			docst = tBean.getProcessDocuments(request);
			if (docst != null && docst.size() > 0) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeDocPro")%></DIV><%= processCollection(docst)%><%
				areDocs = true;
			}
			
			docst = tBean.getTaskDocuments(request);
			if (docst != null && docst.size() > 0) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeDocTar")%></DIV><%= processCollection(docst)%><%
				areDocs = true;
			}
		}
		
		if (tBean != null || eBean != null) { 
			docst = null;
			docse = null;
			docsEnv = null;
			if (tBean != null) {
				docst = tBean.getEntityDocuments(request);
				docsEnv = tBean.getEnvDocuments(request);
			}
			if (eBean != null) {
				docse = eBean.getEntityDocuments(request);
				docsEnv = eBean.getEnvDocuments(request);
			}
			if ((docst != null && docst.size() > 0) || (docse != null && docse.size() > 0)) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeDocEnt")%></DIV><%= (docst != null && docst.size() > 0)?processCollection(docst):""%><%= (docse != null && docse.size() > 0)?processCollection(docse):""%><%
				areDocs = true;
			}
			
			
			if ((docsEnv != null && docsEnv.size() > 0)) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeDocEnv")%></DIV><%= (docsEnv != null && docsEnv.size() > 0)?processCollection(docsEnv):""%><%
			areDocs = true;
		}

			docst = null;
			docse = null;
			if (tBean != null) {
				docst = tBean.getFormDocuments(request);
			}
			if (eBean != null) {
				docse = eBean.getFormDocuments(request);
			}
			if ((docst != null && docst.size() > 0) || (docse != null && docse.size() > 0)) { %><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtEjeDocFor")%></DIV><%= (docst != null && docst.size() > 0)?processCollection(docst):""%><%= (docse != null && docse.size() > 0)?processCollection(docse):""%><%
				areDocs = true;
			}
		} 
		
		if (! areDocs) { %><%= LabelManager.getName(labelSet,"sbtNoDocs") %><% } %></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><td></td><TD><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEjeSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEjeSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEjeSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endModalInc.jsp" %><script defer="true">
	var msgNotPer = "<%=LabelManager.getName(labelSet,com.dogma.document.DocumentException.DOC_NO_PER)%>";
	var msgMusLoc = "<%=LabelManager.getName(labelSet,com.dogma.document.DocumentException.DOC_MUST_BE_LOCKED_FOR_UPDATE)%>";
</script><script>
function downloadDocument (docId, docBean) {
	document.getElementById("docFrame").src="DocumentAction.do?action=downloadConf&docId="+docId+"&docBean="+docBean;
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>


