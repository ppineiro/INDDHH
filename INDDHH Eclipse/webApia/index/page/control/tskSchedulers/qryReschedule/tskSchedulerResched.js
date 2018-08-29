var Scheduler = new Class({
	
	Implements: Events,
	
	mondayDate: null,
	
	container: null,
	
	xml: null,
		
	initialize: function(container) {
		this.container = container;
	},
	
	getMondayDateStr: function() {		
		return this.mondayDate.getDate() + '/' + (this.mondayDate.getMonth() + 1) + '/' + this.mondayDate.getFullYear();
	},
	
	getCompleteMondayDateStr: function() {
		var day = this.mondayDate.getDate() + "";
		if(day.length == 1) day = '0' + day;
		
		var month = this.mondayDate.getMonth() + 1 + "";
		if(month.length == 1) month = '0' + month;
		
		return day + '/' + month + '/' + this.mondayDate.getFullYear();
	},
	
	getMonth: function() {
		return this.mondayDate.getMonth() + 1;
	},
	
	generateScheduler: function(xml) { 
		if (xml==null) return;
		this.xml = xml;
		
		this.container.set('html', '');
		
		this.overassign = Number.from(xml.getAttribute('overassign'));
		
		var mins = xml.getAttribute('frec');
		var date_split = xml.getAttribute('mondayWeek').split('/');
		var day = Number.from(date_split[0]);
		var month = Number.from(date_split[1]);
		var year = Number.from(date_split[2]);
		
		var actual_week_str = this.getNavBtnText(day, month, year);
		
		if(xml.getAttribute('weekNotConfigured')) {
			//Semana no configurada
			showMessage(LBL_SCHED_WEEK_NOT_CONFIGURED, LBL_SCHED_FORM_TITLE);
			return actual_week_str;
		}
		
		//Generar la tabla
		var table = new Element('table.tskSchedTable', {
			cellspacing: '0'
		}).store('calendar', this);
		table.set('html', '<thead><tr><th style="width: 50px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th><th>' + this.getHeaderDate(day, month, year) + '</th><th>' + this.getHeaderDate(day + 1, month, year) + '</th><th>' + this.getHeaderDate(day + 2, month, year) + '</th><th>' + this.getHeaderDate(day + 3, month, year) + '</th><th>' + this.getHeaderDate(day + 4, month, year) + '</th><th>' + this.getHeaderDate(day + 5, month, year) + '</th><th>' + this.getHeaderDate(day + 6, month, year) + '</th></tr></thead>');
	
		var start_hour = '9999';
		var end_hour = '0000';
		
		Array.from(xml.childNodes).each(function (day_xml, index) {
			//Buscamos la hora de inicio
			for(var i = 0; i < day_xml.childNodes.length; i++) {
				var aux_hour = day_xml.childNodes[i].getAttribute('hour');
				if(day_xml.childNodes[i].getAttribute('disabled') != 'true') {				
					if(aux_hour < start_hour)
						start_hour = aux_hour;

					if(aux_hour > end_hour)
						end_hour = aux_hour;
				}
			}
		});
		
		if(start_hour == '9999') {
			showMessage(LBL_SCHED_WEEK_NOT_CONFIGURED, LBL_SCHED_FORM_TITLE);
			return actual_week_str;
		}
		
		//Corregimos mes
		//var month = month - 1;
		month--;
		
		this.mondayDate = new Date(year, month, day);
		
		this.frecuency_ms = mins*60*1000;
		var startDate = new Date(year, month, day, start_hour[0] + '' + start_hour[1] , start_hour[2] + '' + start_hour[3], 0, 0);
		
		var endDate;
		
		if(end_hour == '0000') {
			end_hour == '2400';
			endDate = new Date(year, month, day, end_hour[0] + '' + end_hour[1] , end_hour[2] + '' + end_hour[3], 0, 0);
		} else {
			endDate = new Date(year, month, day, end_hour[0] + '' + end_hour[1] , end_hour[2] + '' + end_hour[3], 0, 0);
			var time = endDate.getTime();
			endDate.setTime(time + this.frecuency_ms);
		}
		
		var tbody = new Element('tbody').inject(table);
		
		var curr_day = startDate.getDay();		
		//var trs = new Array();
		
		while(startDate < endDate) {
		
			var curr_hour = startDate.getHours() + '';
			if(curr_hour.length == 1) curr_hour = '0' + curr_hour;
			var curr_min = startDate.getMinutes() + '';
			if(curr_min.length == 1) curr_min = '0' + curr_min;
			var tr = new Element('tr', {
				id: curr_hour + "" + curr_min
			}).set('html', '<td style="width: 50px">' + curr_hour + ':' + curr_min + '</td><td d="1">&nbsp;</td><td d="2">&nbsp;</td><td d="3">&nbsp;</td><td d="4">&nbsp;</td><td d="5">&nbsp;</td><td d="6">&nbsp;</td><td d="7">&nbsp;</td>');
			
			tr.inject(tbody);
			
			//trs.push(tr);
			
			tr.getElements('td').erase(tr.getElements('td')[0]).each(function(td, index) {
				
				if(this.canBeAsigned(day + index, month + 1, year, curr_hour, curr_min)) {
					td.set('strdate', this.getStrDate(day + index, month + 1, year));
					td.addEvent('click', this.selectTD);
				} else {
					td.addClass('td_disabled');
				}
			}.bind(this));
			
			var time = startDate.getTime();
			startDate.setTime(time + this.frecuency_ms);
			
			//week_day = startDate.getDay();
		}
	
		table.inject(this.container);
		
		//Cargamos la tabla
		Array.from(xml.childNodes).each(function (day_xml, index) {
			//Para cada día
			//if(day_xml.getAttribute('disabled') == 'true') {
			if(day_xml.getAttribute('type') == 'free') {
				tbody.getElements('tr').each(function(tr) {
					tr.getElements('td').each(function (td, td_index) {
						if(td_index == index + 1) {
							td.removeEvent('click', this.selectTD);
							td.addClass('td_blocked');
						}
					}.bind(this));
				}.bind(this));
			} else if(day_xml.getAttribute('type') == 'no_laboral') {
				tbody.getElements('tr').each(function(tr) {
					tr.getElements('td').each(function (td, td_index) {
						if(td_index == index + 1) {
							td.removeEvent('click', this.selectTD);
							td.addClass('td_disabled');
						}
					}.bind(this));
				}.bind(this));
			} else {
				Array.from(day_xml.childNodes).each(function (hour_xml) {
					var tr_hour = $(hour_xml.getAttribute('hour'));
					var value = hour_xml.getAttribute('value');
					
					if(tr_hour) {
						tr_hour.getElements('td').each(function (td, td_index) {
							if(td_index == index + 1 && !td.hasClass('td_blocked') && !td.hasClass('td_disabled')) {
								
								if(value != null && value != "") {
									var val_number = Number.from(value) + this.overassign;
									
									if(TskScheduler.showDisponibility) {
										//td.set('html', value);
										td.set('html', val_number);
									}
									//td.set('available_turns', value);
									td.set('available_turns', val_number);
									
									//if(value == '-' + this.overassign || this.overassign == 0 && value == '0') {
									if(val_number == 0) {
										//TURNO COMPLETO
										td.addClass('td_blocked');
									} else if(val_number <= this.overassign) {
										//SOBREASIGNADO
										td.addClass('td_overassign');
									}
								}
							}
						}.bind(this));
					}
				}.bind(this));
			}
		}.bind(this));
		
		return actual_week_str;
	},
	
	getNavBtnText: function(day, month, year) {
		var d1 = this.getDate(day, month, year);
		var d2 = this.getDate(day + 6, month, year);
		
		if(d1.getMonth() == d2.getMonth()) {
			return d1.getDate() + ' - ' + d2.getDate() + ' ' + LBL_SCHED_OF + ' ' + this.getMonthStr(d1.getMonth()) + ', ' + d1.getFullYear();
		} else if(d1.getYear() == d2.getYear()) {
			return d1.getDate() + ' ' + LBL_SCHED_OF + ' ' + this.getMonthStr(d1.getMonth()) + ' - ' + d2.getDate() + ' ' + LBL_SCHED_OF + ' ' + this.getMonthStr(d2.getMonth()) + ', ' + d1.getFullYear();
		} else {
			return d1.getDate() + ' ' + LBL_SCHED_OF + ' ' + this.getMonthStr(d1.getMonth()) + ', ' + d1.getFullYear() + ' - ' + d2.getDate() + ' ' + LBL_SCHED_OF + ' ' + this.getMonthStr(d2.getMonth()) + ', ' + d2.getFullYear();
		}
	},

	cell_selected: null,
	frecuency_ms: null,

	getDate: function(day, month, year) {
		if(!year)
			year = new Date().getFullYear();
		if(!month)
			month = new Date().getMonth() + 1;
		
		var d = new Date(year, month - 1);
		
		if (d.getLastDayOfMonth() < day) {
			var curr_day = day - d.getLastDayOfMonth();
			if(month == 12) {
				month = 0;
				year++;
			}
			d = new Date(year, month, curr_day);
		} else {
			d.setDate(day);
		}
		
		return d;
	},

	getMonthStr: function(month) {	
		switch(month) {
			case 0: return TSK_MONT_JAN; 
			case 1: return TSK_MONT_FEB;
			case 2: return TSK_MONT_MAR;
			case 3: return TSK_MONT_APR;
			case 4: return TSK_MONT_MAY;
			case 5: return TSK_MONT_JUN;
			case 6: return TSK_MONT_JUL;
			case 7: return TSK_MONT_AUG;
			case 8: return TSK_MONT_SEP;
			case 9: return TSK_MONT_OCT;
			case 10: return TSK_MONT_NOV;
			case 11: return TSK_MONT_DEC;
		}	
		return '';
	},

	getDayStr: function(day) {
		switch(day) {
			case 0: return TSK_DAY_SUN;
			case 1: return TSK_DAY_MON;
			case 2: return TSK_DAY_TUE;
			case 3: return TSK_DAY_WED;
			case 4: return TSK_DAY_THU;
			case 5: return TSK_DAY_FRI;
			case 6: return TSK_DAY_SAT;
		}	
		return '';
	},

	getHeaderDate: function(day, month, year) {
		
		var d = this.getDate(day, month, year);
		
		var current_date = new Date();
		
		//if(current_date.diff(d) == 0)
		if(current_date.getDate() == d.getDate() && current_date.getMonth() == d.getMonth() && current_date.getYear() == d.getYear())
			return '<span style="font-weight: bold;">' + this.getDayStr(d.getDay()) + ' ' + d.getDate() + '/' + (d.getMonth() + 1) + '</span>';
		
		return this.getDayStr(d.getDay()) + ' ' + d.getDate() + '/' + (d.getMonth() + 1);
	},

	getStrDate: function(day, month, year) {
		
		var d = this.getDate(day, month, year);
		
		return this.getDayStr(d.getDay()) + ', ' + d.getDate() + ' ' + LBL_SCHED_OF + ' ' + this.getMonthStr(d.getMonth()) + ', ' + d.getFullYear();
		
	},
	
	canBeAsigned: function(day, month, year, hours, minutes) {
		var d = this.getDate(day, month, year);
		
		d.setHours(hours);
		d.setMinutes(minutes);
		
		var current_date = new Date(); 
		
		return (current_date.diff(d, 'minute') > 0); 
	},

	selectTD: function(event) {
		
		var cal = event.target.getParent('table').retrieve('calendar')
		
		//TODO: Preguntar por la cantidad disponible para la celda.
		var value = Number.from(event.target.get('available_turns'));
		if(value < 1)
			return;
		
		if(value <= cal.overassign)
			event.target.addClass('td_overassign');
		
		if(cal.cell_selected)
			cal.cell_selected.removeClass('td_selected');
		
		event.target.addClass('td_selected');
		 
		cal.cell_selected = event.target;
		//cal.openCalendarModal(event.target, event.page.x, event.page.y);
		cal.fireEvent('tdselected', event);
	},
	
	forceDateSelect: function(td) {
		var cal = td.getParent('table').retrieve('calendar')

		//var value = Number.from(td.get('available_turns'));
		//if(value < 1)
		//	return;
		
		td.addClass('td_selected');
		 
		cal.cell_selected = td;		
	}
});

