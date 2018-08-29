var isReadyPage;
var isLeave;
function initPage(){
	isReadyPage = false;
	
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition();
	initAdminFav();
	
	setFieldsProperties();
	initImgMdlPage();
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
	
	$('fncType').fireEvent('change');
	
	var changeImg = $('changeImg');
	if (changeImg){
		changeImg.addEvent("click",function(e){
			e.stop();
			showImagesModal(processImg);
		});
	}
	
	resetChangeHighlight();
	
	isReadyPage = true;
}


function processImg(ret){
	if (ret != null){
		$('changeImg').style.backgroundImage = "url('"+ret.path+"')";
		$('txtFncImg').value=ret.id;
	}
}


function setFieldsProperties(){
	var fncName = $('fncName');
	var fncURL = $('fncURL');
	var fncTooltip = $('fncTooltip');
	var fncFather = $('fncFather');
	var fncType = $('fncType');
	var fncOrder = $('fncOrder');
	var fncTypeEje = $('fncTypeEje');
	var fncFatherShow = $('fncFatherShow');
	var fncTypeShow = $('fncTypeShow');
	var fncTypeEjeShow = $('fncTypeEjeShow');
	var fncRecommended = $('fncRecommended');
	var fncRecIcon = $('fncRecIcon');
	
	fncType.addEvent('change', function(evt) {
		var disabled = this.options[this.selectedIndex].value != 'L';
		fncURL.disabled = disabled;
		fncTypeEje.disabled = disabled;
		
		if (this.value == 'L'){
			//fncRecommended.disabled = false;
			isLeave = true;
		} else {
			//fncRecommended.disabled = true;
			//if (isReadyPage == true) fncRecommended.checked = false;
			if ($('fncRecommended').value == "true"){
				$('fncRecIcon').fireEvent('click');
			}
			isLeave = false;
		}
	});
	
	fncRecIcon.addEvent("click", function(e){
		if (e) e.stop();
		if (isLeave){
			this.toggleClass("fncRecommended");
			this.toggleClass("fncNoRecommended");
			$('fncRecommended').value = !toBoolean($('fncRecommended').value);
		}
	});
	
	if (allEnv && !modeGlobal) {
		if (fncGroup != 4){ //Si no fue creada por el usuario
			fncName.readOnly = true;
			fncName.addClass("readonly");
			fncTooltip.readOnly = true;
			fncTooltip.addClass("readonly");
			fncURL.readOnly = true;
			fncURL.addClass("readonly");
			fncOrder.readOnly = true;
			fncOrder.addClass("readonly");
		}
		
		fncTypeEje.setStyle("display","none");
		fncTypeEjeShow.readOnly = true;
		fncTypeEjeShow.addClass("readonly");
		fncTypeEjeShow.setStyle("display","");

		fncFather.setStyle("display","none");
		fncFatherShow.readOnly = true;
		fncFatherShow.addClass("readonly");
		fncFatherShow.setStyle("display","");
		
		fncType.setStyle("display","none");
		fncTypeShow.readOnly = true;
		fncTypeShow.addClass("readonly");
		fncTypeShow.setStyle("display","");
 		
	} else if (fncFolder || fncGroup != 4){
		if (fncGroup != 4){ //Si no fue creada por el usuario	
			fncName.readOnly = true;
			fncName.addClass("readonly");
			fncTooltip.readOnly = true;
			fncTooltip.addClass("readonly");
			fncURL.readOnly = true;
			fncURL.addClass("readonly");
		}
		
		fncTypeEje.setStyle("display","none");
		fncTypeEjeShow.readOnly = true;
		fncTypeEjeShow.addClass("readonly");
		fncTypeEjeShow.setStyle("display","");

		if (!dw || fncFather.value == admFncFather) {
			fncFather.setStyle("display","none");
			fncFatherShow.readOnly = true;
			fncFatherShow.addClass("readonly");
			fncFatherShow.setStyle("display","");
		}

		fncType.setStyle("display","none");
		fncTypeShow.readOnly = true;
		fncTypeShow.addClass("readonly");
		fncTypeShow.setStyle("display","");
	} 
	
 	if (fncGroup != 4){ //Si no fue creada por el usuario
 		fncType.disabled = true;
	}	
}