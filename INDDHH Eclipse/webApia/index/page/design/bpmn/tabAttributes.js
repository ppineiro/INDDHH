
function initTabAttributes(){	
	
	var strTxts = ['txtAttName1','txtAttName2','txtAttName3','txtAttName4','txtAttName5'];
	var strIds =  ['hidAttId1','hidAttId2','hidAttId3','hidAttId4','hidAttId5'];
	var strOpts = ['optAttId1','optAttId2','optAttId3','optAttId4','optAttId5'];
	
	var numTxts = ['txtAttNameNum1','txtAttNameNum2','txtAttNameNum3'];
	var numIds =  ['hidAttIdNum1','hidAttIdNum2','hidAttIdNum3'];
	var numOpts = ['optAttIdNum1','optAttIdNum2','optAttIdNum3'];
		
	var dteTxts = ['txtAttNameDte1','txtAttNameDte2','txtAttNameDte3'];
	var dteIds =  ['hidAttIdDte1','hidAttIdDte2','hidAttIdDte3'];
	var dteOpts = ['optAttIdDte1','optAttIdDte2','optAttIdDte3'];
	
	strTxts.each(toUpper);
	numTxts.each(toUpper);
	dteTxts.each(toUpper);
	
	addAttributeBehaviors(strTxts, strIds, strOpts, ['S.att_type.S']); //colType.colName.colValue
	addAttributeBehaviors(numTxts, numIds, numOpts, ['S.att_type.N']);
	addAttributeBehaviors(dteTxts, dteIds, dteOpts, ['S.att_type.D']);
	
	disabledAllTabAttributes();
}

function disabledAllTabAttributes(){
	if (MODE_DISABLED){
    	var tabContent = $('contentTabAttributes');
    	tabContent.getElements("input").each(function(input){
    		input.disabled = true;
    		input.readOnly = true;
    		input.addClass("readonly");
    	});
    	tabContent.getElements("select").each(function(select){
    		select.disabled = true;
    		select.readOnly = true;
    		select.addClass("readonly");
    	});
    	tabContent.getElements("div.optionRemove").each(function(optionRemove){
    		optionRemove.removeEvents('click');
    	});
    }
}

function toUpper(ele){
	ele = $(ele);
	if (ele) { 
		ele.addEvent("keyup",function(e){
			if (ele.value != null && ele.value != ""){
				ele.value = ele.value.toUpperCase();
			}
		});
	}		
}

function addAttributeBehaviors(txts, ids, opts, adtFilters) {
	for (var i = 0; i < txts.length; i++) {
		var txt = $(txts[i]);
		var id = $(ids[i]);
		var opt = $(opts[i]);
		
		opt.htmlTxt = txt;
		opt.htmlId = id;
		opt.addEvent('click', function(evt){			
			if (! this.hasClass('optionRemove')) return;
			if(evt && evt.client.x < evt.target.getPosition().x + evt.target.getWidth() - 15) return;
			
			var cmbAtts = $('cmbAtts');
			var options = cmbAtts.options;
			if (options != null){
				for (var j = 0; j < options.length; j++) {
					var theOption = options[j];
					if ((this.htmlId.value+'') == (theOption.value+'') && this.htmlId == theOption.theHtmlId) {
						cmbAtts.removeChild(theOption);
						break;
					}
				}
			}				
			
			this.htmlTxt.value = '';
			this.htmlTxt.disabled = false;
			this.htmlTxt.removeClass("readonly");
			
			this.htmlTxt.value = '';
			this.htmlId.value = '';
			this.htmlId.oldValue = '';
		});
		
		opt.tooltip(DEL_ATT_TT, { mode: 'auto', width: 100, hook: 0 });
		
		txt.htmlIds = ids;
		txt.htmlIdsPosition = i;
		txt.htmlId = id;
		txt.htmlOpt = opt;
		txt.addEvent('click', function(evt){if (evt) evt.stopPropagation(); });		
		
		txt.addEvent('optionSelected', function(visible,fromClick,fromEnter){
			if (!visible || fromClick || fromEnter){
				this.fireEvent('change');				
			}
		});
		txt.addEvent('change', function(){
			if (this.htmlId.value == "") return;
			
			var cmbAtts = $('cmbAtts');
			var exist = false;
			var hasOption = false;
			var options = cmbAtts.options;
			if (options != null){
				for (var i = 0; i < options.length && !exist && !hasOption; i++){
					var theOption = options[i];
					hasOption = theOption.theHtmlId == this.htmlId;
					exist = theOption.theHtmlId != this.htmlId && (theOption.value + '') == (this.htmlId.value + '');
				}
			}
			
			this.disabled = true;
			this.addClass("readonly");
			
			if (!exist) { 
				if (! hasOption) {
					var aOption = new Element('option', {value: this.htmlId.value, html: this.htmlId.value});
					aOption.theHtmlId = this.htmlId;
					aOption.inject(cmbAtts);
				}
			} else { //att repetido
				this.htmlOpt.fireEvent('click');
			}
		});		
		
		setAutoCompleteGeneric(txt , id, 'search', 'attribute', 'att_name', 'att_id_auto', 'att_name', false, true, false, true, true, adtFilters);
						
		if (id.value != "") txt.fireEvent('optionSelected');
	}
}