var Scroller1;
var Scroller2;

function initPage() {
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	cancel = false;
	
	$('frmData').formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: 10,
					tipsOffsetX: -10
				}
			}
	);
	
	var btnConf = $('btnConfi');
	if (btnConf){
		btnConf.addEvent("click",function(e){
			if(!verifyPermissions()){
				return;
			}
			if (flashLoaded) {
				actionAfterFlash = "confirm";
				getFlashObject("shell").SetVariable("call", "getOutputXML");				
			}else{
				if (btnConf_click()){
					sendFormEnt();
				}	
			}
					 
		});
	}
	
	var btnBackToList = $('btnBackToList');
	if (btnBackToList){
		btnBackToList.addEvent("click",function(e){
			e.stop();
			
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = GNR_PER_DAT_ING;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); clickGoBack();\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel);

			SYS_PANELS.refresh();
		});
	}
	
	var btnResetImage = $('btnResetImage');
	if(btnResetImage) {
		btnResetImage.addEvent('click', function(evt) {
			var path = CONTEXT + '/images/uploaded/' + POOL_DEFAULT_IMAGE;
			$('changeImg').setStyle('background-image', 'url(' + path + ')');
			$('txtProjImg').value = POOL_DEFAULT_IMAGE;		
		});
	}
	
	//['btnResetImage'].each(setTooltip);
	
	
	//eventos para tab
    $('generalTab').addEvent("focus", function(evt){
    	$('panelOptions').style.display='';
    	$('btnView').style.display='' 
    	$('btnEstTime').style.display='none'; 
    });
    
    $('generalTab').addEvent("blur", function(evt){
    	$('panelOptions').style.display='none';
    	$('btnView').style.display='none' 
    	$('btnEstTime').style.display='none'; 
    });
    
    $('tabRel').addEvent("focus",function(evt){
    	addScrollTable($('tableDataDes'));
    	addScrollTable($('tableDataAnc'));
    })
    
    $('tabDefIde').addEvent("focus", function(evt){
    	fixTableEnt($('tableDataFormEnt'));	    
    	fixTableEnt($('tableDataFormMonEnt'));
    	fixTableEnt($('tableDataFormPanelEnt'));
    });
    
    var biTab = $('biTab');
    
    //si hay BI
    if(biTab){
    	biTab.addEvent("focus", function(evt){
        	var radSelected = $("radSelected");
        	if (radSelected){
        		if (radSelected.value=="1" && toBoolean(HAS_CUBE)){
        			$('panelOptions').style.display='';
        	    	$('btnView').style.display='none' 
        	    	$('btnEstTime').style.display=''; 
        		}else{
        			$('panelOptions').style.display='none';    		
        		}
        	}else{
        		$('panelOptions').style.display='none';    		
        	}
        });
        
    	biTab.addEvent("blur", function(evt){
        	$('panelOptions').style.display='none';
        	$('btnView').style.display='none' 
        	$('btnEstTime').style.display='none'; 
        });
    }
    
	var cmbTxtTemplate = $('txtTemplate');
	if (cmbTxtTemplate){
		cmbTxtTemplate.addEvent("change", function(e) {
			e.stop();
			changeTemplate();
		});
	}
	
	var changeImg = $('changeImg');
	if (changeImg){
		changeImg.addEvent("click",function(e){
			e.stop();
			showImagesModal(processImg);
		});
	}
	
	$('addStatus').addEvent("click", function(e) {
		e.stop();
		STATUSMODAL_SHOWGLOBAL = true;		
		showStatusModal(processStatusModalReturn);
	});
	
	$('addProcess').addEvent("click", function(e) {
		e.stop();
		STATUSMODAL_SHOWGLOBAL = true;	
		PROCESSMODAL_ADT_SQL = ' and not exists (select * from bus_ent_process bep where bep.env_id = env_id and bep.pro_id = pro_id_auto and bep.pro_ver_id = pro_ver_id) ';
		showProcessModal(processProcessModalReturn);
	});
	
	initFormTable('btnAddFormEnt','btnDeleteFormEnt','btnUpFormEnt','btnDownFormEnt','tableDataFormEnt');
	
	initFormTable('btnAddFormMonEnt','btnDeleteFormMonEnt','btnUpFormMonEnt','btnDownFormMonEnt','tableDataFormMonEnt');
	
	initFormTable('btnAddFormPanelEnt','btnDeleteFormPanelEnt','btnUpFormPanelEnt','btnDownFormPanelEnt','tableDataFormPanelEnt');
	
	var strTxts = ['txtAttName1','txtAttName2','txtAttName3','txtAttName4','txtAttName5','txtAttName6','txtAttName7','txtAttName8','txtAttName9','txtAttName10'];
	var strIds =  ['hidAttId1','hidAttId2','hidAttId3','hidAttId4','hidAttId5','hidAttId6','hidAttId7','hidAttId8','hidAttId9','hidAttId10'];
	var strChks = ['chkAttId1','chkAttId2','chkAttId3','chkAttId4','chkAttId5','chkAttId6','chkAttId7','chkAttId8','chkAttId9','chkAttId10'];
	var strOpts = ['optAttId1','optAttId2','optAttId3','optAttId4','optAttId5','optAttId6','optAttId7','optAttId8','optAttId9','optAttId10'];
	
	var numTxts = ['txtAttNameNum1','txtAttNameNum2','txtAttNameNum3','txtAttNameNum4','txtAttNameNum5','txtAttNameNum6','txtAttNameNum7','txtAttNameNum8'];
	var numIds =  ['hidAttIdNum1','hidAttIdNum2','hidAttIdNum3','hidAttIdNum4','hidAttIdNum5','hidAttIdNum6','hidAttIdNum7','hidAttIdNum8'];
	var numChks = ['chkAttIdNum1','chkAttIdNum2','chkAttIdNum3','chkAttIdNum4','chkAttIdNum5','chkAttIdNum6','chkAttIdNum7','chkAttIdNum8'];
	var numOpts = ['optAttIdNum1','optAttIdNum2','optAttIdNum3','optAttIdNum4','optAttIdNum5','optAttIdNum6','optAttIdNum7','optAttIdNum8'];
		
	var dteTxts = ['txtAttNameDte1','txtAttNameDte2','txtAttNameDte3','txtAttNameDte4','txtAttNameDte5','txtAttNameDte6'];
	var dteIds =  ['hidAttIdDte1','hidAttIdDte2','hidAttIdDte3','hidAttIdDte4','hidAttIdDte5','hidAttIdDte6'];
	var dteChks = ['chkAttIdDte1','chkAttIdDte2','chkAttIdDte3','chkAttIdDte4','chkAttIdDte5','chkAttIdDte6'];
	var dteOpts = ['optAttIdDte1','optAttIdDte2','optAttIdDte3','optAttIdDte4','optAttIdDte5','optAttIdDte6'];
	
	var itemTxts = ['txtAttNameDesc','txtAttNameTitle'];
	var itemIds = ['hidAttIdDesc','hidAttIdTitle'];
	var itemChks = ['chkAttIdDesc','chkAttIdTitle'];
	var itemOpts = ['optAttIdDesc','optAttIdTitle'];
	
	strTxts.each(toUpper);
	numTxts.each(toUpper);
	dteTxts.each(toUpper);
	itemTxts.each(toUpper);
	
	addAttributeBehaviors(strTxts, strIds, strChks, strOpts, ['S.att_type.S'],true); //colType.colName.colValue
	addAttributeBehaviors(numTxts, numIds, numChks, numOpts, ['S.att_type.N'],true);
	addAttributeBehaviors(dteTxts, dteIds, dteChks, dteOpts, ['S.att_type.D'],true);
	
	addAttributeBehaviors(itemTxts, itemIds, itemChks, itemOpts, ['S.att_type.S'],false);
	
	$('btnAddAttEntRelation').addEvent('click', function(evt){
		addNewLineTableAttBusEntRelation('', '', '', '');
	});
	
	$('btnDeleteAttEntRelation').addEvent('click', function(evt){
		evt.stop();
		var tableName = $('tableDataAttEntRelation');
		if(selectionCount(tableName) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var pos = getSelectedRows(tableName)[0].rowIndex;
			var rows=getSelectedRows(tableName);
			for(var i=0;i<rows.length;i++){
				rows[i].destroy();
			}
			
			for (var i=0;i<tableName.rows.length;i++){
				if (i%2==0){
					tableName.rows[i].addClass("trOdd");
				}else{
					tableName.rows[i].removeClass("trOdd");
				}
			}
			
			addScrollTable(tableName);
		}	
	});
	
	$('txtUsrAdm').addEvent("click",function(e){			
		var txtAttName1 = $('txtAttName1');
		var hidAttId1 = $('hidAttId1');
		var chkAttId1 = $('chkAttId1');
		var optAttId1 = $('optAttId1');
		
		optAttId1.addClass('optionRemove'); //agregar la clase para asegurarse de que se va a ejecutar
		optAttId1.fireEvent('click'); //borramos lo que tenga, de esta forma sale del combo y luego actuamos seg�n corresponda

		$('chkCod').disabled = this.checked;
		$('chkTreeEnt').disabled = this.checked;
		
		if (this.checked) { //Agrego el atributo
			hidAttId1.value = LOGIN_ATT_ID;
			txtAttName1.value = LOGIN_ATT_NAME;
			
			txtAttName1.removeClass('autocomplete');
			txtAttName1.addClass('readonly');
			txtAttName1.set('disabled', true);
			
			optAttId1.removeClass('optionRemove');
			
			chkAttId1.checked = true;
			chkAttId1.erase('disabled');
			chkAttId1.setStyle('visibility', 'hidden');
			//hay que colocar la imagen de la pk chucu falta img - document.getElementById('imgUCAtt1EntNeg').style.visibility="visible";
			
			new Element('option', {value: '0', html: LOGIN_ATT_NAME}).inject($('cmbAttText'));
			
			addUserForm('tableDataFormEnt', USRCREATION_FORM_NAME,USRCREATION_FORM_ID);
			addUserFormMonitor('tableDataFormMonEnt', USRCREATION_FORM_NAME, USRCREATION_FORM_ID);
			addUserFormPanel('tableDataFormPanelEnt', USRCREATION_FORM_NAME, USRCREATION_FORM_ID);
			
			txtAttName1.disabled = true;
			
		}else{
			txtAttName1.addClass('autocomplete');
			txtAttName1.removeClass('readonly');
			txtAttName1.erase('disabled', true);
			
			optAttId1.addClass('optionRemove');
			
			chkAttId1.setStyle('visibility', '');
			
			//elimino el formulario
			removeUserForm('tableDataFormEnt', USRCREATION_FORM_ID);
			removeUserFormMonitor('tableDataFormMonEnt', USRCREATION_FORM_ID);
			removeUserFormPanel('tableDataFormPanelEnt', USRCREATION_FORM_ID);
			
			txtAttName1.disabled = false;			
		}
	});
	
	$('chkTreeEnt').addEvent('click', function(evt) {
		var txtAttName2 = $('txtAttName2');
		var hidAttId2 = $('hidAttId2');
		var chkAttId2 = $('chkAttId2');
		var optAttId2 = $('optAttId2');
		
		optAttId2.addClass('optionRemove'); //agregar la clase para asegurarse de que se va a ejecutar
		optAttId2.fireEvent('click'); //borramos lo que tenga, de esta forma sale del combo y luego actuamos seg�n corresponda
		
		var txtAttName1 = $('txtAttName1');
		var hidAttId1 = $('hidAttId1');
		var chkAttId1 = $('chkAttId1');
		var optAttId1 = $('optAttId1');
		
		optAttId1.addClass('optionRemove'); //agregar la clase para asegurarse de que se va a ejecutar
		optAttId1.fireEvent('click'); //borramos lo que tenga, de esta forma sale del combo y luego actuamos seg�n corresponda
		
		$('txtUsrAdm').disabled = this.checked;
		$('chkCod').disabled = this.checked;
		
		if (this.checked) { //Agrego el atributo
			
			hidAttId1.value = CODER_ATT_ID;
			txtAttName1.value = CODER_ATT_NAME;
			
			txtAttName1.removeClass('autocomplete');
			txtAttName1.addClass('readonly');
			txtAttName1.set('disabled', true);
			
			optAttId1.removeClass('optionRemove');
			
			chkAttId1.checked = true;
			chkAttId1.erase('disabled');
//			chkAttId1.setStyle('visibility', 'hidden');
			
			//hay que colocar la imagen de la pk chucu falta img - document.getElementById('imgUCAtt1EntNeg').style.visibility="visible";
			
			new Element('option', {value: '0', html: CODER_ATT_NAME}).inject($('cmbAttText'));		
			
			hidAttId2.value = TREE_ATT_ID;
			txtAttName2.value = TREE_ATT_NAME;
			
			txtAttName2.removeClass('autocomplete');
			txtAttName2.addClass('readonly');
			txtAttName2.set('disabled', true);
			
			optAttId2.removeClass('optionRemove');
			
			chkAttId2.erase('disabled');
			//chkAttId2.checked = true;
			//hay que colocar la imagen de la pk chucu falta img - document.getElementById('imgUCAtt1EntNeg').style.visibility="visible";
			
			new Element('option', {value: '1', html: TREE_ATT_NAME}).inject($('cmbAttText'));
			
			addUserForm('tableDataFormEnt', TREE_FRM_NAME, TREE_FRM_ID);
			addUserFormMonitor('tableDataFormMonEnt', TREE_FRM_NAME, TREE_FRM_ID);
			addUserFormPanel('tableDataFormPanelEnt', TREE_FRM_NAME, TREE_FRM_ID);
			
		} else {
			
			txtAttName1.addClass('autocomplete');
			txtAttName1.removeClass('readonly');
			txtAttName1.erase('disabled', true);
			
			optAttId1.addClass('optionRemove');
			
			chkAttId1.setStyle('visibility', '');
			
			txtAttName2.addClass('autocomplete');
			txtAttName2.removeClass('readonly');
			txtAttName2.erase('disabled', true);
			
			optAttId2.addClass('optionRemove');
			
			//elimino el formulario
			removeUserForm('tableDataFormEnt', TREE_FRM_ID);
			removeUserFormMonitor('tableDataFormMonEnt', TREE_FRM_ID);
			removeUserFormPanel('tableDataFormPanelEnt', TREE_FRM_ID);
			
			//elimino la opcion en el select de text-combo
			var cmbAttText = $('cmbAttText');
			var opts = cmbAttText.getChildren('option');
			for(var i = 0; i < opts.length; i++) {
				if(opts[i].get('html') == 'A_TREE_NODE_PARENT')
					opts[i].destroy();
			}
		}
		
	})
	
	$('chkCod').addEvent('click', function(evt) {
		var txtAttName1 = $('txtAttName1');
		var hidAttId1 = $('hidAttId1');
		var chkAttId1 = $('chkAttId1');
		var optAttId1 = $('optAttId1');
		
		optAttId1.addClass('optionRemove'); //agregar la clase para asegurarse de que se va a ejecutar
		optAttId1.fireEvent('click'); //borramos lo que tenga, de esta forma sale del combo y luego actuamos seg�n corresponda

		$('txtUsrAdm').disabled = this.checked;
		$('chkTreeEnt').disabled = this.checked;
		
		if (this.checked) { //Agrego el atributo
			hidAttId1.value = CODER_ATT_ID;
			txtAttName1.value = CODER_ATT_NAME;
			
			txtAttName1.removeClass('autocomplete');
			txtAttName1.addClass('readonly');
			txtAttName1.set('disabled', true);
			
			optAttId1.removeClass('optionRemove');
			
			chkAttId1.checked = true;
			chkAttId1.erase('disabled');
			chkAttId1.setStyle('visibility', 'hidden');
			
			//hay que colocar la imagen de la pk chucu falta img - document.getElementById('imgUCAtt1EntNeg').style.visibility="visible";
			
			new Element('option', {value: '0', html: CODER_ATT_NAME}).inject($('cmbAttText'));
			
			addUserForm('tableDataFormEnt', CODER_FRM_NAME, CODER_FRM_ID);
			addUserFormMonitor('tableDataFormMonEnt', CODER_FRM_NAME, CODER_FRM_ID);
			addUserFormPanel('tableDataFormPanelEnt', CODER_FRM_NAME, CODER_FRM_ID);
			
		}else{
			txtAttName1.addClass('autocomplete');
			txtAttName1.removeClass('readonly');
			txtAttName1.erase('disabled');
			
			optAttId1.addClass('optionRemove');
			
			chkAttId1.setStyle('visibility', '');
			
			//elimino el formulario
			removeUserForm('tableDataFormEnt', CODER_FRM_ID);
			removeUserFormMonitor('tableDataFormMonEnt', CODER_FRM_ID);
			removeUserFormPanel('tableDataFormPanelEnt', CODER_FRM_ID);
		}
	});
	
	var cmbAttText = $('cmbAttText');
	if (cmbAttText.options.length > 0) {
		var mustBeSelected = cmbAttText.get("mustBeSelected");
		for (var i = 0; i < cmbAttText.options.length; i++) {
			if (cmbAttText.options[i].value == mustBeSelected) {
				cmbAttText.selectedIndex = i;
				break;
			}
		}
	}
	
	var cmbType = $('cmbType');
	if (cmbType){
		if (IS_CUSTOM_TEMPLATE){
			$('txtTemplate').selectedIndex = 3;
			changeTemplate();
		}
		cmbType.addEvent("change",function(e){
			e.stop();
			changeType();
		});
	}
	
	var btnView = $('btnView');
	if (btnView){
		btnView.addEvent("click",function(e){
			e.stop();
			
			var cmbTemplate = $('txtTemplate');
			
			var template = "";
					
			if (cmbTemplate.value == "<CUSTOM>"){
				if ($('customTemplate').value == ""){
					showMessage(MSG_ADD_TEMPLATE, GNR_TIT_WARNING, 'modalWarning');
					return;
				} else {
					template = $('customTemplate').value;
				}   		
			} else {
				template = cmbTemplate.value;												
			}
			
			var width = Number.from(frameElement.getParent("body").clientWidth);
			var height = Number.from(frameElement.getParent("body").clientHeight);
			width = (width*80)/100; //80%
			height = (height*80)/100; //80%
			
			var url = ENT_TEMPLATE_PAGE + "?template=" + template + TAB_ID_REQUEST;
			ModalController.openWinModal(url, width, height, undefined, undefined, false, true, false);
		});
	}
	
	var btnAddDesc = $('btnAddDesc');
	if (btnAddDesc){
		btnAddDesc.addEvent("click",function(e){
			e.stop();
			addRowDesc($('tableDataDes'),null);
		});
	}
	
	var btnDeleteDesc = $('btnDeleteDesc');
	if (btnDeleteDesc){
		btnDeleteDesc.addEvent("click",function(e){
			e.stop();
			if(selectionCount($('tableDataDes')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($('tableDataDes'))[0].rowIndex;
				deleteRow(parseInt(pos),'tableDataDes');
			} 
		});
	}
	
	var btnAddAnc = $('btnAddAnc');
	if (btnAddAnc){
		btnAddAnc.addEvent("click",function(e){
			e.stop();
			addRowAnc($('tableDataAnc'),null);
		});
	}
	
	var btnDeleteAnc = $('btnDeleteAnc');
	if (btnDeleteAnc){
		btnDeleteAnc.addEvent("click",function(e){
			e.stop();
			if(selectionCount($('tableDataAnc')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($('tableDataAnc'))[0].rowIndex;
				deleteRow(parseInt(pos),'tableDataAnc');
			} 
		});
	}
	
	var chkCreateCbe = $('chkCreateCbe');
	if (chkCreateCbe){
		chkCreateCbe.addEvent("click",enableDisable);
	}
	
	if (OK=="ok"){
		$('divAddProfile').addEvent("click", function(e) {
			e.stop();
			if ($('chkCreateCbe').checked){
				STATUSMODAL_SHOWGLOBAL = true;		
				showProfilesModal(processProfilesModalReturn);
			}
		});
		$('divAddNoAccProfile').addEvent("click", function(e) {
			e.stop();
			if ($('chkCreateCbe').checked){
				if ($("txtCbeName")==""){
					showMessage(MSG_CBE_NAME_MISS);
					return;
				}
				STATUSMODAL_SHOWGLOBAL = true;		
				showProfilesModal(processNoAccProfilesModalReturn);
			}
		});
		var btnEstTime = $('btnEstTime');
		if (btnEstTime){
			btnEstTime.addEvent("click",function(e){
				e.stop();
				btnEstTime_click();
			});
		}
		
		initPrfMdlPage();
		loadProfiles();
		loadNoAccProfiles();

		
	}
	
	changeType();
	
	initImgMdlPage();
	
	initStaMdlPage();
	loadStatus();
	
	initProcMdlPage();
	loadProcess();
	
	initFormMdlPage();
	loadForm();
	
	loadFormMon();
	
	loadFormPanel();
	
	loadAttBusEntRelation();
	
	loadRelDesc();
	loadRelAnc();
	
	initPermissions();	
	
	initDocuments(null,"ajaxUploadStartDoc");
	
	initDimensions(toBoolean(HAS_CUBE),OK);
	
	initMeasures(toBoolean(HAS_CUBE),OK);
	
	initDocTypePermitted();
	
	initAdminFieldOnChangeHighlight(false, false);
	
	if (!SHOW_TYPE_FUNCIONALITY) {
		var cmbType = $('cmbType');
		cmbType.remove(cmbType.options[0]);
	}
	
	if(Browser.chrome || Browser.safari/* || Browser.ie && Browser.version >= 10*/)
		$('att-container').getElements('input[type=checkbox]').setStyle('margin-top', '-19px');
	//else if(Browser.ie && Browser.version < 10)
	//	$('att-container').getElements('input[type=checkbox]').setStyle('margin-top', '1px');
	else if(Browser.ie)
		$('att-container').getElements('input[type=checkbox]').setStyle('margin-top', '-21px');
	else if(Browser.firefox)
		$('att-container').getElements('input[type=checkbox]').setStyle('margin-top', '4px');
	
	$('attTab').addEvent('click', function() {
		addScrollTable($('tableDataAttEntRelation'));
	});
	
	if(biTab) {
		biTab.addEvent('click', function() {
			addScrollTable($('gridDims'));
			addScrollTable($('gridMeasures'));
		});
	}
	
	$("flashTab").addEvent("click", function() {
		//Ocultar campa�a
    	$$('div.campaign').setStyle("display", "none");
	}).addEvent("custom_blur", function() {
		//Ocultar campa�a
    	$$('div.campaign').setStyle("display", "block");
	});
	
	
	
	/***/
	var fEventsContainer = $('fEventsContainer');
	var bodyDiv = $('bodyDiv');
	var entStates = $('entStates');
	
	$('flashTab').addEvent('click', function() {
		//Ocultar campa�a
    	$$('div.campaign').setStyle("display", "none");
    	
    	fEventsContainer.addClass('onscreen').removeClass('offscreen').getParent('div.contentTab').addClass('always-visible');
    	
    	//fEventsContainer.setStyle("width", Number.from(bodyDiv.getWidth()) - 15);
    	fEventsContainer.setStyle("width", Number.from(fEventsContainer.getParent('div.contentTab').getWidth()));
    	
		//$('panelGenData').style.display='';
		
		bodyDiv.getElement('div.dataContainer').addClass('dataContainerOffscreen');
		
		$('entStates').setStyle('display', '');
	});
	
	$('flashTab').addEvent('custom_blur', function() {
		
		if(!this.hasClass('active')) {
			fEventsContainer
				.addClass('offscreen')
				.removeClass('onscreen');
		}
		//$('panelGenData').style.display='none';
		bodyDiv.getElement('div.dataContainer').removeClass('dataContainerOffscreen');
		
		$('entStates').setStyle('display', 'none');
		
		$$('div.campaign').setStyle("display", "block");
	});
	
	//eventos para el tab
    $('flashTab').addEvent("focus", function(evt){
    	//$('optionsContainer').addClass('hideSections').getChildren('div').setStyle('margin-bottom', '0px');
    	$('tabComponent').setStyle('margin-right', 'inherit');
    	var panelOptionsTabMap = $('panelOptionsTabMap');
    	if (panelOptionsTabMap) {
    		panelOptionsTabMap.style.display='';
    	}
    });
    
    $('flashTab').addEvent("custom_blur", function(evt) {
    	//$('optionsContainer').removeClass('hideSections').getChildren('div').setStyle('margin-bottom', '');
    	$('tabComponent').setStyle('margin-right', '');
    	var panelOptionsTabMap = $('panelOptionsTabMap');
    	if (panelOptionsTabMap){ 
    		panelOptionsTabMap.style.display='none';
    	}
    });
	/***/
	
	if($('txtUsrAdm').checked) {
		$('chkCod').disabled = true;
		$('chkTreeEnt').disabled = true;
		
		var txtAttName1 = $('txtAttName1');
		var optAttId1 = $('optAttId1');
		var chkAttId1 = $('chkAttId1');
		
		txtAttName1.removeClass('autocomplete');
		optAttId1.removeClass('optionRemove');
		chkAttId1.erase('disabled');
		chkAttId1.setStyle('visibility', 'hidden');
	} else if($('chkCod').checked) {
		$('txtUsrAdm').disabled = true;
		$('chkTreeEnt').disabled = true;
		
		var txtAttName1 = $('txtAttName1');
		var optAttId1 = $('optAttId1');
		var chkAttId1 = $('chkAttId1');
		
		txtAttName1.removeClass('autocomplete');
		optAttId1.removeClass('optionRemove');
		chkAttId1.erase('disabled');
		chkAttId1.setStyle('visibility', 'hidden');
	} else if($('chkTreeEnt').checked) {
		$('chkCod').disabled = true;
		$('txtUsrAdm').disabled = true;
		
		var txtAttName1 = $('txtAttName1');
		var optAttId1 = $('optAttId1');
		var chkAttId1 = $('chkAttId1');
		
		txtAttName1.removeClass('autocomplete');
		optAttId1.removeClass('optionRemove');
		chkAttId1.erase('disabled');
//		chkAttId1.setStyle('visibility', 'hidden');
		
		var txtAttName2 = $('txtAttName2');
		var optAttId2 = $('optAttId2');
		
		txtAttName2.removeClass('autocomplete');
		optAttId2.removeClass('optionRemove');
		
	}
}

var SITE_ESCAPE_AJAX = false;
var selAttsDim = new Array();
var selBasicDatDim = new Array();

var selAttsMea = new Array();
var selBasicDatMea = new Array();

//-------------------------------
//---- Funciones generales
//-------------------------------

function addNewLineTableAttBusEntRelation(attId, attName, entId, entName) {
	var table = $('tableDataAttEntRelation');
	var parent = table.getParent();
	table.selectOnlyOne = true;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	
	var tr = new Element('tr');
	tr.addClass("selectableTR");
	tr.addEvent("click",function(e){ tr.toggleClass("selectedTR"); }); 
	if(table.rows.length%2==0)tr.addClass("trOdd");
	
	var td1 = new Element('td', {width: tdWidths[0]});
	var td2 = new Element('td', {width: tdWidths[1]});
	
	var htmlAttId = new Element('input', {type: 'hidden', name: 'txtAttId', value: attId});
	var htmlAttName = new Element('input', {type: 'text', name: 'txtAttName', value: attName, 'class': 'autocomplete validate[\'required\']', styles: {width: '95%'}});
	htmlAttName.addEvent('click', function(evt){ evt.stop()});
	
	htmlAttId.inject(td1);
	htmlAttName.inject(td1);
	
	var htmlEntId = new Element('input', {type: 'hidden', name: 'txtEntId', value: entId});
	var htmlEntName = new Element('input', {type: 'text', name: 'txtEntName', value: entName, 'class': 'autocomplete validate[\'required\']', styles: {width: '95%'}});
	htmlEntName.addEvent('click', function(evt){ evt.stop()});
	
	htmlEntId.inject(td2);
	htmlEntName.inject(td2);
	
	setAutoCompleteGeneric( htmlAttName , htmlAttId, 'search', 'attribute', 'att_name', 'att_id_auto', 'att_name', false, true, false, true, true);
	setAutoCompleteGeneric( htmlEntName , htmlEntId, 'search', 'bus_entity', 'bus_ent_name', 'bus_ent_id_auto', 'bus_ent_name', false, true, false, true,true);
	
	toUpper(htmlAttName);
	toUpper(htmlEntName);	
	
	td1.inject(tr);
	td2.inject(tr);
	tr.inject(table);
	
	addScrollTable(table);
}

function addAttributeBehaviors(txts, ids, chks, opts, adtFilters,redundant) {
	for (var i = 0; i < txts.length; i++) {
		var txt = $(txts[i]);
		var id = $(ids[i]);
		var chk = $(chks[i]);
		var opt = $(opts[i]);
		
		opt.htmlTxt = txt;
		opt.htmlChk = chk;
		opt.htmlId = id;
		opt.addEvent('click', function(evt){
			if (! this.hasClass('optionRemove')) return;
			if(evt && evt.client.x < evt.target.getPosition().x + evt.target.getWidth() - 15) return;		
			
			this.htmlTxt.value = '';
			this.htmlTxt.disabled = false;
			this.htmlTxt.removeClass("readonly");
			this.htmlId.value = '';
			this.htmlId.oldValue = '';
			this.htmlChk.checked = false;
			this.htmlChk.disabled = true;
			
			var attPosition = this.htmlTxt.get("attPosition");
			var cmbAttText = $('cmbAttText');
			for (var j = 0; j < cmbAttText.options.length; j++) {
				if (attPosition == cmbAttText.options[j].value) {
					cmbAttText.removeChild(cmbAttText.options[j]);
					break;
				}
			}
		});
		
		txt.htmlChk = chk;
		
		chk.addEvent('click', function(evt){if (evt) evt.stopPropagation(); });
		chk.set('title', LBL_ATT_UC);
		
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
		txt.addEvent('change', function(visible){
			this.htmlChk.disabled = false;
			this.disabled = true;
			this.addClass("readonly");
			var attPosition = this.get("attPosition");
			
			var exist = false;
			var hasOption = false;
			var options = $('cmbAttText').options;
			var theOption = null;
			for (var i = 0; i < options.length && !exist && !hasOption; i++){
				theOption = options[i];
				hasOption = theOption.theHtmlId == this.htmlId;
				exist = theOption.theHtmlId != this.htmlId && theOption.innerHTML == this.value;				
			}
			
			if(redundant){
			
				if (!exist) { 
					if (! hasOption) {
						var aOption = new Element('option', {value: attPosition, html: this.value});
						aOption.theHtmlId = this.htmlId;
						aOption.inject($('cmbAttText'));
					} else {
						theOption.innerHTML = this.value;
					}
				} else {
					this.htmlOpt.fireEvent('click');
				}
				
			}
		});
		
		setAutoCompleteGeneric(txt , id, 'search', 'attribute', 'att_name', 'att_id_auto', 'att_name', false, true, false, true, true, adtFilters);
		
		if (id.value != "") txt.fireEvent('change');
	}
}

function registerValidation(obj){
	obj.className="validate['required']";
	$('frmData').formChecker.register(obj);
}

function disposeValidation(obj){
	$('frmData').formChecker.dispose(obj);
}

function deleteRow(pos,tblName) {
	var table = $(tblName);
	var row = table.rows[pos-1];
	inputs = row.getElementsByTagName("input");
	input = inputs.item(0);
	disposeValidation(input);
	row.dispose();
	for (var i=0;i<table.rows.length;i++){
		table.rows[i].setRowId(i);
		if (i%2==0){
			table.rows[i].addClass("trOdd");
		}else{
			table.rows[i].removeClass("trOdd");
		}
	}
	addScrollTable(table);
} 

function downRow(pos,tblName){
	var p = pos-1;
	var table = $(tblName);	
	if (pos==table.rows.length){
		return
	}else{
		table.rows[p].parentNode.insertBefore(table.rows[p+1],table.rows[p]);
		table.rows[p].setRowId(p);
		table.rows[p+1].setRowId(p+1);
		return table.rows[p+1];
	}
}

function upRow(pos,tblName){
	var p = pos-1;
	var table = $(tblName);
	if (p==0){
		return
	}else{
		table.rows[p].parentNode.insertBefore(table.rows[p],table.rows[p-1]);
		table.rows[p-1].setRowId(p-1);
		table.rows[p].setRowId(p);
		return table.rows[p-1];
	}	
}

function myToggle(oTr){
	if (oTr.getParent().selectOnlyOne) {
		var parent = oTr.getParent();
		if (parent.lastSelected) parent.lastSelected.toggleClass("selectedTR");
		parent.lastSelected = oTr;
	}
	oTr.toggleClass("selectedTR"); 
}

//-------------------------------
//---- Confirmar
//-------------------------------

function btnConf_click(){	
	var form = $('frmData');
	if(!form.formChecker.isFormValid()){
		return;
	}
	return verifyCubeData();	
} 

function getFormParametersToSendEnt(form) { //se realiza el encoding de todos los parametros que se envian: encodeURIComponent
	var params = "";
	if (form.childNodes.length > 0) {
		for (var i = 0; i < form.elements.length; i++) {
			var formElement = form.elements[i];
			
			var formEleName = formElement.name;
			var formEleValue = formElement.value;
			var avoidSend = toBoolean(formElement.getAttribute("avoidSend"));
			
			if (avoidSend) continue;
			if (formEleName == null || formEleName == "") continue;
			
			if (formElement.tagName == "TEXTAREA" && toBoolean(formElement.getAttribute("isEditor"))) {
				var inst = tinyMCE.getInstanceById(formElement.id);
				formEleValue = inst.getContent();
				tinyMCE.execCommand('mceRemoveControl', false, formElement.id);
			}
			
			if (formElement.type == "select-multiple") {
				for ( var j = 0; j < formElement.options.length; j++) {
					if (formElement.options[j].selected) {
						if (params != "") params += "&";
						params += formEleName + "=" + encodeURIComponent(formElement.options[j].value);
					}
				}
			}else if ((formElement.type == "checkbox" && formElement.checked) || (formElement.type == "radio" && formElement.checked) || (formElement.type != "radio" && formElement.type != "checkbox"))  {
				if (formElement.getAttribute("hasdatepicker")=="true"){
					formEleValue = $(formElement.id).value;
				}
				if (SITE_ESCAPE_AJAX) formEleValue = escape(formEleValue);
				if (!formElement.disabled){
					if (params != "") params += "&";
					params += formEleName + "=" + encodeURIComponent(formEleValue);
				}
			}
		}
	}
	return params;	
}

function verifyCubeData() {
	if($('chkCreateCbe')!=null && $('chkCreateCbe').checked){
		//Verificamos si ingreso nombre al cubo
		if ($("txtCbeName").value==""){
			showMessage(MSG_MUST_ENT_CBE_NAME);
			return false;
		}
		if(!isValidCubeName($("txtCbeName").value)){
			return false;
		}
		//Verificamos si el nombre del cubo es �nico
		checkExistCubeName($("txtCbeName").value);
		
	}else{
		return true;
	}		
}

function isValidCubeName(s){
	var re = new RegExp("^[a-zA-Z0-9_.]+[^ ]*$");
	if (!s.match(re)) {
		showMessage(MSG_CUBE_NAME_INVALID);
		return false;
	}
	return true;
}

function checkExistCubeName(cubeName,cubeId){
	var request = new Request({
		method: 'post',
		data:{'cubeName':cubeName,'cubeId':cubeId},
		url: CONTEXT + URL_REQUEST_AJAX +'?action=checkExistCbeName' + TAB_ID_REQUEST,		
		onComplete: function(resText, resXml) { continueCube(resXml);}
	}).send();	
}

function continueCube(resXml){
	var html = resXml.getElementsByTagName("text").item(0).firstChild.nodeValue;
	var ok = false;
	if(html == "true"){
		showMessage(MSG_CUBE_NAME_ALREADY_EXIST);
		return false;
    }
	
	//Verificamos si ingreso al menos una dimension
	if ($("gridDims").rows.length < 1){
		showMessage(MSG_MUST_ENT_ONE_DIM);
		return false;
	}
	//Verificamos todas las dimensiones se llamen distinto
	if (!checkDimNames()){
		showMessage(MSG_DIM_NAME_UNIQUE);
		return false;
	}
	//Verificamos dimensiones
	var dimRows=$("gridDims").rows;
	var someAttNoBasic = false;
	for(var i=0;i<dimRows.length;i++){
		var dimName=dimRows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
		var attName = dimRows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0].value;
		var attId = dimRows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
		if(attName == ""){//Verificamos que los nombres de los atributos no sean nulos
			showMessage(MSG_MIS_DIM_ATT);
			return false;
		}
		if (dimName == ""){//Verificamos que los nombres de las dimensiones no sean nulos
			showMessage(MSG_WRG_DIM_NAME);
			return false;
		}
		if (attId>0){
			someAttNoBasic = true;
		}
	}
	
	//Verificamos si ingreso al menos una medida
	if ($("gridMeasures").rows.length < 1){
		showMessage(MSG_MUST_ENT_ONE_MEAS);
		return false;
	}
	
	//Verificamos todas las medidas se llamen distinto
	if (!checkMeasureNames()){
		showMessage(MSG_MEASURE_NAME_UNIQUE);
		return false;
	}
	
	//Verificamos medidas
	var meaRows=$("gridMeasures").rows;
	var visible = false;
	for(var i=0;i<meaRows.length;i++){
		var meaName=meaRows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
		if (meaName == ""){//Verificamos que los nombres de las medidas no sean nulos
			showMessage(MSG_WRG_MEA_NAME);
			return false;
		}
		
		var cmb=meaRows[i].cells[2].getElementsByTagName("SELECT")[0];
		var measType = (cmb.options[cmb.selectedIndex].value);
		if (measType == 1){//Si es medida calculada verificamos la formula
			var measFormula = meaRows[i].getElementsByTagName("TD")[5].getElementsByTagName("INPUT")[0];
			if (!chkFormula(measFormula,meaName)){
				return false;
			}
		}else{
			var attName = meaRows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0].value;
			if (attName == ""){
				showMessage(MSG_MIS_MEA_ATT);
				return false;
			}
		}
		if (meaRows[i].getElementsByTagName("TD")[6].getElementsByTagName("INPUT")[0].checked){
			visible = true;
		}
	}
	
	if (!visible){
		showMessage(MSG_ATLEAST_ONE_MEAS_VISIBLE);
		return false;
	}
			
	//9. Verificamos que si se agrego algun perfil para restringir sus dimensiones, se haya restringido alguna
	var i = 0;
	var prfs = "";
	var divs = $("divNoAccProfiles").getElementsByTagName("DIV");
	var i=0
	while (i<divs.length){
		var item = divs[i];
		if (item.id!="addProfile"){
			if ("true" == item.getElementsByTagName("input")[0].getAttribute("flagNew")){
				if (prfs==""){
					prfs = item.getElementsByTagName("input")[0].getAttribute("profile");
				}else {
					prfs += ";" + item.getElementsByTagName("input")[0].getAttribute("profile");
				}			
			}
			i=i+3;
		}else{
			break;
		}
	}
	
	if (prfs!=""){
		if (prfs.indexOf(";")<0){
			var msg = MSG_PRF_NO_ACC_DELETED.replace("<TOK1>",prfs);
			
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = msg;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll();confirmOK();\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel,true,"returnFalse");
			SYS_PANELS.refresh();
		}else {
			var msg = MSG_PRFS_NO_ACC_DELETED.replace("<TOK1>",prfs);
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = msg;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll();confirmOK();\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel,true,"returnFalse");
			SYS_PANELS.refresh();
		}
	} else {
		if(hasCubeBefore != '' && $('chkCreateCbe')!=null && $('chkCreateCbe').checked){ //Si habia cubo y hay cubo ahora
			//Se verifica la consistencia de las vistas
			doCubeViewsCheck();
			//El submit de confirm se hace al recargarse la pagina segun el resultado
		}else {
			sendFormEnt();
		}
	}
}

