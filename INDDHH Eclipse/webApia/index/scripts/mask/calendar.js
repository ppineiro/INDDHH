         // how reliable is this test?
     isIE = (document.all ? true : false);
	 isDOM = (document.getElementById ? true : false);
         // Initialize arrays.
     var months = new Array(GNR_JANUARY.substring(0,3),GNR_FEBRUARY.substring(0,3),GNR_MARCH.substring(0,3),GNR_APRIL.substring(0,3),GNR_MAY.substring(0,3),GNR_JUNE.substring(0,3),GNR_JULY.substring(0,3),GNR_AUGUST.substring(0,3),GNR_SEPTEMBER.substring(0,3),GNR_OCTOBER.substring(0,3),GNR_NOVEMBER.substring(0,3),GNR_DECEMBER.substring(0,3));
     var dayNames = new Array(GNR_SUNDAY.toUpperCase().substring(0,2),GNR_MONDAY.toUpperCase().substring(0,2),GNR_TUESDAY.toUpperCase().substring(0,2),GNR_WEDNESDAY.toUpperCase().substring(0,2),GNR_THURSDAY.toUpperCase().substring(0,2),GNR_FRIDAY.toUpperCase().substring(0,2),GNR_SATURDAY.toUpperCase().substring(0,2));
     var daysInMonth = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
	 var displayMonth = new Date().getMonth();
	 var displayYear = new Date().getFullYear();
	 var displayDivName;
	 var displayElement;

     function getDays(month, year) {
        // Test for leap year when February is selected.
        if (1 == month)
           return ((0 == year % 4) && (0 != (year % 100))) ||
              (0 == year % 400) ? 29 : 28;
        else
           return daysInMonth[month];
     }

     function getToday(){
        // Generate today's date.
        this.now = new Date();
        this.year = this.now.getFullYear();
        this.month = this.now.getMonth();
        this.day = this.now.getDate();
     }

     // Start with a calendar for today.
     today = new getToday();

 function newCalendar(elt,input) {
 	elt.input=input;
 	if(elt.input.readOnly){
 		return;
 	}
    var eltName=elt.id;
    if (input) {
       displayElement = input;
    }
    displayDivName = eltName;
    today = new getToday();
    var parseYear = parseInt(displayYear + '');
    var newCal = new Date(parseYear,displayMonth,1);
    var day = -1;
    var startDayOfWeek = newCal.getDay();
    if ((today.year == newCal.getFullYear()) && (today.month == newCal.getMonth())){
       day = today.day;
    }
    var intDaysInMonth =getDays(newCal.getMonth(), newCal.getFullYear());
    var daysGrid = makeDaysGrid(startDayOfWeek,day,intDaysInMonth,newCal,elt);
	var clone=elt.cloneNode(true);
	if(MSIE){
		clone.innerHTML = "<div style='position:absolute;z-index:999999999999999;'>"+daysGrid+"</div><iframe name='divBackBlocker' id='divBackBlocker'></iframe>";
		clone.style.zIndex=999999999;
	}else{
		clone.style.zIndex=99999999;
		clone.innerHTML = daysGrid;
	}
	elt.parentNode.appendChild(clone);
	elt.parentNode.removeChild(elt);
	if(MSIE){
		var blocker=document.getElementById("divBackBlocker");
		blocker.style.width=clone.firstChild.clientWidth+"px";
		blocker.style.height=clone.firstChild.clientHeight+"px";
		blocker.style.top=0;
		blocker.style.top=(clone.offsetTop+52)+"px";
		blocker.style.left=(clone.offsetLeft+2)+"px";
		blocker.style.zIndex="9";
	}
 }

function incMonth(aEvent,delta) {
	if(MSIE){
		aEvent=window.event;
	}
	displayMonth += delta;
	if (displayMonth >= 12) {
		displayMonth = 0;
		incYear(aEvent,1);
	} else if (displayMonth <= -1) {
		if(parseInt(displayYear + '')>1800){
			displayMonth =11;
			incYear(aEvent,-1);
		}else{
			displayMonth += (-delta);
		}
	} else {
		newCalendar(getCalendar(aEvent),displayElement);
	}
}
function incYear(aEvent,delta) {
	if(MSIE){
		aEvent=window.event;
	}
	if( ( parseInt(displayYear + '') + delta )>=1800 ){
		displayYear = parseInt(displayYear + '') + delta;
		newCalendar(getCalendar(aEvent),displayElement);
	}
}
function getCalendar(e){
	var calendar;
	if(MSIE){
		calendar=e.srcElement;
	}else{
		calendar=e.target;
	}
	while(calendar!=null && calendar.getAttribute("type")!="calendar"){
		calendar=calendar.parentNode;
	}
	return calendar;
}

