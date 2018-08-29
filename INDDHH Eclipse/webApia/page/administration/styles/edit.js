var objectsArray;

function initPage() {
	
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	
	initAdminFav();
	initAdminActionsEdition();
	
	$$('img.colorPicker').each(function(item) {
		colorPicker(item);
	});
	
	$('btnHeaderImage').addEvent("click", function(e) {
		e.stop();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=ajaxUploadStartImage&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	})
		
	var divElements = ['divFont', 'divHeader', 'divFooter', 'divMenu', 'divUserMenu', 'divFunctionalities', 'divTables', 'divButtons', 'divSplash', 'divLogInButtons', 'divModals'];
	var checkElements = ['prmtModFont', 'prmtModHeader', 'prmtModFooter', 'prmtModMenu', 'prmtModUserMenu', 'prmtModFunct', 'prmtModTables', 'prmtModButtons','prmtModSplash', 'prmtModLogInButtons', 'prmtModModals'];
	
	objectsArray = [
		$('prmtButtonsColorFromDiv'), $('prmtButtonsHoverFromDiv'), $('prmtButtonsSugColorFromDiv'), $('prmtButtonsHoverSugColorFromDiv'), 
		$('prmtButtonsColorToDiv'), $('prmtButtonsHoverToDiv'),	$('prmtButtonsSugColorToDiv'),	$('prmtButtonsHoverSugColorToDiv'), //buttons
		$('prmtHeaderColorFromDiv'), $('prmtHeaderColorToDiv'), //header
		$('prmtLgInBttnColorFromDiv'), $('prmtLgInBttnHoverFromDiv'), $('prmtLgInBttnColorToDiv'), $('prmtLgInBttnHoverToDiv') //lgInBttns
	];
	
	
	for (i = 0; i < objectsArray.length; i++) {
		var elem = objectsArray[i];
		if (elem.id.contains('Header')) {
			if ($('prmtHeaderUseDegrade').checked) {
				if (elem.id.endsWith('ToDiv'))
					elem.style.display = '';
				else {
					elem.style.float = 'left';
					elem.style.marginRight = '20px';
					elem.style.display = '';
					elem.style.className = 'left-div';
					elem.style.width = '';
				}
			} else {
				if (elem.id.endsWith('ToDiv')) 
					elem.style.display = 'none';
				else {
					elem.style.marginBottom = '5px';
					elem.style.display = '';
					elem.style.className = '';
					elem.style.width = '100%';
				}
			}
		} else if (elem.id.contains('LgIn')) {
			if ($('prmtLgInBttnUseDegrade').checked) {
				if (elem.id.endsWith('ToDiv'))
					elem.style.display = '';
				else {
					elem.style.float = 'left';
					elem.style.marginRight = '20px';
					elem.style.display = '';
					elem.style.className = 'left-div';
					elem.style.width = '';
				}
			} else {
				if (elem.id.endsWith('ToDiv'))
					elem.style.display = 'none';
				else {
					elem.style.marginBottom = '5px';
					elem.style.display = '';
					elem.style.className = '';
					elem.style.width = '100%';
				}
			}
		} else {
			if ($('prmtButtonsUseDegrade').checked) {
				if (elem.id.endsWith('ToDiv'))
					elem.style.display = '';
				else {
					elem.style.float = 'left';
					elem.style.marginRight = '20px';
					elem.style.display = '';
					elem.style.className = 'left-div';
					elem.style.width = '';
				}
			} else {
				if (elem.id.endsWith('ToDiv'))
					elem.style.display = 'none';
				else {
					elem.style.marginBottom = '5px';
					elem.style.display = '';
					elem.style.className = '';
					elem.style.width = '100%';
				}
			}
		}
	}
	
	
	// deshabilito todas las opciones de diseño
	for (i = 0; i < divElements.length; i++) {
		if (MODE_CREATE) {
			$(divElements[i]).style.display = 'none';
		} else {
			$(checkElements[i]).checked ? $(divElements[i]).style.display = '' : $(divElements[i]).style.display = 'none'; 
		}
	}
	
	initAdminFieldOnChangeHighlight(false, false, false);
	
	var imgPath = $('imgStyleImage');
	if (imgPath){
		imgPath.set('initialValue', imgPath.src);
		imgPath.addEvent("change",function(){
			var isSameValue = this.src == this.get('initialValue');
			if (! isSameValue) {
				this.addClass("highlighted");
			} else {
				this.removeClass("highlighted");
			}
		});
	}
}

