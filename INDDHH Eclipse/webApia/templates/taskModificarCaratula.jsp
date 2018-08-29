<%@ taglib uri='regions' prefix='region'%>
<%@include file="../page/includes/startInc.jsp" %>
<%@include file="../page/includes/headInclude.jsp" %>
<%@include file="../expedientes/jsp/CustomJSP-EXP-ELEC.jsp" %>

<html>
<head>
		
	<link href="<system:util show="context" />/css/documentum/execution/generalExecution.css" rel="stylesheet" type="text/css">
	<link href="<system:util show="context" />/css/documentum/common/modal.css" rel="stylesheet" type="text/css">
	<region:render section='scripts_include' />
	<script type="text/javascript">
		currentTab = <%=request.getParameter("currentTab") != null ? request.getParameter("currentTab") : "3"%>;
		
		
		function loadCancelButton(){
			var actions 		= document.getElementById("divAdminActEdit");
			
			var divCancel 		= document.createElement("div");
			divCancel.className	= "btnCancelar";
			divCancel.id 		= "btnCancelar";
			divCancel.onclick 	= function callConfirmCloseMC() { confirmCloseMC(); };
			
			var lblCancel 		= document.createElement("label");
			lblCancel.className = "lblBtnCancelar";
			lblCancel.innerHTML = "Cancelar"
			
			divCancel.insertBefore(lblCancel,null);			
			actions.insertBefore(divCancel,null);	
			
		}
		
		function confirmCloseMC(){
			var title	= "Cancelar modificación de carátula";
			var msg		= "¿Desea cancelar la modificación de la carátula?"			
			showConfirm(msg, title, function(res) { if(res) closeMC(); });
		}
		
		function closeMC(){
			
			var title	= "";
			var msg		= "Espere un momento por favor..."			
			showMessage(msg , title);			
			
			document.getElementsByClassName("modalContent")[1].childNodes[2].childNodes[0].style.display = "none";
			
			var formMC 		= "MODIFICAR_CARATULA";
			var formFirma	= "FIRMA_MODIFICACION_CARATULA"
			
			var myForm = ApiaFunctions.getForm(formMC);
			if (myForm == null){ myForm = ApiaFunctions.getForm(formFirma); }
			
			var myButton = myForm.getField('BCC_Cancelar'); 
			myButton.fireClickEvent();
			
		}
		
	</script>
	
	<style>
	
		div.btnCancelar {
			background: -webkit-gradient(linear, 0 0, 0 100%, from(#ffffff) to(#EFEFEF));
		    background: -webkit-linear-gradient( #ffffff, #EFEFEF);
		    background: -moz-linear-gradient( #ffffff, #EFEFEF);
		    background: -ms-linear-gradient( #ffffff, #EFEFEF);
		    background: -o-linear-gradient( #ffffff, #EFEFEF);
		    background: linear-gradient( #ffffff, #EFEFEF);
    
		    position: absolute;
		    top: 19.5%;
		    left: 34%;
		    height: 26px;
		    width: 93px;
		    border: 1px solid silver;
		    border-radius: 3px;
		    margin-left: 0px;
		    margin-right: 0px;
		    margin-bottom: 8px;
		    padding-bottom: 1px;
		    
		    cursor: pointer;
	    }
	    
	    div.btnCancelar:hover {
	    	background: -webkit-gradient(linear, 0 0, 0 100%, from(#D2CFCF) to(#EFEFEF));
	    	background: -webkit-linear-gradient( #D2CFCF, #EFEFEF);   	
	    	background: -moz-linear-gradient( #D2CFCF, #EFEFEF);
	    	background: -ms-linear-gradient( #D2CFCF, #EFEFEF);
	    	background: -o-linear-gradient( #D2CFCF, #EFEFEF);
	    	background: linear-gradient( #D2CFCF, #EFEFEF);
	    }
    
    	label.lblBtnCancelar {
    		color: #606060;
    		font-family: Verdana,Arial,Tahoma;
		    font-size: 8pt;
		    font-weight: bold;
		    text-align: center;
		    position: relative;
		    top: 27%;
		    left: 22%;
    	}
    
    	#btnCloseTab { display: none; }
    
    	#menuContainer { position: absolute; width: 310px; height: 300px; display: inline-block; float: right; right: 0px; z-index: 1; background-color: #FFF; }
    	#taskInfoContainer { position: absolute; width: 310px; height: 125px; }
    	#taskContent { position: absolute; top: 20%; width: 300px; height: 60px; }
    	#imgTask { position: absolute; top: 10%; left: 5%; background: url(templates/img/cambio_caratula.png); background-size: 45px; background-repeat: no-repeat; width: 45px; height: 46px; }
    	#descTask { position: absolute; top: 11%; left: 25%; width: 175px; font-size: 12px; text-align: justify; }
    	#buttonsActions{ position: absolute ; top: 30%; width: 310px; }
    	
    	span.titImage{ display: none; }
		span.proTitle{ display: inline; font-weight: bold; font-size: 12px; }
		span.taskTitle{ display: inline; font-weight: bold; font-size: 12px; }
				
	</style>
</head>

<body onLoad="loadCancelButton()">
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
						<div id="descTask">Tarea en la cual se pueden realizar cambios en la carátula de un expediente.</div>
						<div class="clear"></div>
					</div>
					
				</div>			
				
				<div id="buttonsActions" class="buttonsActions">					
					<region:render section='buttons' />					
					
					<div class="fncPanel options" style="display:none">
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
	
<%@include file="../page/includes/footer.jsp" %>
<%@include file="../page/modals/documents.jsp" %>
<%@include file="../page/modals/calendarsView.jsp" %>
<%@include file="../page/social/socialShareMdl.jsp" %>
<%@include file="../page/social/socialReadChannelMdl.jsp" %>	
<%@include file="../page/execution/includes/endInclude.jsp" %>
</body>

</html>