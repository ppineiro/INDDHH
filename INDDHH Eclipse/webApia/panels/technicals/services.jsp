<%@ page contentType="text/html; charset=iso-8859-1" language="java"%><%@page import="com.dogma.UserData"%><%@include file="../../components/scripts/server/startInc.jsp" %><%
	UserData usrData = BasicBeanStatic.getUserDataStatic(request);
	Integer ident = usrData.getLangId();
%><script type="text/javascript" defer="defer">
function callService(url,event) {
	var height = (screen.availHeight-30) * 0.85;
	var width = (screen.availWidth-10) * 0.85;
	var top = ((screen.availHeight-30) / 2) - (height / 2);
	var left = ((screen.availWidth-10) / 2) - (width / 2);
	var valores = "height= " + height + " , " + "width= " + width;
	valores = "toolbar=no,location=no,status=no,menubar=no,resizable=no,scrollbars=yes,top=" + top + ",left=" + left + "," + valores;
	x="\"";
	valores = x + valores + x;
	window.open (url,"dogmaApp", valores);
}

</script><% if (ident==1){%><iframe src="http://www.statum.info/StatumChat/status.jsp?id=statum.info.support&lang=es" width="23px" height="21" scrolling="no" style="border: 0px;"></iframe><br><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=1&user=skbitil&pass=entradaskbitil&proCode=1072&type=P&entCode=1084',event);return false;">Dudas y Sugerencias</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=1&user=skbitil&pass=entradaskbitil&proCode=1068&type=P&entCode=1084',event);return false;">Bug Report</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=1&user=skbitil&pass=entradaskbitil&proCode=1067&type=P&entCode=1084',event);return false;">Nueva funcionalidad</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=1&user=skbitil&pass=entradaskbitil&proCode=1071&type=P&entCode=1084',event);return false;">Modificar funcionalidad</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=1&user=skbitil&pass=entradaskbitil&proCode=1070&type=P&entCode=1084',event);return false;">Nueva licencia</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=1&user=skbitil&pass=entradaskbitil&proCode=1069&type=P&entCode=1084',event);return false;">Nuevo contacto</a><br><% }else if (ident==3){%><iframe src="http://www.statum.info/StatumChat/status.jsp?id=statum.info.support&lang=en" width="23px" height="21" scrolling="no" style="border: 0px;"></iframe><br><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=3&user=skbitil&pass=entradaskbitil&proCode=1072&type=P&entCode=1084',event);return false;">Doubts and Suggestions</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=3&user=skbitil&pass=entradaskbitil&proCode=1068&type=P&entCode=1084',event);return false;">Bug Report</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=3&user=skbitil&pass=entradaskbitil&proCode=1067&type=P&entCode=1084',event);return false;">New functionality</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=3&user=skbitil&pass=entradaskbitil&proCode=1071&type=P&entCode=1084',event);return false;">Modify functionality</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=3&user=skbitil&pass=entradaskbitil&proCode=1070&type=P&entCode=1084',event);return false;">New licence</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=3&user=skbitil&pass=entradaskbitil&proCode=1069&type=P&entCode=1084',event);return false;">New contact</a><br><% }else if (ident==2){%><iframe src="http://www.statum.info/StatumChat/status.jsp?id=statum.info.support&lang=pt" width="23px" height="21" scrolling="no" style="border: 0px;"></iframe><br><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=2&user=skbitil&pass=entradaskbitil&proCode=1072&type=P&entCode=1084',event);return false;">D�vidas e Sugest�es</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=2&user=skbitil&pass=entradaskbitil&proCode=1068&type=P&entCode=1084',event);return false;">Bug Report</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=2&user=skbitil&pass=entradaskbitil&proCode=1067&type=P&entCode=1084',event);return false;">Nova funcionalidade</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=2&user=skbitil&pass=entradaskbitil&proCode=1071&type=P&entCode=1084',event);return false;">Alterar funcionalidade</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=2&user=skbitil&pass=entradaskbitil&proCode=1070&type=P&entCode=1084',event);return false;">Nova licen�a</a><br><a class="skbServices" href="#" onclick="callService('http://www.statum.biz/Itil/programs/login/open.jsp?lang=2&user=skbitil&pass=entradaskbitil&proCode=1069&type=P&entCode=1084',event);return false;">Novo contato</a><br><% }%>