function showDiv(e) {	
	if (e.checked) {
		switch (e.name) {
			case 'prmtModFont'			:	$('divFont').style.display = ''; break;
			case 'prmtModHeader'		:	$('divHeader').style.display = ''; break;
			case 'prmtModFooter'		:	$('divFooter').style.display = ''; break;
			case 'prmtModMenu'			:	$('divMenu').style.display = ''; break;
			case 'prmtModUserMenu'		:	$('divUserMenu').style.display = ''; break;
			case 'prmtModFunct'			:	$('divFunctionalities').style.display = ''; break;
			case 'prmtModTables'		:	$('divTables').style.display = ''; break;
			case 'prmtModButtons'		:	$('divButtons').style.display = ''; break;
			case 'prmtModLogInButtons'	:	$('divLogInButtons').style.display = ''; break;
			case 'prmtModSplash'		:	$('divSplash').style.display = ''; break;
			case 'prmtModModals'		:	$('divModals').style.display = ''; break;
		}
	}
	else {
		switch (e.name) {
			case 'prmtModFont'			:	$('divFont').style.display = 'none'; break;
			case 'prmtModHeader'		:	$('divHeader').style.display = 'none'; break;
			case 'prmtModFooter'		:	$('divFooter').style.display = 'none'; break;
			case 'prmtModMenu'			:	$('divMenu').style.display = 'none'; break;
			case 'prmtModUserMenu'		:	$('divUserMenu').style.display = 'none'; break;
			case 'prmtModFunct'			:	$('divFunctionalities').style.display = 'none'; break;
			case 'prmtModTables'		:	$('divTables').style.display = 'none'; break;
			case 'prmtModButtons'		:	$('divButtons').style.display = 'none'; break;
			case 'prmtModLogInButtons'	:	$('divLogInButtons').style.display = 'none'; break;
			case 'prmtModSplash'		:	$('divSplash').style.display = 'none'; break;
			case 'prmtModModals'		:	$('divModals').style.display = 'none'; break;
		}
	}
}

function showDegrade(e) {
	if (e.checked) {
		switch(e.name) {
			case 'prmtHeaderUseDegrade'		:	$('prmtHeaderColorToDiv').style.display = '';
												$('prmtHeaderColorFromDiv').className='left-div';
												$('prmtHeaderColorFromDiv').style.width='';
												$('prmtHeaderColorFromDiv').style.float = 'left';
												$('prmtHeaderColorFromDiv').style.marginRight = '20px';
												
												break;
			case 'prmtLgInBttnUseDegrade'	:	$('prmtLgInBttnColorToDiv').style.display = '';
												$('prmtLgInBttnColorFromDiv').className='left-div';
												$('prmtLgInBttnColorFromDiv').style.width='';
												$('prmtLgInBttnHoverToDiv').style.display = '';
												$('prmtLgInBttnHoverFromDiv').className='left-div';
												$('prmtLgInBttnHoverFromDiv').style.width='';
												$('prmtLgInBttnHoverFromDiv').style.float = 'left';
												$('prmtLgInBttnColorFromDiv').style.float = 'left';
												$('prmtLgInBttnHoverFromDiv').style.marginRight = '20px';
												$('prmtLgInBttnColorFromDiv').style.marginRight = '20px';
												
												break;
			case 'prmtButtonsUseDegrade'	:	$('prmtButtonsColorToDiv').style.display = '';
												$('prmtButtonsColorFromDiv').className='left-div';
												$('prmtButtonsColorFromDiv').style.width='';
												$('prmtButtonsHoverToDiv').style.display = '';
												$('prmtButtonsHoverFromDiv').className='left-div';
												$('prmtButtonsHoverFromDiv').style.width='';
												$('prmtButtonsSugColorToDiv').style.display = '';
												$('prmtButtonsSugColorFromDiv').className='left-div';
												$('prmtButtonsSugColorFromDiv').style.width='';
												$('prmtButtonsHoverSugColorToDiv').style.display = '';
												$('prmtButtonsHoverSugColorFromDiv').className='left-div';
												$('prmtButtonsHoverSugColorFromDiv').style.width='';
												$('prmtButtonsHoverFromDiv').style.float = 'left';
												$('prmtButtonsColorFromDiv').style.float = 'left';
												$('prmtButtonsSugColorFromDiv').style.float = 'left';
												$('prmtButtonsHoverSugColorFromDiv').style.float = 'left';
												$('prmtButtonsHoverFromDiv').style.marginRight = '20px';
												$('prmtButtonsColorFromDiv').style.marginRight = '20px';
												$('prmtButtonsSugColorFromDiv').style.marginRight = '20px';
												$('prmtButtonsHoverSugColorFromDiv').style.marginRight = '20px';
												break;
		}
	} else {
		switch(e.name) {
			case 'prmtHeaderUseDegrade'		:	$('prmtHeaderColorToDiv').style.display = 'none'; 
												$('prmtHeaderColorFromDiv').className='';
												$('prmtHeaderColorFromDiv').style.width='100%';
												$('prmtHeaderColorFromDiv').style.marginBottom = '5px';
												break;
			case 'prmtLgInBttnUseDegrade'	:	$('prmtLgInBttnColorToDiv').style.display = 'none';
												$('prmtLgInBttnColorFromDiv').className='';
												$('prmtLgInBttnColorFromDiv').style.width='100%';
												$('prmtLgInBttnHoverToDiv').style.display = 'none';
												$('prmtLgInBttnHoverFromDiv').className='';
												$('prmtLgInBttnHoverFromDiv').style.width='100%';
												$('prmtLgInBttnColorFromDiv').style.marginBottom = '5px'; 
												$('prmtLgInBttnHoverFromDiv').style.marginBottom = '5px';
												break;
			case 'prmtButtonsUseDegrade'	:	$('prmtButtonsColorToDiv').style.display = 'none';
												$('prmtButtonsColorFromDiv').className='';
												$('prmtButtonsColorFromDiv').style.width='100%';
												$('prmtButtonsHoverToDiv').style.display = 'none';
												$('prmtButtonsHoverFromDiv').className='';
												$('prmtButtonsHoverFromDiv').style.width='100%';
												$('prmtButtonsSugColorToDiv').style.display = 'none';
												$('prmtButtonsSugColorFromDiv').className='';
												$('prmtButtonsSugColorFromDiv').style.width='100%';
												$('prmtButtonsHoverSugColorToDiv').style.display = 'none';
												$('prmtButtonsHoverSugColorFromDiv').className='';
												$('prmtButtonsHoverSugColorFromDiv').style.width='100%';
												$('prmtButtonsColorFromDiv').style.marginBottom = '5px';
												$('prmtButtonsHoverFromDiv').style.marginBottom = '5px';
												$('prmtButtonsSugColorFromDiv').style.marginBottom = '5px';
												$('prmtButtonsHoverSugColorFromDiv').style.marginBottom = '5px';
												break;
		}
	}
}