function makeDaysGrid(startDay, day, intDaysInMonth, newCal, elt) {
	var eltName=elt.id;
	var daysGrid;
	var month = newCal.getMonth();
	var year = newCal.getFullYear();
	var isThisYear = (year == new Date().getFullYear());
	var isThisMonth = (day>-1);
	daysGrid = '<table style="width:160px" width=160 id=dtPicker border=1 cellspacing=0 cellpadding=0><tr><td nowrap>';
	daysGrid += '<table class="pickerControls"  style="width:160px;height:0px;" width=160px border=0 cellspacing=0 cellpadding=0 height=10><tr height=15px width=160px style="height:15px;width:160px;">'
	daysGrid += '<td valign=top><img src="'+URL_STYLE_PATH+'/images/leftBtn.gif" width=10 height=10 onclick="javascript:incMonth(event,-1)"></img></td>';
	daysGrid += '<td style="height:0px;align:center;" align="center" valign="bottom"><b>';
	if (isThisMonth) {
		daysGrid += '<div style="width:20px;height:15px;padding-top5px;align:center;" align="center"><font class="this">'+months[month]+'</font></div>';
	} else {
		daysGrid += '<div style="width:20px;height:15px;padding-top5px;align:center;" align="center"><font class="notThis">'+months[month]+'</font></div>';
	}
	daysGrid += '</b></td>';
	daysGrid += '<td valign=top><img src="'+URL_STYLE_PATH+'/images/rightBtn.gif" width=10 height=10 onclick="javascript:incMonth(event,1)"></img></td>';
	daysGrid += '<td valign=top><img src="'+URL_STYLE_PATH+'/images/leftBtn.gif" width=10 height=10 onclick="javascript:incYear(event,-1)"></img></td>';
	daysGrid += '<td width=50px style="width:50px;height:0px;align:center;" valign="bottom" align="center"><b>';
	if (isThisYear) {
		daysGrid += '<div style="width:35px;height:15px;align:center;" align=center><font class="this">'+year+'</font></div>';
	} else {
		daysGrid += '<div style="width:35px;height:15px;align:center;" align=center><font class="notThis">'+year+'</font></div>';
	}
	daysGrid += '</td></b>';
	daysGrid += '<td valign=top><img src="'+URL_STYLE_PATH+'/images/rightBtn.gif" width=10 height=10 onclick="javascript:incYear(event,1)"></img></td>';
	daysGrid += '<td width=15 valign=top><img src="'+URL_STYLE_PATH+'/images/closeBtn.gif" width=10 height=10 onClick="javascript:hideElement(event)" /><br></td>';
	daysGrid +='</tr></table>';
	daysGrid += '<table id=calendar width=0 height=0 border=0 cellpadding=0><tr>';
	daysGrid += '<td width=20 class="week">'+dayNames[0]+'</td><td width=20 class="week">'+dayNames[1]+'</td><td width=20 class="week">'+dayNames[2]+'</td><td width=20 class="week">'+dayNames[3]+'</td><td width=20 class="week">'+dayNames[4]+'</td><td width=20 class="week">'+dayNames[5]+'</td><td width=20 class="week">'+dayNames[6]+'</td></tr><tr>';
	var dayOfMonthOfFirstSunday = (7-startDay+1);
	for (var intWeek = 0; intWeek<6; intWeek++) {
		var dayOfMonth;
		for (var intDay = 0; intDay<7; intDay++) {
			dayOfMonth = (intWeek*7)+intDay+dayOfMonthOfFirstSunday-7;
			if (dayOfMonth<=0) {
				daysGrid += "<td>&nbsp;&nbsp;</td>";
			} else if (dayOfMonth<=intDaysInMonth) {
				var color = "black";
				if (day>0 && day == dayOfMonth) {
					color = "red";
				}
				daysGrid += '<td class=days onMouseOver=\'this.className="daysHover";\' onMouseOut=\'this.className="days";\' onclick="javascript:setDay(event,';
				daysGrid += dayOfMonth+')" ';
				daysGrid += 'style="color:'+color+'">';
				var dayString ="<a style='color:"+color+"'>"+dayOfMonth+"</a></td>";
				if (dayString.length == 6) {
					dayString = '0'+dayString;
				}
				daysGrid += dayString;
			}
		}
		if (dayOfMonth<intDaysInMonth) {
			daysGrid += "</tr><tr>";
		}
	}
	return daysGrid+"</td></tr></table></td></tr></table>";
}

 function setDay(aEvent,day) {
	 day+="";
	 if(day.length<2){
		 day="0"+day;
	 }
	 var month=(displayMonth+1)+"";
	 if(month.length<2){
		 month="0"+month;
	 }
	if ('M' == strDateFormat.charAt(0)) {
   displayElement.value = month + GNR_DATE_SEPARATOR + day + GNR_DATE_SEPARATOR + displayYear;
	} else if ('d' == strDateFormat.charAt(0)) {
   displayElement.value = day + GNR_DATE_SEPARATOR + month + GNR_DATE_SEPARATOR + displayYear;
	} else if ('y' == strDateFormat.charAt(0)) {
   displayElement.value = displayYear + GNR_DATE_SEPARATOR + month + GNR_DATE_SEPARATOR + day;
	}
	
	displayElement.unMaskedText=day +  month + displayYear;
	if(!displayElement.getAttribute("prev_value")) {
		displayElement.setAttribute("prev_value", displayElement.getAttribute("start_value"));
	}
	if(displayElement.getAttribute("prev_value")!=displayElement.value){
		fireEvent(displayElement,"change");
		displayElement.setAttribute("prev_value", displayElement.value);
	}
	hideElement(aEvent);
 }