function confirmOK(){
	if(hasCubeBefore != '' && $('chkCreateCbe')!=null && $('chkCreateCbe').checked){ //Si habia cubo y hay cubo ahora
		//Se verifica la consistencia de las vistas
		doCubeViewsCheck();
		//El submit de confirm se hace al recargarse la pagina segun el resultado
	}else {
		sendFormEnt();
	}
}

function doCubeViewsCheck(){
	var params = getFormParametersToSendEnt($("frmData"));
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=checkCubeViews&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send(params);
}

function askUserToSubmit(message) {
	SYS_PANELS.newPanel();
	var panel = SYS_PANELS.getActive();
	panel.addClass("modalWarning");
	panel.content.innerHTML = message;
	panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); sendFormEnt();\">" + BTN_CONFIRM + "</div>";
	SYS_PANELS.addClose(panel);
	SYS_PANELS.refresh();
}

function sendFormEnt(){
	var params = getFormParametersToSendEnt($("frmData"));
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=confirm&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send(params); 			
}

function checkDimNames(){
	trows=$("gridDims").rows;
	var auxId = new Array();
	var auxName = new Array();
	for (i=0;i<trows.length;i++) {
		var attId = trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
		var dimName = trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
		if (auxId.length==0){
			auxId[i]= attId;
			auxName[i]= dimName;
		}else{
			if (auxName.lastIndexOf(dimName)!=-1){
				return false; //se repite el nombre de una dimension
			}else{
				auxId[i]= attId;
				auxName[i]= dimName;
			}
		}		
	}
	return true; //no se repite el nombre de ninguna dimension
}

