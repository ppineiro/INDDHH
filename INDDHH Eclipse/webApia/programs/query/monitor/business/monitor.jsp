<%@page import="com.dogma.vo.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %><script language="javascript">

	function openDetailsModal(type,id){
		if (type == "<%= com.apia.query.extractors.MainExtractor.TYPE_PROCESS_INSTANCE%>") {
			var rets = openModal("/query.MonitorBusinessAction.do?action=details&proInstId=" + id + "&type=" + type,640,480);
		} else {
			var rets = openModal("/query.MonitorBusinessAction.do?action=details&busEntInstId=" + id + "&type=" + type,640,480);
		}
	}
	
	function openTasksModal(type,id){
		var rets = openModal("/query.MonitorBusinessAction.do?action=tasks&proInstId=" + id + "&type=" + type,640,480);
	}

</script></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorBusinessBean"></jsp:useBean><%

	String DEFAULT_VISUALIZATION=(dBean.getMonBusFlag(MonBusinessVo.FLAG_SHOW_AS_TREE)?"Tree":"Circle");
	boolean DEFAULT_SHOW_RELATED_ENTITIES=!dBean.getMonBusFlag(MonBusinessVo.FLAG_NOT_CHECKED_SHOW_ENT_RELATED);
	boolean DEFAULT_SHOW_RELATED_PROCESS=!dBean.getMonBusFlag(MonBusinessVo.FLAG_NOT_CHECKED_SHOW_PRO_RELATED);
	boolean DEFAULT_SHOW_RELATED_TASKS=!dBean.getMonBusFlag(MonBusinessVo.FLAG_NOT_CHECKED_SHOW_TSK_RELATED);
	boolean DEFAULT_GROUP_ENTITY_INSTANCES=!dBean.getMonBusFlag(MonBusinessVo.FLAG_NOT_CHECKED_GROUP_ENT_INST);
	boolean DEFAULT_GROUP_PROCESS_INSTANCES=!dBean.getMonBusFlag(MonBusinessVo.FLAG_NOT_CHECKED_GROUP_PRO_INST);
	boolean SHOW_HISTORY=!dBean.getMonBusFlag(MonBusinessVo.FLAG_DONT_SHOW_HISTORY);
	boolean SHOW_INSTANCES=!dBean.getMonBusFlag(MonBusinessVo.FLAG_DONT_SHOW_INSTANCES);

%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMonBusiness")%><%= (dBean.getMonitorBusinessName() == null) ? "" : (": " + dBean.getMonitorBusinessName()) %></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div style="margin-top:10px"><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"  
					 codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" 
						WIDTH="100%" 
						HEIGHT="500px" 
						style="/*border:1px solid black*/"
						id="shell" ALIGN="center" VALIGN="middle"><param name="allowScriptAccess" value="sameDomain" /><param name="movie" value="<%=Parameters.ROOT_PATH%>/flash/Monitor/bin/Monitor.swf" /><param name="FlashVars" value="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&SWF_URL=<%=Parameters.ROOT_PATH%>/flash/Monitor/bin/<%=windowId%>&LBL_URL=<%=Parameters.ROOT_PATH%>/programs/query/monitor/business/labels.jsp&DEFAULT_VISUALIZATION=<%=DEFAULT_VISUALIZATION%>&DEFAULT_SHOW_RELATED_ENTITIES=<%=DEFAULT_SHOW_RELATED_ENTITIES%>&DEFAULT_SHOW_RELATED_PROCESS=<%=DEFAULT_SHOW_RELATED_PROCESS%>&DEFAULT_SHOW_RELATED_TASKS=<%=DEFAULT_SHOW_RELATED_TASKS%>&DEFAULT_GROUP_ENTITY_INSTANCES=<%=DEFAULT_GROUP_ENTITY_INSTANCES%>&DEFAULT_GROUP_PROCESS_INSTANCES=<%=DEFAULT_GROUP_PROCESS_INSTANCES%>&SHOW_HISTORY=<%=SHOW_HISTORY%>&SHOW_INSTANCES=<%=SHOW_INSTANCES%>" /><param name="quality" value="high" /><param name="menu" value="false"/><param name="bgcolor" value="#efefef" /><param name="WMODE" value="transparent" /><embed wmode="transparent" menu="false" allowScriptAccess="sameDomain" src="<%=Parameters.ROOT_PATH%>/flash/Monitor/bin/Monitor.swf" quality="high" bgcolor="#efefef" width="100%" height="450" swLiveConnect="true" id="shell" name="shell" align="middle" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" flashVars="utf=<%="UTF-8".equals(Parameters.APP_ENCODING)%>&SWF_URL=<%=Parameters.ROOT_PATH%>/flash/Monitor/bin/<%=windowId%>&LBL_URL=<%=Parameters.ROOT_PATH%>/programs/query/monitor/business/labels.jsp&DEFAULT_VISUALIZATION=<%=DEFAULT_VISUALIZATION%>&DEFAULT_SHOW_RELATED_ENTITIES=<%=DEFAULT_SHOW_RELATED_ENTITIES%>&DEFAULT_SHOW_RELATED_PROCESS=<%=DEFAULT_SHOW_RELATED_PROCESS%>&DEFAULT_SHOW_RELATED_TASKS=<%=DEFAULT_SHOW_RELATED_TASKS%>&DEFAULT_GROUP_ENTITY_INSTANCES=<%=DEFAULT_GROUP_ENTITY_INSTANCES%>&DEFAULT_GROUP_PROCESS_INSTANCES=<%=DEFAULT_GROUP_PROCESS_INSTANCES%>&SHOW_HISTORY=<%=SHOW_HISTORY%>&SHOW_INSTANCES=<%=SHOW_INSTANCES%>" /></object></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><td></td><td><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../../components/scripts/server/endInc.jsp" %>

