<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.business.*"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.dao.DataBaseDAO"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.business.querys.factory.*" %><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML XMLNS:CONTROL><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.AdministrationBean"></jsp:useBean><% QryChartVo chartVo = dBean.getQryChartVo(); %><script language="javascript" defer="true">
	if(document.addEventListener){
		document.addEventListener('load', function(){
			window.returnValue="<%= chartVo.getQryChtTitle() %>";
			window.close();
		}
		, false);
	}else{
		document.body.onload=function(){
			window.returnValue="<%= chartVo.getQryChtTitle() %>";
			window.close();
		}
	}
	function init(){
		window.returnValue="<%= chartVo.getQryChtTitle() %>";
		window.close();
	}
</script></head><body onload="init()"></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %>


