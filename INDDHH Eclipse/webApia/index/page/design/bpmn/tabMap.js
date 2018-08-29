function initTabMapa(){
	$('optionsContainer').addEvent('mouseover', function(evt) {
		if (this.hasClass('hideSections')) this.addClass('forceShowSections');
	});
	
	$('optionsContainer').addEvent('mouseout', function(evt) {
		if (this.hasClass('hideSections')) this.removeClass('forceShowSections');
	});
	
	
	$('tabMap').beforechange = function() {
		if($("cmbEntAsoc").get('value') == "") {
			showMessage(MSG_MUST_SEL_ENTITY);
			
			this.fireEvent("custom_blur");
			
			return false;
		}
	};
	
	//eventos para el tab
    $('tabMap').addEvent("focus", function(evt){
    	
    	$('optionsContainer').addClass('hideSections');
    	$('tabComponent').setStyle('margin-right', 'inherit');
    	var panelOptionsTabMap = $('panelOptionsTabMap');
    	if (panelOptionsTabMap){
    		panelOptionsTabMap.style.display='';
    	}
    	
    	//Workaround para bug de chrome, en el que no se muestran todos los flash. 
    	setTimeout(function() {
			var objects = document.getElementsByTagName('embed');
			for (var i = 0, m = objects.length; i < m; i++) {
			    objects[i].style.display = "";
			}
		}, 1000);
		
    });    
    $('tabMap').addEvent("custom_blur", function(evt){
    //$('tabMap').addEvent("blur", function(evt){
    	$('optionsContainer').removeClass('hideSections');
    	$('tabComponent').setStyle('margin-right', '');
    	var panelOptionsTabMap = $('panelOptionsTabMap');
    	if (panelOptionsTabMap){ 
    		panelOptionsTabMap.style.display='none';
    	}
    });
    
    //Generar Documentacion del Proceso
    var btnGenDoc = $('btnGenDoc');
    if (btnGenDoc){
    	btnGenDoc.addEvent("click", function(evt){
	    	evt.stop();
	    	generateDocumentation();    	
    	});
    	//['btnGenDoc'].each(setTooltip);
    }    	
    
    disabledAllTabMap();
    
//    if(!Browser.ie) {
	    var pDesigner = $('pDesignerContainer');
	    var bodyDiv = $('bodyDiv');
	    var tabHolder = $('tabHolder');
	    $('tabMap').addEvent('focus', function() {
	    	
	    	//Ocultar campa�a
	    	$$('div.campaign').setStyle("display", "none");
	    	
	    	//pDesigner.setStyle('width', pDesigner.getWidth());
	    	pDesigner.setStyle('width', Number.from(bodyDiv.getWidth()) - 15);
	    	pDesigner.setStyle('height', Number.from(bodyDiv.getHeight()) - Number.from(tabHolder.getHeight()) - 44);
	    	bodyDiv.setStyle('height', '99%');
	    	pDesigner.addClass('onscreen').removeClass('offscreen').getParent('div.contentTab').addClass('always-visible');
			//$('panelGenData').style.display='';
		});
		
		//$('tabMap').addEvent('blur', function() {
	    $('tabMap').addEvent('custom_blur', function() {
			if(!this.hasClass('active')) {
				pDesigner.setStyle('width', '98%').addClass('offscreen').removeClass('onscreen');
			}
			//$('panelGenData').style.display='none';
			
			$$('div.campaign').setStyle("display", "block");
			
			bodyDiv.setStyle('height', '');
		});
//    }
}

function disabledAllTabMap(){
	if (MODE_DISABLED){
    	var tabContent = $('contentTabMap');
    	btnGenDoc.removeEvents('click');    	
    }
}

function generateDocumentation(){
	var title = $('txtName').value;
	var desc = $('txtDesc').get('value');
	if (IS_PRO_BPMN){
		generateRTF(title, desc);
	} else {
		showConfirm(
			CONFIRM_PRINT, 
			"", 
			function(ret) {  
				if (ret) { 
					uploadProcessImage();					
				}
				SYS_PANELS.closeAll();
			}, 
			"modalWarning"
		);
	}
}

function generateRTF(title, desc){
	try{
		getFlashMovie("Designer").getRTF(title, desc);
	}catch(e){}
}

function getFlashMovie(movieName) {   
	if (window.document[movieName]){
		return window.document[movieName];
	}
	if (navigator.appName.indexOf("Microsoft Internet")==-1){
		if (document.embeds && document.embeds[movieName]){
			return document.embeds[movieName];
		}
	}else{ 
		return document.getElementById(movieName);
	}  
}  