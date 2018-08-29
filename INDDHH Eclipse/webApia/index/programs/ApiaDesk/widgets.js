// JavaScript Document
var widgetArea;
var widgetsArray;

function setWidgets(widgets){
	widgetArea=document.createElement("DIV");
	widgetArea.id="widgetArea";
	widgetArea.style.position="absolute";
	widgetArea.style.zIndex=1;
	deskTop.appendChild(widgetArea);
	widgetArea.style.width="160px";
	widgetArea.style.height=deskTop.offsetHeight+"px";
	widgetArea.style.left=(deskTop.offsetWidth-widgetArea.offsetWidth)+"px";
	widgetArea.style.top="5px";
	for(var i=0;i<widgets.length;i++){
		var widget=document.createElement("DIV");
		makeUnselectable(widget);
		widget.style.width="160px";
		widget.style.height="160px";
		widget.innerHTML='<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,124,0" width="150" height="150" id="'+"widget_"+i+'"><param name="movie" value="'+widgets[i].movie+'"><param name="swliveconnect" value="true"><param name="wmode" value="transparent"><param name="FlashVars" value="'+widgets[i].flashVars+'"><param name="quality" value="high"><embed src="'+widgets[i].movie+'" quality="high" name="'+"widget_"+i+'" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="150" height="150" wmode="transparent" flashvars="'+widgets[i].flashVars+'" swliveconnect="true"></embed></object>'+'<div class="widgetHandle"></div>';
		widget.drag=widget.getElementsByTagName("DIV")[0];
		widget.id="widget_"+i;
		widgetArea.appendChild(widget);
		widgetsArray.push(widget);
		if(widgets[i].js){
			var loader=new ScriptLoader();
			loader.loadingWidget=widget;
				if(widgets[i].loadFunction){
				loader.loadingFunc=new Function("widget",widgets[i].loadFunction+"(widget)");
				loader.onload=function(){
					this.loadingFunc(this.loadingWidget);
				}
			}
			loader.load(URL_ROOT_PATH+"/programs/ApiaDesk/"+widgets[i].js+".js");
		}
	}
	addListener(widgetArea,"mousemove",function(e){
		e=getEventObject(e);
		var x=getMouseX(e);
		var y=getMouseY(e);
		for(var i=0;i<widgetsArray.length;i++){
			if(hitTest(widgetsArray[i],{x:x,y:y})){
				widgetsArray[i].drag.style.visibility="visible";
			}else{
				widgetsArray[i].drag.style.visibility="hidden";
			}
		}
	});
	addListener(widgetArea,"mouseout",function(e){
		for(var i=0;i<widgetsArray.length;i++){
			widgetsArray[i].drag.style.visibility="hidden";
		}
	});
	widgetArea.size=function(){
		widgetArea.style.width="160px";
		widgetArea.style.height=deskTop.offsetHeight+"px";
		widgetArea.style.left=(deskTop.offsetWidth-widgetArea.offsetWidth)+"px";
		widgetArea.style.top="5px";
	}
	Sortable.create("widgetArea",{tag:'div',overlap:'horizontal',constraint: false,handle:'widgetHandle'});
}

function initWidgets(){
	widgetsArray=new Array();
	setWidgets(
	[{movie:"flash/calendar.swf",flashVars:"serverHour="+serverHour+"&serverMinute="+serverMinute+"&serverDate="+serverDate+"&serverMonth="+serverMonth+"&serverYear="+serverYear+"&months="+GNR_JANUARY+","+GNR_FEBRUARY+","+GNR_MARCH+","+GNR_APRIL+","+GNR_MAY+","+GNR_JUNE+","+GNR_JULY+","+GNR_AUGUST+","+GNR_SEPTEMBER+","+GNR_OCTOBER+","+GNR_NOVEMBER+","+GNR_DECEMBER+"&days="+GNR_MONDAY+","+GNR_TUESDAY+","+GNR_WEDNESDAY+","+GNR_THURSDAY+","+GNR_FRIDAY+","+GNR_SATURDAY+","+GNR_SUNDAY,js:"calendarWidget",loadFunction:"setCalendarWidget"}
	,{movie:"flash/chartLoader.swf",flashVars:("urlBase="+URL_ROOT_PATH+"/programs/ApiaDesk/flash/&urlModel=ApiaDeskAction.do?action=userResumeWidget"),js:"chartWidget",loadFunction:"setChartWidget"}
	,{movie:"flash/clock.swf",flashVars:"serverHour="+serverHour+"&serverMinute="+serverMinute+"&serverDate="+serverDate+"&serverMonth="+serverMonth+"&serverYear="+serverYear}]);
	
	Droppables.add(widgetsArray[0], {accept:'trashable',hoverclass:'opacity50',onDrop:function(draggable,droppable){ 
																								droppable.doDrop(draggable);
																				 } } ); 
	
}