function checkMeasureNames(){
	trows=$("gridMeasures").rows;
	var auxName = new Array();
	for (i=0;i<trows.length;i++) {
		var rowId = i;
		var measName = trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
		if (auxName.length==0){		
			auxName[i]= measName;
		}else{
			if (auxName.lastIndexOf(measName)!=-1){
				return false; //se repite el nombre de una medida
			}else{			
				auxName[i]= measName;
			}
		}
	}
	return true; //no se repite el nombre de ninguna medida
}

//Verifica si la formula es correcta
//formatos posibles: Measure op Measure, Measure op NUMBER
function chkFormula(obj, measName){
	
	//1. Hallamos la medida 1, el operarador y la medida2 (o number)
	var formula = obj.value;
	if (formula == ""){
		showMessage(MSG_MUST_ENTER_FORMULA);
		return false;
	}
	var esp1 = formula.indexOf(" ");
	var formula2 = formula.substring(esp1+1, formula.length);
	var meas1 = formula.substring(0,esp1);
	var op = formula2.substring(0,1);
	var meas2 = formula2.substring(2, formula2.length);
	
	//2. Verificamos la medida1 exista
	if (!chkMeasExist(meas1)){
		if (esp1 < 0){
			showMessage(formula + ": " + MSG_MEAS_OP1_NAME_INVALID);
		}else {
			showMessage(meas1 + ": " + MSG_MEAS_OP1_NAME_INVALID);
		}
		obj.focus();		
		return false;
	}
	
	//3. Verificamos el operador sea valido
	if (op != '/' && op != '-' && op != '+' && op != '*'){
		showMessage(op + ": " + MSG_OP_INVALID);
		obj.focus();
		return false;
	}
	
	//4. Verificamos la medida2 exista
	if (!chkMeasExist(meas2)){//Si no existe como medida talvez sea un numero
		if (isNaN(meas2)){
			showMessage(meas2 + ": " + MSG_MEAS_OP2_NAME_INVALID);
			obj.focus();
			return false;
		}
	}
	
	//5. Verificamos no se utilice el nombre de la propia medida como un operando de la formula.
	if (measName == meas1 || measName == meas2){
		showMessage(measName + ": " + MSG_MEAS_NAME_LOOP_INVALID);
		obj.focus();
		return false;
	}
	
	return true;
}

