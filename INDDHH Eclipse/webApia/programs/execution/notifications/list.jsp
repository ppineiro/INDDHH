<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.filter.*"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@include file="../../../components/scripts/server/startInc.jsp" %><% boolean canOrderBy = false; %><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><%@page import="com.dogma.dao.UsrNotReadDAO"%><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.NotificationBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,(dBean.isGeneral()?"titNotGen":"titNot"))%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><table width="100%"><tr class="subTit"><td width="100%" align="left"><%=LabelManager.getName(labelSet,"sbtFil")%></td><td align="right"><button type="button" id="toggleFilter" title="<%=LabelManager.getToolTip(labelSet,"lblMonButFil")%>" type="button" class="btn" onclick="toggleFilterSection(<%=Parameters.SCREEN_LIST_SIZE - Parameters.FILTER_LIST_SIZE%>,<%=(Parameters.SCREEN_LIST_SIZE)%>)"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/openToc.gif" width="8" height="7"></button></td></tr></table></DIV><DIV id="listFilterArea" style="display:none"><DIV style="OVERFLOW:AUTO;HEIGHT:<%= Parameters.FILTER_LIST_SIZE - 32 %>px;"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblMen")%>"><%=LabelManager.getNameWAccess(labelSet,"lblMen")%>:</td><td><input name="txtMessage" maxlength="255" type="text" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblMen")%>" value="<%=dBean.fmtStr(dBean.getFilter().getMessage())%>"></td><td></td><td></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblFrom")%>"><%=LabelManager.getNameWAccess(labelSet,"lblFrom")%>:</td><td><select name="cmbFrom"><option value=""></option><option value="<%=NotificationVo.NOTIFICATION_FROM_PROCESS%>" <%=NotificationVo.NOTIFICATION_FROM_PROCESS.equals(dBean.getFilter().getFrom())?"selected":""%>><%= LabelManager.getName(labelSet,"lblPro") %></option><option value="<%=NotificationVo.NOTIFICATION_FROM_TASK%>" <%=NotificationVo.NOTIFICATION_FROM_TASK.equals(dBean.getFilter().getFrom())?"selected":""%>><%= LabelManager.getName(labelSet,"lblTask") %></option><option value="<%=NotificationVo.NOTIFICATION_FROM_BUSCLASS%>" <%=NotificationVo.NOTIFICATION_FROM_BUSCLASS.equals(dBean.getFilter().getFrom())?"selected":""%>><%= LabelManager.getName(labelSet,"lblBusClass") %></option><option value="<%=NotificationVo.NOTIFICATION_FROM_SCHEDULER%>" <%=NotificationVo.NOTIFICATION_FROM_SCHEDULER.equals(dBean.getFilter().getFrom())?"selected":""%>><%= LabelManager.getName(labelSet,"lblSch") %></option></select></td><td title="<%=LabelManager.getToolTip(labelSet,"lblEvent")%>"><%=LabelManager.getNameWAccess(labelSet,"lblEvent")%>:</td><td><select name="cmbEvent"><option value=""></option><option value="<%=NotificationVo.EVENT_PROCESS_CREATE%>" <%=NotificationVo.EVENT_PROCESS_CREATE.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveProCre") %></option><option value="<%=NotificationVo.EVENT_PROCESS_END%>" <%=NotificationVo.EVENT_PROCESS_END.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveProEnd") %></option><option value="<%=NotificationVo.EVENT_PROCESS_ALERT%>" <%=NotificationVo.EVENT_PROCESS_ALERT.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveProAlert") %></option><option value="<%=NotificationVo.EVENT_PROCESS_OVERDUE%>" <%=NotificationVo.EVENT_PROCESS_OVERDUE.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveProOver") %></option><option value="<%=NotificationVo.EVENT_TASK_ASIGNED%>" <%=NotificationVo.EVENT_TASK_ASIGNED.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveTskAsi") %></option><option value="<%=NotificationVo.EVENT_TASK_COMPLEAT%>" <%=NotificationVo.EVENT_TASK_COMPLEAT.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveTskCom") %></option><option value="<%=NotificationVo.EVENT_TASK_ACQUIRED%>" <%=NotificationVo.EVENT_TASK_ACQUIRED.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveTskAcq") %></option><option value="<%=NotificationVo.EVENT_TASK_RELEASE%>" <%=NotificationVo.EVENT_TASK_RELEASE.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveTskRel") %></option><option value="<%=NotificationVo.EVENT_TASK_ALARM%>" <%=NotificationVo.EVENT_TASK_ALARM.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveTskAla") %></option><option value="<%=NotificationVo.EVENT_TASK_OVERDUE%>" <%=NotificationVo.EVENT_TASK_OVERDUE.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveTskOver") %></option><option value="<%=NotificationVo.EVENT_TASK_REASIGN%>" <%=NotificationVo.EVENT_TASK_REASIGN.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveTskRea") %></option><option value="<%=NotificationVo.EVENT_TASK_ELEVATE%>" <%=NotificationVo.EVENT_TASK_ELEVATE.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveTskEle") %></option><option value="<%=NotificationVo.EVENT_TASK_DELEGATE%>" <%=NotificationVo.EVENT_TASK_DELEGATE.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveTskDel") %></option><option value="<%=NotificationVo.EVENT_SCHEDULER_ERROR%>" <%=NotificationVo.EVENT_SCHEDULER_ERROR.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveSchError") %></option><option value="<%=NotificationVo.EVENT_BUSCLASS_GENERATED%>" <%=NotificationVo.EVENT_BUSCLASS_GENERATED.equals(dBean.getFilter().getEvent())?"selected":""%>><%= LabelManager.getName(labelSet,"lblEveBusClaGen") %></option></select></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblFecDes")%>"><%=LabelManager.getNameWAccess(labelSet,"lblFecDes")%>:</td><td><input name="dteFrom" id="dteFrom" class="txtDate" size="10" p_mask = "<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" type="text" value="<%=dBean.fmtDate(dBean.getFilter().getDateFrom())%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblFecDes")%>"></td><td title="<%=LabelManager.getToolTip(labelSet,"lblFecHas")%>"><%=LabelManager.getNameWAccess(labelSet,"lblFecHas")%>:</td><td><input name="dteTo" id="dteTo" class="txtDate" size="10" p_mask = "<%=DogmaUtil.getHTMLDateMask(dBean.getEnvId(request))%>" p_calendar="true" maxlength="10" type="text" value="<%=dBean.fmtDate(dBean.getFilter().getDateTo())%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblFecHas")%>"></td></tr></table></div><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td></td><td colspan=3 align="right"><button type="button" onclick="btnSearch_click()" title="<%=LabelManager.getToolTip(labelSet,"btnBus")%>" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnBus")%>"><%=LabelManager.getNameWAccess(labelSet,"btnBus")%></button></td></tr></table></div><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRes")%></DIV><div class="tableContainerNoHScroll" type="grid" id="gridList" height="<%=Parameters.SCREEN_LIST_SIZE%>" style="height:<%=Parameters.SCREEN_LIST_SIZE%>px;" ><table cellpadding="0" cellspacing="0" width="900px"><thead class="fixedHeader"><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th min_width="5px" style="width:5px" title =""></th><% canOrderBy = dBean.getFilter().getOrderBy() != NotificationFilterVo.ORDER_MESSAGE; %><th min_width="450px" style="min-width:450px;width:90%<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=NotificationFilterVo.ORDER_MESSAGE%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblMen")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblMen")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != NotificationFilterVo.ORDER_DATE; %><th min_width="70px" style="width:70px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=NotificationFilterVo.ORDER_DATE%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblDate")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblDate")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != NotificationFilterVo.ORDER_FROM; %><th min_width="70px" style="min-width:70px;width:10%<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=NotificationFilterVo.ORDER_FROM%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblFrom")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblFrom")%><%=canOrderBy?"</u>":""%></th><% canOrderBy = dBean.getFilter().getOrderBy() != NotificationFilterVo.ORDER_EVENT; %><%if(dBean.isGeneral()){%><th min_width="80px" style="width:80px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=NotificationFilterVo.ORDER_EVENT%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblEvent")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblEvent")%><%=canOrderBy?"</u>":""%></th><th min_width="90px" style="width:90px" title="<%=LabelManager.getToolTip(labelSet,"lblUsu")%>"><%=LabelManager.getName(labelSet,"lblUsu")%></th><%}else{%><th min_width="80px" style="width:80px<% if (canOrderBy) {%>;cursor:hand" onclick="orderBy('<%=NotificationFilterVo.ORDER_EVENT%>')<%}%>" title="<%=LabelManager.getToolTip(labelSet,"lblEvent")%>"><%=canOrderBy?"<u>":""%><%=LabelManager.getName(labelSet,"lblEvent")%><%=canOrderBy?"</u>":""%></th><%}%></tr></thead><tbody class="scrollContent"><%
				   			Collection col = dBean.getList();
							if (col != null) {
								Iterator it = col.iterator();
								int i = 0;
								NotificationVo nVo = null;
								while (it.hasNext()) {
									nVo = (NotificationVo) it.next(); %><tr<%if (nVo.isAlreadyRead()){%> readMsg="true"<%}%>><%if (!NotificationVo.EVENT_BUSCLASS_GENERATED.equals(nVo.getNotEvent())){%><td style="width:0px;display:none;"><input type="hidden" id="idSel" name="chkSel<%=i%>"><input type="hidden" name="hidEnvId<%=i%>" value="<%=dBean.fmtInt(nVo.getEnvId())%>"><input type="hidden" name="hidNotId<%=i%>" value="<%=dBean.fmtInt(nVo.getNotId())%>"></td><% } else {%><td style="width:0px;display:none;"><input type="hidden" id="idSel" name="chkSel<%=i%>"><input type="hidden" name="hidEnvId<%=i%>" value="<%=dBean.fmtInt(nVo.getEnvId())%>"><input type="hidden" name="hidNotId<%=i%>" value="<%=dBean.fmtInt(nVo.getNotId())%>"></td><%}%><%if (nVo.isAlreadyRead()){%><td><img border="0" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/i_read.gif" alt="Leídos" ></img></td><%}else{%><td><img border="0" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/i_new.gif" alt="No leídos" ></img></td><%}%><td style="min-width:450px;"><%=nVo.getNotMessage()%></td><td><%=dBean.fmtHTML(nVo.getNotDate())%></td><td style="min-width:70px"><%=NotificationVo.NOTIFICATION_FROM_PROCESS.equals(nVo.getNotFrom())?LabelManager.getName(labelSet,"lblPro"):""%><%=NotificationVo.NOTIFICATION_FROM_TASK.equals(nVo.getNotFrom())?LabelManager.getName(labelSet,"lblTask"):""%><%=NotificationVo.NOTIFICATION_FROM_BUSCLASS.equals(nVo.getNotFrom())?LabelManager.getName(labelSet,"lblBusClass"):""%><%=NotificationVo.NOTIFICATION_FROM_SCHEDULER.equals(nVo.getNotFrom())?LabelManager.getName(labelSet,"lblSch"):""%></td><td><%=NotificationVo.EVENT_PROCESS_CREATE.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveProCre"):""%><%=NotificationVo.EVENT_PROCESS_END.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveProEnd"):""%><%=NotificationVo.EVENT_PROCESS_ALERT.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveProAlert"):""%><%=NotificationVo.EVENT_PROCESS_OVERDUE.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveProOver"):""%><%=NotificationVo.EVENT_TASK_ASIGNED.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveTskAsi"):""%><%=NotificationVo.EVENT_TASK_COMPLEAT.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveTskCom"):""%><%=NotificationVo.EVENT_TASK_ACQUIRED.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveTskAcq"):""%><%=NotificationVo.EVENT_TASK_RELEASE.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveTskRel"):""%><%=NotificationVo.EVENT_TASK_ALARM.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveTskAla"):""%><%=NotificationVo.EVENT_TASK_OVERDUE.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveTskOver"):""%><%=NotificationVo.EVENT_TASK_REASIGN.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveTskRea"):""%><%=NotificationVo.EVENT_TASK_ELEVATE.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveTskEle"):""%><%=NotificationVo.EVENT_TASK_DELEGATE.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveTskDel"):""%><%=NotificationVo.EVENT_SCHEDULER_ERROR.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveSchError"):""%><%=NotificationVo.EVENT_BUSCLASS_GENERATED.equals(nVo.getNotEvent())?LabelManager.getName(labelSet,"lblEveBusClaGen"):""%></td><%if(dBean.isGeneral()){%><td style="width:90px"><%=nVo.getUsrLogin()%></td><%}%></tr><%i++;%><%}
							}%></tbody></table></div><table class="navBar"><COL class="col1"><COL class="col2"><tr><%@include file="../../includes/navButtons.jsp" %><td align="right"><button type="button" onclick="btnView_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnView")%>" title="<%=LabelManager.getToolTip(labelSet,"btnView")%>"><%=LabelManager.getNameWAccess(labelSet,"btnView")%></button><button type="button" onclick="btnEli_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnEli")%>" title="<%=LabelManager.getToolTip(labelSet,"btnEli")%>"><%=LabelManager.getNameWAccess(labelSet,"btnEli")%></button></td></tr></table></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/execution/notifications/list.js'></script><script language="javascript">
