var CALENDAR_MODAL_HIDE_OVERFLOW	= true;

var spModalCal;
//var calName;
//var calDesc;
var tableDataDays;
var freeDaysContainter;

var hours = new Array("00:00","00:30","01:00","01:30","02:00","02:30","03:00","03:30","04:00","04:30",
					"05:00","05:30","06:00","06:30","07:00","07:30","08:00","08:30","09:00","09:30",
					"10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30",
					"15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30",
					"20:00","20:30","21:00","21:30","22:00","22:30","23:00","23:30");
var lblDays;

function initCalendarViewMdlPage(){
	var mdlCalendarViewContainer = $('mdlCalendarViewContainer');
	if (mdlCalendarViewContainer.initDone) return;
	mdlCalendarViewContainer.initDone = true;

	mdlCalendarViewContainer.blockerModal = new Mask();
	
	//calName = $('calName');
	//calDesc = $('calDesc');
	tableDataDays = $('tableDataDays');
	freeDaysContainter = $('freeDaysContainter');
	
	lblDays = new Array(SUNDAY,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY);
	
	spModalCal = new Spinner($('mdlBody'),{message:WAIT_A_SECOND});
	
	$('closeModalCalView').addEvent("click", function(e) {
		e.stop();
		closeCalendarViewModal();
	});
}


function showCalendarViewModal(calId,retFunction, closeFunction){
   
	if(CALENDAR_MODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	var mdlCalendarViewContainer = $('mdlCalendarViewContainer');
	mdlCalendarViewContainer.removeClass('hiddenModal');
	mdlCalendarViewContainer.position();
	mdlCalendarViewContainer.blockerModal.show();
	mdlCalendarViewContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlCalendarViewContainer.onModalConfirm = retFunction;
	mdlCalendarViewContainer.onModalClose = closeFunction;
	
	spModalCal.show(true);
	cleanModal();	
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX_CALENDAR + '?action=load&calId=' + calId + '&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { modalProcessDataXml(resXml); spModalCal.hide(true); }
	}).send();
}

function cleanModal(){
	$("calName").getElements("span").each(function(span){ span.destroy(); });
	$("calDesc").getElements("span").each(function(span){ span.destroy(); });
	tableDataDays.getElements("tr").each(function(tr){ tr.dispose(); });
	freeDaysContainter.getElements("div").each(function(div){ div.dispose(); });	
}

function modalProcessDataXml(resXml){
	var calendar = resXml.getElementsByTagName("calendar");
	if (calendar != null && calendar.length > 0 && calendar.item(0) != null) {
		var generalInfo = calendar.item(0).getElementsByTagName("general")[0];
		var labDays = calendar.item(0).getElementsByTagName("labDays");
		if (labDays != null && labDays.length > 0 && labDays.item(0) != null) {
			labDays = labDays.item(0).getElementsByTagName("labDay");
		} else {
			labDays = null;
		}
		var freeDays = calendar.item(0).getElementsByTagName("freeDays");
		if (freeDays != null && freeDays.length > 0 && freeDays.item(0) != null) {
			freeDays = freeDays.item(0).getElementsByTagName("freeDay");
		} else {
			freeDays = null;
		}
		
		//Info General
		var calName = generalInfo.getAttribute("name");
		if (calName != null && calName != ""){
			var spanName = new Element("span",{html: calName}).inject($("calName"));
			spanName.setStyle("font-weight","bold");
		}
		var calDesc = generalInfo.getAttribute("description");
		if (calDesc != null && calDesc != ""){
			var spanDesc = new Element("span",{html: calDesc}).inject($("calDesc"));
			spanDesc.setStyle("font-weight","bold");
		}
		
		
		//Dias Laborales
		var day;
		if (labDays != null){
			for(var i = 0; i < labDays.length; i++) {
				day = labDays[i];
				
				var dayName = lblDays[parseInt(day.getAttribute("day"))-1];
				var dayStart = hours[parseInt(day.getAttribute("start"))];
				var dayEnd = hours[parseInt(day.getAttribute("end"))];
				
				var tr = new Element("tr",{}).inject(tableDataDays);
				if (i % 2 == 0) { tr.addClass("trOdd"); }
				if (i == labDays.length-1) { tr.addClass("lastTr"); }
				var td1 = new Element("td",{html: dayName}).inject(tr);
				td1.setStyle("width","200px");
				var td2 = new Element("td",{html: dayStart + " " + LBL_A + " " + dayEnd}).inject(tr);
				td2.setStyle("width","259px");
			}	
		}
		
		//Feriados
		if (freeDays != null){
			for(var i = 0; i < freeDays.length; i++){
				day = freeDays[i];
				
				var div = new Element("div",{'class': 'option optionOneEighthModal', html: day.getAttribute("day")}).inject(freeDaysContainter);
				div.setStyle("text-align","center");
			}
		}
	}
}

function closeCalendarViewModal(){
    var mdlCalendarViewContainer = $('mdlCalendarViewContainer');
    
    if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlCalendarViewContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlCalendarViewContainer.addClass('hiddenModal');
			mdlCalendarViewContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlCalendarViewContainer.blockerModal.hide();
			if (mdlCalendarViewContainer.onModalClose) mdlCalendarViewContainer.onModalClose();
			
			if(CALENDAR_MODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlCalendarViewContainer.addClass('hiddenModal');
		
	    mdlCalendarViewContainer.blockerModal.hide();
		if (mdlCalendarViewContainer.onModalClose) mdlCalendarViewContainer.onModalClose();
		
		if(CALENDAR_MODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
    
}