//Verifica si la medida usada en una formula es valida
function chkMeasExist(measure){
	trows=$("gridMeasures").rows;
	for (i=0;i<trows.length;i++) {
		if (trows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value == measure) {
			return true;
		}
	}
	return false;
}


//-------------------------------
//---- Datos Entidad
//-------------------------------

function changeType(){
	var cmbType = $('cmbType');
	if (cmbType.value==ADMIN_FUNCT){
		$('titleEntPro').style.display='none';
		$('processContainer').style.display='none';
		
		//Borrar los procesos seleccionados
		$('processContainer').getElements("div").each(function(item){
			if (item.getAttribute("id") != "divAddProcess" && item.getAttribute("id") != "addProcess"){
				item.destroy();
			}
		});		
		
	}else{
		$('titleEntPro').style.display='';
		$('processContainer').style.display='';
	}
}

function loadStatus(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=getStatuses' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processXMLStatus(resXml); sp.hide(true); }
	}).send();
}

function processXMLStatus(ajaxCallXml){
	if (ajaxCallXml != null) {
		
		var envs = ajaxCallXml.getElementsByTagName("statuses");
		if (envs != null && envs.length > 0 && envs.item(0) != null) {
			envs = envs.item(0).getElementsByTagName("status");
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				var text	= env.getAttribute("text");
				var id = env.getAttribute("id");
				var fixed_ent = env.getAttribute("fixed_ent")=="true";
				addActionElementStatus($('statusContainer'),text,id,"true",!fixed_ent);
			}
		}
	}
}

function processStatusModalReturn(ret){
	ret.each(function(e){
		var text = e.getRowContent()[0];	
		addActionElementStatus($('statusContainer'),text,e.getRowId(),"true",true);
	});
}

function addActionElementStatus(container, text, id,helper,addRemove){
	var repeated = false;
	//primero verificar que no exista
	container.getElements("DIV").each(function(item,index){
		if(item.getAttribute("id")==id){
			repeated = true;
		}
	});
	if(repeated){
		return;
	}
	
	//si no est�, se agrega
	var divElement = new Element('div', {'class': 'option', html: text});
	divElement.setAttribute("id", id);
	divElement.setAttribute("helper",helper);
	
	var hiddenInput = new Element('input',{ type:'hidden','name':'chkStatus','value':id}).inject(divElement);
	hiddenInput = new Element('input',{ type:'hidden','name':'staName','value':text}).inject(divElement);
	
 	
	if(addRemove){
		divElement.container = container;
		divElement.addClass("optionRemove");
		divElement.addEvent("click", actionAlementAdminClickRemove);
		divElement.addEvent("mouseenter", actionElementAdminMouseOverToggleClasss);
		divElement.addEvent("mouseleave", actionElementAdminMouseOverToggleClasss);
	}
	
	divElement.inject(container.getLast(),'before');
	
	return divElement;
}

function processImg(ret){
	if (ret != null){
		$('changeImg').style.backgroundImage = "url('"+ret.path+"')";
		$('txtProjImg').value=ret.id;
	}
	
}

function changeTemplate() {
	if ($("txtTemplate").value=="<CUSTOM>") {		
		$("divCustomTemplate").style.display = "";
		$("customTemplate").disabled = false;
	}else{
		$("divCustomTemplate").style.display = "none";
		$("customTemplate").disabled = true;
	}
} 

function changeIdePre(val) {
	$("txtIdePre").readOnly = val;
	if (val) {
		disposeValidation($("txtIdePre"));	
		$("txtIdePre").addClass("readonly");
	} else {
		registerValidation($("txtIdePre"));
		$("txtIdePre").removeClass("readonly");
	}
}

function changeIdePos(val) {
	$("txtIdePos").readOnly = val;
	if (val) {
		disposeValidation($("txtIdePos"));	
		$("txtIdePos").addClass("readonly");
	} else {
		registerValidation($("txtIdePos"));
		$("txtIdePos").removeClass("readonly");
	}
}

//-------------------------------
//---- Proc. y Form
//-------------------------------

function addUserFormMonitor(tableName, name, id){
	var table = $(tableName);
	var parent = table.getParent();
	table.selectOnlyOne = true;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	addActionElementForm(table,name,id,true,tdWidths,true);
}

function addUserFormPanel(tableName, name, id){
	var table = $(tableName);
	var parent = table.getParent();
	table.selectOnlyOne = true;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	addActionElementForm(table,name,id,true,tdWidths,true);
}

function addUserForm(tableName, name, id){
	var table = $(tableName);
	var parent = table.getParent();
	table.selectOnlyOne = true;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	
	addActionElementForm(table,name,id,true,tdWidths,null);	
}

function removeUserFormMonitor(tableName,id){
	var rows=$(tableName).rows;
	for(var i=0;i<rows.length;i++){
		var input=rows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0];//chkForm
		if(input.value==id){
			deleteRow((i+1),$(tableName));
		}
	}
}

function removeUserFormPanel(tableName,id){
	var rows=$(tableName).rows;
	for(var i=0;i<rows.length;i++){
		var input=rows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0];//chkForm
		if(input.value==id){
			deleteRow((i+1),$(tableName));
		}
	}
}

function removeUserForm(tableName,id){
	var rows=$(tableName).rows;
	for(var i=0;i<rows.length;i++){
		var input=rows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1];//chkForm
		if(input.value==id){
			deleteRow((i+1),$(tableName));
		}
	}
}

function initFormTable(addName,removeName,upName,downName,tableName){
	
	$(addName).addEvent("click", function(e) {
		e.stop();
		FORMSMODAL_SHOWGLOBAL = true;	
		if (tableName=="tableDataFormEnt") {
			showFormModal(processFormModalReturn);
		} else if (tableName=="tableDataFormMonEnt") {
			showFormModal(processFormMonModalReturn);
		} else {
			showFormModal(processFormPanelModalReturn);
		}
	});
	
	$(removeName).addEvent("click", function(e) {
		e.stop();
		if(selectionCount($(tableName)) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			//CAM_11713
			var stop = false;
			while (getSelectedRows($(tableName)).length > 0 && !stop){			
				var pos = getSelectedRows($(tableName))[0].rowIndex;
				var rows=getSelectedRows($(tableName));
				
				if (removeName=="btnDeleteFormEnt"){				
					var esta = false;
					var fixedForms="";
					for(var i=0;i<rows.length;i++){
						var input=rows[i].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1];
						
						//si el form esta usado por un proc. no se borra
						if("true"==(rows[i].getAttribute("fixed_ent"))){
							//CAM_11713
							/*var firstChild = rows[i].getElementsByTagName("TD")[0].firstChild;
							if(firstChild.nodeValue == null)
								fixedForms += " " + firstChild.firstChild.nodeValue;
							else
								fixedForms += " " + firstChild.nodeValue; 
							continue;*/
							
							var formName = rows[i].getElement("td").getElement("div").innerHTML;
							if (fixedForms != "") fixedForms += ", ";
							fixedForms += formName;							
						}				
						
						if(input.value==USRCREATION_FORM_ID){
							if (rows.length == 1){
								showMessage(MSG_FOR_NO_BOR);	
								return
							}
						}
					}
				 
					if(fixedForms!=""){
						showMessage(MSG_USED_FORMS + " " + fixedForms);
						return
					}
				}else{			
					var esta = false;
					for(var i=0;i<rows.length;i++){
						var input=rows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[0];
						if(input.value==USRCREATION_FORM_ID){
							if (rows.length == 1){
								showMessage(MSG_FOR_NO_BOR);
							}
						}
					} 
				}
				deleteRow(parseInt(pos),tableName);
				fixTableEnt($(tableName));
			}
		}	
	});
	
	$(upName).addEvent("click", function(e) {
		e.stop();
		if(selectionCount($(tableName)) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var pos = getSelectedRows($(tableName))[0].rowIndex;
			var row = upRow(parseInt(pos),tableName);
			fixTableEnt($(tableName));
			if (row){
				if (tableName == 'tableDataFormEnt'){
					Scroller1.v.showElement(row);
				} else if (tableName == 'tableDataFormMonEnt'){
					Scroller2.v.showElement(row);
				} else {
					Scroller3.v.showElement(row);
				}
			}
		}		
	});
	
	$(downName).addEvent("click", function(e) {
		e.stop();
		if(selectionCount($(tableName)) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var pos = getSelectedRows($(tableName))[0].rowIndex;
			var row = downRow(parseInt(pos),tableName);
			fixTableEnt($(tableName));
			if (row){
				if (tableName == 'tableDataFormEnt'){
					Scroller1.v.showElement(row);
				} else if (tableName == 'tableDataFormMonEnt'){
					Scroller2.v.showElement(row);
				} else {
					Scroller3.v.showElement(row);
				}
			}
		}
	});
}

