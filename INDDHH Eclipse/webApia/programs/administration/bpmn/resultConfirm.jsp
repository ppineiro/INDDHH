<%@ taglib uri='/WEB-INF/regions.tld' prefix='region' %><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.execution.*"%><%@page import="com.dogma.vo.custom.ProAdmResultVo"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><%@include file="../../../components/scripts/server/messages.jsp" %><%@page import="com.dogma.controller.ThreadData"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.BPMNBean"></jsp:useBean><%  
	ProAdmResultVo resultVo = dBean.getResultVo();
	StringBuffer message = new StringBuffer();
	if (resultVo != null) {
		if (resultVo.isUsedInScenario()) {
			//message.append("<B> El proceso se eliminará de los siguientes escenarios: </B>");
			message.append("<B>" + LabelManager.getName(labelSet,"msgProWillBeDelFromScenarios") + ":</B>");
			if (resultVo.getScenarios()!=null && resultVo.getScenarios().size()>0){
				Iterator itScenarios = resultVo.getScenarios().iterator();
				while (itScenarios.hasNext()){
					SimScenarioVo scenarioVo = (SimScenarioVo) itScenarios.next();
					message.append("<br><LI> " + scenarioVo.getSimSceName());
				}
			}
			//message.append("<br><br>(Si el proceso es único en el escenario, el escenario será eliminado)");
			message.append("<br><br>(" + LabelManager.getName(labelSet,"msgIfProUniqEsceWillBeDeleted") + ")");
		}else if (!resultVo.isChangeVersionComments()) {
			message.append("<B>" + LabelManager.getName(labelSet,"lblAltProMsgCmb") + "</B>");
			if (resultVo.isChangeBasicData()) {message.append("<LI> " + LabelManager.getName(labelSet,"lblAltProChgDatBas"));}
			if (resultVo.isChangeAlerts()) {message.append("<LI> " + LabelManager.getName(labelSet,"lblAltProChgNot"));}
			if (resultVo.isChangeEvents()) {message.append("<LI> " + LabelManager.getName(labelSet,"lblAltProChgEve"));}
			if (resultVo.isChangeStates()) {message.append("<LI> " + LabelManager.getName(labelSet,"lblAltProChgSta"));}
			if (resultVo.isChangeForms())  {message.append("<LI> " + LabelManager.getName(labelSet,"lblAltProChgFor"));}
			if (resultVo.isChangeGroups()) {message.append("<LI> " + LabelManager.getName(labelSet,"lblAltProChgGru"));}
			if (resultVo.isChangeStructure()) {message.append("<LI> " + LabelManager.getName(labelSet,"lblAltProChgEst"));}		
			if (resultVo.isChangeCube()) {message.append("<LI> " + LabelManager.getName(labelSet,"lblDwQry"));}	
			if (resultVo.mustVersion()) {
				message.append("<P><B>" + LabelManager.getName(labelSet,"lblAltProMsgMusVer") + "</B>");
			} else {
				message.append("<P><B>" + LabelManager.getName(labelSet,"lblAltProMsgCanVer") + "</B>");
			}
			message.append("<TABLE><tr><td><input name=rad id=radVer type=radio onclick=radVer_click()></td><td>" + LabelManager.getName(labelSet,"lblAltProMsgResVer") + "</td></tr>");
			message.append("<tr><td></td><td>"+LabelManager.getName(labelSet,"lblCom")+": "+"</td><td><input disabled=true name=comment id=comment  maxlength=255 type=text></td></tr>");
			if (resultVo.mustVersion()) {
				message.append("<tr style=\"display:none\">");
			} else {
				message.append("<tr>");
			}
			message.append("<td><input name=rad id=radMod type=radio onclick=radVer_click()></td><td>" + LabelManager.getName(labelSet,"lblAltProMsgResMod") + "</td></tr>");
			message.append("<tr><td><input name=rad id=radCan type=radio onclick=radVer_click() checked=true></td><td>" + LabelManager.getName(labelSet,"lblAltProMsgResCan") + "</td></tr></TABLE>");
		
		}else {
			message.append("<TABLE><tr><td><input style=visibility:hidden name=rad id=radVer type=radio checked=true disabled=true></td><td>" + LabelManager.getName(labelSet,"lblProVer") + "</td></tr>");
			message.append("<tr><td></td><td>"+LabelManager.getName(labelSet,"lblCom")+": "+"</td><td><input name=commentVer id=commentVer  maxlength=255 type=text ></td></tr></TABLE>");
		}
	}
	
	
	String wfWarnings = null;
	if(ThreadData.get("WFWarning")!=null){
		String str = (String)ThreadData.get("WFWarning");
		wfWarnings = str;
	}
	
	String biVwMsg = null;
	String biVwListMsg = null;
	if(ThreadData.get("BIViewMsgWarning")!=null){
		String vwMsg = (String)ThreadData.get("BIViewMsgWarning");
		String vwListMsg = (String)ThreadData.get("BIViewListMsgWarning");
		biVwMsg = vwMsg.replace("\"", "'");
		biVwListMsg = vwListMsg.replace("\"", "'");
	}
	String biWidMsg = null;
	String biWidListMsg = null;
	if(ThreadData.get("BIWidMsgWarning")!=null){
		String widMsg = (String)ThreadData.get("BIWidMsgWarning");
		String widListMsg = (String)ThreadData.get("BIWidListMsgWarning");
		biWidMsg = widMsg.replace("\"", "'");
		biWidListMsg = widListMsg.replace("\"", "'");
	}
	
	String missSubProcsMsg = null;
	if(ThreadData.get("MissingSubProcsWarning")!=null){
		missSubProcsMsg = (String)ThreadData.get("MissingSubProcsWarning");
	}
