<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><!DOCTYPE html><html><head><title>Apia</title><%@include file="../common/headInclude.jsp" %><!-- Script --><script type="text/javascript" src="<system:util show="context" />/miniSite/pages/menu.js"></script><!-- CSS --><link rel="stylesheet" href="<system:util show="context" />/miniSite/css/default/menu.css"><script type="text/javascript">
		var CONTEXT					= "<system:util show="context" />";
		var WAIT_A_SECOND			= "<system:label show="text" label="lblEspUnMom" />";
		var TOKENID					= "<system:util show="tokenId" />";
	</script></head><body><div class="header"><div class="logo"></div></div><div class="message hidden" id="messageContainer"></div><div class="content"><ul><li id="taskList"><div class="item"><system:label show="text" label="mnuLisTar" /></div></li><li id="startProcesses"><div class="item"><system:label show="text" label="mnuIniPro" /></div></li><li id="listQueries"><div class="item" ><system:label show="text" label="mnuQry" /></div></li><li><div class="item extraMargin"><div class="data"><div class="label"><system:label show="text" label="titEjeTarLib" />:
						</div><div id="divRdy" class="divRdy"></div></div><div class="data"><div class="label"><system:label show="text" label="titPnlAcqTasks" />:
						</div><div id="divAcq" class="divAcq"></div></div></div></li><li id="btnExit"><div class="item"><system:label show="text" label="btnSal" /></div></li></ul></div></body></html>