function loadFormMon(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=getFormsMon' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processXMLFormsMon(resXml); sp.hide(true); }
	}).send();
}

function loadFormPanel(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=getFormsPanel' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processXMLFormsPanel(resXml); sp.hide(true); }
	}).send();
}



function loadAttBusEntRelation(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=getAttBusEntRelation' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processXMLAttBusEntRelated(resXml); sp.hide(true); }
	}).send();
}

function loadForm(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=getForms' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processXMLForms(resXml); sp.hide(true); }
	}).send();
}

function loadProcess(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=getProcesses' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processXMLProcesses(resXml); sp.hide(true); }
	}).send();
}

function processXMLForms(ajaxCallXml){
	if (ajaxCallXml != null) {		
		var envs = ajaxCallXml.getElementsByTagName("forms");
		if (envs != null && envs.length > 0 && envs.item(0) != null) {		
			envs = envs.item(0).getElementsByTagName("form");
			var table = $('tableDataFormEnt');						
			var parent = table.getParent();
			table.selectOnlyOne = true;
			var thead = parent.getFirst("thead");
			var theadTr = thead ? thead.getFirst("tr") : null;
			var headers = theadTr ? thead.getElements("th") : null;
			var tdWidths = headers ? new Array(headers.length) : null;
			if (headers) {
				for (var i = 0; i < headers.length; i++) {
					tdWidths[i] = headers[i].style.width;
					if (! tdWidths[i]) tdWidths[i] = headers[i].width;
					if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
				}
			}
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				var text	= env.getAttribute("text");
				var id = env.getAttribute("id");
				var fixed_ent = env.getAttribute("fixed_ent");
				var show = env.getAttribute("checked") == "true";
				addActionElementForm(table, text, id, show, tdWidths, fixed_ent, null);
			}
		}
	}
}

function processXMLFormsMon(ajaxCallXml){
	if (ajaxCallXml != null) {		
		var envs = ajaxCallXml.getElementsByTagName("forms");
		if (envs != null && envs.length > 0 && envs.item(0) != null) {		
			envs = envs.item(0).getElementsByTagName("form");
			var table = $('tableDataFormMonEnt');
			var parent = table.getParent();
			table.selectOnlyOne = true;
			var thead = parent.getFirst("thead");
			var theadTr = thead ? thead.getFirst("tr") : null;
			var headers = theadTr ? thead.getElements("th") : null;
			var tdWidths = headers ? new Array(headers.length) : null;
			if (headers) {
				for (var i = 0; i < headers.length; i++) {
					tdWidths[i] = headers[i].style.width;
					if (! tdWidths[i]) tdWidths[i] = headers[i].width;
					if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
				}
			}
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				var text	= env.getAttribute("text");
				var id = env.getAttribute("id");
				var fixed_ent = env.getAttribute("fixed_ent");
				addActionElementForm(table,text,id,true,tdWidths,fixed_ent,null);
			}
		}
	}
}

function processXMLFormsPanel(ajaxCallXml){
	if (ajaxCallXml != null) {		
		var envs = ajaxCallXml.getElementsByTagName("forms");
		if (envs != null && envs.length > 0 && envs.item(0) != null) {		
			envs = envs.item(0).getElementsByTagName("form");
			var table = $('tableDataFormPanelEnt');
			var parent = table.getParent();
			table.selectOnlyOne = true;
			var thead = parent.getFirst("thead");
			var theadTr = thead ? thead.getFirst("tr") : null;
			var headers = theadTr ? thead.getElements("th") : null;
			var tdWidths = headers ? new Array(headers.length) : null;
			if (headers) {
				for (var i = 0; i < headers.length; i++) {
					tdWidths[i] = headers[i].style.width;
					if (! tdWidths[i]) tdWidths[i] = headers[i].width;
					if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
				}
			}
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				var text	= env.getAttribute("text");
				var id = env.getAttribute("id");
				var fixed_ent = env.getAttribute("fixed_ent");
				addActionElementForm(table,text,id,true,tdWidths,fixed_ent,null);
			}
		}
	}
}

function processXMLAttBusEntRelated(ajaxCallXml){
	if (ajaxCallXml != null) {
		
		var relations = ajaxCallXml.getElementsByTagName("relation");
		if (relations != null) {
			for(var i = 0; i < relations.length; i++) {
				var relation = relations.item(i);
				var attId	= relation.getAttribute("attId");
				var attName	= relation.getAttribute("attName");
				var entId	= relation.getAttribute("busEntId");
				var entName	= relation.getAttribute("busEntName");
				
				addNewLineTableAttBusEntRelation(attId, attName, entId, entName);
			}
		}
	}
}

function processXMLProcesses(ajaxCallXml){
	if (ajaxCallXml != null) {		
		var envs = ajaxCallXml.getElementsByTagName("processes");
		if (envs != null && envs.length > 0 && envs.item(0) != null) {
			envs = envs.item(0).getElementsByTagName("process");
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				var text	= env.getAttribute("text");
				var id = env.getAttribute("id");
				var hidProVerId = env.getAttribute("hidProVerId");
				var instanced = toBoolean(env.getAttribute("instanced"));
				addActionElementProcess($('processContainer'),text,id,hidProVerId,"true",!instanced);
			}
		}
	}
}

function processProcessModalReturn(ret){
	ret.each(function(e){
		var text = e.getRowContent()[0];	
		var id = e.getRowId();
		var hidProVerId = e.getAttribute("proVerId");
		addActionElementProcess($('processContainer'),text,id,hidProVerId,"true",true);		
	});
}

function addActionElementProcess(container, text, id,hidProVerId,helper,addRemove){
	var repeated = false;
	//primero verificar que no exista
	container.getElements("DIV").each(function(item,index){
		if(item.getAttribute("id")==id){
			repeated = true;
		}
	});
	if(repeated){
		return;
	}
	
	//si no est�, se agrega
	var divElement = new Element('div', {'class': 'option', html: text});
	divElement.setAttribute("id", id);
	divElement.setAttribute("helper",helper);
	
	var hiddenInput = new Element('input',{ type:'hidden','name':'chkProc','value':id}).inject(divElement);
	hiddenInput = new Element('input',{ type:'hidden','name':'hidProVerId','value':hidProVerId}).inject(divElement);
	 	
	if(addRemove){
		divElement.container = container;
		divElement.addClass("optionRemove");
		divElement.addEvent("click", warningDelete, divElement);				
		divElement.addEvent("mouseenter", actionElementAdminMouseOverToggleClasss);
		divElement.addEvent("mouseleave", actionElementAdminMouseOverToggleClasss);
	} else {
		divElement.addClass("optionRemoveNoImg");
	}
	
	divElement.inject(container.getLast(),'before');
	
	return divElement;
}

function warningDelete(element){
	SYS_PANELS.newPanel();
	var panel = SYS_PANELS.getActive();
	panel.addClass("modalWarning");
	panel.header.innerHTML = TIT_WARNING;
	panel.content.innerHTML = BPMN_DEL_WARNING;
	
	//Se mantiene referencia al elemento a borrar
	currentProc = element.target;
	currentProc.addEvent("confirm", actionAlementAdminClickRemove);
	
	panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); currentProc.fireEvent('confirm');\">" + BTN_CONFIRM + "</div>";	
	SYS_PANELS.addClose(panel);
	SYS_PANELS.refresh();
}

function processFormMonModalReturn(ret){
	var table = $('tableDataFormMonEnt');
	var parent = table.getParent();
	table.selectOnlyOne = true;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	ret.each(function(e){
		var text = e.getRowContent()[0];	
		var id = e.getRowId();
		addActionElementForm(table,text,e.getRowId(),true,tdWidths,null);
	});
	fixTableEnt(table);
}

function processFormPanelModalReturn(ret){
	var table = $('tableDataFormPanelEnt');
	var parent = table.getParent();
	table.selectOnlyOne = true;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	ret.each(function(e){
		var text = e.getRowContent()[0];	
		var id = e.getRowId();
		addActionElementForm(table,text,e.getRowId(),true,tdWidths,null);
	});
	fixTableEnt(table);
}


function processFormModalReturn(ret){
	
	var table = $('tableDataFormEnt');
	var parent = table.getParent();
	table.selectOnlyOne = true;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	ret.each(function(e){
		var text = e.getRowContent()[0];	
		var id = e.getRowId();
		addActionElementForm(table,text,e.getRowId(),true,tdWidths,null);
	});	
	
	fixTableEnt(table);
}