function fixPosition(divname) {
 divstyle = getDivStyle(divname);
 positionerImgName = divname;
 isPlacedUnder = false;
 if (isPlacedUnder) {
  setPosition(divstyle,positionerImgName,true);
 } else {
  setPosition(divstyle,positionerImgName)
 }
}

function toggleDatePicker(aEvent) {
	var tempX;
	var tempY;
	var doc;
	var height=window.innerHeight;
	var width=(document.body.offsetWidth);
	if(MSIE){
		doc=aEvent.srcElement;
		height=document.body.parentNode.clientHeight;
		width=document.body.parentNode.clientWidth;
		tempX = aEvent.clientX + document.body.scrollLeft;
		tempY = aEvent.clientY + document.body.scrollTop;
	}else{
		doc=aEvent.target;
		tempX = aEvent.pageX;
		tempY = aEvent.pageY;
	}
	if((tempX+160)>width){
		tempX=(tempX-((tempX+160)-width))-20;
	}
	if((tempY+140)>height){
		tempY=(tempY-((tempY+140)-height))-20;
	}
	textToSetDate=doc.parentNode.previousSibling;
	while(textToSetDate.tagName!="INPUT"){
		textToSetDate=textToSetDate.previousSibling;
	}
	if(textToSetDate.disabled || textToSetDate.getAttribute("readonly")=="readonly" || textToSetDate.getAttribute("readonly")=="true" || textToSetDate.getAttribute("readonly")==true){
		return false;
	}
	if(textToSetDate.getAttribute("p_calendar")!='true'){return false;}
	if(document.getElementById("calendarDiv")!=null){
		document.getElementById("calendarDiv").innerHTML="";
		document.getElementById("calendarDiv").style.visibility="hidden";
		document.getElementById("calendarDiv").style.top=tempY+"px";
		document.getElementById("calendarDiv").style.left=tempX+"px";
		//document.getElementById("dtPicker").id="";
	}else{
		var dtPicker=document.createElement("DIV");
		dtPicker.id="calendarDiv";
		dtPicker.setAttribute("type","calendar");
		dtPicker.style.position="absolute";
		dtPicker.style.visibility="hidden";
		dtPicker.style.visibility="hidden";
		dtPicker.style.top=tempY+"px";
		dtPicker.style.left=tempX+"px";
		document.body.appendChild(dtPicker);
	}
	var dtPicker=document.getElementById("calendarDiv");
	//textToSetDate=doc.parentNode.parentNode.getElementsByTagName("INPUT")[0];
	/*
	textToSetDate=doc.parentNode.previousSibling;
	while(textToSetDate.tagName!="INPUT"){
		textToSetDate=textToSetDate.previousSibling;
	}
	*/
	toggleVisible(dtPicker,"visible");
//	newCalendar(doc.parentNode.childNodes[1],input);
	
	newCalendar(document.getElementById("calendarDiv"),textToSetDate);
	setSelectedDate(textToSetDate,document.getElementById("calendarDiv"));
	
	//setPosition(doc.parentNode.childNodes[1],tempX,tempY);
}
var textToSetDate;
function fixPositions(){
}