function colorPicker(ele){
	var div = ele.getParent("div");
	var inputValue = div.getElement("input");
	var inputColor = div.getElements("input")[1];
	
	var rgb = hexToRgb(inputValue.value.toUpperCase());
	var r = rgb != null ? rgb.r : 255;
	var g = rgb != null ? rgb.g : 0;
	var b = rgb != null ? rgb.b : 0;
	
	var pickerId = inputValue.get('id') + "picker";
	if ($(pickerId)){
		$(pickerId).dispose();
	}
	
	var picker = new MooRainbow(ele, {
		id: inputValue.get('id') + "picker",
		'startColor': [r, g, b],
		'imgPath': CONTEXT + '/js/colorpicker/images/',
		'onChange': function(color) {},
		'onComplete': function(color) {
			inputValue.set('value', color.hex);
			inputValue.value = inputValue.value.toUpperCase();
			inputColor.setStyle('background-color', color.hex);
			this.fireEditionEvent();
		},
		'onCancel':function(color) {}
	});	
}

function hexToRgb(hex) {
    // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
    var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
    hex = hex.replace(shorthandRegex, function(m, r, g, b) {
        return r + r + g + g + b + b;
    });

    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}

function ajaxUploadCallStatusUrlImage() {
	new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + "?action=ajaxUploadFileStatusImage&isAjax=true" + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) {
			modalProcessXml(resXml); }
		}).send();
}

function setFileName(){
	 var ajaxCallXml = getLastFunctionAjaxCall();
	 if (ajaxCallXml != null) {
		 var messages = ajaxCallXml.getElementsByTagName("messages");
		 if (messages != null && messages.length > 0 && messages.item(0) != null) {
			 messages = messages.item(0).getElementsByTagName("message");
			 var message = messages.item(0);
			 if (message.firstChild != null) text = message.firstChild.nodeValue;
			 var id = text;
//			 $('txtUpload').value=fileName;
			 $('imgStyleImage').src = CONTEXT + "/getImageServlet.run?path=" + id + "&height=150&width=150";
			 $('imgStyleImage').fireEvent('change');
		 }
	 }
	 SYS_PANELS.closeAll();
}