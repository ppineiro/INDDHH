<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.vo.custom.*"%><%@page import="com.dogma.business.*"%><%@page import="com.dogma.bean.scheduler.SchedulerBean"%><%@page import="com.dogma.dao.DataBaseDAO"%><%@page import="java.util.*"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.business.querys.factory.*" %><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML XMLNS:CONTROL><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.AdministrationBean"></jsp:useBean><% QryChartVo chartVo = dBean.getQryChartVo(); %><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><script language="javascript">
//document.onload= function(){
	var ret = window.parent.openModal("/query.AdministrationAction.do?action=openChartDesign",610,525);
	var doafter=function(ret){
		if (ret != null) {
			var chartNum = window.parent.document.getElementById("selRowNum");
			var tblChart = window.parent.document.getElementById("tblChart");
			var selectedChart = tblChart.getElementsByTagName("TR")[chartNum.value];
			selectedChart.getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value = ret;
		}else{
			var chartNum = window.parent.document.getElementById("selRowNum");
			var tblChart = window.parent.document.getElementById("tblChart");
			var selectedChart = tblChart.getElementsByTagName("TR")[chartNum.value];
			var title = selectedChart.getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
			if (title == ""){			
				var trows = window.parent.document.getElementById("gridChart").rows;
				var row=trows[trows.length - 1];
				row.parentNode.removeChild(row);
			}
		}
	}
	ret.onclose=function(){
		doafter(ret.returnValue);
	}
//}
</script></head><body></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %>


