var spModalCal;

var RESULTSMODAL_HIDE_OVERFLOW = true;

function initResultsMdlPage(){
	var mdlResultsContainer = $('mdlResultsContainer');
	if (mdlResultsContainer.initDone) return;
	mdlResultsContainer.initDone = true;

	mdlResultsContainer.blockerModal = new Mask();
	
	spModalCal = new Spinner($('mdlBodyRes'),{message:WAIT_A_SECOND});
	
	//Close
	$('closeResultsMdl').addEvent("click", function(e) {
		if (e) { e.stop(); }
		closeResultsMdl();
	});
	
}

function showResultsModal(){
	
	if(RESULTSMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	var mdlResultsContainer = $('mdlResultsContainer');
	mdlResultsContainer.removeClass('hiddenModal');
	mdlResultsContainer.position();
	mdlResultsContainer.blockerModal.show();
	mdlResultsContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlResultsContainer.setStyle('top', '100px');
	
	spModalCal.show(true);

	var lineBreak = '<br>';
	
	var buffer = '';
	var content = ApiaShellCommand.getResultContainer();
	if (content && content.length > 0){
		for (var i = 0; i < content.length; i++){
			var resComm = content[i];
			
			//Comando ejecutado
			if (resComm.sintax != '') {
				buffer += '<b style="color:#5A89A2;">' + MSG_SINTAX_ERROR + ':</b>';
				buffer += lineBreak;
				buffer += lineBreak;
			}
			
			buffer += '<b>' + resComm.command + '</b>';
			buffer += lineBreak;
			buffer += lineBreak;
			
			//Resultado del comando ejecutado
			if (resComm.result && resComm.result.length > 0){
				for (var j = 0; j < resComm.result.length; j++){
					buffer += resComm.result[j];
					buffer += lineBreak;
				}
			}
			buffer += lineBreak;
			
			if (i+1 < content.length){
				buffer += lineBreak;
				buffer += lineBreak;
			}
		}
	}
	
	$('resultContainer').innerHTML = buffer;
	
	spModalCal.hide(true);
}

function closeResultsMdl(){
    var mdlResultsContainer = $('mdlResultsContainer');
    
    $('resultContainer').innerHTML = '';
    
    if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlResultsContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlResultsContainer.addClass('hiddenModal');
			mdlResultsContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlResultsContainer.blockerModal.hide();
			if (mdlResultsContainer.onModalClose) mdlResultsContainer.onModalClose();
			
			if(RESULTSMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlResultsContainer.addClass('hiddenModal');
		
	    mdlResultsContainer.blockerModal.hide();
		if (mdlResultsContainer.onModalClose) mdlResultsContainer.onModalClose();
		
		if(RESULTSMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
    
}