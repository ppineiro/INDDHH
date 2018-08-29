var HistoryManager=new Object();
	
HistoryManager.openHistoryWindow=function(){
	if(this.historyWindow){
		this.historyWindow.bringToTop();
		return this.historyWindow;
	}
	var x=(getStageWidth()-320)/2;
	var y=(getStageHeight()-340)/2;
	this.historyWindow=openWindow({ url:"" ,width:370 , height:340 , title:(btnMonHis), fixedSize:true,x:x,y:y,persistable:false });
	var dateMask="";//"'";
	for(var i=0;i<DATE_MASK.length;i++){
		if(DATE_MASK.charAt(i)=="_"){
			dateMask+="n";//DATE_MASK.charAt(i);
			if(i+1<DATE_MASK.length && DATE_MASK.charAt(i+1)!="_"){
				dateMask+="'";
			}
		}if(DATE_MASK.charAt(i)!="_"){
			dateMask+=DATE_MASK.charAt(i);
			dateMask+="'";
		}
	}
	dateMask+="";//"'";
	var html="<table width='100%' style='padding:5px;font-size:12px'>";
	html+="<tr><td align='left' width='20%' align='right'>"+lblTit+"</td><td width='30%'><input style='font-size:12px;width:80px;' type='text'></td>";
	html+="<td align='left' width='20%'>"+lblFilUsrNom+"</td><td width='30%'><input style='font-size:12px;width:80px;' type='text'></td></tr>";
	html+="<tr><td></td><td></td><td></td><td></td></tr>";
	html+="<tr><td align='left' width='20%' align='right'>"+lblEjeFchDes+"</td><td width='30%'><input p_calendar='true' p_mask='"+dateMask+"' style='font-size:12px;width:70px;' type='text'></td>";
	html+="<td align='left' width='20%' align='right'>"+lblEjeFchHas+"</td><td width='30%'><input p_calendar='true' p_mask='"+dateMask+"' style='font-size:12px;width:70px;' type='text'></td></tr>";
	html+="<tr><td></td><td></td><td></td><td align='right'><button style='font-size:12px' type='button'>Search</button></td></tr>";
	html+="</table>"
	html+="<div class='panel' style='position:relative;width:360;height:190px;'></div>";
	this.historyWindow.content.innerHTML=html;
	this.historyWindow.content.menu=[];
	this.historyWindow.list=this.historyWindow.content.childNodes[1];
	setList(this.historyWindow.list);
	var inputs=this.historyWindow.content.getElementsByTagName("INPUT");
	this.historyWindow.txtTitle=inputs[0];
	this.historyWindow.txtUser=inputs[1];
	this.historyWindow.txtDate1=inputs[2];
	this.historyWindow.txtDate2=inputs[3];
	setMask(this.historyWindow.txtDate1,dateMask);
	setDTPicker(this.historyWindow.txtDate1);
	setMask(this.historyWindow.txtDate2,dateMask);
	setDTPicker(this.historyWindow.txtDate2);
	this.historyWindow.btnSearch=this.historyWindow.content.getElementsByTagName("BUTTON")[0];
	this.historyWindow.list.onElementDoubleClicked=function(el){
		var id=el.data.id;
		HistoryManager.getConference(id);
	}
	/*this.win.list.refreshList=function(model){
		this.clear();
		for(var i=0;i<model.length;i++){
			this.addElement(model[i]);
		}
	}
	comm.addRosterList(this.win.list);
	comm.updateRosterLists();*/
	this.historyWindow.onclose=function(){
		comm.removeRosterList(this.list);
		HistoryManager.historyWindow=null;
	}
	
	this.historyWindow.btnSearch.onclick=function(){
		HistoryManager.historyWindow.search();
	}
	
	this.historyWindow.search=function(title,user,date1,date2){
		if(title){
			HistoryManager.historyWindow.txtTitle.value=title;
		}
		if(user){
			HistoryManager.historyWindow.txtUser.value=user;
		}
		if(date1 && date2){
			HistoryManager.historyWindow.txtDate1.value=date1;
			HistoryManager.historyWindow.txtDate2.value=date2;
		}
		HistoryManager.search(HistoryManager.historyWindow.txtTitle.value,HistoryManager.historyWindow.txtUser.value,HistoryManager.historyWindow.txtDate1.value,HistoryManager.historyWindow.txtDate2.value);
	}
	var actualDate=new Date();
	var yearDiff=1900;
	if(document.all){
		yearDiff=0;
	}
	this.historyWindow.txtDate2.value=( ((actualDate.getDate()+"").length>1)?actualDate.getDate():"0"+actualDate.getDate() )+"/"+( (((actualDate.getMonth()+1)+"").length>1)?(actualDate.getMonth()+1):"0"+(actualDate.getMonth()+1) )+"/"+(actualDate.getYear()+yearDiff);
	var daysLess=10;
	actualDate.setDate(actualDate.getDate()-daysLess);
	this.historyWindow.txtDate1.value=( ((actualDate.getDate()+"").length>1)?actualDate.getDate():"0"+actualDate.getDate() )+"/"+( (((actualDate.getMonth()+1)+"").length>1)?(actualDate.getMonth()+1):"0"+(actualDate.getMonth()+1) )+"/"+(actualDate.getYear()+yearDiff);	
	return this.historyWindow;
}
	
