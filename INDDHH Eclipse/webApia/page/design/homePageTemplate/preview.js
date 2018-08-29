
var spModalHT;

function initHomeTemplateMdlPage(isEditing){
	var mdlHomeTemplateContainer = $('mdlHomeTemplateContainer');
	if (mdlHomeTemplateContainer.initDone) return;
	mdlHomeTemplateContainer.initDone = true;
	
	if (!isEditing) isEditing = false;
	mdlHomeTemplateContainer.isEditing = isEditing;
	
	$('mdlBodyHT').formChecker = new FormCheck(
		'mdlBodyHT',
		{
			submit:false,
			display : {
				keepFocusOnError : 1,
				tipsPosition: 'left',
				tipsOffsetX: -10
			}
		}
	);
	
	mdlHomeTemplateContainer.blockerModal = new Mask();
	
	spModalHT = new Spinner($('mdlBodyHT'),{message:WAIT_A_SECOND});
	
	$('closeHomeTemplateModal').addEvent("click", function(e) {
		e.stop();
		closeHomeTemplateModal();
	});
		
}

function showHomeTemplateModal(hptName,hptDesc,hptHTML){   
	var mdlHomeTemplateContainer = $('mdlHomeTemplateContainer');
	mdlHomeTemplateContainer.removeClass('hiddenModal');
	mdlHomeTemplateContainer.position();
	mdlHomeTemplateContainer.blockerModal.show();
	mdlHomeTemplateContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());		
	
	mdlHomeTemplateContainer.hptName = hptName;
	mdlHomeTemplateContainer.hptDesc = hptDesc;
	mdlHomeTemplateContainer.hptHTML = hptHTML;
	
	spModalHT.show(true);
	setModal();	
	spModalHT.hide(true);
}

function setModal(){
	var mdlHomeTemplateContainer = $('mdlHomeTemplateContainer');
	if (mdlHomeTemplateContainer.isEditing){
		$('divName').setStyle("display","none");
		$('divDesc').setStyle("display","none");
	} else {
		$('htName').innerHTML = mdlHomeTemplateContainer.hptName;
		$('htDesc').innerHTML = mdlHomeTemplateContainer.hptDesc;
	}
	
	if (mdlHomeTemplateContainer.hptHTML.indexOf("<html>") != 0){
		mdlHomeTemplateContainer.hptHTML = "<html>" + mdlHomeTemplateContainer.hptHTML + "</html>";
	}
	$('tempHtml').innerHTML = mdlHomeTemplateContainer.hptHTML;	
}

function closeHomeTemplateModal(){
    var mdlHomeTemplateContainer = $('mdlHomeTemplateContainer');
    mdlHomeTemplateContainer.addClass('hiddenModal');
    mdlHomeTemplateContainer.blockerModal.hide();    
}
