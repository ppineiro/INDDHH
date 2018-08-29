
function initPage(){
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition();	
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
	
	$$("input.datePicker").each(setAdmDatePicker);
	$$('img.datepickerSelector').each(function(img){
		img.setStyle("margin-top","-2px");
	});
	
	parTypeOnChange($('parType'));
	onChangeFlagReq($('parFlagRequired'));
}

function parTypeOnChange(parType){
	var valStr = $('parValStr');
	var valNum = $('parValNum');
	var valDte = $('parValDte');
	var valDtePick = valDte.getNext("img.datepickerSelector");
	var valCmb = $('parValCmb');
	var valChk = $('parValChk');
	var parFlagRequired = $('parFlagRequired');
	var parFlagReadonly = $('parFlagReadonly');
	
	if (parType.value == TYPE_INTEGER){
		valStr.value = '';
		valStr.setStyle("display","none");
		
		valDte.value = '';
		valDte.getNext().value = '';
		valDte.setStyle("display","none");
		valDte.getNext().setStyle("display","none");
		valDtePick.setStyle("display","none");
		
		valCmb.selectedIndex = 0;
		valCmb.setStyle("display","none");
		
		valChk.checked = false;
		valChk.setStyle("display","none");
		
		valNum.setStyle("display","");
		
		parFlagRequired.disabled = false;
	
	} else if (parType.value == TYPE_DATE){
		valStr.value = '';
		valStr.setStyle("display","none");
		
		valNum.value = '';
		valNum.setStyle("display","none");
		
		valCmb.selectedIndex = 0;
		valCmb.setStyle("display","none");
		
		valChk.checked = false;
		valChk.setStyle("display","none");
		
		valDte.setStyle("display","none");
		valDte.getNext().setStyle("display","");
		valDtePick.setStyle("display","");
		
		parFlagRequired.disabled = false;
	
	} else if (parType.value == TYPE_BOOL_COMBO){
		valDte.value = '';
		valDte.getNext().value = '';
		valDte.setStyle("display","none");
		valDte.getNext().setStyle("display","none");
		valDtePick.setStyle("display","none");
		
		valNum.value = '';
		valNum.setStyle("display","none");
		
		valChk.checked = false;
		valChk.setStyle("display","none");
		
		valStr.value = '';
		valStr.setStyle("display","none");
		
		valCmb.setStyle("display","");
		
		parFlagRequired.checked = false;
		parFlagRequired.disabled = true;
		
	} else if (parType.value == TYPE_CHECKBOX){
		valDte.value = '';
		valDte.getNext().value = '';
		valDte.setStyle("display","none");
		valDte.getNext().setStyle("display","none");
		valDtePick.setStyle("display","none");
		
		valNum.value = '';
		valNum.setStyle("display","none");
		
		valStr.value = '';
		valStr.setStyle("display","none");
		
		valCmb.selectedIndex = 0;
		valCmb.setStyle("display","none");
		
		valChk.setStyle("display","");
		
		parFlagRequired.checked = false;
		parFlagRequired.disabled = true;
		
	} else { //TYPE_STRING
		valDte.value = '';
		valDte.getNext().value = '';
		valDte.setStyle("display","none");
		valDte.getNext().setStyle("display","none");
		valDtePick.setStyle("display","none");
		
		valNum.value = '';
		valNum.setStyle("display","none");
		
		valCmb.selectedIndex = 0;
		valCmb.setStyle("display","none");
		
		valChk.checked = false;
		valChk.setStyle("display","none");
		
		valStr.setStyle("display","");
		
		parFlagRequired.disabled = false;
	}
	
	onChangeFlagReq(parFlagRequired);
}

function onChangeFlagReq(chkReq){
	if (chkReq.checked){
		$('fieldValue').addClass("required");
	} else {
		$('fieldValue').removeClass("required");
	}
}

function cusParRequired(ele){
	var error = false;
	var parType = $('parType');
	if ($('parFlagRequired').checked){
		if (ele.get('cusParType') == TYPE_STRING && parType.value == TYPE_STRING){
			error = ele.value == '';			
		} else if (ele.get('cusParType') == TYPE_INTEGER && parType.value == TYPE_INTEGER){
			error = ele.value == '';
		} else if (ele.get('cusParType') == TYPE_DATE && parType.value == TYPE_DATE){
			error = ele.value == '';
		}
		
		if (error){
			ele.errors.push(formcheckLanguage.required);
	        return false;
		} 
	}
	return true;
}
