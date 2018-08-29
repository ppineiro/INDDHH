<%@ taglib uri='regions' prefix='region'%>
<%@include file="../page/includes/startInc.jsp" %>
<html>
<head>
	<%@include file="../page/includes/headInclude.jsp" %>
	<link href="<system:util show="context" />/css/documentum/execution/generalExecution.css" rel="stylesheet" type="text/css">
	<link href="<system:util show="context" />/css/documentum/common/modal.css" rel="stylesheet" type="text/css">
	<region:render section='scripts_include' />
	<script type="text/javascript">
		currentTab = <%=request.getParameter("currentTab") != null ? request.getParameter("currentTab") : "2"%>;
		

		function cargarElementos(){
			document.getElementById("imgHelpVideo").style.background = "url("+ getUrlApp() + "/css/documentum/img/menu/help_12.png)";
		}
		
		function showMenu(){
			document.getElementById("pinHidden").style.display = "block";
			document.getElementById("menuContainer").style.display = "block";
			document.getElementById("tabHolder").style.width = "auto";				
			document.getElementById("tabComponent").style.width = "100%";
			var tas = document.getElementsByTagName("textarea");
			document.getElementById("txtComment").style.width = "100%";			
		}
		
		function hiddeMenu(){
			document.getElementById("pinHidden").style.display = "none";
			document.getElementById("menuContainer").style.display = "none";
			document.getElementById("tabHolder").style.width = "96%";
			document.getElementById("tabComponent").style.width = "135%";
			
			var tas = document.getElementsByTagName("textarea");
			for (var i = 0; i < tas.length; i++) {
			    tas[i].style.width = "104%";
			}
			
			var ghs = document.getElementsByClassName("gridHeader");
			for (var i = 0; i < tas.length; i++) {
				ghs[i].style.width = "104%";
			}
			
			var gbs = document.getElementsByClassName("gridBody");
			for (var i = 0; i < tas.length; i++) {
				gbs[i].style.width = "104%";
			}
			
			var gfs = document.getElementsByClassName("gridFooter");
			for (var i = 0; i < tas.length; i++) {
				gfs[i].style.width = "104%";
			}
			
			document.getElementById("txtComment").style.width = "100%";	
		}
		
		function helpVideo(){			
			var URL = getUrlApp() + "/expedientes/videos/helpVideo.jsp?context=" + getUrlApp() + "&video=iniciarExp" + "&" + TAB_ID_REQUEST;
			var tab = { title: "Video de ayuda", url: URL };
			parent.tabContainer.addNewTab(tab.title, tab.url);
		}
		
		
	</script>
		
	<style type="text/css">
		/* Div General */
		#menuContainer { position: absolute; width: 310px; height: 600px; display: inline-block; float: right; right: 0px; z-index: 1; background-color: #FFF; }
		
		/* Panel de la tarea */	
		#taskContent { position: relative; width: 300px; height: 110px; }
		#imgTask{ position: absolute; top: 10%; left: 5%; background: url(templates/img/iniciar_expediente.png); background-size: 45px; background-repeat: no-repeat; width: 45px; height: 55px; }
		#descTask{ position: absolute; top: 20%; left: 25%; width: 190px; font-size: 12px; }
		span.titImage{ display: none !important; }
		span.proTitle{ display: inline; font-weight: bold; font-size: 12px; }
		span.taskTitle{ display: inline; font-weight: bold; font-size: 12px; }
		#imgHelpVideo { cursor: pointer; width: 12px; height: 12px; position: relative; left: 90%; top: 18%; }
		
		/* Menu de acciones */
		#buttonsActions{ position: absolute ; top: 16%; height: 135px; width: 310px; }			
		div.options { top: 47%; position: absolute; width: 310px; }
		
		/* Ocultar menu */
		#pinHidden { position: absolute; top: 0%; left: 98%; width: 20px; height: 20px; background-image: url("templates/img/pinHide.png"); background-repeat: no-repeat; background-position: 0% 0%; cursor:pointer; z-index: 2; }
		#pinShow { position: absolute; top: 0%; left: 98%; display: block; cursor: pointer; width: 20px; height: 20px; background-image: url("templates/img/pinShow.png"); background-repeat: no-repeat; background-position: 0% 0%; z-index: 2; }
			
	</style>
	
</head>

<body onLoad="cargarElementos()">
	<div id="exec-blocker"></div>
	<div class="header">
		
	</div>
	
	<div class="body" id="bodyDiv">
		<form id="frmData" action="" method="post">
			<span id="pinShow" onClick="showMenu()"></span>
			<span id="pinHidden" onClick="hiddeMenu()"></span>
		
			<div id="menuContainer" class="optionsContainer">
				<div class="fncPanel info">
					<div class="campaign"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /></div>
					<div class="title">
						<span class="title"><region:render section='title' /></span>
						<span class="panelPinShow" id="panelPinShow">&nbsp;</span>
					</div>
					<div id="taskContent" class="content divFncDescription">
						<div id="imgTask"></div>
						<div id="descTask">Tarea en la cual se crea un expediente.</div>
						<div id="imgHelpVideo" onClick="helpVideo()"></div>
					</div>
				</div>			
				
				<div id="buttonsActions">
					<region:render section='buttons' />
					<%boolean eDocsEsActivo = ConfigurationManager.isEDOCS(envId, uData.getLangId(), false);%>
					<%if(!eDocsEsActivo){ %>
						<div class="fncPanel options">
							<region:render section='helpDocuments' />
						</div>
					<%} %>
					
					<region:render section='apiaSocial' />
					
					<system:campaign inLogin="false" inSplash="false" location="verticalDown" />
				</div>
			</div>	
			
			<div class="dataContainer">
				<div class='tabComponent' id="tabComponent">
					<div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div>
					<div class='aTab'>
						<div class='tab'  style="display:none;"><system:label show="text" label="tabEjeFor"/></div>
						<div class='contentTab'>
							<region:render section='entityForms' />
							<region:render section='processForms' />
						</div>
					</div>
					<div class='aTab'>
						<div class='tab' id="tabComments"><system:label show="text" label="tabEjeObs"/></div>
						<div class='contentTab'>
							<region:render section='taskComments' />
						</div>
					</div>

					</div> 
				</div>
				<system:campaign inLogin="false" inSplash="false" location="horizontalDown" />		 
						
		</form>
	</div>
	
	<!-- ESTOS INCLUDES DEBEN IR EN ESTE LUGAR PARA QUE NO SALGA UN CARTEL CUANDO SE ESTA CARGANDO EL TEMPLATE EN CHROME -->
	<%@include file="../page/includes/footer.jsp" %>
	<%@include file="../page/modals/documents.jsp" %>
	<%@include file="../page/modals/calendarsView.jsp" %>
	<%@include file="../page/social/socialShareMdl.jsp" %>
	<%@include file="../page/social/socialReadChannelMdl.jsp" %>	
	<%@include file="../page/execution/includes/endInclude.jsp" %>
	<%@include file="../expedientes/jsp/CustomJSP-EXP-ELEC.jsp" %>
	
</body>

</html>

