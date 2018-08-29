<%@ taglib uri='regions' prefix='region'%>
<%@include file="../page/includes/startInc.jsp" %>
<%@include file="../page/includes/headInclude.jsp" %>
<%@include file="../expedientes/jsp/CustomJSP-EXP-ELEC.jsp" %>


<html>
	<head>
			
		<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css">
		<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/modal.css" rel="stylesheet" type="text/css">
		<region:render section='scripts_include' />
		
		<script type="text/javascript">
			currentTab = <%=request.getParameter("currentTab") != null ? request.getParameter("currentTab") : "3"%>;
						
			function actuar(){
				var myForm = ApiaFunctions.getForm('TABSBUTTONS'); 
				var myButton = myForm.getField('ACTUAR'); 
				myButton.fireClickEvent();
			}
			
			function elem_fisc(){
				var myForm = ApiaFunctions.getForm('TABSBUTTONS');
				var myButton = myForm.getField('ELEM_FISICA'); 
				myButton.fireClickEvent();
			}
			
			function acc_rest(){
				var myForm = ApiaFunctions.getForm('TABSBUTTONS'); 
				var myButton = myForm.getField('ACC_REST'); 
				myButton.fireClickEvent();
			}
			
			function hist(){
				var myForm = ApiaFunctions.getForm('TABSBUTTONS'); 
				var myButton = myForm.getField('HISTORIAL'); 
				myButton.fireClickEvent();
			}
			
			function acords(){
				var myForm = ApiaFunctions.getForm('TABSBUTTONS'); 
				var myButton = myForm.getField('ACORDONADOS'); 
				myButton.fireClickEvent();
			}
			
			function relads(){
				var myForm = ApiaFunctions.getForm('TABSBUTTONS'); 
				var myButton = myForm.getField('RELACIONADOS'); 
				myButton.fireClickEvent();
			}
			
			function incorporados(){
				var myForm = ApiaFunctions.getForm('TABSBUTTONS'); 
				var myButton = myForm.getField('INCORPORADOS'); 
				myButton.fireClickEvent();
			}
			
			function modf_cara(){
				var myForm = ApiaFunctions.getForm('TABSBUTTONS'); 
				var myButton = myForm.getField('MODF_CARA'); 
				myButton.fireClickEvent();
			}
			
		</script>
	
		<style type="text/css">
		
			/* Div General */
			#menuContainer { position: absolute; width: 310px; height: 600px; display: inline-block; float: right; right: 0px; z-index: 1; background-color: #FFF; }
			
			/* Panel de la tarea */	
			#taskInfoContainer { position: absolute; width: 310px; height: 125px; }
			#taskTitleContainer { position: absolute; top: 0%; }
			#taskContent { position: absolute; top:20%; width: 300px; height: 100px; }
			#imgTask { position: absolute; top: 10%; background: url(/Apia/templates/img/realizar_actuacion.png); background-size: 80px; background-repeat: no-repeat; width: 80px; height: 90px; } 
			#descTask{ position: absolute; top: 28%; left: 30%; width: 190px; font-size: 12px; }
			div.titImage{ display: inline; }
			div.proTitle{ display: inline; font-weight: bold; font-size: 12px; }
			div.taskTitle{ display: inline; font-weight: bold; font-size: 12px; }			
			
			/* Menu de funcionalidades */
			#tabMenuContainer { position: absolute; top: 25%; width: 310px; height: 150px; }
			#menuTabTable { position: absolute; top: 20%; left: 2%; width: 300px; height: 36px; border: 0px solid yellowgreen; }
			div.title{ border-bottom: 1px solid #CCCCCC; color: #464646; font-size: 12px; line-height: 20px; margin: 0; padding-left: 5px; padding-right: 2px; font-weight: bold; }
			
			div.actuar { position: absolute; width: 26px; height: 26px; top: 10%; left: 1.5%; border: 0px solid blue; cursor: pointer; }
			div.actuar:hover{ background-color: #F4F8FB; }
			#imgActuar { position: absolute; left: 7%; top: 0%; width: 24px; }
						
			div.modf_cara { position: absolute; width: 26px; height: 26px; top: 10%; left: 14%; border: 0px solid blue; cursor: pointer; }
			div.modf_cara:hover{ background-color: #F4F8FB; }
			#imgModCar { position: absolute; left: 5%; top: 5%; width: 24px; }			
						
			div.elem_fisc { position: absolute; width: 26px; height: 26px; top: 10%; left: 39%; border: 0px solid blue; cursor: pointer; }
    		div.elem_fisc:hover{ background-color: #F4F8FB; }
			#imgElemFisc { position: absolute; left: 5%; top: 5%; width: 24px; }
						
			div.acc_rest { position: absolute; width: 26px; height: 26px; top: 10%; left: 51.5%; border: 0px solid blue; cursor: pointer; }
    		div.acc_rest:hover{ background-color: #F4F8FB;}
			#imgAccRest { position: absolute; left: -5%; top: -5%; width: 28px; }
					
			div.hist { position: absolute; width: 26px; height: 26px; top: 10%; left: 26%; border: 0px solid blue; cursor: pointer; }
			div.hist:hover{ background-color: #F4F8FB;}
			#imgHist { position: absolute; left: 5%; top: 5%; width: 24px; }
						
			div.acords { position: absolute; width: 26px; height: 26px; top: 10%; left: 64%; border: 0px solid blue; cursor: pointer; }
			div.acords:hover{ background-color: #F4F8FB; }
			#imgAcord { position: absolute; left: 5%; top: 5%; width: 24px; }
						
			div.relads { position: absolute; width: 26px; height: 26px; top: 10%; left: 76.5%; border: 0px solid blue; cursor: pointer; }
			div.relads:hover{ background-color: #F4F8FB; }
			#imgRelac { position: absolute; left: 5%; top: 5%; width: 24px; }
						
			div.incorporados { position: absolute; width: 26px; height: 26px; top: 10%; left: 89%; border: 0px solid blue; cursor: pointer; }
			div.incorporados:hover{ background-color: #F4F8FB; }
			#imgIncPar { position: absolute; left: 1%; top: -1%; width: 24px; }
						
			/* Menu de botones */
			#buttonsActions{ position: absolute ; top: 40%; }
			
			/* Estilo de elementos */			
			div#hmenu ul { list-style: none; margin: 5; padding: 0; list-style-type: none; }			
			div#hmenu ul li { margin: 0; padding: 0; display: inline; }			
			div#hmenu ul a:link{ margin: 0; padding: .3em .4em .3em .4em; text-decoration: none; font-weight: bold; font-size: medium; } 
			div#hmenu ul a:visited{ margin: 0; padding: .3em .4em .3em .4em; text-decoration: none; font-weight: bold; font-size: medium; } 
			div#hmenu ul a:active{ margin: 0; padding: .3em .4em .3em .4em; text-decoration: none; font-weight: bold; font-size: medium; } 
			div#hmenu ul a:hover{ margin: 0; padding: .3em .4em .3em .4em; text-decoration: none; font-weight: bold; font-size: medium; }
			
		</style>
	</head>
	
	<body>
		<div id="exec-blocker"></div>
		<div class="header">
			
		</div>
		
		<div class="body" id="bodyDiv">
			<form id="frmData" action="" method="post">
			
				<div id="menuContainer" class="optionsContainer">
					
						<div id="taskInfoContainer" class="campaign"><system:campaign inLogin="false" inSplash="false" location="verticalUp" />				
							<div style="border-bottom: 1px solid #CCCCCC; width: 310px; height: 20px;">
								<span class="title"><region:render section='title' /></span>		
							</div>
							
							<div id="taskContent">
									<div id="imgTask"></div>
									<div id="descTask">Tarea en la cual se trabaja con el expediente.</div>
							</div>
										
						</div>
						
						<div id="tabMenuContainer">
							
							<div class="title">
								<span> Funcionalidades </span>							
							</div>
							
							<div id="menuTabTable" class="content divFncDescription">
							
									<ul style="list-style-type: none;"> 
										
										<li>
										<div class="actuar" onClick="actuar()">
										<a title="Actuar">&nbsp;<img id="imgActuar" src="/Apia/expedientes/iconos/tabsbuttons/actuar.png">&nbsp;</a>
										</div>
										</li>
											
										<li>
										<div class="modf_cara" onClick="modf_cara()">
											<a title="Modificar carátula"><img id="imgModCar" src="/Apia/expedientes/iconos/tabsbuttons/cambio_caratula.png">&nbsp;</a>
										</div>
										</li>
											 
										<li>
										<div class="elem_fisc" onClick="elem_fisc()">
										<a title="Elementos físicos"><img id="imgElemFisc" src="/Apia/expedientes/iconos/tabsbuttons/elemfisc.png">&nbsp;</a>
										</div>
										</li>
											 
										<li>
										<div class="acc_rest" onClick="acc_rest()">
										<a title="Acceso restringido"><img id="imgAccRest" src="/Apia/expedientes/iconos/tabsbuttons/accrestr.png">&nbsp;</a>
										</div>
										</li>
											 
										<li>
										<div class="hist" onClick="hist()">
										<a title="Historial de actuaciones"><img id="imgHist" src="/Apia/expedientes/iconos/tabsbuttons/history.png">&nbsp;</a>
										</div>
										</li>
											 
										<li>
										<div class="acords" onClick="acords()">
										<a title="Vinculaciones acordonado"><img id="imgAcord"  src="/Apia/expedientes/iconos/tabsbuttons/acordonado.png">&nbsp;</a>
										</div>
										</li>
											 
										<li>
										<div class="relads" onClick="relads()">
										<a title="Vinculaciones simples"><img id="imgRelac" src="/Apia/expedientes/iconos/tabsbuttons/relacionado.png">&nbsp;</a>
										</div>
										</li>
											 
										<li>
										<div class="incorporados" onClick="incorporados()">
										<a title="Incorporación parcial"><img id="imgIncPar" src="/Apia/expedientes/iconos/tabsbuttons/incorporados.png">&nbsp;</a>
										</div>
										</li>
											
									</ul>   
							
							</div>
						</div>				
					
					<div id="buttonsActions" class="buttonsActions">
						<region:render section='buttons' />
						
						<div class="fncPanel options">
							<region:render section='helpDocuments' />
						</div>
						
						<region:render section='apiaSocial' />
						
						<system:campaign inLogin="false" inSplash="false" location="verticalDown" />
					</div>
					
				</div>	
				
				<div class="dataContainer">
					<div class='tabComponent' id="tabComponent">
						<div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div>
						<div class='aTab'>
							<div class='tab'  style="display:none"><system:label show="text" label="tabEjeFor"/></div>
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
						<div class='aTab'>
							<div class='tab' style="display:none" id="tabDocs"><system:label show="text" label="tabEjeDoc"/></div>
							 <div class='contentTab'>
								<region:render section='entityDocuments' />
								<region:render section='processDocuments' />
							</div>
						</div>
					</div>
					<system:campaign inLogin="false" inSplash="false" location="horizontalDown" />					
						
				</div>	
			 	
			</form>
		</div>
		
		<!-- ESTOS INCLUDES DEBEN IR EN ESTE LUGAR PARA QUE NO SALGA UN CARTEL CUANDO SE ESTA CARGANDO EL TEMPLATE EN CHROME -->
		<%@include file="../page/includes/footer.jsp" %>
		<%@include file="../page/modals/documents.jsp" %>
		<%@include file="../page/modals/calendarsView.jsp" %>
		<%@include file="../page/social/socialShareMdl.jsp" %>
		<%@include file="../page/social/socialReadChannelMdl.jsp" %>	
		<%@include file="../page/execution/includes/endInclude.jsp" %>
		
	</body>

</html>