<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE html><html><head><title>Apia</title><%@include file="../common/headInclude.jsp" %><!-- Script --><script type="text/javascript" src="<system:util show="context" />/miniSite/pages/taskList.js"></script><!-- CSS --><link rel="stylesheet" href="<system:util show="context" />/miniSite/css/default/taskList.css"><link rel="stylesheet" href="<system:util show="context" />/miniSite/css/default/back.css"><script type="text/javascript">
		var CONTEXT					= "<system:util show="context" />";
		var WAIT_A_SECOND			= "<system:label show="text" label="lblEspUnMom" />";
		var TOKENID					= "<system:util show="tokenId" />";
	</script></head><body><div class="header"><div class="logo"></div></div><div class="message hidden" id="messageContainer"></div><div class="content"><div class="title"><system:label show="text" label="mnuLisTar" /></div><%
 		System.out.println(session.getId());
 		pageContext.setAttribute("beanName", "viewBean");%><ul><system:edit show="iteration" from="theBean" field="tasksForMiniSite" saveOn="tasks" ><li><%/* columnas a mostrar:
				- prioridad
				- identificador
				- tarea
				- proceso
				- grupo
				*/ %><div class="item <system:edit show="ifValue" from="tasks" field="isAdquired" value="true"> acquired </system:edit>" onclick="work('<system:edit show="value" from="tasks" field="taskName" avoidHtmlConvert="true"/>','<system:edit show="value" from="tasks" field="procInstIdNum" avoidHtmlConvert="true"/>')"><system:edit show="ifValue" from="tasks" field="priority" value="1"><img src="<system:util show="context" />/miniSite/css/default/priority1.gif"/></system:edit><system:edit show="ifValue" from="tasks" field="priority" value="2"><img src="<system:util show="context" />/miniSite/css/default/priority2.gif"/></system:edit><system:edit show="ifValue" from="tasks" field="priority" value="3"><img src="<system:util show="context" />/miniSite/css/default/priority3.gif"/></system:edit><system:edit show="ifValue" from="tasks" field="priority" value="4"><img src="<system:util show="context" />/miniSite/css/default/priority4.gif"/></system:edit>
					&nbsp;				
					(<system:edit show="value" from="tasks" field="processIdentifier" avoidHtmlConvert="true"/>)
					&nbsp;-&nbsp;
					<system:edit show="value" from="tasks" field="processTitle" avoidHtmlConvert="true"/>
					&nbsp;-&nbsp;
					<system:edit show="value" from="tasks" field="taskTitle" avoidHtmlConvert="true"/><br><system:edit show="value" from="tasks" field="groupName" avoidHtmlConvert="true"/>
					&nbsp;-&nbsp;
					<a class='<system:edit show="ifValue" from="tasks" field="proInOverdue" value="true">dateOverdue </system:edit><system:edit show="ifValue" from="tasks" field="proInWarning" value="true">dateWarning</system:edit>'><system:edit show="value" from="tasks" field="procCreationDate" avoidHtmlConvert="true"/></a>
					&nbsp;-&nbsp;
					<a class='<system:edit show="ifValue" from="tasks" field="tskInWarning" value="true">dateWarning </system:edit><system:edit show="ifValue" from="tasks" field="tskInOverdue" value="true">dateOverdue</system:edit>'><system:edit show="value" from="tasks" field="taskCreationDate" avoidHtmlConvert="true"/></a></div></li></system:edit></ul></div><div class="back" onclick="btnBack_click()"></div></body></html>