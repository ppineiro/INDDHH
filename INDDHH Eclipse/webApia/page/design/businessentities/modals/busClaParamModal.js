var tdWidthsParams;
var currentEvents;

function initPage(){
	
	//Se obtienen anchos de columnas
	tdWidthsParams = getTdWidths($('tableDataBCParams'));

	loadBCParameters(parent.selectedClaId);
	
	//Se inicializan eventos actuales
	currentEvents = JSON.parse(parent.currentSelectedEvents);

	//Se inicializa combo con opciones de tipo de parámetros
	cmbTypeParams = new Element('select',{styles:{'width':'100%'}});
	new Element('option',{value:0, html:LBL_VAL}).inject(cmbTypeParams);
	new Element('option',{value:1, html:LBL_ENT_ATT}).inject(cmbTypeParams);
	new Element('option',{value:2, html:LBL_PRO_ATT}).inject(cmbTypeParams);
	
}
function getModalReturnValue() {
	return JSON.stringify(currentEvents); 
}

function loadBCParameters(clsId){
	var request = new Request({
		method: 'get',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=xmlBindings' + TAB_ID_REQUEST + '&claId=' + clsId,
		onSuccess: function(resText, resXml) {
			var values = resXml.getElementsByTagName('ROW');
			if (values){
				for(var i=0; i<values.length; i++){
					var id, inout, type, param, desc;
					
					var paramData=values[i].getElementsByTagName('COL');
					if (paramData){
						id=paramData[0].textContent;
						param=paramData[1].textContent;
						type=paramData[2].textContent;
						inout=paramData[3].textContent;
					}
					
					var evt = currentEvents;
					var bnd = getEventBinding(evt, id);
					if (!bnd){
						bnd = new ApiaEventBinding(id, param, type, 'V');
						bnd.param_desc=desc;
						evt.bindings.push(bnd);
					}
					
					addParameterRow(inout, bnd);
				}
			}
		}
	}).send();
}