function addActionElementForm(table, text, idRow, isChecked,tdWidths,fixed_ent){

	var repeated = false;
	//primero verificar que no exista
	table.getElements("tr").each(function(item,index){
		if(item.getAttribute("id")==idRow){
			repeated = true;
		}
	});
	if(repeated){
		return;
	}	
	
	var tr = new Element('tr',{id:idRow});
	if (fixed_ent!=null){
		tr.setAttribute("fixed_ent",fixed_ent);
	}
	tr.addClass("selectableTR");
	tr.getRowId = function () { return this.getAttribute("rowId"); };
	tr.setRowId = function (a) { this.setAttribute("rowId",a); };
	tr.setAttribute("rowId", idRow);
	
	var td = new Element('td');
	td.setAttribute("textContent",text);
	if (table.id!="tableDataFormEnt"){
		td.setAttribute('style','border-right:none');
	}
	var div = new Element('div', {styles: {width: tdWidths[0], overflow: 'hidden', 'white-space': 'pre'}});
	new Element('span', {html: text}).inject(div);
	
	if (table.id == "tableDataFormMonEnt") {
		var input =  new Element('input',{type:'hidden',id:'chkMonForm',name:'chkMonForm',value:idRow});	
		input.inject(div);
	} else if (table.id == "tableDataFormPanelEnt") {
		var input =  new Element('input',{type:'hidden',id:'chkPanelForm',name:'chkPanelForm',value:idRow});	
		input.inject(div);
	}
	
	div.inject(td);
	td.inject(tr); 
	
	
	td.inject(tr);
	if (table.id=="tableDataFormEnt"){
		td = new Element('td');
		td.setAttribute('style','border-right:none');
		div = new Element('div', {styles: {width: tdWidths[1], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
		var input =  new Element('input',{type:'checkbox',id:'showForm'+idRow,name:'showForm'+idRow,checked:isChecked});	
		input.setAttribute('value','true');
		input.inject(div);
		var input =  new Element('input',{type:'hidden',id:'chkForm',name:'chkForm',value:idRow});	
		input.inject(div);
		div.inject(td);
		td.inject(tr);
	}
	
	if(table.rows.length%2==0){
		tr.addClass("trOdd");
	}
	
	tr.inject(table);
	
	tr.addEvent("click",function(e){
		//CAM_11713
		/*if (tr.getParent().selectOnlyOne) {
		var parent = tr.getParent();
		if (parent.lastSelected) parent.lastSelected.toggleClass("selectedTR");
		parent.lastSelected = tr;
		}*/
		tr.toggleClass("selectedTR");
	}); 
	return table;
}

//-------------------------------
//---- Relaciones
//-------------------------------

function addRowAnc(table,extra){
	
	var parent = table.getParent();
	table.selectOnlyOne = true;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	var i=0;
	var tr = new Element('tr');
	tr.addClass("selectableTR");
	tr.addEvent("click",function(e){myToggle(this)});
	tr.getRowId = function () { return this.getAttribute("rowId"); };
	tr.setRowId = function (a) { this.setAttribute("rowId",a); };
	tr.setAttribute("rowId", table.rows.length);
	
	var td = new Element('td',{'align': 'center'});	
	var input = new Element("input");
	div = new Element('div', {styles: {width: tdWidths[i], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	input.setAttribute("name","txtEntNameFather");
	input.setAttribute("id","txtEntNameFather");
	input.setAttribute('type','text');
	input.setAttribute('style','width:90%');
	if (extra!=null){
		input.setAttribute('value',extra.txtEntNameFather);
		input.setAttribute('readonly',true);	
	}
	input.inject(div);	
	registerValidation(input);	
	new Element("span",{html:"&nbsp;*"}).inject(div);
	div.inject(td);
	td.inject(tr);
	i++;
	
	var td = new Element('td',{'align': 'center'});	
	var input = new Element("input");
	div = new Element('div', {styles: {width: tdWidths[i], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	input.setAttribute("name","txtEntNameFatherRel");
	input.setAttribute("id","txtEntNameFatherRel");
	input.setAttribute('type','text');
	input.setAttribute('style','width:90%');
	if (extra!=null){
		input.setAttribute('value',extra.txtEntNameFatherRel);
		input.setAttribute('readonly',true);	
	}
	input.inject(div);	
	div.inject(td);
	td.inject(tr);
	i++;
	
	var td = new Element('td',{'align': 'center'});	
	var input = new Element("input");
	div = new Element('div', {styles: {width: tdWidths[i], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	input.setAttribute("name","txtEntNameFatherRelNameA");
	input.setAttribute("id","txtEntNameFatherRelNameA");
	input.setAttribute('type','text');
	input.setAttribute('style','width:90%');
	if (extra!=null){
		input.setAttribute('value',extra.txtEntNameFatherRelNameA);
		input.setAttribute('disabled',true);	
	}
	input.inject(div);
	div.inject(td);
	
	var input = new Element("input");
	input.setAttribute("name","txtEntNameFatherRelNameB");
	input.setAttribute("id","txtEntNameFatherRelNameB");
	input.setAttribute('type','hidden');
	if (extra!=null){
		input.setAttribute('value',extra.txtEntNameFatherRelNameB);
	}
	input.inject(td);	
	td.inject(tr);
		
	if(table.rows.length%2==0){
		tr.addClass("trOdd");
	}
	
	tr.inject(table);	
	
	addScrollTable(table);
}

function addRowDesc(table,extra){
	
	var parent = table.getParent();
	table.selectOnlyOne = true;
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	var headers = theadTr ? thead.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			tdWidths[i] = headers[i].style.width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].width;
			if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
		}
	}
	var i=0;
	var tr = new Element('tr');
	tr.addClass("selectableTR");
	tr.addEvent("click",function(e){myToggle(this)});
	tr.getRowId = function () { return this.getAttribute("rowId"); };
	tr.setRowId = function (a) { this.setAttribute("rowId",a); };
	tr.setAttribute("rowId", table.rows.length);
	
	var td = new Element('td',{'align': 'center'});	
	var input = new Element("input");
	div = new Element('div', {styles: {width: tdWidths[i], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	input.setAttribute("name","txtEntNameChild");
	input.setAttribute("id","txtEntNameChild");
	input.setAttribute('type','text');
	input.setAttribute('style','width:90%');
	if (extra!=null){
		input.setAttribute('value',extra.txtEntNameChild);
		input.setAttribute('readonly',true);	
	}
	input.inject(div);	
	registerValidation(input);	
	new Element("span",{html:"&nbsp;*"}).inject(div);
	div.inject(td);
	td.inject(tr);
	i++;
	
	var td = new Element('td',{'align': 'center'});
	var select = new Element('select', {styles: {width: '100%'}});
	select.setAttribute('name',"txtEntNameChildRel");
	
	var selected = "";
	if (extra!=null){
		selected = extra.txtEntNameChildRel;
	}
	var option = new Element('option');
	option.setAttribute('value',"1");
	option.appendText("1");
	option.inject(select);
	if (selected=="1"){
		option.setAttribute('selected','selected');
	}
	
	option = new Element('option');
	option.setAttribute('value',"N");
	option.appendText("N");
	option.inject(select);
	if (selected=="N"){
		option.setAttribute('selected','selected');
	}
	select.setAttribute('style','width:90%');
	div = new Element('div', {styles: {width: tdWidths[i], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	select.inject(div);
	div.inject(td);
	td.inject(tr);
	i++;
	
	var td = new Element('td',{'align': 'center'});	
	var input = new Element("input");
	div = new Element('div', {styles: {width: tdWidths[i], overflow: 'hidden', 'white-space': 'pre','text-align':'center'}});
	input.setAttribute("name","txtEntNameChildRelNameB");
	input.setAttribute("id","txtEntNameChildRelNameB");
	input.setAttribute('type','text');
	input.setAttribute('style','width:90%');
	if (extra!=null){
		input.setAttribute('value',extra.txtEntNameChildRelNameB);
	}
	input.inject(div);	
	div.inject(td);
	
	var input = new Element("input");
	input.setAttribute("name","txtEntNameChildRelNameA");
	input.setAttribute("id","txtEntNameChildRelNameA");
	input.setAttribute('type','hidden');
	if (extra!=null){
		input.setAttribute('value',extra.txtEntNameChildRelNameA);
	}
	input.inject(td);
	
	td.inject(tr);
	if(table.rows.length%2==0){
		tr.addClass("trOdd");
	}
	
	tr.inject(table);	
	
	addScrollTable(table);
}

function loadRelAnc(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=getRelAnc' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processXMLRelAnc(resXml); sp.hide(true); }
	}).send();
}

function loadRelDesc(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=getRelDesc' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processXMLRelDesc(resXml); sp.hide(true); }
	}).send();
}

function processXMLRelAnc(ajaxCallXml){
	if (ajaxCallXml != null) {
		
		var envs = ajaxCallXml.getElementsByTagName("descs");
		if (envs != null && envs.length > 0 && envs.item(0) != null) {
			envs = envs.item(0).getElementsByTagName("desc");
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				var extra = {
						txtEntNameFather:env.getAttribute("txtEntNameFather"),
						txtEntNameFatherRel:env.getAttribute("txtEntNameFatherRel"),
						txtEntNameFatherRelNameA:env.getAttribute("txtEntNameFatherRelNameA"),
						txtEntNameFatherRelNameB:env.getAttribute("txtEntNameFatherRelNameB"),
				}
				addRowAnc($('tableDataAnc'),extra);
			}
			initTable($('tableDataAnc'));
		}
	}
}

function processXMLRelDesc(ajaxCallXml){
	if (ajaxCallXml != null) {
		
		var envs = ajaxCallXml.getElementsByTagName("descs");
		if (envs != null && envs.length > 0 && envs.item(0) != null) {
			envs = envs.item(0).getElementsByTagName("desc");
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				var extra = {
						txtEntNameChild:env.getAttribute("txtEntNameChild"),
						txtEntNameChildRel:env.getAttribute("txtEntNameChildRel"),
						txtEntNameChildRelNameB:env.getAttribute("txtEntNameChildRelNameB"),
						txtEntNameChildRelNameA:env.getAttribute("txtEntNameChildRelNameA"),
				}
				addRowDesc($('tableDataDes'),extra);
			}
			initTable($('tableDataDes'));
		}
	}
}


//-------------------------------
//---- Consultas Analiticas
//-------------------------------

function enableDisable(){
	if($('chkCreateCbe').checked){
		//Habilitamos todo
		registerValidation($('txtCbeName'));
		$('txtCbeName').disabled=false;
		registerValidation($('txtCbeTitle'));
		$('txtCbeTitle').disabled=false;
		$('txtCbeDesc').disabled=false;
		$('buttonsDim').style.display='';
		$('buttonsMea').style.display='';
		//$('divAddProfile').style.display='';
		//$('divAddNoAccProfile').style.display='';
		$('dataLoad1').disabled=false;
		$('dataLoad2').disabled=false;
		$('panelOptions').style.display='';
		$('btnEstTime').style.display='';
		HAS_CUBE="true";
	}else{
		SYS_PANELS.newPanel();
		var panel = SYS_PANELS.getActive();
		panel.addClass("modalWarning");
		panel.content.innerHTML = MSG_DELETE_CUBE_CONFIRM;
		panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); getWidgetDependency();\">" + BTN_CONFIRM + "</div>";
		SYS_PANELS.addClose(panel,true,"checkCreateCbe");
		SYS_PANELS.refresh();
	}
}

function checkCreateCbe(){
	$('chkCreateCbe').checked = true
}

function getWidgetDependency(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=getWidgetDeps' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processWidgetDep(resXml); sp.hide(true); }
	}).send();	
}

function getAjaxText(xml){
	 var toLoad = xml.getElementsByTagName("load").item(0);
	 var theText = toLoad.getElementsByTagName("text").item(0);
	 var html = "null";
	 if  (theText.firstChild!=null){
		 html = theText.firstChild.nodeValue;
	 }	 
	 return html;
}

function processWidgetDep(resXml){
	var widNames = getAjaxText(resXml);
	if (widNames == null || widNames == "null"){
		getCubesDependency();		
	}else{
		showMessage(MSG_CBE_IN_USE_BY_WIDGET.replace("<TOK1>",widNames));
		$('chkCreateCbe').checked = true;
	}
}

function getCubesDependency(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=getCubeDeps' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processCubeDep(resXml); sp.hide(true); }
	}).send();	
}

function processCubeDep(resXml){
	var cbeNames = getAjaxText(resXml);
	if (cbeNames == null || cbeNames == "null"){
		borrarAllInBean();		
	}else{
		showMessage(MSG_CBE_IN_USE_BY_CUBE.replace("<TOK1>", cbeNames));
		$('chkCreateCbe').checked = true;
	}
}

function borrarAllInBean(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=removeAllEntDwCol' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processBorrarAllInBean(resXml); sp.hide(true); }
	}).send();	
}

function processBorrarAllInBean(resXml){
	var ok = getAjaxText(resXml);
	if (ok=="OK"){
		disposeValidation($('txtCbeName'));
		$('txtCbeName').disabled=true;
		$('txtCbeName').value="";
		disposeValidation($('txtCbeTitle'));
		$('txtCbeTitle').disabled=true;
		$('txtCbeTitle').value="";
		$('txtCbeDesc').disabled=true;
		$('txtCbeDesc').value="";
		$('buttonsDim').style.display='none';
		$('buttonsMea').style.display='none';
		$('dataLoad1').disabled=true;
		$('dataLoad2').disabled=true;
		$('panelOptions').style.display='none';
		borrarAllDimensions();
		borrarAllMeasures();
		borrarAllProfiles();
		borrarAllNoAccProfiles();
		//$('divAddProfile').style.display='none';	
		//$('divAddNoAccProfile').style.display='none';
		HAS_CUBE="false";
		selAttsDim = new Array();
		selAttsMea = new Array();
		selBasicDatDim = new Array();
		selBasicDatMea = new Array();		
	}
}

function borrarAllMeasures(){
	trows=$("gridMeasures").rows;
	var i = 0;
	while (i<trows.length) {
		trows[i].destroy();
	}
}

function borrarAllDimensions(){
    trows=$("gridDims").rows;
	var i = 0;
	while (i<trows.length) {
		trows[i].destroy();
	}
}

function borrarAllProfiles(){
	var container = $('divProfiles');
	var divs = container.getElements("DIV");
	for (var i=0;i<(divs.length-2);i++){
		var div = divs[i];
		div.destroy();
	}		
}

function borrarAllNoAccProfiles(){
	var container = $('divNoAccProfiles');
	var divs = container.getElements("DIV");
	for (var i=0;i<(divs.length-2);i++){
		var div = divs[i];
		div.destroy();
	}	
}

//Marcamos que el cubo se modifico estructuralmente
function cubeChanged(){
	$("hidCbeChanged").value = "true";
}

function inAttIds(attIds, attId){
	if (attIds!=""){
		var posSep = attIds.indexOf(",");
		while (posSep>0){
			var actual = attIds.substring(0,posSep);
			if (actual == attId){
				return true;
			}else{
				attIds = attIds.substring(posSep+1, attIds.length);
			}
			posSep = attIds.indexOf(",");
		}
		if (attIds == attId){
			return true;
		}
	}
	return false;
}

//Elimina el valor pasado por parametro del string pasado por parametro
//Formato del string: valores separados por ;
function remFromString(str, value, all){
	var newStr = "";
	var pos = str.indexOf(",");
	while (pos>0){
		var val = str.substring(0,pos);
		if (val!=value){
			if (newStr == ""){
				newStr=val;
			}else{
				newStr=newStr+","+val;
			}
		}
		if (val==value && all==false){
			str=str.substring(pos+1,str.length);
			newStr = newStr + "," + str;
			return (newStr);
		}
		str=str.substring(pos+1,str.length);
		pos = str.indexOf(",");
	}
	if (str!=value){
		if (newStr == ""){
			newStr=str;
		}else{
			newStr=newStr+","+str;
		}
	}
	return newStr;
}

function loadAtts(isDimension){
	var attIds = "";
	if (isDimension){
		attIds = $('txtHidAttIds').value;	
	}else{
		attIds = $('txtHidAttMeasureIds').value;
	}
	if (attIds.length > 0){
		var sepPos = attIds.indexOf(",");     
		while (sepPos>=0){
			var attId = attIds.substring(0,sepPos);
			if (parseInt(attId)>0){
				if (isDimension){
					selAttsDim[selAttsDim.length] = attId;
				}else{
					selAttsMea[selAttsMea.length] = attId;
				}
			}else{
				if (isDimension){
					selBasicDatDim[selBasicDatDim.length] = attId;
				}else{
					selBasicDatMea[selBasicDatMea.length] = attId;
				}
			}
			attIds = attIds.substring(sepPos+1,attIds.length);
			sepPos = attIds.indexOf(",");     
		}
		if (parseInt(attIds)>0){
			if (isDimension){
				selAttsDim[selAttsDim.length] = attIds;
			}else{
				selAttsMea[selAttsMea.length] = attIds;
			}
		}else{
			if (isDimension){
				selBasicDatDim[selBasicDatDim.length] = attIds;				
			}else{
				selBasicDatMea[selBasicDatMea.length] = attIds;
			}
		}
	}
}

function checkIfSelected(attId,isDimension){
	var aux = selAttsDim;
	if (!isDimension){
		aux = selAttsMea;
	}
	for(var i=0;i<aux.length;i++){
		if (aux[i] == attId){
			return true;
		}
	}
	return false;
}

function checkIfSelBasicDat(datId,isDimension){
	var aux = selBasicDatDim;
	if (!isDimension){
		aux = selBasicDatMea;
	}
	for(var i=0;i<aux.length;i++){
		if (aux[i] == datId){
			return true;
		}
	}
	return false;
}

function selUnselBasicData(obj,datId,isDimension){
	var li = obj.parentNode;
	var aux = selBasicDatDim;
	if (!isDimension){
		aux = selBasicDatMea;
	}
	if(li.getElementsByTagName("INPUT")[0].checked){
		if (notInBasicDatAtts(datId,isDimension)){
			aux[aux.length] = datId;
		}
		if (!isDimension){
			selBasicDatMea = aux;
		}else{
			selBasicDatDim = aux;
		}
	}else{
		for (var i=0; i<aux.length; i++){
			if (aux[i] == datId) {	
				aux.splice(i);
				if (!isDimension){
					selBasicDatMea = aux;
				}else{
					selBasicDatDim = aux;
				}
				return;
			}
		}
	}
}

function notInBasicDatAtts(attId,isDimension){
	var aux = selBasicDatDim;
	if (!isDimension){
		aux = selBasicDatMea;
	}
	for (var i=0; i<aux.length; i++){
		if (aux[i] == attId){
			return false;
		}
	}
	return true;
}

function selUnselAttribute(obj,attId,isDimension){
	var aux = selAttsDim;
	if (!isDimension){
		aux = selAttsMea;
	}
	var li = obj.parentNode;
	if(li.getElementsByTagName("INPUT")[0].checked){
		if (notInSelAtts(attId,isDimension)){
			aux[aux.length] = attId;
		}
		if (!isDimension){
			selAttsMea = aux;
		}else{
			selAttsDim = aux;
		}
	}else{
		for (var i=0; i<aux.length; i++){
			if (aux[i] == attId) {	
				aux.splice(i);
				if (!isDimension){
					selAttsMea = aux;
				}else{
					selAttsDim = aux;
				}
				return;
			}
		}
	}
}

function notInSelAtts(attId,isDimension){
	var aux = selAttsDim;
	if (!isDimension){
		aux = selAttsMea;
	}
	for (var i=0; i<aux.length; i++){
		if (aux[i] == attId){
			return false;
		}
	}
	return true;
}

function readXML(ajaxCallXml,element,type,isDimension){
	var xmlRoot=ajaxCallXml.getElementsByTagName("ROWSET");
	var nextType;
	var prefix;
	var nextType2;
	var prefix2;
	
	if (type=="entityData"){
		nextType = "attribute";
		prefix = "";
	}else if (type=="entityRedAtts"){ 
		nextType = "attribute";
		prefix = ATT_LABEL;
	}else if (type=="actEntityForms"){ //Formularios asociados a la entidad actual
		nextType = "entityFormAtts";
		prefix = FORM_LABEL;
	}else if (type=="entityForms"){ //Si hizo click en la opcion formularios de entidad
		nextType = "entityForm"; // Debo mostrar formularios de entidad
		prefix = FORM_LABEL;	
	}else if (type=="entityProcessJer"){
		nextType = "processJer";
		prefix = PRO_LABEL;
	}else if (type=="processJer"){
		nextType = "processJer";
		prefix = SUB_PRO_LABEL;
		nextType2="task";
		prefix2= TASK_LABEL;
	}else if (type=="task"){
		nextType = "form";
		prefix = FORM_LABEL;
	}else if (type=="form"){
		nextType = "attribute";
		prefix = ATT_LABEL;
	}else if (type == "entityFormAtts" || type=="entityForm"){
		nextType = "attribute";
		prefix = ATT_LABEL;
	}
	if (xmlRoot.nodeName != "EXCEPTION") {
		if (xmlRoot.length == 0) {

		} else {	
			var rowset = xmlRoot.item(0);
			for(i=0;i<rowset.childNodes.length;i++){
				xRow = rowset.childNodes[i];

				//Identificador
				var objId = xRow.childNodes[0].firstChild.nodeValue;

				var objName = "";;
				//Nombre
				if (type=="entityRedAtts" || type == "entityFormAtts" || type=="entityForm" || type == "form"){
					objName = prefix + xRow.childNodes[1].firstChild.nodeValue + " (" + xRow.childNodes[3].firstChild.nodeValue;
					if (xRow.childNodes[2].firstChild != null){ //Si tiene descripcion la mostramos
						objName = objName + " - " + xRow.childNodes[2].firstChild.nodeValue + ")";
					}else{
						objName = objName + ")";
					}
				}else if (type=="processJer") { 
					if (xRow.childNodes[4]!=null && 'true' == xRow.childNodes[4].firstChild.nodeValue){ // es subproceso
						objName = prefix + xRow.childNodes[1].firstChild.nodeValue + " (" + xRow.childNodes[3].firstChild.nodeValue;
						if (xRow.childNodes[2].firstChild != null){ //Si tiene descripcion la mostramos
							objName = objName + " - " + xRow.childNodes[2].firstChild.nodeValue + ")";
						}else{
							objName = objName + ")";
						}
					}else{ //es tarea
						objName = prefix2 + xRow.childNodes[1].firstChild.nodeValue + " (" + xRow.childNodes[3].firstChild.nodeValue;
						if (xRow.childNodes[2].firstChild != null){ //Si tiene descripcion la mostramos
							objName = objName + " - " + xRow.childNodes[2].firstChild.nodeValue + ")";
						}else{
							objName = objName + ")";
						}
					}
				}else{
					objName = prefix + xRow.childNodes[1].firstChild.nodeValue + " (" + xRow.childNodes[3].firstChild.nodeValue;
					if (xRow.childNodes[2].firstChild != null){ //Si tiene descripcion la mostramos
						objName = objName + " - " + xRow.childNodes[2].firstChild.nodeValue + ")";
					}else{
						objName = objName + ")";
					}
				}
				
				//ToolTip (solo para atributos de formularios de la entidad y de tareas de procesos)
				var objTitle = "";
				if (type == "entityFormAtts" || type=="entityForm" || type == "form"){
					if (xRow.childNodes[4].firstChild != null){
						var attType = xRow.childNodes[4].firstChild.nodeValue;
						if (attType == "D"){
							objTitle = "(" + TYPE_LABEL + DATE_LABEL;
						}else if (attType == "S"){
							objTitle = "(" + TYPE_LABEL + STRING_LABEL;						
						}else{
							objTitle = "(" + TYPE_LABEL + NUMERIC_LABEL;
						}
					}
					if (xRow.childNodes[5].firstChild != null){
						var oblig = xRow.childNodes[5].firstChild.nodeValue;
						objTitle = objTitle + ", " + OBLIG_LABEL + oblig;
					}
					if (xRow.childNodes[6].firstChild != null){
						var entity = xRow.childNodes[6].firstChild.nodeValue;
						objTitle = objTitle + ", " + MAP_ENTITY_LABEL + entity + ")";
					}else{
						objTitle = objTitle + ")";
					}
				}
				var oUL = new Element("ul");
				var oLI = new Element("li",{'class':'li'}); 
			
				oLI.title = objTitle;
				var isTask = false;
				var aux = new Array({type:'hidden',name:'hidTskId',id:'hidTskId',value:objId});
				if (type!="form" && type!="entityRedAtts" && type!="entityFormAtts" && type!="entityForm"){
					if (type=="processJer"){ //Si es subproceso
						if (xRow.childNodes[4]!=null && 'true'==xRow.childNodes[4].firstChild.nodeValue){//es subproceso
							
							var extra = {
									action:nextType,
									tooltip:null,
									text: objName,
									inputs:aux
							}
							aux.push({type:'hidden',name:'hidProEleId',id:'hidProEleId',value:-1});
							aux.push({type:'hidden',name:'hidProId',id:'hidProId',value:-1});							
						}else{//es tarea
							isTask = true;
							var extra = {
									action:nextType2,
									tooltip:null,
									text: objName,
									inputs:aux
							}
							aux.push({type:'hidden',name:'hidProEleId',id:'hidProEleId',value:xRow.childNodes[4].firstChild.nodeValue});
							aux.push({type:'hidden',name:'hidProId',id:'hidProId',value:xRow.childNodes[5].firstChild.nodeValue});							 
						}
					}else{
						var extra = {
								action:nextType,
								tooltip:null,
								text: objName,
								inputs:aux
						}
						aux.push({type:'hidden',name:'hidProEleId',id:'hidProEleId',value:-1});
						aux.push({type:'hidden',name:'hidProId',id:'hidProId',value:-1});
					}
					addAttLi(extra,oUL,isDimension);
				}else{
					if (checkIfSelected(objId,isDimension)){
						input = new Element('input',{type:'checkbox',checked:true,name:'chkAtt',id:'chkAtt'+objId,'onclick':'selUnselAttribute(this,'+objId+','+isDimension+')'});
					}else{
						input = new Element('input',{type:'checkbox',checked:false,name:'chkAtt',id:'chkAtt'+objId,'onclick':'selUnselAttribute(this,'+objId+','+isDimension+')'});
					}		
					var label = new Element('label',{'for':'chkAtt'+objId,html:objName,'class':'label'});
					input.inject(oLI);
					label.inject(oLI);
					input = new Element('input',{type:'hidden',name:'hidTskId',value:objId});
					input.inject(oLI);
					input = new Element('input',{type:'hidden',name:'hidProEleId',value:-1});
					input.inject(oLI);
					input = new Element('input',{type:'hidden',name:'hidProId',value:-1});	
					input.inject(oLI);
					oLI.inject(oUL);
				}			
			
				oUL.inject(element.parentNode);				
			}
		}
	}else{
		showMessage("error occurred");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}

function addAttLi(extra,ul,isDimension){
	
	
	var li = new Element('li',{title:extra.tooltip,'class':'li'});
	
	var div = new Element('div',{'class':'showChilds'});
	div.setAttribute("onclick","doLIAction(this,'"+extra.action+"',"+isDimension+")");
	div.addClass("plusMinus");
	div.inject(li);
	
	var span = new Element('span',{html:extra.text,title:extra.tooltip});
	span.inject(li);
	
	for (var i=0;i<extra.inputs.length;i++){
		var ex = extra.inputs[i];
		var hidden = new Element('input',{type:ex.type,name:ex.name,id:ex.id,value:ex.value});
		hidden.inject(li); 
	}
	li.inject(ul);
	
}

function doLIAction(aEvent, type,isDimension){
	var element = aEvent;
	if (type=="entityData" || type=="entityRedAtts" || type=="actEntityForms" || type=="entityFormAtts" || type=="entityForms" || type=="entityForm" || type=="entityProcessJer" || type=="processJer" || type=="process" || type=="task" || type=="form"){
		var close = false;
		if(element.hasClass("showChilds")){
			//Estaba cerrado --> hay que abrir			
			element.className='hideChilds';//show open			
		}else{ //Estaba abierto --> hay que cerrar
			element.className='showChilds';//show open
			close=true;
		}
	}
	if(!close){
		if (type=="entityData"){
			openBasicData(element,isDimension);
		}else if (type == "task"){
			openTaskForms(element,isDimension);
		}else{
			openData(element,type,isDimension);
		}
	}else{
		closeData(element);
	}
}

function openTaskForms(element,isDimension){
	obj = element.parentNode;
	var objId = obj.getElementsByTagName("INPUT")[0].value;
	var proEleId = obj.getElementsByTagName("INPUT")[1].value;
	var proId = obj.getElementsByTagName("INPUT")[2].value;
	
	var oUL = new Element("ul");
	
	//1.Formularios de entidad
	var aux = new Array();
	var extra = {
			action:'entityForms',
			tooltip:null,
			text: ENT_PRO_FORM_LABEL,
			inputs:aux
	}
	aux.push({type:'hidden',name:"hidObjId",id:"hidObjId",value:objId});
	aux.push({type:'hidden',name:"hidProEleId",id:"hidProEleId",value:proEleId});
	aux.push({type:'hidden',name:"hidProId",id:"hidProId",value:proId});
	
	addAttLi(extra,oUL,isDimension);	
	oUL.inject(element.parentNode);	
}

function openData(element,type,isDimension){
	var obj = element.parentNode;
	var objId = obj.getElementsByTagName("INPUT")[0].value;
	
	var op = "";	
	var extra = null;
	if (type=="entityRedAtts"){ //Atributos redundantes
		op = "1";	
		extra = {opt:op};
	}else if (type=="actEntityForms"){ //Formularios de la entidad actual
		op = "2";	
		extra = {opt:op};
	}else if (type=="entityForms"){ //Formularios de entidad
		op = "3";	
		var proEleId = obj.getElementsByTagName("INPUT")[1].value;
		var proId = obj.getElementsByTagName("INPUT")[2].value;
		extra = {opt:op,'proId':proId,'proEleId':proEleId};
	}else if (type=="process"){ //Proceso
		op = "4";
		extra = {opt:op,'proId':objId};
	}else if (type=="task"){ //Tarea de proceso
		op = "5";
		extra = {opt:op,'tskId':objId};
	}else if (type=="form"){ //Formulario de tarea
		op = "6";
		extra = {opt:op,'frmId':objId};
	}else if (type =="entityFormAtts" || type=="entityForm"){ //Atributos de un formulario de entidad
		op = "7";
		extra = {opt:op,'frmId':objId};
	}else if (type=="entityProcessJer"){ //Procesos donde se utiliza la entidad (solo los procesos padres)
		op = "8";
		extra = {opt:op,'proId':objId};
	}else if (type=="processJer"){ //Sub-Procesos y tareas de un proceso
		op = "9";
		extra = {opt:op,'proId':objId};
	}
	
	var request = new Request({
		method: 'post',			
		data:extra,
		url: CONTEXT + URL_REQUEST_AJAX+'?action=getTreeXMLForAddAttDim&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) { readXML(resXml,element,type,isDimension);  }
	}).send();
}

function openBasicData(element,isDimension){
	var oUL =  new Element("ul");
	var oLI1 = new Element("li",{title:ENTITY_ID_LABEL}); 
	var oLI2 = new Element("li",{title:ENTITY_STATUS_LABEL});
	var oLI3 = new Element("li",{title:ENTITY_CREATOR_LABEL});
	var oLI4 = new Element("li",{title:ENTITY_CRE_DATE_LABEL});
	
	var input
	
	//1.Identificador de la entidad
	if (checkIfSelBasicDat(-1,isDimension)){
		input = new Element('input',{type:'checkbox',checked:true,name:'chkAtt',id:'chkAtt1','onclick':'selUnselBasicData(this,-1,'+isDimension+')'});
	}else{
		input = new Element('input',{type:'checkbox',checked:false,name:'chkAtt',id:'chkAtt1','onclick':'selUnselBasicData(this,-1,'+isDimension+')'});
	}
	var label = new Element('label',{'for':'chkAtt1',html:ENTITY_ID_LABEL,'class':'label'});
	input.inject(oLI1);
	label.inject(oLI1);
	input = new Element('input',{type:'hidden',name:'hidEntDatId',value:'-1'});
	input.inject(oLI1);
	
	//2.Estado de la entidad
	if (checkIfSelBasicDat(-2,isDimension)){
		input = new Element('input',{type:'checkbox',checked:true,name:'chkAtt',id:'chkAtt2','onclick':'selUnselBasicData(this,-2,'+isDimension+')'});
	}else{
		input = new Element('input',{type:'checkbox',checked:false,name:'chkAtt',id:'chkAtt2','onclick':'selUnselBasicData(this,-2,'+isDimension+')'});		
	}
	label = new Element('label',{'for':'chkAtt2',html:ENTITY_STATUS_LABEL,'class':'label'});
	input.inject(oLI2);
	label.inject(oLI2);
	input = new Element('input',{type:'hidden',name:'hidEntDatId',value:'-2'});
	input.inject(oLI2);
	
	//3.Creador de la entidad
	if (checkIfSelBasicDat(-3,isDimension)){
		input = new Element('input',{type:'checkbox',checked:true,name:'chkAtt',id:'chkAtt3','onclick':'selUnselBasicData(this,-3,'+isDimension+')'});		
	}else{
		input = new Element('input',{type:'checkbox',checked:false,name:'chkAtt',id:'chkAtt3','onclick':'selUnselBasicData(this,-3,'+isDimension+')'});
	}
	label = new Element('label',{'for':'chkAtt3',html:ENTITY_CREATOR_LABEL,'class':'label'});
	input.inject(oLI3);
	label.inject(oLI3);
	input = new Element('input',{type:'hidden',name:'hidEntDatId',value:'-3'});
	input.inject(oLI3);
	
	//4.Fecha de creacion de la entidad
	if (checkIfSelBasicDat(-4,isDimension)){
		input = new Element('input',{type:'checkbox',checked:true,name:'chkAtt',id:'chkAtt4','onclick':'selUnselBasicData(this,-4,'+isDimension+')'});
	}else{
		input = new Element('input',{type:'checkbox',checked:false,name:'chkAtt',id:'chkAtt4','onclick':'selUnselBasicData(this,-4,'+isDimension+')'});
	}
	label = new Element('label',{'for':'chkAtt4',html:ENTITY_CRE_DATE_LABEL,'class':'label'});
	input.inject(oLI4);
	label.inject(oLI4);
	input = new Element('input',{type:'hidden',name:'hidEntDatId',value:'-4'});
	input.inject(oLI4);
	
	oLI1.inject(oUL);
	oLI2.inject(oUL);
	oLI3.inject(oUL);
	oLI4.inject(oUL);
	
	oUL.inject(element.parentNode);
}

function closeData(element){
	var ul = element.parentNode.getElementsByTagName("UL");
	while(ul.length >0){
		ul[0].parentNode.removeChild(ul[0]);
	}
}

function btnEstTime_click(){
	if (verifyCubeDataToEstimateTime()){
		var str = getAttIdsSelected();
		if (str == ""){
			showMessage("Must complete cube first");
		}else{
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX +'?action=estimateTime' + TAB_ID_REQUEST,
				onRequest: function() { sp.show(true); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
			}).send(str);			
		}
	}
}

function verifyCubeDataToEstimateTime(){
	//Verificamos si ingreso al menos dos dimensiones
		if ($("gridDims").rows.length < 2){
			showMessage(MSG_MUST_ENT_TWO_DIMS);
			return false;
		}
		
		//Verificamos dimensiones
		var dimRows=$("gridDims").rows;
		for(var i=0;i<dimRows.length;i++){
			var dimName=dimRows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
			var attName = dimRows[i].cells[0].getElementsByTagName("INPUT")[0];
			if(attName == ""){//Verificamos que los nombres de los atributos no sean nulos
				showMessage(MSG_MIS_DIM_ATT);
				return false;
			}
			if (dimName == ""){//Verificamos que los nombres de las dimensiones no sean nulos
				showMessage(MSG_WRG_DIM_NAME);
				return false;
			}
		}
				
		//Verificamos si ingreso al menos una medida
		if ($("gridMeasures").rows.length < 1){
			showMessage(MSG_MUST_ENT_ONE_MEAS);
			return false;
		}
		
		//Verificamos medidas
		var meaRows=$("gridMeasures").rows;
		for(var i=0;i<meaRows.length;i++){
			//Verificamos haya seleccionado atributos en las medidas estandard			
			var cmb=meaRows[i].cells[2].getElementsByTagName("SELECT")[0];
			var measType = (cmb.options[cmb.selectedIndex].value);
			if (measType == 0){//Si es medida calculada verificamos la formula
				var attName = meaRows[i].cells[0].getElementsByTagName("INPUT")[0];
				if(attName == ""){//Verificamos que los nombres de los atributos no sean nulos
					showMessage(MSG_MIS_MEA_ATT);
					return false;
				}
			}
		}
		return true;
}

function getAttIdsSelected(){
  	var str = "";
  	var mapAtts = 0;
  	if ($("gridDims") != null && $("gridMeasures")!=null){
		var dimRows=$("gridDims").rows;
		for(var i=0;i<dimRows.length;i++){
			var attId = dimRows[i].cells[0].getElementsByTagName("INPUT")[1].value;
			if (str == ""){
	  			str = "attId=" + attId;
		  	}else if (str.indexOf(attId)<0){
		  		str = str + "&attId=" + attId;
	  		}
	  		if (dimRows[i].cells[0].getElementsByTagName("INPUT")[3].value != "D"){
		  		var map=dimRows[i].cells[2].getElementsByTagName("INPUT")[1].value;
		  		
		  	}else{
		  		var map=dimRows[i].cells[2].getElementsByTagName("INPUT")[10].value;
		  	}
	  		if (map != "" && map != "on"){
	  			mapAtts++;
		  	}
		}
		var dimMeas=$("gridMeasures").rows;
		for(var i=0;i<dimMeas.length;i++){
			var attId=dimMeas[i].cells[0].getElementsByTagName("INPUT")[1].value;
			if (str == ""){
	  			str = "attId=" + attId;
		  	}else if (str.indexOf(attId)<0){
		  		str = str + "&attId=" + attId;
	  		}
		}
		str = str + "&mapAtts="+mapAtts;
	}
	return str;

}

function changeRadFact(val){
	if (val == 1){		
    	$('panelOptions').style.display='';
    	$('btnView').style.display='none' 
    	$('btnEstTime').style.display='';
		$("radSelected").value = 1;
		$("txtFchIni").disabled=true;
		$("txtHorIni").disabled=true;
		disposeValidation($("txtFchIni"));
		disposeValidation($("txtHorIni"));
	}else if (val == 2){
		$('panelOptions').style.display='none';
    	$('btnView').style.display='none' 
    	$('btnEstTime').style.display='none';
		$("radSelected").value = 2;
		$("txtFchIni").disabled=false;
		$("txtHorIni").disabled=false;
		registerValidation($("txtFchIni"));
		registerValidation($("txtHorIni"));
	}
} 

function loadNoAccProfiles(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=loadCubeRestrictedProfiles' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processXMLCubeRestrictedProfiles(resXml); sp.hide(true); }
	}).send();
}

