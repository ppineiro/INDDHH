var IMAGEMODAL_HIDE_OVERFLOW	= true;

function initImgMdlPage() {
	var mdlImageContainer = $('mdlImageContainer');
	if (mdlImageContainer.initDone) return;
	mdlImageContainer.initDone = true;

	mdlImageContainer.blockerModal = new Mask();
	
	var btnCloseImageModal = $('btnCloseImageModal');
	var btnConfirmImageModal = $('btnConfirmImageModal');
	
	if (btnCloseImageModal) { btnCloseImageModal.addEvent("click", closeImagesModal); }
	
	mdlImageContainer.lastSelected = null;
	mdlImageContainer.style.overFlow = 'auto';
	mdlImageContainer.getSelectedImage = function() {
		if (this.lastSelected != null) return this.lastSelected.adtData;
		return null;
	}
	
	if (btnConfirmImageModal) {
		btnConfirmImageModal.addEvent('click', function(evt){
			var mdlImageContainer = $('mdlImageContainer');
			if (mdlImageContainer.onModalConfirm) jsCaller(mdlImageContainer.onModalConfirm,mdlImageContainer.getSelectedImage());
			closeImagesModal();
		});
	}
}

function showImagesModal(retFunction, closeFunction){
	
	if(IMAGEMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	var mdlImageContainer = $('mdlImageContainer');
	mdlImageContainer.removeClass('hiddenModal');
	mdlImageContainer.position();
	mdlImageContainer.blockerModal.show();
	mdlImageContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlImageContainer.onModalConfirm = retFunction;
	mdlImageContainer.onModalClose = closeFunction;

	var request = new Request({
		method: 'post',
		url: CONTEXT + '/apia.modals.ImagesAction.run?' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) { processXMLImages(resXml);}
	}).send();
}

function closeImagesModal(){
	var mdlImageContainer = $('mdlImageContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlImageContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlImageContainer.addClass('hiddenModal');
			mdlImageContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlImageContainer.blockerModal.hide();
			if (mdlImageContainer.onModalClose) mdlImageContainer.onModalClose();
			
			if(IMAGEMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlImageContainer.addClass('hiddenModal');
		
		mdlImageContainer.blockerModal.hide();
		if (mdlImageContainer.onModalClose) mdlImageContainer.onModalClose();
		
		if(IMAGEMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
	
	
}

function processXMLImages(ajaxCallXml){
	if (ajaxCallXml != null) {
		var images = ajaxCallXml.getElementsByTagName("images");
		if (images != null && images.length > 0 && images.item(0) != null) {
			images = images.item(0).getElementsByTagName("image");
			var mdlImageViewer = $('mdlImageViewer');
			mdlImageViewer.empty();
			mdlImageContainer.lastSelected = null;
			
			for(var i = 0; i < images.length; i++) {
				var image = images.item(i);
				
				var name = image.getAttribute("name");
				var id = image.getAttribute("id");
				var path = image.getAttribute("path");
				var description = image.getAttribute("description");
				
				var element = new Element("div", {'class': 'elementImage'}); element.style.width = "47%";
				var imgCont = new Element("div", {'class': 'imgContainer'});
				imgCont.setStyle('background-image', 'url(' + path + ')');
				imgCont.inject(element);
				new Element('div', {'html': name, 'class': 'imgName'}).inject(element);
				new Element('div', {'html': description, 'class': 'imgDescription'}).inject(element);

				element.adtData = {
					name : name,
					id : id,
					path : path,
					description : description
				};
				
				element.addEvent('click', mldImageSelected);
				
				element.inject(mdlImageViewer);
			}
			
			mdlImageContainer.position();
		}
	}
}

function mldImageSelected(evt) {
	var mdlImageContainer = $('mdlImageContainer');
	if (mdlImageContainer.lastSelected != null) mdlImageContainer.lastSelected.toggleClass("elementImageSelected");
	mdlImageContainer.lastSelected = this;
	mdlImageContainer.lastSelected.toggleClass("elementImageSelected");
	
}
