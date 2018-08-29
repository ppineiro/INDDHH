<%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="com.dogma.vo.ErrMessageVo"%><%@page import="com.st.util.StringUtil"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js"></script><SCRIPT language="javascript">
	function fnStartDocInit(){
		var aux=function(){try {
			hideResultFrame();
			} catch (e) {}
	<%
	int intErrors = 0;
	String errMessage = null;
	
	if (session.getAttribute("dBean") != null) {
		com.dogma.bean.execution.EntInstanceBean tmpBean= (com.dogma.bean.execution.EntInstanceBean) session.getAttribute("dBean");
		%>window.parent.closeWindow('<%=tmpBean.getEntity().getBusEntInstNameNum()%>');<%
		tmpBean.clearMessages();	
	}
	%>
	}
	setTimeout(aux,300);
	}
</SCRIPT><body onload="fnStartDocInit()">
LOADED
</body>