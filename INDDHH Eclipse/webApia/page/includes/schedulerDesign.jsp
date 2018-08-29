<link href="<system:util show="context" />/css/base/modules/schedulerAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/includes/scheduler.js"></script><script>
	var TSK_DAY_MON = '<system:label show="text" label="lblTskDayMon" forScript="true" />';
	var TSK_DAY_TUE = '<system:label show="text" label="lblTskDayTue" forScript="true" />';
	var TSK_DAY_WED = '<system:label show="text" label="lblTskDayWed" forScript="true" />';
	var TSK_DAY_THU = '<system:label show="text" label="lblTskDayThu" forScript="true" />';
	var TSK_DAY_FRI = '<system:label show="text" label="lblTskDayFri" forScript="true" />';
	var TSK_DAY_SAT = '<system:label show="text" label="lblTskDaySat" forScript="true" />';
	var TSK_DAY_SUN = '<system:label show="text" label="lblTskDaySun" forScript="true" />';
	
	var TSK_MONT_JAN = '<system:label show="text" label="lblEnero" forScript="true" />';
	var TSK_MONT_FEB = '<system:label show="text" label="lblFebrero" forScript="true" />';
	var TSK_MONT_MAR = '<system:label show="text" label="lblMarzo" forScript="true" />';
	var TSK_MONT_APR = '<system:label show="text" label="lblAbril" forScript="true" />';
	var TSK_MONT_MAY = '<system:label show="text" label="lblMayo" forScript="true" />';
	var TSK_MONT_JUN = '<system:label show="text" label="lblJunio" forScript="true" />';
	var TSK_MONT_JUL = '<system:label show="text" label="lblJulio" forScript="true" />';
	var TSK_MONT_AUG = '<system:label show="text" label="lblAgosto" forScript="true" />';
	var TSK_MONT_SEP = '<system:label show="text" label="lblSetiembre" forScript="true" />';
	var TSK_MONT_OCT = '<system:label show="text" label="lblOctubre" forScript="true" />';
	var TSK_MONT_NOV = '<system:label show="text" label="lblNoviembre" forScript="true" />';
	var TSK_MONT_DEC = '<system:label show="text" label="lblDiciembre" forScript="true" />';
	
	var LBL_SCHED_FORM_TITLE = '<system:label show="text" label="titTabSchTask" forScript="true" />';
	
	var LBL_SCHED_OF = '<system:label show="text" label="lblTskSchedOf" forScript="true" />';
	var LBL_SCHED_WEEK_NOT_CONFIGURED = '<system:label show="text" label="msgTskSchWeekNotConfig" forScript="true" />';
	
	var myScheduler;
	var visDate = new Date();
	
	window.addEvent('domready', function() {
		
		Generic.setButton($('cancelModal'));
		Generic.setButton($('acceptModal'));
		
		Numeric.setNumeric($('nextMonthsCant'));
		
		Generic.setButton($('acceptMas')).addEvent('click', function() {
			if($('allMonth').get('checked')) {
				//Todo el mes
				repeatWeekForMonth(0);
				
			} else if($('nextMonths').get('checked')) {
				//Proximos meses
				repeatWeekForMonth(Number.from($('nextMonthsCant').value))
				
			} else if($('allYear').get('checked')) {
				//Todo el año
				repeatWeekForMonth(12 - myScheduler.getMonth())
				
			} else if($('eraseCurrentWeek').get('checked')) {
				//Borrar semana actual
				
				var rows = $('schedTableContainer').getElements('tbody')[0].getElements('tr');
				if(rows && rows.length > 0) {
					
					myScheduler.assignResource(rows[0].getElements('td')[1], 0, false, true, false);
					
					var frec = Number.from($('selFrec').getSelected()[0].get('value'));
					if(!frec) frec = Number.from($('txtOthFrec').get('value'));
					var monday = myScheduler.getMondayDateStr();
					var horIni = rows[0].get('id');
					var horFin = rows[rows.length - 1].get('id');
					var dayIni = '1';
					var dayFin = '7';
					
					new Request({	
						url : CONTEXT + URL_REQUEST_AJAX + '?action=setDisponibility' +
								'&frec=' + frec +
								'&monday=' + monday +
								'&horIni=' + horIni + 
								'&horFin=' + horFin + 
								'&dayIni=' + dayIni + 
								'&dayFin=' + dayFin + 
								'&disp=' + 0 + 
								TAB_ID_REQUEST,
					    
						onSuccess: function(responseText, responseXML) {
					    	//TODO: 
// 					    	console.log('success');
					    },
					    
					    onFailure: function(xhr) {
					    	//TODO
// 					    	console.log('failure');
					    }
					}).send();
				}
			} else if($('eraseAllCalendar').get('checked')) {
				
				//Borramos la semana actual
				var rows = $('schedTableContainer').getElements('tbody')[0].getElements('tr');
				if(rows && rows.length > 0) {
					myScheduler.assignResource(rows[0].getElements('td')[1], 0, false, true, false);
				}
				
				//Borrar todo el calendario
				new Request({	
					url : CONTEXT + URL_REQUEST_AJAX + '?action=deleteAllWeeks' +					
							TAB_ID_REQUEST,
				    
					onSuccess: function(responseText, responseXML) {
				    	//TODO: 
// 				    	console.log('success');
				    },
				    
				    onFailure: function(xhr) {
				    	//TODO
// 				    	console.log('failure');
				    }
				}).send();
			}
			
			$('menuMas').getElements('input').each(function(inp) {
				if(inp.get('type') == 'checkbox')
					inp.erase('checked');
				else if(inp.get('type') == 'text')
					inp.set('value', '');
			});
			toggleMenuMas();
		});
		Generic.setButton($('cancelMas')).addEvent('click', function() {
			$('menuMas').getElements('input').each(function(inp) {
				if(inp.get('type') == 'checkbox')
					inp.erase('checked');
				else if(inp.get('type') == 'text')
					inp.set('value', '');
			});
			toggleMenuMas();
		});
				
		myScheduler = new Scheduler($('schedTableContainer'));
		
		$('btnGoToToday').addEvent('click', function() {
			var day = new Date();
			if(visDate.diff(day)) {
				visDate = day;
				loadScheduler(day.getDate() + '/' + (day.getMonth() + 1) + '/' + day.getFullYear(), null, true);
			}
		});
		
		$('btnGoToPrev').addEvent('click', function() {
			
			visDate.setDate(Number.from(visDate.getDate()) - 7);
			loadScheduler(visDate.getDate() + '/' + (visDate.getMonth() + 1) + '/' + visDate.getFullYear(), null, true);
		});
			
		
		$('btnGoToNext').addEvent('click', function() {
			
			visDate.setDate(Number.from(visDate.getDate()) + 7);
			loadScheduler(visDate.getDate() + '/' + (visDate.getMonth() + 1) + '/' + visDate.getFullYear(), null, true);
		});
		
		$('btnMas').addEvent('click', toggleMenuMas);
		
		//Mover el modal como hermano del div body
		$('modalDiv').inject($('bodyDiv'), 'after');
		$('modalDiv').setStyles({top: 0, left: 0});
		
		$('menuMas').inject($('bodyDiv'), 'after');
		$('menuMas').setStyles({top: 0, left: 0});
		
		var datepicker_opts = {
			pickerClass: 'datepicker_vista',
			toggleElements: $('navBtn'),
			onSelect: function(day) {
				
				if(day.getDay() == 0) {
					var dom_date = day.getDate();
					day.setDate(dom_date - 6);
				} else {
					day.setDay(1);
				}
				
				if(visDate.diff(day)) {
					visDate = day;
					loadScheduler(day.getDate() + '/' + (day.getMonth() + 1) + '/' + day.getFullYear(), null, true);
				}
			}
		};
		if(window.LBL_DAYS) {
			datepicker_opts.days = window.LBL_DAYS;
		}
		if(window.LBL_MONTHS) {
			datepicker_opts.months = window.LBL_MONTHS;
		}
		
		//DatePicker para navegación de la agenda
		new DatePicker($('navDate'), datepicker_opts);
		
		//Eventos del modal de agenda
		$('acceptModal').addEvent('click', onModalConfirm);
		
		$('cancelModal').addEvent('click', function() {
			$('modalDiv').setStyle('display', 'none');
			$('cantModal').set('value', '');
			$('allDayModal').erase('checked');
			$('allWeakModal').erase('checked');
			$('allHourModal').erase('checked');
		});
		
		$('cantModal').addEvent('keyup', function(event) {
			if(event.key == 'enter') 
				onModalConfirm();
		});
		
		//Highlight para los botones de navegacion
		$$('.schedNavButton').addEvent('click', function(event) {
			this.highlight();
		});
		
		myScheduler.addEvent('tdselected', openSchedulerModal);
		//cal.openCalendarModal(event.target, event.page.x, event.page.y);
		
		$('bodyDiv').addEvent('mousedown', function(event) {
			if(event && event.target.get('id') != 'btnMas')
				$('menuMas').setStyle('display', 'none');
			
			$('modalDiv').setStyle('display', 'none');
			$('cantModal').set('value', '');
			$('allDayModal').erase('checked');
			$('allWeakModal').erase('checked');
			$('allHourModal').erase('checked');
		});
		
		
	});
	
	function processXmlScheduler(xml) {
		if(!myScheduler) {
			setTimeout(function() {
				processXmlScheduler(xml);
			}, 10);
		} else {
			var week_str = myScheduler.generateScheduler(xml);
			$('navBtn').set('html', week_str);
		}
	}
	
	function placeMenuMas() {
		//Posicionar el menu de mas opciones
		var btnMas = $('btnMas');
		var pos = btnMas.getPosition();
		var menuMas = $('menuMas');
		menuMas.setStyles({
			top: pos.y + btnMas.getHeight(),
			left: pos.x  + btnMas.getWidth() - menuMas.getWidth()
		});
	}

	var positioned = false;

	function toggleMenuMas() {
		
		var menuMas = $('menuMas');
		
		if(menuMas.getStyle('display') == 'none') {
			menuMas.setStyle('display', 'inline-block');
		} else {
			menuMas.setStyle('display', 'none');
		}
		
		if(!positioned) {
			placeMenuMas();
			positioned = true;
		}
	}
	
	function openSchedulerModal(event) {
		
		var td = this.cell_selected;
		var pos_x = event.page.x;
		var pos_y = event.page.y;
		
		var modalDiv = $('modalDiv').setStyle('display', '');
		
		var left = pos_x - 20;	
		var top = pos_y + 15;
		var styles = {};
		var win_width = Window.getWidth();
		var win_height = Window.getHeight();
		var modal_width = Number.from(modalDiv.getStyle('width'));
		var modal_height = Number.from(modalDiv.getStyle('height'));
		
		if(left +  modal_width> win_width) {
			styles.right = 15;
			styles.left = '';
		} else {
			styles.left = left;
			styles.right = '';
		}
		if(top + modal_height > win_height - 30) {
			styles.bottom = 15 + 30;
			styles.top = '';
		} else {
			styles.top = top;
			styles.bottom = '';
		}
			
		modalDiv.setStyles(styles);
		
		var tr = td.getParent('tr');
		
		var from = tr.getElements('td')[0].get('html');
		
		var to;
		
		if(tr.getNext()) {
			to = tr.getNext().getElements('td')[0].get('html');
		} else {
			var d = new Date();
			var prev_d_str = tr.getElements('td')[0].get('html');
			d.setHours(prev_d_str[0] + '' + prev_d_str[1]);
			d.setMinutes(prev_d_str[3] + '' + prev_d_str[4]);
			d.setTime(d.getTime() + this.frecuency_ms);
			to = d.getHours() + ':' + d.getMinutes();
		}
		
		modalDiv.getElements('span.formatedDate').set('html', 
				td.get('strDate') + ', ' + from + ' - ' + to);
		
		modalDiv.store('TD', td);
		
		var val = Number.from(td.get('html'));
		$('cantModal').set('value', val)
			.selectRange(0, val != undefined ? (val + '').length : 0);
	}
	
	function onModalConfirm() {
		$('modalDiv').setStyle('display', 'none');
		myScheduler.assignResource($('modalDiv').retrieve('TD'), $('cantModal').get('value'), $('allDayModal').get('checked'), $('allWeakModal').get('checked'), $('allHourModal').get('checked'));
		
		var td_selected = $('modalDiv').retrieve('TD');		
		
		var monday = myScheduler.getMondayDateStr();
		var horIni = td_selected.getParent().get('id');
		var horFin = horIni;
		var dayIni = td_selected.get('d');
		var dayFin = dayIni;
		var disp = Number.from($('cantModal').get('value'));
		/*
		var frec = $('selFrec').get('value');
		if (frec==0) frec = $('txtOthFrec').value;
		*/
		var frec = Number.from($('selFrec').getSelected()[0].get('value'));
		if(!frec) frec = Number.from($('txtOthFrec').get('value'));
		
		if($('allHourModal').get('checked')) {
			dayIni = '1';
			dayFin = '7';
		} else if($('allDayModal').get('checked')) {
			var rows = td_selected.getParent().getParent().getChildren();
			horIni = rows[0].get('id');
			horFin = rows[rows.length - 1].get('id');
		} else if($('allWeakModal').get('checked')) {
			dayIni = '1';
			dayFin = '7';
			var rows = td_selected.getParent().getParent().getChildren();
			horIni = rows[0].get('id');
			horFin = rows[rows.length - 1].get('id');
		}
		
		$('cantModal').set('value', '');
		$('allDayModal').erase('checked');
		$('allWeakModal').erase('checked');
		$('allHourModal').erase('checked');
		
		new Request({	
			url : CONTEXT + URL_REQUEST_AJAX + '?action=setDisponibility' +
					'&frec=' + frec +
					'&monday=' + monday +
					'&horIni=' + horIni + 
					'&horFin=' + horFin + 
					'&dayIni=' + dayIni + 
					'&dayFin=' + dayFin + 
					'&disp=' + disp + 
					TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
		    	//TODO: 
// 		    	console.log('success');
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO
// 		    	console.log('failure');
		    }
		}).send();
	}
	
	function repeatWeekForMonth(cantMonths) {
		
		if(Number.from(cantMonths) <= 0)
			return;
		
		var monday = myScheduler.getMondayDateStr();
		var sobreasignacion = Number.from($('txtOvrAsign').value);
		var frec = Number.from($('selFrec').getSelected()[0].get('value'));
		if(!frec)
			frec = Number.from($('txtOthFrec').get('value'));
		
		new Request({	
			url : CONTEXT + URL_REQUEST_AJAX + '?action=applyWeekConf' +					
					'&monday=' + monday +
					'&months=' + cantMonths + 
					'&disp=' + sobreasignacion + 
					'&frec=' + frec +
					TAB_ID_REQUEST,
		    
			onSuccess: function(responseText, responseXML) {
		    	//TODO: 
// 		    	console.log('success');
		    },
		    
		    onFailure: function(xhr) {
		    	//TODO
// 		    	console.log('failure');
		    }
		}).send();
	}
