var Scheduler = new Class({
	
	Implements: Events,
	
	mondayDate: null,
	
	container: null,
	
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
		
		this.container.set('html', '');
		
		var mins = xml.getAttribute('frec');
		var overassign = xml.getAttribute('overassign');
		
		var selFrec = $('selFrec');
		if(selFrec) {
			var hasValue = false;
			selFrec.getElements('option').each(function(opt) {
				if(opt.get('value') == mins) {
					hasValue = true;
					opt.set('selected', true);
				}
			});
			if(!hasValue) {
				selFrec.set('value', 0);
				$('txtOthFrec').erase('disabled').set('value', mins);
			}
		}
		
		$('txtOvrAsign').set('value', overassign);
		
		var date_split = xml.getAttribute('mondayWeek').split('/');
		var day = Number.from(date_split[0]);
		var month = Number.from(date_split[1]);
		var year = Number.from(date_split[2]);
		
		var actual_week_str = this.getNavBtnText(day, month, year);		
		
		//Generar la tabla
		var table = new Element('table.tskSchedTable').store('calendar', this);
		table.set('html', '<thead><tr><th style="width: 50px;"> </th><th>' + this.getHeaderDate(day, month, year) + '</th><th>' + this.getHeaderDate(day + 1, month, year) + '</th><th>' + this.getHeaderDate(day + 2, month, year) + '</th><th>' + this.getHeaderDate(day + 3, month, year) + '</th><th>' + this.getHeaderDate(day + 4, month, year) + '</th><th>' + this.getHeaderDate(day + 5, month, year) + '</th><th>' + this.getHeaderDate(day + 6, month, year) + '</th></tr></thead>');
	
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
			return;
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
					td.set('strDate', this.getStrDate(day + index, month + 1, year));
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
			//Para cada d�a
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
							if(td_index == index + 1 && !td.hasClass('td_blocked') && !td.hasClass('td_disabled'))
								td.set('html', value);
						});
					}
				});
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

	assignResource: function(td, cant, all_day, all_weak, all_hour) {
		var cant_resource = Number.from(cant);
		
		if(!cant_resource) {
			td.set('html', '&nbsp;');
		} else {
			td.set('html', cant_resource);
		}
		
		if(all_weak) {
			td.getParent('tbody').getElements('tr').each(function(tr) {
				tr.getElements('td').erase(tr.getElements('td')[0]).each(function (curr_td) {
					if(!curr_td.hasClass('td_disabled') && !curr_td.hasClass('td_blocked'))
						curr_td.set('html', cant);
				});
			});
		} else {
			if(all_day) {
				var index = 0;
				td.getParent().getElements('td').each(function(curr_td, curr_index) {
					if(curr_td == td)
						index = curr_index;
				})
				
				if(index == 0) {
					console.error('ERROR: No se encuentra el dia');
				} else {
					td.getParent('tbody').getElements('tr').each(function(tr) {
						tr.getElements('td').each(function(curr_td, curr_index) {
							if(curr_index == index && !curr_td.hasClass('td_disabled') && !curr_td.hasClass('td_blocked'))
								curr_td.set('html', cant);
						});
					});
				}
				
			}
			if(all_hour) {
				var tr = td.getParent(); 
				tr.getElements('td').erase(tr.getElements('td')[0]).each(function (curr_td) {
					if(!curr_td.hasClass('td_disabled') && !curr_td.hasClass('td_blocked'))
						curr_td.set('html', cant);
				});
			}
		}
	},

	selectTD: function(event) {
		var cal = event.target.getParent('table').retrieve('calendar');
		if(cal.cell_selected)
			cal.cell_selected.removeClass('td_selected');
		
		event.target.addClass('td_selected');
		 
		cal.cell_selected = event.target;
		//cal.openCalendarModal(event.target, event.page.x, event.page.y);
		cal.fireEvent('tdselected', event);
	}
});