function processNoAccProfilesModalReturn(ret){
	ret.each(function(e){
		var text = e.getRowContent()[0];
		addActionElementNoAccProfile($('divNoAccProfiles'),text,e.getRowId(),"true",true,"chkPrfRest",true);
	});
}

function addActionElementNoAccProfile(container, text, id, helper, addRemove, inputName,isNew){
	var repeated = false;
	//primero verificar que no exista
	container.getElements("DIV").each(function(item,index){
		if(item.getAttribute("id")==id){
			repeated = true;
		}
	});
	if(repeated){
		return;
	}
	
	//si no est�, se agrega
	var divElement = new Element('div', {'class': 'option optionRemove'});
	divElement.setAttribute("id", id);
	divElement.setAttribute("helper",helper);
	
	var divData = new Element('div',{'class':'profileNoAccData',html:text});
	divData.inject(divElement);
	
	var input =  new Element('input',{type:'hidden','name':inputName,value:id,'flagNew':isNew,'profile':text});	
	input.inject(divElement);	
	
	var editIcon = new Element('div', {'class': 'editIcon'});
	editIcon.addEvent("click", function(e){
		//Para agregar un perfil de acceso restringido, se debe verificar previamente que el cubo tenga nombre
		if ($("txtCbeName")==""){
			showMessage(MSG_CBE_NAME_MISS);
			return;
		}
		if (!e) var e = window.event; e.cancelBubble = true; if (e.stopPropagation) e.stopPropagation();
		var trows=$("gridDims").rows;
		var dimNames = "";
		for (var i=0;i<trows.length;i++){
			var dimName = trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].value;
			dimNames+=dimName+";";
			
			var request = new Request({
				method: 'post',
				data:{'txtDimName':dimNames,'prfName':text,cbeName:$("txtCbeName").value},
				url: CONTEXT + URL_REQUEST_AJAX +'?action=loadDims' + TAB_ID_REQUEST,
				onRequest: function() { sp.show(true); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
			}).send();
		}
		
		
	});
	editIcon.inject(divElement);
	
	if(addRemove){
		//divElement.container = container;		
		divElement.addEvent("click", function(e){
			var request = new Request({
				method: 'post',
				data:{'prfName':text},
				url: CONTEXT + URL_REQUEST_AJAX +'?action=removeNoAccProfile' + TAB_ID_REQUEST,				
				onRequest: function() { sp.show(true); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml);sp.hide(true);}
			}).send();
			this.destroy();
			if (this.container && this.container.onRemove) this.container.onRemove();
		});
		divElement.addEvent("mouseenter", actionElementAdminMouseOverToggleClasss);
		divElement.addEvent("mouseleave", actionElementAdminMouseOverToggleClasss);
	}
	
	divElement.inject(container.getLast(),'before');
	
	return divElement;
}

