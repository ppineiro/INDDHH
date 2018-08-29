<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dogma.Parameters"%>
	
<html>

	<head>
	
		<%
		String organismo = "AGESIC";
// 		String organismo = "EDOCS";
		
		String image = "";
		
		if (organismo.equals("AGESIC")) {
			image = "agesic_eDocs.png";
		}
				
		if (organismo.equals("EDOCS")) {
			image = "eDocs.png";
		}
		
		String imageUrl = Parameters.ROOT_PATH + "/paneles/login/img/logos/" + image;		
		%>
	
		<script type="text/javascript">
		
			function cargarEstiloLogoRight(){
				

				var organismo = "<%=organismo%>";	
				
				if (organismo == "AGESIC") {
					document.getElementById("logoRight").style.position	= "relative";
					document.getElementById("logoRight").style.top		= "20%";
					document.getElementById("logoRight").style.left		= "2%";	
					document.getElementById("logoRight").style.width	= "30%";
				}
				
			}
			
			function clickCoesys(){
			 	//var type=img.getAttribute("type");
			 	//var cmbLang=document.getElementById("cmbLang");
			 	//var langId=cmbLang.options[cmbLang.selectedIndex].value;
			 	var desktopURL="coesys.response";
			 	//if(type=="desk"){
			 	//	desktopURL="coesys.response";
			 	//}
			 	//desktopURL+=langId;
			 	abrirSis(desktopURL,2);
			}


			function abrirSis(desktopURL,valores){
				height = screen.availHeight-30;
				width = screen.availWidth-10;

				if (valores == "1") {
					if (height > 570) {
						height = 570;
					}
					if (width > 790) {
						width = 790;
					}
				}

//				if (valores=="1"){
//					valores="height= " + 570 + " , " + "width= " + 790
//				}else{
//					valores="height= " + (screen.availHeight-30) + " , " + "width= " + (screen.availWidth-10)
//				}
				valores = "height= " + height + " , " + "width= " + width;
				valores = "toolbar=no,location=no,status=no,menubar=no,resizable=no,scrollbars=yes,top=0,left=0," + valores;
				x="\"";
				valores = x + valores + x;
				<% String sessionId = session.getId();
				sessionId = sessionId.replaceAll("\\.","");
				sessionId = sessionId.replaceAll(" ","");
				sessionId = sessionId.replaceAll("_","");
				sessionId = sessionId.replaceAll(",","");
				sessionId = sessionId.replaceAll("-","");
				sessionId = sessionId.replaceAll("!","");
				if (sessionId.length() > 50) sessionId = sessionId.substring(0,49);
				%>
				
				//var win=window.open (desktopURL,"dogmaApp<%=sessionId%>", valores);
				//win.focus();
				window.location.href = desktopURL;
				
			}
			
		
		</script>
	
		<style type="text/css">
			
			#boxRightImgContainer {
				height:50px;
				width: 50px;
				
				
			}
			div.pnl_PNL_LP_LOGO_AGESIC img {
				height: 30px !important;
/* 				text-align: center !important */
				
			}
			div.pnl_PNL_LP_LOGO_AGESIC {
 				text-align: center !important;
				margin-top: 150px !important;
			}
			
			
		</style>
		
	</head>
	
	<body>
	
		<div id='boxRightImgContainer' class='box ApiaDocumentum'>
			<img id='logoRight' class ='logoRight' src='<%=imageUrl%>' onclick='clickCoesys()'>
		</div>
		
	</body>
	
</html>
