/**
 * Impresion de formularios
 */

function printForms(source) {
	//console.log('Imprimiendo formularios');
	var tabComponent = $('tabComponent');
	var modalContent = new Element('div');
	
	var title = new Element('div.printTitle');
	var titleSpan = $('titleSpan');
	if(!titleSpan)
		titleSpan = $('frmData').getElement('span.taskTitle')
		
	var span1 = new Element('span');
	span1.inject(title);
	if(titleSpan){
		span1.innerText = titleSpan.get('html');	
	}

//	title.set('html', '<span>' + titleSpan.get('html') + '</span>');
	title.inject(modalContent);
	
	if(tabComponent) {
		var extra_forms;
		tabComponent.getElements('div.tabContent').each(function(tab) {
			var form = tab.getChildren('div.formContainer');
			if(form && form.length > 0) {
				for(var i = 0; i < form.length; i++) {
					var frm = form[i].retrieve(Field.STORE_KEY_FORM);
					if(frm) {
						//Pedir al formulario su html de impresi�n
						new Element('div.tabContent').set('html', frm.getPrintHTML()).inject(modalContent);
					}
				}
				if(!extra_forms) extra_forms = [];
			} else {
				//No es un formulario de ejecucion
				var clone = tab.clone();
				
				clone.getElements('input').each(function(input) {
					input.set('disabled', true);
				});
				clone.getElements('select').each(function(select) {
					select.set('disabled', true);
				});
				clone.getElements('textarea').each(function(area) {
					area.set('disabled', true);
				});
				//Si encontre formularios de ejecucion, el resto de los otros formularios los coloco al final
				if(extra_forms)
					extra_forms.push(clone);
				else
					clone.inject(modalContent);
			}
		});
		if(extra_forms)
			extra_forms.each(function(extra_form) { extra_form.inject(modalContent); });
	}
	
	try {
		if(beforePrintFormsData_E)
			beforePrintFormsData_E();
	} catch (e) {}
	
	try {
		if(beforePrintFormsData_P)
			beforePrintFormsData_P();
	} catch(e) {}
	
	var modal = ModalController.openContentModal({url: CONTEXT + '/page/execution/print.jsp?' + TAB_ID_REQUEST, content: modalContent}, 750, 600);
	
	modal.addEvent('beforeConfirm', function(e) {
		if(Browser.ie) {
			this.modalWin.getElement('iframe.modal-content').contentWindow.document.execCommand('print', false, null);
		} else {
			this.modalWin.getElement('iframe.modal-content').contentWindow.print();
		}
	});
	
	modal.addEvent('close', function(e) {
		try {
			if(afterPrintFormsData_E)
				afterPrintFormsData_E();
		} catch (e) {}
		try {
			if(afterPrintFormsData_P)
				afterPrintFormsData_P();
		} catch(e){ }
		
		source.focus();
	});
}

/**
 * Impresion de consultas de usuario
 * param qryTitle: Titulo de la consulta.
 * param results : Array indicando la cantidad de resultados y si existen mas.
 * param headers: Array con todos los nombres cabezales de la consulta.
 * param values: Array de arrays con los valores de la tabla.
 * param graphs: Array con las graficas que tiene la consulta.
 */
function printUserQuery(qryTitle,results,headers,values,graphs){
	var modalContent = new Element('div');	
	
	//titulo de la consulta
	new Element("span",{html:qryTitle}).inject(new Element("div.printTitle.withBorder",{}).inject(modalContent));
	
	//resultados de la consulta
	var divSubtitles = null;
	for (var i = 0; i < results.length; i++){
		if (!divSubtitles){
			divSubtitles = new Element("div.printSubtitle",{}).inject(modalContent);
		}
		new Element("span",{html:results[i]}).inject(divSubtitles);
	}
	
	new Element("div.printSeparator",{}).inject(modalContent);
	
	//tabla de valores de la consulta
	var tr;
	var table;
	for (var v = 0; v < values.length; v++){
		for (var h = 0; h < headers.length; h++){
			if (h == 0){
				table = new Element("table.tbl-query").inject(modalContent);
			}
			if (h % 2 == 0){
				tr = new Element("tr.tr-query",{}).inject(table);
			}
			
			new Element("div.header-query",{html:headers[h]}).inject(new Element("td.tdHeader-query",{}).inject(tr));
			new Element("div.content-query",{html:values[v][h]}).inject(new Element("td.tdContent-query",{}).inject(tr));
		}
	}
	
	new Element("div.printSeparator",{}).inject(modalContent);
	
	//graficas
	if (graphs && graphs.length > 0){
		for (var i = 0; i < graphs.length; i++){
			var divChart = new Element("div.print_chart",{}).inject(modalContent);
			new Element("span",{html:graphs[i].get("title")}).inject(divChart);
			graphs[i].inject(divChart);
		}
	}
	
	var modal = ModalController.openContentModal({url: CONTEXT + '/page/execution/print.jsp?' + TAB_ID_REQUEST, content: modalContent}, 750, 600);
	modal.setConfirmLabel(BTN_PRINT);
	modal.addEvent('beforeConfirm', function(e) {
		this.modalWin.getElement('iframe.modal-content').contentWindow.print();
	});
}