var msgMarkAsRead = "<%=LabelManager.getName(labelSet,"msgMarAsRead")%>";
var msgMarkAsUnread = "<%=LabelManager.getName(labelSet,"msgMarAsUnread")%>";
var msgSelAll = "<%=LabelManager.getName(labelSet,"msgSelAll")%>";
var msnSelNone = "<%=LabelManager.getName(labelSet,"msgSelNone")%>";

document.getElementById("gridList").gridMenu=function(callerGrid,doc,tempX,tempY,aEvent){
	while(doc.tagName!="TR"){
		doc=doc.parentNode;
	}
	var read=doc.getAttribute("readMsg")=="true";
	var text=msgMarkAsRead;
	if(read){
		text=msgMarkAsUnread;
	}
	var div=document.createElement("div");
	div.id="contextMenuContainer";
	div.innerHTML='<table id="contextMenu" width="150" border="0px" cellpadding="0"><%if (!dBean.isGeneral()){%><tr><td width="100" style="padding-left:20px;">'+text+'</td></tr><%}%><tr><td style="padding-left:20px;">'+GRID_SELECTALL+'</td></tr><tr><td style="padding-left:20px;">'+GRID_SELECTNONE+'</td></tr></table>';
	//var input=div.getElementsByTagName("input")[0];
	div.style.position="absolute";
	div.style.width="150px";
	div.style.zIndex="9999999";
	//setOuterBlurEmulation(document);
	document.onmousedown=function(e){
		if(navigator.userAgent.indexOf("MSIE")>0){
			e=window.event;
		}
		//unSetOuterBlurEmulation();
		setTimeout(hideMenu,200);
		e.cancelBubble = true;
		document.oncontextmenu=[];
	}
	//div.style.height="300px";
	div.style.border="1px solid black";
	div.style.left=tempX+"px";
	div.style.top=tempY+"px";
	document.body.appendChild(div);
	var tds=div.getElementsByTagName("TD");
	var table=doc;
	if(table.tagName=="DIV"){
		table=doc.getElementsByTagName("TABLE");
		table=table[0];
	}else{
		while(table.tagName!="TABLE"){
			table=table.parentNode;
		}
	}
	/* No se cuenta con funcionalidad de marcar como leidas. Se desciende en los inidices de tds siguiente
	tds[0].onclick=function(){
		document.getElementById("gridList").selectElement(doc);
		if(doc.getAttribute("readMsg")=="true"){
			markUnMark("execution.NotificationAction.do?action=markAsUnread");
		}else {
			markUnMark("execution.NotificationAction.do?action=markAsRead");
		}
	}
	*/
	<%if (dBean.isGeneral()){%>
	
		tds[0].onclick=function(){
			//select All
			callerGrid.selectAll();
		}		
		tds[1].onclick=function(){
			//unselect All
			callerGrid.unselectAll();
		}
	<%} else {%>
		
		tds[0].onclick=function(){
			//mark as read
			document.getElementById("gridList").selectElement(doc);
			if(doc.getAttribute("readMsg")=="true"){
				markUnMark("execution.NotificationAction.do?action=markAsUnread");
			}else {
				markUnMark("execution.NotificationAction.do?action=markAsRead");
			}
		}	
		tds[1].onclick=function(){
			//select All
			callerGrid.selectAll();
		}		
		tds[2].onclick=function(){
			//unselect All
			callerGrid.unselectAll();
		}		
	<%}%>
	if(window.navigator.appVersion.indexOf("MSIE")>=0){
		for(var i=0;i<tds.length;i++){
			element=aEvent.srcElement;
			tds[i].onmouseover=function(){
				element=window.event.srcElement;
				element.parentNode.className="hoverEmulate";
			}
			tds[i].onmouseout=function(){
				element=window.event.srcElement;
				element.parentNode.className="";
			}
		}
	}
}

</script>