%><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/util.js"></script><region:render template='/templates/resultTemplate.jsp'><region:put section='title'><%=LabelManager.getName(labelSet,"titAltPro")%></region:put><region:put section='message'><%= (resultVo != null && message.toString().length() > 0)?message.toString():" "%></region:put><region:put section='navigate'>true</region:put><region:put section='closeAutomatically'><%=resultVo==null?"true":"false"%></region:put><region:put section='nextUrl'>/administration.BPMNAction.do?action=backToListWOk<%if(request.getParameter("windowId")!=null){%>&windowId=<%=request.getParameter("windowId")%><%}%><%if(wfWarnings!=null){%>&WFWarning=<%=wfWarnings %><%}%><%if(biVwMsg!=null){%>&BIVwMsg=<%=biVwMsg%>&BIVwListMsg=<%=biVwListMsg%><%}%><%if(biWidMsg!=null){%>&BIWidMsg=<%=biWidMsg%>&BIWidListMsg=<%=biWidListMsg%><%}%><%if(missSubProcsMsg!=null){%>&MissingSubProcsMsg=<%=missSubProcsMsg%><%}%></region:put><% if (resultVo!=null && resultVo.isUsedInScenario()) {%><region:put section='btnSalir'>true</region:put><%}else{ %><region:put section='btnSalir'>false</region:put><%} %></region:render><%@include file="../../../components/scripts/server/endInc.jsp" %><script defer><% if (resultVo != null) { %>
	function btnConf_click(){
		<% if (resultVo.isUsedInScenario()) {%>
			window.parent.document.getElementById("iframeResult").hideResultFrame();
			var formulario = window.parent.document.getElementById(window.name).submitWindow.document.getElementById("frmMain");
			formulario.action="administration.BPMNAction.do?action=confirm&version=true&delScenarios=true";
			window.parent.document.getElementById("iframeResult").src="";
			submitFormFrame(formulario);
		<%} else {%>
			if (document.getElementById("radVer") && document.getElementById("radVer").checked) {
				window.parent.document.getElementById("iframeResult").hideResultFrame()
				var formulario = window.parent.document.getElementById(window.name).submitWindow.document.getElementById("frmMain");
				var comm = "";
				var notVersion = false;
				if (document.getElementById("comment")){
					comm = document.getElementById("comment").value;
				} else if (document.getElementById("commentVer")) {
					comm = document.getElementById("commentVer").value;
					notVersion = true;
				}
				if (notVersion == false) {
					formulario.action="administration.BPMNAction.do?action=confirm&version=true&checkComment=true&comment="+comm;
				} else {
					formulario.action="administration.BPMNAction.do?action=confirm&checkComment=true&comment="+comm;
				}
				window.parent.document.getElementById("iframeResult").src="";
				submitFormFrame(formulario);
			} else if (document.getElementById("radMod") && document.getElementById("radMod").checked) {
				window.parent.document.getElementById("iframeResult").hideResultFrame()
				var formulario = window.parent.document.getElementById(window.name).submitWindow.document.getElementById("frmMain");
				formulario.action="administration.BPMNAction.do?action=confirm&notVersion=true";
				window.parent.document.getElementById("iframeResult").src="";
				submitFormFrame(formulario);
			} else {
				window.parent.document.getElementById("iframeResult").hideResultFrame();
				window.parent.document.getElementById("iframeResult").src="";
			}
		<%}%>
	}
	
	function radVer_click(){
		if (document.getElementById("radVer").checked) {
			if (document.getElementById("comment").disabled==true) {
					document.getElementById("comment").disabled=false;
			}
		} else {
			document.getElementById("comment").disabled=true;
		}
	}
	
	<%}%></script>