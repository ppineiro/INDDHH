var calendarWidget;
function setCalendarWidget(cal){
	calendarWidget=cal;
	
	calendarWidget.doDrop=function(draggable){
		var scheduled=schelduler.scheduleElement(draggable.getObject());
		draggable.remove();
		deskTop.dropSelected(this);
		return scheduled;
	}
	calendarWidget.setDate=function(date,month,year){
		schelduler.setDate(date+"/"+month+"/"+year);
		var flashVars=calendarWidget.getFlashVars();
		var vars=updateVariable("scheduleDate",(date+"/"+month+"/"+year),flashVars);
		this.setFlashVars(vars);
	}
	calendarWidget.getFlashVars=function(){
		var params=this.getElementsByTagName("PARAM");
		var param;
		for(var i=0;i<params.length;i++){
			if(params[i].getAttribute("name").toLowerCase()=="flashvars"){
				param=params[i];
			}
		}
		return param.getAttribute("value");
	}
	calendarWidget.setFlashVars=function(value){
		var params=this.getElementsByTagName("PARAM");
		var param;
		for(var i=0;i<params.length;i++){
			if(params[i].getAttribute("name").toLowerCase()=="flashvars"){
				param=params[i];
			}
		}
		param.setAttribute("flashVars",value);
		if(this.getElementsByTagName("EMBED")[0]){
			this.getElementsByTagName("EMBED")[0].setAttribute("flashVars",value);
		}
	}
	//getFlashObject(calendarWidget.id).SetVariable("call", ("setSchelduledDays,"+schelduler.scheduledDays));
}