var TskScheduler = {};

TskScheduler.visDate = new Date();
TskScheduler.schId = null;
TskScheduler.proId = null;
TskScheduler.proVerId = null;
TskScheduler.tskId = null;
TskScheduler.prev_cell_selected = null;
TskScheduler.showDisponibility = null;
TskScheduler.prev_data_selected = null;

TskScheduler.schedDiv = null;

TskScheduler.loadSchedExec = function(schedDiv, schId, proId, proVerId, tskId, showDisponibility) {
	
	//var schedContainer = $(schedDiv);
	TskScheduler.schId = schId;
	TskScheduler.proId = proId;
	TskScheduler.proVerId = proVerId;
	TskScheduler.tskId = tskId;
	TskScheduler.showDisponibility = showDisponibility;
	
	TskScheduler.schedDiv = $(schedDiv);
	
	if(TskScheduler.showDisponibility)
		TskScheduler.schedDiv.addClass('show_disponibility');
	else
		TskScheduler.schedDiv.addClass('hide_disponibility');
	
	TskScheduler.myScheduler = new Scheduler($('schedTableContainer'));
	
	
	var w = WEEKDAY_SELECTED.split('/');
	TskScheduler.visDate.setDate(w[0]);
	TskScheduler.visDate.setMonth(Number.from(w[1]) - 1);
	TskScheduler.visDate.setYear(Number.from(w[2]));
	
	$('btnGoToToday').addEvent('click', function() {
		var day = new Date();
		if(TskScheduler.visDate.diff(day)) {
			TskScheduler.visDate = day;
			TskScheduler.getSched(day.getDate() + '/' + (day.getMonth() + 1) + '/' + day.getFullYear());
		}
	});
	
	$('btnGoToPrev').addEvent('click', function() {
		TskScheduler.visDate.setDate(Number.from(TskScheduler.visDate.getDate()) - 7);
		TskScheduler.getSched(TskScheduler.visDate.getDate() + '/' + (TskScheduler.visDate.getMonth() + 1) + '/' + TskScheduler.visDate.getFullYear());
	});
	
	$('btnGoToNext').addEvent('click', function() {
		TskScheduler.visDate.setDate(Number.from(TskScheduler.visDate.getDate()) + 7);
		TskScheduler.getSched(TskScheduler.visDate.getDate() + '/' + (TskScheduler.visDate.getMonth() + 1) + '/' + TskScheduler.visDate.getFullYear());
	});
	
	//DatePicker para navegación de la agenda
	new DatePicker($('navDate'), {
		pickerClass: 'datepicker_vista',
		toggleElements: $('navBtn'),
		onSelect: function(day) {
			
			if(day.getDay() == 0) {
				var dom_date = day.getDate();
				day.setDate(dom_date - 6);
			} else {
				day.setDay(1);
			}
			
			if(TskScheduler.visDate.diff(day)) {
				TskScheduler.visDate = day;
				TskScheduler.getSched(day.getDate() + '/' + (day.getMonth() + 1) + '/' + day.getFullYear());
			}
		}
	});
	
	//Highlight para los botones de navegacion
	$$('.schedNavButton').addEvent('click', function(event) {this.highlight();});
	
	TskScheduler.myScheduler.addEvent('tdselected', TskScheduler.dateSelected);
	
	TskScheduler.myScheduler.mondayDate  = new Date();
	//TskScheduler.getSched(TskScheduler.myScheduler.getMondayDateStr());
	TskScheduler.getSched(WEEKDAY_SELECTED); //XXX: Verificar
};

