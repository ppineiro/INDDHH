<%@page import="java.util.*"%><%@include file="../components/scripts/server/startInc.jsp" %><%@page import="com.dogma.vo.WsPublicationVo"%><%@page import="com.dogma.vo.WsTreeVo"%><%@page import="com.dogma.Configuration"%><HTML><head><%@include file="../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.configuration.WsBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titWs")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtWs")%></DIV><div style="height: 200px;" type="grid" id="gridList" docBean=""><table cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="width:350px" title="<%=LabelManager.getToolTip(labelSet,"lblWsPro")%>"><%=LabelManager.getName(labelSet,"lblWsPro")%></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblWsTsk")%>"><%=LabelManager.getName(labelSet,"lblWsTsk")%></th><th style="width:200px" title="<%=LabelManager.getToolTip(labelSet,"lblWsAct")%>"><%=LabelManager.getName(labelSet,"lblWsAct")%></th></tr></thead><tbody class="scrollContent"><%	Collection col = dBean.getProWSList();
						if (col != null) {
							Iterator it = col.iterator();
							int i = 0;
							WsTreeVo wsTreeVo = null;
							WsPublicationVo wsPubVo;
							while (it.hasNext()) {
								wsTreeVo = (WsTreeVo)it.next(); 
								if(wsTreeVo.getWsPublicationVo() != null){
									wsPubVo = wsTreeVo.getWsPublicationVo();
								
									if(wsPubVo.getWsName()!=null && wsPubVo.getWsName() != ""){%><tr><td><%=wsPubVo.getWsName()%></td><td></td><td><%if(!wsPubVo.getPermitedAction().equals(WsPublicationVo.ACTION_NOTHING)){ %><%if(Configuration.SSL){ %><a href="https://<%=request.getServerName()+":"+request.getServerPort()+Parameters.ROOT_PATH%>/ws/ApiaWsdl.jsp?wsName=<%=wsPubVo.getWsName()%>">wsdl</a><%}else{ %><a href="http://<%=request.getServerName()+":"+request.getServerPort()+Parameters.ROOT_PATH%>/ws/ApiaWsdl.jsp?wsName=<%=wsPubVo.getWsName()%>">wsdl</a><%}	%><%} %></td></tr><%i++;%><%}
									if(wsTreeVo.getWsTasks()!=null){
										Iterator itTsk = wsTreeVo.getWsTasks().iterator();
										while(itTsk.hasNext()){
											wsPubVo = (WsPublicationVo)itTsk.next();
											
											if(wsPubVo.getWsName()!=null && wsPubVo.getWsName() != ""){%><tr><td></td><td><%=wsPubVo.getWsName()%></td><td><%if(Configuration.SSL){ %><a href="https://<%=request.getServerName()+":"+request.getServerPort()+Parameters.ROOT_PATH%>/ws/ApiaWsdl.jsp?wsName=<%=wsPubVo.getWsName()%>">wsdl</a><%}else{ %><a href="http://<%=request.getServerName()+":"+request.getServerPort()+Parameters.ROOT_PATH%>/ws/ApiaWsdl.jsp?wsName=<%=wsPubVo.getWsName()%>">wsdl</a><%}	%></td></tr><%i++;%><%}
										}
									}
								}
							}
						}%></tbody></table></div><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtBusClaWs")%></DIV><div style="height: 200px;" type="grid" id="gridList" docBean=""><table cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblWsBusCla")%>"><%=LabelManager.getName(labelSet,"lblWsBusCla")%></th><th style="width:200px" title="<%=LabelManager.getToolTip(labelSet,"lblWsAct")%>"><%=LabelManager.getName(labelSet,"lblWsAct")%></th></tr></thead><tbody class="scrollContent"><%	col = dBean.getBusClassWSList();
						if (col != null) {
							Iterator it = col.iterator();
							WsPublicationVo wsPubVo;
							while (it.hasNext()) {
								wsPubVo = (WsPublicationVo)it.next(); 
								if(wsPubVo.getWsName()!=null && wsPubVo.getWsName() != ""){%><tr><td><%=wsPubVo.getWsName()%></td><td><%if(Configuration.SSL){ %><a href="https://<%=request.getServerName()+":"+request.getServerPort()+Parameters.ROOT_PATH%>/ws/ApiaWsdl.jsp?wsName=<%=wsPubVo.getWsName()%>">wsdl</a><%}else{ %><a href="http://<%=request.getServerName()+":"+request.getServerPort()+Parameters.ROOT_PATH%>/ws/ApiaWsdl.jsp?wsName=<%=wsPubVo.getWsName()%>">wsdl</a><%}	%></td></tr><%}	
							}
						}%></tbody></table></div><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtQryWs")%></DIV><div style="height: 200px;" type="grid" id="gridList" docBean=""><table cellpadding="0" cellspacing="0"><thead class="fixedHeader"><tr><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblWsQry")%>"><%=LabelManager.getName(labelSet,"lblWsQry")%></th><th style="width:200px" title="<%=LabelManager.getToolTip(labelSet,"lblWsAct")%>"><%=LabelManager.getName(labelSet,"lblWsAct")%></th></tr></thead><tbody class="scrollContent"><%	col = dBean.getQueryWSList();
						if (col != null) {
							Iterator it = col.iterator();
							WsPublicationVo wsPubVo;
							while (it.hasNext()) {
								wsPubVo = (WsPublicationVo)it.next(); 
								if(wsPubVo.getWsName()!=null && wsPubVo.getWsName() != ""){%><tr><td><%=wsPubVo.getWsName()%></td><td><%if(Configuration.SSL){ %><a href="https://<%=request.getServerName()+":"+request.getServerPort()+Parameters.ROOT_PATH%>/ws/ApiaWsdl.jsp?wsName=<%=wsPubVo.getWsName()%>">wsdl</a><%}else{ %><a href="http://<%=request.getServerName()+":"+request.getServerPort()+Parameters.ROOT_PATH%>/ws/ApiaWsdl.jsp?wsName=<%=wsPubVo.getWsName()%>">wsdl</a><%}	%></td></tr><%}	
							}
						}%></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script src="<%=Parameters.ROOT_PATH%>/programs/configuration/ws/ws.js"></script>