function addParameterRow(inout, bnd){
	var tbody = $('tableDataBCParams');
	
	var tr = new Element('tr');	
	tr.getId = function () { return this.getAttribute("data-id"); };
	tr.setId = function (id) { this.setAttribute("data-id",id); };
	tr.setId(bnd.param_id);
	
	if(tbody.rows.length%2==0) tr.addClass("trOdd");
		
	var inputValue, lblInput, lblCmb, lblAtt, cmbType;
	var divInput, divAttModal;

	
	for (var i=0; i<6; i++){
		var td = new Element('td', {width: tdWidthsParams[i]});
		var div = new Element('div', {styles: {width: '100%', 'height': '17px', overflow: 'hidden', 'white-space': 'pre'}});

		if (i==0){//In-Out
			div.setStyle('text-align', 'center');
			
			switch(inout){
			case 'In' : new Element('img.icon-container-full',{src:FORM_IMG_PATH+"paramIn.png"}).inject(div); break;
			case 'In/Out' : new Element('img.icon-container-full',{src:FORM_IMG_PATH+"paramInOut.png"}).inject(div); break;
			case 'Out' : new Element('img.icon-container-full',{src:FORM_IMG_PATH+"paramOut.png"}).inject(div); break;
			};
			
		} else if (i==1){//Tipo
			div.setStyle('text-align', 'center');			
			switch(bnd.param_type){
			case 'S' : new Element('img.icon-container-full',{src:FORM_IMG_PATH+"stringIcon.png"}).inject(div); break;
			case 'N' : new Element('img.icon-container-full',{src:FORM_IMG_PATH+"numericIcon.png"}).inject(div); break;
			case 'D' : new Element('img.icon-container-full',{src:FORM_IMG_PATH+"dateIcon.png"}).inject(div); break;
			case 'I' : new Element('img.icon-container-full',{src:FORM_IMG_PATH+"integerIcon.png"}).inject(div); break;
			}		
		} else if (i==2){//Nombre
			var span = new Element('span', {'html': bnd.param_name}).inject(div);
		} else if (i==3){//Descripción
			div.setStyle('text-overflow','ellipsis');
			var span = new Element('span', {title:bnd.param_desc, 'html': bnd.param_desc}).inject(div);
		} else if (i==4){//Tipo Valor
			cmbType = cmbTypeParams.clone().inject(div);
			cmbType.hide();		
			
			var currentValueType = "";
			switch(bnd.att_type){
			case 'V' : cmbType.selectedIndex=0; break;
			case 'E' : cmbType.selectedIndex=1; break;
			case 'P' : cmbType.selectedIndex=2; break;
			}
			currentValueType = cmbType.options[cmbType.selectedIndex].textContent;
			
			cmbType.addEvents({
				'blur': function(e){
					this.hide();
					lblCmb.show();
				},
				'change': function(e){
					lblCmb.innerHTML = this.options[this.selectedIndex].textContent;
					this.hide();
					lblCmb.show();
					
					switch(this.selectedIndex){
					case 0: bnd.att_type='V'; break;
					case 1: bnd.att_type='E'; break;
					case 2: bnd.att_type='P'; break;
					}
					
					if (bnd.att_type=="V"){
						divInput.show();
						divAttModal.hide();
					} else {
						divAttModal.show();
						divInput.hide();
					}
					
					//Se resetean valores
					bnd.reset();
					lblInput.textContent='';
					inputValue.value='';
					lblAtt.textContent='';
				}
			})
			
			lblCmb = new Element('div', {styles:{'cursor':'pointer'}, html: currentValueType})
				.addEvent('click', function(e){
					lblCmb.hide();			
					cmbType.show();
					cmbType.focus();				
				})	
				.inject(div);
			
		} else if (i==5){//Valor

			divInput=new Element('div').inject(div);
			divAttModal=new Element('div').inject(div);
			
			divInput.hide();
			divAttModal.hide();
			
			/* divInput */
			inputValue = new Element('input', {styles:{width:'96%'}, value:Generic.unespapeHTML(bnd.value)}).inject(divInput);
			inputValue.hide();
			
			lblInput = new Element('div.lbl-container', {title: Generic.unespapeHTML(bnd.value), html:bnd.value})
				.addEvent('click', function(e){
					lblInput.hide();			
					inputValue.show();
					
					inputValue.focus();
				})	
				.inject(divInput);
			
			inputValue.addEvents({
				'blur':  function(e){
					inputValue.hide();
					lblInput.show();
					var newValue = Generic.espapeHTML(inputValue.value);
					lblInput.innerHTML = newValue;
					lblInput.title = inputValue.value;
					bnd.value=newValue;
				}
			})
			/* Fin divInput */
			
			
			/* divAttModal */				
			lblAtt = new Element('div.lbl-container', {title: bnd.att_name,html:bnd.att_name,styles:{'margin-right': '20px'}})
				.inject(divAttModal);
			
			td.setStyle('position','relative');
			var iconContainer = new Element('div.icon-container',{styles:{'right':'5px'}}).inject(divAttModal);
			
			new Element('div.icon-item.search-icon')
				.addEvent('click', function(e){
					if (e) e.stop();
					
					var footerMask = new Mask(parent.ModalController.modals[0].modalWin.getElement('.modalBottomBar'));
					footerMask.show();
					
					openModal(ATTRIBUTES_MODAL, '&requestAction='+URL_REQUEST_AJAX, 60, 65, 
						function(attInfo){//Confirm
							if (!attInfo) return;
							var attId=attInfo[0], attName=attInfo[1], attLabel=attInfo[2];
														
							lblAtt.textContent = attName;
							lblAtt.title = attName;
							bnd.att_id=attId;
							bnd.att_name=attName;
							bnd.att_label=attLabel;
							
							footerMask.destroy();
						}, 
						function(){//Close
							footerMask.destroy();
						}, 
						parent.document.body
					)
				})
				.inject(iconContainer);
			/* Fin divAttModal */
			
			
			if (bnd.att_type=="V" || bnd.att_type=="null"){
				divInput.show();	
			} else {
				divAttModal.show();
			}
		}
		
		div.inject(td);
		td.inject(tr);
		tr.inject(tbody);
	}
	
	//--Scroll
	addScrollTable(tbody);	
}

function getEventBinding(event, paramId){
	if (event && event.bindings){
		for(var i=0; i<event.bindings.length; i++){
			if (event.bindings[i].param_id==paramId){
				var bnd = new ApiaEventBinding();
				bnd.initializeFromObject(event.bindings[i]);
				event.bindings[i]=bnd;
				return bnd;
			}
		}
	}
	return null;
}