TskScheduler.getSched = function(weekDay) {
	
	var calSpinner = new Spinner(TskScheduler.myScheduler.container, {
		destroyOnHide: true/*,
		style: {width: cal_spinner_width, height: cal_spinner_height*/
	});
	
	//weekDay es cualquier dia de la semana que se desea cargar con formato: "dd/mm/yyyy"
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getExecutionSchedulerWeek&isAjax=true&weekDay=' + weekDay + '&schId=' + TskScheduler.schId + '&proId=' + TskScheduler.proId +'&proVerId=' + TskScheduler.proVerId +'&tskId=' + TskScheduler.tskId + TAB_ID_REQUEST,
		onRequest: function() {
			calSpinner.show();
		},
		onSuccess: function(resText, resXml) {
			if(resXml.childNodes.length) {
				var xml;
				if(Browser.ie)
					xml = resXml.childNodes[1];
				else
					xml = resXml.childNodes[0];
				
				if(xml.tagName == 'data') {
					processXmlExceptions(xml);
					processXmlMessages(xml);
					TskScheduler.processXmlScheduler(xml);
				} else {
					TskScheduler.processXmlScheduler(xml);
				}
			} else {
				//TODO: retry!!!
			}
			calSpinner.hide();
			TskScheduler.schedDiv.setStyle('display', '');
		},
		onFailure: function() {
			//TODO: retry!!!!
			calSpinner.hide();
			TskScheduler.schedDiv.setStyle('display', '');
		}
	}).send();
}