HistoryManager.search=function(title,user,date1,date2){
	var year1="";
	var month1="";
	var day1="";
	var year2="";
	var month2="";
	var day2="";
	
	for(var i=0;i<strDateFormat.length;i++){
		var type=strDateFormat.charAt(i);
		if(type.toUpperCase()=="D"){
			day1+=date1.charAt(i);
			day2+=date2.charAt(i);
		}
		if(type.toUpperCase()=="M"){
			month1+=date1.charAt(i);
			month2+=date2.charAt(i);
		}
		if(type.toUpperCase()=="Y"){
			year1+=date1.charAt(i);
			year2+=date2.charAt(i);
		}
	}
	date1=year1+month1+day1+"0000";
	date2=year2+month2+day2+"9999";
	date1=(date1.indexOf("_")>=0)?"":date1;
	date2=(date2.indexOf("_")>=0)?"":date2;
	
	var after=function(list){
		HistoryManager.historyWindow.list.clear();
		for(var i=0;i<list.length;i++){
			list[i].icon=URL_ROOT_PATH+"/programs/ApiaDesk/styles/"+currStyle+"/images/apiacomm/conferenceIcon.png";
			HistoryManager.historyWindow.list.addElement(list[i]);
		}
	}
	var dateFilter="";
	if(date1 && date2 && date1.length==12 && date2.length==12){
		dateFilter=date1+"-"+date2
	}
	comm.chatHistory.filterConferences(title,dateFilter,user,"",after);
}

HistoryManager.getConference=function(id){
	if(HistoryManager.logXSLConverter!=null){
		var after=function(xml){
			var converted=xslTransform(xml,HistoryManager.logXSLConverter);
			HistoryManager.openLogWindow(converted);
		}
		comm.chatHistory.getConference(id,after);
	}else{
		var idAux=id;
		var loader=new xmlLoader();
		loader.onload=function(xsl){
			HistoryManager.logXSLConverter=xsl;
			HistoryManager.getConference(idAux);
		}
		loader.load(URL_ROOT_PATH+"/programs/ApiaDesk/apiaCommunicator/logTransformer.xsl");
	}
}

HistoryManager.logXSLConverter=null;

HistoryManager.openLogWindow=function(log){
	if(this.logWindow){
		this.logWindow.bringToTop();
	}else{
		var x=(getStageWidth()-300)/2;
		var y=(getStageHeight()-200)/2;
		this.logWindow=openWindow({ url:"" ,width:300 , height:200 , title:("LOG"), fixedSize:true,x:x,y:y,persistable:false });
		this.logWindow.onclose=function(){
			HistoryManager.logWindow=null;
		}
	}
	this.logWindow.content.style.font="10px Tahoma";
	this.logWindow.content.innerHTML="";
	//alert(this.logWindow.content.innerHTML);
	
	this.logWindow.content.appendChild(log.firstChild);
	log.firstChild.style.height="200px";
	if(MSIE){
		setTimeout(function(){
		HistoryManager.logWindow.content.innerHTML=HistoryManager.logWindow.content.innerHTML;
		},20);
	}
	//this.logWindow.content.firstChild.style.height="180px";
}