</script><div><div id='toolsDiv'><div align="center"><div class="schedNavButton" style="float:left;" id="btnGoToToday"><system:label show="text" label="lblToday" /></div><div class="schedNavButton" id="btnGoToPrev">&lt;</div><input id="navDate" type="text" style="border: 0px; width: 0px; height: 0px; visibility: hidden;"/><div type="button" class="schedNavButton" id="navBtn"></div><div class="schedNavButton" id="btnGoToNext">&gt;</div><div id="btnMas" class="schedNavButton" style="float:right;"><system:label show="text" label="lblMore" /></div></div></div><div id="menuMas" style="display: none; position: absolute"><div class="title">Acciones sobre la agenda</div><input id="allMonth" class="check" type="checkbox"><system:label show="text" label="lblApplyToAllMonth" /><br/><input id="nextMonths" class="check" type="checkbox"><system:label show="text" label="lblApplyToNext" /><input id="nextMonthsCant" name="nextMonthsCant" type="text" style="width: 30px;"/><system:label show="text" label="lblMonths" /><br/><input id="allYear" class="check" type="checkbox"><system:label show="text" label="lblApplyToAllYear" /><br/><br/><input id="eraseCurrentWeek" class="check" type="checkbox"><system:label show="text" label="lblDelActWeek" /><br/><input id="eraseAllCalendar" class="check" type="checkbox"><system:label show="text" label="lblDelAllSch" /><br/><br/><div class="right-float"><div id="acceptMas"><system:label show="text" label="lblAccept" /></div><div id="cancelMas"><system:label show="text" label="btnCan" /></div></div></div><hr><div id='schedulerDiv'><div id='schedTableContainer'></div></div></div><div id='modalDiv' style="display:none;"><div class="title"><system:label show="text" label="lblAvaResources" /></div><system:label show="text" label="lblDate" />: 
	<span class="formatedDate"></span><br/><system:label show="text" label="lblAmount" />: <input id="cantModal" style="margin-left:5px;" type="text"/><br/><br/><input id="allDayModal" class="check" type="checkbox"><system:label show="text" label="lblStaForAllDay" /><br/><input id="allWeakModal" class="check" type="checkbox"><system:label show="text" label="lblStaForAllWeek" /><br/><input id="allHourModal" class="check" type="checkbox"><system:label show="text" label="lblStaForAllWeekHour" /><br/><br/><div class="right-float"><div id="acceptModal"><system:label show="text" label="lblAccept" /></div><div id="cancelModal"><system:label show="text" label="btnCan" /></div></div></div>