function processXMLCubeRestrictedProfiles(ajaxCallXml){
	if (ajaxCallXml != null) {		
		var envs = ajaxCallXml.getElementsByTagName("profiles");
		if (envs != null && envs.length > 0 && envs.item(0) != null) {
			envs = envs.item(0).getElementsByTagName("profile");
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				var text	= env.getAttribute("text");
				var id = env.getAttribute("id");
				addActionElementNoAccProfile($('divNoAccProfiles'),text,id,"true",true,"chkPrfRest",false);
			}
		}
	}
}

function loadProfiles(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX +'?action=loadCubeProfiles' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { processXMLCubeProfiles(resXml); sp.hide(true); }
	}).send();
}

function processProfilesModalReturn(ret){
	ret.each(function(e){
		var text = e.getRowContent()[0];
		addActionElement($('divProfiles'),text,e.getRowId(),"chkPrf");
	});
}

function processXMLCubeProfiles(ajaxCallXml){
	if (ajaxCallXml != null) {		
		var envs = ajaxCallXml.getElementsByTagName("profiles");
		if (envs != null && envs.length > 0 && envs.item(0) != null) {
			envs = envs.item(0).getElementsByTagName("profile");
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				var text	= env.getAttribute("text");
				var id = env.getAttribute("id");
				addActionElement($('divProfiles'),text,id,"chkPrf");
			}
		}
	}
}

function clickGoBack(){
	sp.show(true);
	window.location = CONTEXT + URL_REQUEST_AJAX + '?action=list' + TAB_ID_REQUEST;	
}

function returnFalse(){	
	return false;
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

function fixTableEnt(table){
	if (table){
		var trs = table.getElements("tr"); 
		var total = trs.length;
		var i = 1;
		trs.each(function (tr){
			if (i % 2 == 0){
				tr.addClass("trOdd");
			} else {
				tr.removeClass("trOdd");
			}
			if (i == total){
				tr.addClass("lastTr");
			} else {
				tr.removeClass("lastTr");
			}
			i++;
		});
		
		if (table == $('tableDataFormEnt')){
			Scroller1 = addScrollTable(table);
		} else if (table == $('tableDataFormMonEnt')){
			Scroller2 = addScrollTable(table);
		} else {
			addScrollTable(table);	
		}		
	}	
}

