<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

	<head>
	
	<%
	String context = request.getParameter("context");
	String video = request.getParameter("video");
	String titulo = "";
	
	if (video.equals("") || video.equals("actuar") || video.equals("acc_rest") || video.equals("incorp")){
		titulo = "RA_Actuar.webm";
	}
	
	if (video.equals("elem_fis")){
		titulo = "RA_ElemFiscModCar.webm";
	}
	
	if (video.equals("acordonados") || video.equals("relacionados")){
		titulo = "RA_AcordonarRelacionar.webm";
	}
	
	if (video.equals("iniciarExp")){
		titulo = "IE_CrearExpediente.webm";
	}
	
	if (video.equals("menu")){
		titulo = "MenuPrincipal.webm";
	}
	
	%>
	
	<script type="text/javascript">
		function reziseHeight()  {
			var browserHeight = window.innerHeight;
			browserHeight = browserHeight * 0.95;
			document.getElementById("helpVideo").style.height = browserHeight + "px";
		}
	</script>
	
	<style type="text/css">
		#helpVideo {
		width:100%; border-left: 1px solid black; margin-left: auto; margin-right: auto; display: block;
		}
	
	</style>
	
	</head>
	
	<body onLoad="reziseHeight()">
	
		<object id="helpVideo" data="<%=context%>/expedientes/videos/<%=titulo%>"></object>
		
	</body>
	
</html>