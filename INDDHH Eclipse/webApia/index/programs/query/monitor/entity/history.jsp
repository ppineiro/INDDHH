<%@page import="com.st.util.translator.TranslationManager"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@page import="com.dogma.bean.execution.EntInstanceBean"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorEntityBean"></jsp:useBean><%
String urlAction = request.getParameter("action");
boolean blnSpecific = ! dBean.getFilter().isGlobal();
 %><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMonEnt")%><%if (blnSpecific) {%> : <%=dBean.getBusEntityVo().getBusEntTitle()%><%}%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type ="tabElement" id="samplesTab" ontabswitched="tabSwitch()" <% if (dBean.isShowHistoryTab()) {%>defaultTab="1"<% } %>><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabMonEntBefore")%>" tabText="<%=LabelManager.getName(labelSet,"tabMonEntBefore")%>"><jsp:include page="/programs/execution/includes/forms.jsp?frmParent=E&frmSource=before"/></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabMonEntHistory")%>" tabText="<%=LabelManager.getName(labelSet,"tabMonEntHistory")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtMonEntAttValHis")%></DIV><div type="grid" id="gridList" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table id="tblHead" cellpadding="0" cellspacing="0"><thead><tr><th style="width:150px"><%=LabelManager.getName(labelSet,"lblMonEntDate")%></th><th style="width:75px"><%=LabelManager.getName(labelSet,"lblMonEntUser")%></th><th style="width:75px" onclick="sortHistoryBy(<%= MonitorEntityFilterVo.HISTORY_ORDER_BY_ACTION %>);"><%= (dBean.getFilter().getHistoryOrderBy() == MonitorEntityFilterVo.HISTORY_ORDER_BY_ACTION) ? "" : "<u>" %><%=LabelManager.getName(labelSet,"lblMonEntOpe")%><%= (dBean.getFilter().getHistoryOrderBy() == MonitorEntityFilterVo.HISTORY_ORDER_BY_ACTION) ? "" : "</u>" %></th><th style="width:150px" onclick="sortHistoryBy(<%= MonitorEntityFilterVo.HISTORY_ORDER_BY_ATTRIBUTE %>);"><%= (dBean.getFilter().getHistoryOrderBy() == MonitorEntityFilterVo.HISTORY_ORDER_BY_ATTRIBUTE) ? "" : "<u>" %><%=LabelManager.getName(labelSet,"lblMonEntAtt")%><%= (dBean.getFilter().getHistoryOrderBy() == MonitorEntityFilterVo.HISTORY_ORDER_BY_ATTRIBUTE) ? "" : "</u>" %></th><th style="width:150px"><%=LabelManager.getName(labelSet,"lblMonEntIndex")%></th><th style="width:150px"><%=LabelManager.getName(labelSet,"lblMonEntValue")%></th></tr></thead><tbody><%
								Collection history = dBean.getHistoryPage();
								if (history != null && history.size() > 0) {
									for (Iterator it = history.iterator(); it.hasNext(); ) {
										BusEntInstAttributeVo vo = (BusEntInstAttributeVo) it.next(); %><tr><td><%= vo.getRegDate() %></td><td><%= vo.getRegUser() %></td><td><%= LabelManager.getName(labelSet,"lblMonBusEntOpe" + vo.getOpId()) %></td><td><%= vo.getAttributeVo().getAttLabel() %></td><td><%= vo.getAttIndexId() %></td><td><%= dBean.getAttRemaping(vo.getAttId(), vo.getValueAsObject()) %></td></tr><%
									}
								} %></tbody></table></div><DIV class="subTit"><%=LabelManager.getName(labelSet,"lblMonEntHisFilAtt")%></DIV><div><table id="tblHead" cellpadding="0" cellspacing="0"><tbody><tr><td style="width:150px"><input type="checkbox" name="attId" id="allIds" value=""  onclick="checkAllAttIdSelected(true);" <%= dBean.getFilter().hasAttributeSelected() ? "" : "checked" %>><%= LabelManager.getName(labelSet,"lblMonEntHisAttAll") %></td><%
				   					int count = 1;
					   				Collection attributes = dBean.getAttributes(); 
					   				if (attributes != null) {
					   					for (Iterator it = attributes.iterator(); it.hasNext(); ) {
					   						AttributeVo vo = (AttributeVo) it.next(); 
					   						if (count == 10) { %></tr><tr><%
					   							count = 0;
					   						} %><td style="width:150px"><input type="checkbox" name="attId" id="attId<%= vo.getAttId() %>" onclick="checkAllAttIdSelected(false);" value="<%= vo.getAttId() %>" <%= dBean.getFilter().isAttributeSelected(vo.getAttId()) ? "checked" : "" %>><%= vo.getAttLabel() %></td><%
					   						count ++;
					   					}
					   				}%></tr></tbody></table><br><button onclick="filterByAttribute();"><%=LabelManager.getName(labelSet,"btnFil")%></button></div></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabMonEntAfter")%>" tabText="<%=LabelManager.getName(labelSet,"tabMonEntAfter")%>"><jsp:include page="/programs/execution/includes/forms.jsp?frmParent=E&frmSource=after"/></div><div type="tab" style="visibility:hidden" tabTitle="<%=LabelManager.getToolTip(labelSet,"tabMonEntProInst")%>" tabText="<%=LabelManager.getName(labelSet,"tabMonEntProInst")%>"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtMonEntProInst")%></DIV><div type="grid" id="gridListInst" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProNroReg")%>"><%=LabelManager.getName(labelSet,"lblMonInstProNroReg")%></th><th style="width:250px" title="<%=LabelManager.getToolTip(labelSet,"lblProTit")%>"><%=LabelManager.getName(labelSet,"lblProTit")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProAct")%>"><%=LabelManager.getName(labelSet,"lblMonProAct")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProSta")%>"><%=LabelManager.getName(labelSet,"lblMonInstProSta")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonProPriority")%>"><%=LabelManager.getName(labelSet,"lblMonProPriority")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProCreUsu")%>"><%=LabelManager.getName(labelSet,"lblMonInstProCreUsu")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProCreDat")%>"><%=LabelManager.getName(labelSet,"lblMonInstProCreDat")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProEndDat")%>"><%=LabelManager.getName(labelSet,"lblMonInstProEndDat")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProWarnDat")%>"><%=LabelManager.getName(labelSet,"lblMonInstProWarnDat")%></th><th style="width:100px" title="<%=LabelManager.getToolTip(labelSet,"lblMonInstProOverDat")%>"><%=LabelManager.getName(labelSet,"lblMonInstProOverDat")%></th></tr></thead><tbody><%	Collection col = dBean.getProInstances();
								if (col != null) {
									Iterator it = col.iterator();
									int i = 0;
									while (it.hasNext()) {
										ProInstanceVo mPVo = (ProInstanceVo) it.next(); %><tr row_id="<%=dBean.fmtStr(mPVo.getReqString())%>"><td><%=dBean.fmtHTML(mPVo.getIdentification())%></td><td><%=dBean.fmtHTML(mPVo.getProcess().getProTitle())%></td><td><%=
												ProcessVo.PROCESS_ACTION_CREATION.equals(mPVo.getProcess().getProAction())?LabelManager.getName(labelSet,"lblMonProActCre"):
												ProcessVo.PROCESS_ACTION_ALTERATION.equals(mPVo.getProcess().getProAction())?LabelManager.getName(labelSet,"lblMonProActAlt"):
												ProcessVo.PROCESS_ACTION_CANCEL.equals(mPVo.getProcess().getProAction())?LabelManager.getName(labelSet,"lblMonProActCan"):""
											%></td><td><%=
												ProInstanceVo.PROC_STATUS_RUNNING.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,"lblMonInstProStaRun"):
												ProInstanceVo.PROC_STATUS_SUSPENDED.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,"lblMonInstProStaSus"):
												ProInstanceVo.PROC_STATUS_CANCELLED.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,"lblMonInstProStaCan"):
												ProInstanceVo.PROC_STATUS_FINALIZED.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,"lblMonInstProStaFin"):
												ProInstanceVo.PROC_STATUS_COMPLETED.equals(mPVo.getProInstStatus())?LabelManager.getName(labelSet,"lblMonInstProStaCom"):""
											%></td><td><%=
												(mPVo.getProPriority() == null) ? "" :
												(ProInstanceVo.PRO_PRIORITY_HIGH == mPVo.getProPriority().intValue())?LabelManager.getName(labelSet,"lblMonInstProPriAlt"):
												(ProInstanceVo.PRO_PRIORITY_LOW == mPVo.getProPriority().intValue())?LabelManager.getName(labelSet,"lblMonInstProPriBaj"):
												(ProInstanceVo.PRO_PRIORITY_NORMAL == mPVo.getProPriority().intValue())?LabelManager.getName(labelSet,"lblMonInstProPriNor"):
												(ProInstanceVo.PRO_PRIORITY_URGENT == mPVo.getProPriority().intValue())?LabelManager.getName(labelSet,"lblMonInstProPriUrg"):""
											%></td><td><%=dBean.fmtHTML(mPVo.getProInstCreateUser())%></td><td><%=dBean.fmtHTMLAMPM(mPVo.getProInstCreateDate())%></td><td><%=dBean.fmtHTMLAMPM(mPVo.getProInstEndDate())%></td><td><%=dBean.fmtHTMLAMPM(mPVo.getProInstWarnDate())%></td><td><%=dBean.fmtHTMLAMPM(mPVo.getProInstOverdueDate())%></td></tr><%i++;%><%}
								}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><td></td><td><button type="button" onclick="btnTsk_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnMonTsk")%>" title="<%=LabelManager.getToolTip(labelSet,"btnMonTsk")%>"><%=LabelManager.getNameWAccess(labelSet,"btnMonTsk")%></button></td></tr></table></div></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script>
	var FROM_QUERY = <%= dBean.isFromQuery() %>;
	
	var ALL_IDS = [<%
		if (attributes != null) {
			for (Iterator it = attributes.iterator(); it.hasNext(); ) {
				AttributeVo vo = (AttributeVo) it.next();
				%>'attId<%= vo.getAttId() %>'<%
				if (it.hasNext()) {%>,<%}
			}
		}%>];
	
	function checkAllAttIdSelected(fromAll) {
		var allIds = document.getElementById('allIds');
		if (fromAll) {
			if (allIds.checked) {
				for (var i = 0; i < ALL_IDS.length; i++) {
					document.getElementById(ALL_IDS[i]).checked = false;
				}	
			}
		} else {
			allIds.checked = true;
			for (var i = 0; i < ALL_IDS.length; i++) {
				if (document.getElementById(ALL_IDS[i]).checked) {
					allIds.checked = false;
					break;
				}
			}
		}
		
	}
</script><script src="<%=Parameters.ROOT_PATH%>/programs/query/monitor/entity/history.js"></script><%@include file="../../../../components/scripts/server/endInc.jsp" %>