TskScheduler.dateSelected = function(event) {
	
	var td = TskScheduler.myScheduler.cell_selected;
	
	if(TskScheduler.showDisponibility) {
		//if(TskScheduler.prev_cell_selected) {
		//	TskScheduler.prev_cell_selected.set('html', Number.from(TskScheduler.prev_cell_selected.get('html')) + 1);
		//}
		td.set('html', Number.from(td.get('html')) - 1);
	}
	
	TskScheduler.prev_cell_selected = td;
	
	var tr = td.getParent('tr');
	var from = tr.getElements('td')[0].get('html');
	var hour_split = from.split(':');
	var hour = hour_split[0] + hour_split[1];
	var dayNumber = td.get('d');
	
	//Seteamos las variables para el confirmar:
	var aux_mondayStr = TskScheduler.myScheduler.getMondayDateStr().split('/');
	if(aux_mondayStr)
		mondayStr = (aux_mondayStr[0].length == 2 ? aux_mondayStr[0] : '0' + aux_mondayStr[0]) + '/' +
					(aux_mondayStr[1].length == 2 ? aux_mondayStr[1] : '0' + aux_mondayStr[1]) + '/' + aux_mondayStr[2];
	else
		mondayStr = WEEKDAY_SELECTED;
	day = dayNumber;
	hor = hour;
	
	if(mondayStr != TskScheduler.original_data_deselected.fecha 
			|| hor != TskScheduler.original_data_deselected.hora)
		hasChange = 'true';
	else
		hasChange = 'false';
	
	if(TskScheduler.prev_data_selected) {
		//Verificar si podemos seleccionarla (solo visualmente, el server ya tiene la variable de sesion seteada)
		var tr_prev = $(TskScheduler.prev_data_selected.hora);
		if(tr_prev) {
			tr_prev.getElements('td').each(function(item) {
				if(item.get('strdate') == TskScheduler.prev_data_selected.fecha) {
					//Seleccionar celda
					//TskScheduler.prev_cell_selected = item;
					//TskScheduler.myScheduler.cell_selected = item;
					
					if(TskScheduler.showDisponibility) {
						item.set('html', Number.from(item.get('html')) + 1);
					}
				}
			});
		}
	}
	
	TskScheduler.prev_data_selected = {
		fecha: td.get('strdate'),
		hora: tr.get('id')
	};
	
	/*
	var request = new Request({
		method: 'post',
		//url: CONTEXT + '/apia.design.TaskSchedulerAction.run?action=setExecutionSchedulerSelectedDay&isAjax=true&weekDay=' + TskScheduler.myScheduler.getMondayDateStr() + '&dayNumber=' + dayNumber + '&hour=' + hour + TAB_ID_REQUEST,
		url: CONTEXT + '/apia.design.TaskSchedulerAction.run?action=setReschedDay&isAjax=true&weekDay=' + TskScheduler.myScheduler.getMondayDateStr() + '&dayNumber=' + dayNumber + '&hour=' + hour + TAB_ID_REQUEST,
		onSuccess: function(resText, resXml) {
			if(resXml.childNodes.length) {
				var xml;
				if(Browser.ie)
					xml = resXml.childNodes[1];
				else
					xml = resXml.childNodes[0];
				
				if(xml.tagName == 'result' && xml.getAttribute('success') == 'true') {
					//Todo ok
				} else {
					//Error
					processXmlExceptions(xml);
					processXmlMessages(xml);
				}
			} else {
				//TODO: retry!!!
			}
		},
		onFailure: function() {
			//TODO: Mostrar mensaje de error al seleccionar la fecha de agenda
		}
	}).send();
	*/
};

