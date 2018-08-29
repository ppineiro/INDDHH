<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML XMLNS:CONTROL><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.BusinessClassesBean"></jsp:useBean><% BusClassVo busClaVo = dBean.getBusinessClassesVo(); %><script language="javascript" defer="true">
	/*
	if(document.addEventListener){
		document.addEventListener('load', function(){
			window.parent.returnValue="<%= busClaVo.getBusClaUploadedFileName() %>";
			window.parent.close();
		}
		, false);
	}else{
		document.body.onload=function(){
			window.parent.returnValue="<%= busClaVo.getBusClaUploadedFileName() %>";
			window.parent.close();
		}
	}
	*/
	function init(){		
		window.parent.returnValue="<%= busClaVo.getBusClaUploadedFileName() %>";
		window.parent.close();
		//closeModal();
	}
</script><script src="<%=Parameters.ROOT_PATH%>/programs/administration/businessClasses/update.js"></script></head><body onload="init()"></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %>


