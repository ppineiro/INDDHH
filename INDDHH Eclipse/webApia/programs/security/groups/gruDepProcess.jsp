<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@page import="java.util.Collection"%><%@page import="java.util.Iterator"%><%@page import="com.st.util.labels.LabelManager"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.GroupBean"></jsp:useBean><%/*
  Collection colDeps = dBean.getDependencies();
 
  Iterator itDeps = colDeps.iterator();
  Integer proId = new Integer(request.getParameter("proId")); 
  while (itDeps.hasNext()){
	  Object obj = itDeps.next();
		if (obj instanceof GruDepProcessVo){
			GruDepProcessVo gruDepProVo = (GruDepProcessVo) obj;

			if (gruDepProVo.getProId().intValue() == proId.intValue()){
				*/
			%><table class="pageTop"><col class="col1"><col class="col2"><tr><td><%=LabelManager.getName(labelSet,"titPro")%></td><td></td></tr></table><div id="divContent" class="divContent" style="overflow:auto"><form id="frmMain" name="frmMain" method="POST"><%
		  Collection colDeps = dBean.getDependencies();
		  ArrayList<GruDepProcessVo> auxPro = new ArrayList<GruDepProcessVo>();		  
		  
		  Iterator itDeps = colDeps.iterator();
		  Integer proId = new Integer(request.getParameter("proId")); 
		  		  
		  while (itDeps.hasNext()){
			  Object obj = itDeps.next();
				if (obj instanceof GruDepProcessVo){
					GruDepProcessVo gruDepProVo = (GruDepProcessVo) obj;
		
					if (gruDepProVo.getProId().intValue() == proId.intValue()){	
						auxPro.add(gruDepProVo);
					}
				}
		  }
		  
		  ArrayList<GruDepProcessVo> orderPro = new ArrayList<GruDepProcessVo>();
		
		  ListIterator<GruDepProcessVo> itAux = auxPro.listIterator();

		  while(itAux.hasNext()) {
			  GruDepProcessVo gVo = itAux.next();
			  int index = 0;
			  int version = gVo.getProVersion().intValue();
			  for(GruDepProcessVo orderGVo : orderPro) {				  
			  	  //Orden descendente
				  if(orderGVo.getProVersion().intValue() > version)
					  index++;
				  else
					  break;
			  }
			  orderPro.add(index, gVo);
		  }
		  
		  ListIterator<GruDepProcessVo> itOrdered = orderPro.listIterator();
		  
		  while (itOrdered.hasNext()){
			  GruDepProcessVo gruDepProVo = itOrdered.next();
									
				%><table class="tblFormLayout"><col class="col1"><col class="col2"><col class="col3"><col class="col4"><tr><td colspan=4 align=left><div class="subTit"><%=LabelManager.getName(labelSet,"sbtDatPro")%></div></td></tr><tr><td colspan=4 align=left><table><%if (gruDepProVo.getPrjName() != null){ %><tr><td><LI class="liDep"><%=LabelManager.getName(labelSet,"titPrj")%>: <%=dBean.fmtStr(gruDepProVo.getPrjName())%></LI></td></tr><%} %><tr><td><LI class="liDep"><%=LabelManager.getToolTip(labelSet,"lblNom")%>: <%=dBean.fmtStr(gruDepProVo.getProName())%></LI></td></tr><tr><td><LI class="liDep"><%=LabelManager.getToolTip(labelSet,"lblVer")%>: <%=gruDepProVo.getProVersion()%></LI></td></tr></table></td></tr><% if (gruDepProVo.getProTskName().size() > 0){%><tr><td colspan=4 align=left><div class="subTit"><%=LabelManager.getName(labelSet,"lblTarUtil")%></div></td></tr><tr><td colspan=4 align=left><table><thead><tr><th style="width:50%" title=""></th></tr></thead><tbody><tr><td><%Collection colTasks = gruDepProVo.getProTskName();
								   	  Iterator itTasks = colTasks.iterator();
								      while (itTasks.hasNext()){%><LI class="liDep"><%=(String)itTasks.next()%></LI><%}%></td></tr></tbody></table></td></tr><%} %><% if (gruDepProVo.isProReasign()){%><tr><td colspan=4 align=left><div class="subTit"><%=LabelManager.getName(labelSet,"lblAccUtil")%></div></td></tr><tr><td colspan=4 align=left><table><tr><td><LI class="liDep"><%=LabelManager.getToolTip(labelSet,"lblReaProGru")%></LI></td></tr></table></td></tr><%}%><% if (gruDepProVo.getProNotType().size() > 0){ %><tr><td colspan=4 align=left><div class="subTit"><%=LabelManager.getName(labelSet,"lblNotUtil")%></div></td></tr><tr><td colspan=4 align=left><table><thead><tr><th style="width:50%" title=""></th></tr></thead><tbody><tr><td><%Collection notPool = gruDepProVo.getProNotType();
								   	  Iterator itNotPool = notPool.iterator();
								      while (itNotPool.hasNext()){
										 String event = (String)itNotPool.next();
									   	 if (ProNotPoolVo.NOTIFICATION_EVENT_CREATE.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblProCre")%></LI><%}
	  							  	     if (ProNotPoolVo.NOTIFICATION_EVENT_END.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblProEnd")%></LI><%}
									     if (ProNotPoolVo.NOTIFICATION_EVENT_ALERT.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblProAla")%></LI><%}
									     if (ProNotPoolVo.NOTIFICATION_EVENT_OVERDUE.equals(event)) { %><LI class="liDep"><%=LabelManager.getName(labelSet,"lblProOve")%></LI><%}
							      	   }%></td></tr></tbody></table></td></tr><%}%></table><br/><%
		  }%></form></div><table class="pageBottom"><col class="col1"><col class="col2"><tr><td></td><td><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></td></tr></table></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script>
function btnExit_click() {
	window.close();
}
</script>