/**
 * Para seleccionar la fecha manualmente
 */
TskScheduler.selectDate = function(weekday, dayNumber, hour, select_original_date) {
	
	var tr = $(hour);
	if(tr) {
		tr.getElements('td').each(function(td) {
			if(td.get('d') == dayNumber) {
				if(TskScheduler.firstDateLoaded) {
					td.fireEvent('click', new Event({
						type: 'click',
						target: td
					}));
				} else {
					TskScheduler.myScheduler.forceDateSelect(td);
					if(td.hasClass('td_blocked')) {
						td.set('available_turns', Number.from(td.get('available_turns')) + 1);
						td.removeClass('td_blocked').addEvent('click', TskScheduler.myScheduler.selectTD);
					}
				}
				
				TskScheduler.prev_data_selected = {
					fecha: td.get('strdate'),
					hora: tr.get('id')
				};
				
				if(select_original_date) {
					TskScheduler.original_data_deselected = {
						fecha: td.get('strdate'), 
						hora: tr.get('id')
					};
				}
			}
		});
	}

}

TskScheduler.processXmlScheduler = function(xml) {
	if(!TskScheduler.myScheduler) {
		setTimeout(function() {
			TskScheduler.processXmlScheduler(xml);
		}, 10);
	} else {
		var week_str = TskScheduler.myScheduler.generateScheduler(xml);
		/*
		new Request({
			method: 'post',
			url: CONTEXT + '/apia.design.TaskSchedulerAction.run?action=getExecutionSchedulerSelectedDay&isAjax=true' + TAB_ID_REQUEST,
			onSuccess: function(resText, resXml) {
				if(resXml.childNodes.length) {
					var xml;
					if(Browser.ie)
						xml = resXml.childNodes[1];
					else
						xml = resXml.childNodes[0];
					
					if(xml.tagName == 'result' && xml.getAttribute('success') == 'true') {
						//Todo ok
						if(xml.getAttribute('notSelected') == 'true') {
							//Esta agenda no contiene seleccion
						} else {
							if(xml.getAttribute('weekDay') == TskScheduler.myScheduler.getCompleteMondayDateStr()) {
								var tr = $(xml.getAttribute('hour'));
								if(tr) {
									tr.getElements('td').each(function(td) {
										if(td.get('d') == xml.getAttribute('dayNumber')) {
											td.fireEvent('click', new Event({
												type: 'click',
												target: td
											}));
										}
									});
								}
							}
						}
					} else {
						//Error
						processXmlExceptions(xml);
						processXmlMessages(xml);
					}
				} else {
					//TODO: retry!!!
				}
			},
			onFailure: function() {
			}
		}).send();
		*/
		$('navBtn').set('html', week_str);
		TskScheduler.prev_cell_selected = null;
		if(TskScheduler.prev_data_selected) {
			//Verificar si podemos seleccionarla (solo visualmente, el server ya tiene la variable de sesion seteada)
			var tr = $(TskScheduler.prev_data_selected.hora);
			if(tr) {
				tr.getElements('td').each(function(item) {
					if(item.get('strdate') == TskScheduler.prev_data_selected.fecha) {
						//Seleccionar celda
						item.addClass('td_selected');
						TskScheduler.prev_cell_selected = item;
						TskScheduler.myScheduler.cell_selected = item;
						
						
						//SELECCION ENTRE SEMANAS
						if(TskScheduler.showDisponibility) {
							item.set('html', item.get('html') - 1);
						}
					}
				});
			}
		}
		
		if(TskScheduler.original_data_deselected && TskScheduler.showDisponibility) {
			//Sumarle un +1 visualmente en caso de que se muestre la disponibilidad
			var tr = $(TskScheduler.original_data_deselected.hora);
			if(tr) {
				tr.getElements('td').each(function(item) {
					if(item.get('strdate') == TskScheduler.original_data_deselected.fecha) {
						//SELECCION ENTRE SEMANAS
						item.set('html', Number.from(item.get('html')) + 1);
						
						if(item.hasClass('td_blocked')) {
							item.set('available_turns', Number.from(item.get('available_turns')) + 1);
							item.removeClass('td_blocked').addEvent('click', TskScheduler.myScheduler.selectTD);
						}
					}
				});
			}
		}/* else if(TskScheduler.showDisponibility) {
			TskScheduler.original_data_deselected = {
				fecha: td.get('strdate'), 	//TODO: OBTENER LA FECHA 
				hora: tr.get('id')			//TODO: OBTENER LA HORA
			};
		}*/
		
		//Selección manual
		if(!TskScheduler.firstDateLoaded) {
			//XXX: verficar
			while(HOUR_SELECTED.length < 4)
				HOUR_SELECTED = '0' + HOUR_SELECTED;
			TskScheduler.selectDate(WEEKDAY_SELECTED, DAY_NUMBER_SELECTED, HOUR_SELECTED, !TskScheduler.original_data_deselected && TskScheduler.showDisponibility);
			TskScheduler.firstDateLoaded = true;
		}		
	}
};