var evtNotif;

var doScrollOnFocus;

function initTabActions(){
	evtNotif = "";
	doScrollOnFocus = true;
	
	//evento para el tab
    $('tabActions').addEvent("click", function(evt){
    	if (doScrollOnFocus){
    		if(Browser.ie) {
    			setTimeout(function() {
    				fixTable();
    			}, 100);
    		} else {
    			fixTable();
    		}
    		doScrollOnFocus = false;
	    }
    });
	
	//Agregar Grupo Notificacion
    $('addPoolAsi').addEvent("click", function(evt){
    	evt.stop();
    	openPoolsModal('Asi');    	
    });
    $('addPoolCom').addEvent("click", function(evt){
    	evt.stop();
    	openPoolsModal('Com');    	
    });
    $('addPoolAcq').addEvent("click", function(evt){
    	evt.stop();
    	openPoolsModal('Acq');    	
    });
    $('addPoolRel').addEvent("click", function(evt){
    	evt.stop();
    	openPoolsModal('Rel');    	
    });
    $('addPoolAle').addEvent("click", function(evt){
    	evt.stop();
    	openPoolsModal('Ale');    	
    });
    $('addPoolOve').addEvent("click", function(evt){
    	evt.stop();
    	openPoolsModal('Ove');    	
    });
    $('addPoolRea').addEvent("click", function(evt){
    	evt.stop();
    	openPoolsModal('Rea');    	
    });
    $('addPoolEle').addEvent("click", function(evt){
    	evt.stop();
    	openPoolsModal('Ele');    	
    });
    $('addPoolDel').addEvent("click", function(evt){
    	evt.stop();
    	openPoolsModal('Del');    	
    });
   
    
    //Mensajes
    $('viewMsgAsi').addEvent("click", function(evt){
    	evt.stop();
    	openMsgsModal('Asi'); 	   	
    });
    $('viewMsgCom').addEvent("click", function(evt){
    	evt.stop();
    	openMsgsModal('Com'); 	   	
    });
    $('viewMsgAcq').addEvent("click", function(evt){
    	evt.stop();
    	openMsgsModal('Acq'); 	   	
    });
    $('viewMsgRel').addEvent("click", function(evt){
    	evt.stop();
    	openMsgsModal('Rel'); 	   	
    });
    $('viewMsgAle').addEvent("click", function(evt){
    	evt.stop();
    	openMsgsModal('Ale'); 	   	
    });
    $('viewMsgOve').addEvent("click", function(evt){
    	evt.stop();
    	openMsgsModal('Ove'); 	   	
    });
    $('viewMsgRea').addEvent("click", function(evt){
    	evt.stop();
    	openMsgsModal('Rea'); 	   	
    });
    $('viewMsgEle').addEvent("click", function(evt){
    	evt.stop();
    	openMsgsModal('Ele'); 	   	
    });
    $('viewMsgDel').addEvent("click", function(evt){
    	evt.stop();
    	openMsgsModal('Del'); 	   	
    });
    
    
    //['addPoolAsi','addPoolCom','addPoolAcq','addPoolRel','addPoolAle','addPoolOve','addPoolRea','addPoolEle','addPoolDel'].each(setTooltip);
	
	onChangeChkReaPool($('chkReaPool'));
	
	loadNotifications();
}

function openPoolsModal(event){
	evtNotif = event;
	POOLMODAL_SHOWAUTOGENERATED = false;
	POOLMODAL_SHOWNOTAUTOGENERATED = false;
	POOLMODAL_FROMENVS = "";
	POOLMODAL_SHOWCURRENTENV = true;
	POOLMODAL_SHOWGLOBAL = true;
	POOLMODAL_EXACTMATCH = ""; 
	POOLMODAL_SELECTONLYONE	= false;
	showPoolsModal(processPoolsModalReturn);
}

function openMsgsModal(event){
	evtNotif = event;
	var text = $("msgText"+event).value;
	var sub = $("msgSub"+event).value;
	showMsgNotificationsModal(event,sub,text,processMsgNotifModalReturn);
}

function onChangeChkReaPool(chkReaPool){
	var cmbReaPool = $('cmbReaPool');
	if (chkReaPool.checked == true){
		cmbReaPool.disabled = false;		
	} else {
		cmbReaPool.disabled = true;
		cmbReaPool.value = "";
	}
}

function onChangeCmbNotif(cmbNotif){
	var cmbNotifId = cmbNotif.getAttribute("id");
	var levelX = $("levX"+cmbNotifId);
	if (cmbNotif.value != "0"){
		levelX.value = "";
		levelX.disabled = true;
	} else {
		levelX.disabled = false;
		levelX.value = "0";
	}
}

function loadNotifications(){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadNotifications&isAjax=true' + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { 
			processNotificationXml(resXml); 
			
			["containerPoolsAsi","containerPoolsCom","containerPoolsAcq","containerPoolsRel","containerPoolsAle",
			 	"containerPoolsOve","containerPoolsRea","containerPoolsEle","containerPoolsDel"].each(function(container){
				initAdminModalHandlerOnChangeHighlight($(container));	
			})
		}
	}).send();
}

function processNotificationXml(resXml){
	var notifications = resXml.getElementsByTagName("notifications")
	if (notifications != null && notifications.length > 0 && notifications.item(0) != null) {
		var notify, asig, compleat, acquired, release, alert, overdue, reasign, elevate, delegate;
		
		//Genericas
		var cols = new Array("U","P","E","T"); //Usuario creador proceso, Grupo del usuario creador, Usuario creador entidad, Grupo asignado a tarea
		for(var i = 0; i < cols.length; i++){
			//notify = notifications.item(0).getElements("Not" + cols[i])[0];
			//IE friendly
			for(var j = 0; j < notifications.item(0).childNodes.length; j++) {
				if(notifications.item(0).childNodes[j].tagName == ("Not" + cols[i])) {
					notify = notifications.item(0).childNodes[j];
					break;
				}
			}
			
			asig = notify.getAttribute("Asi");
			compleat = notify.getAttribute("Com");
			acquired = notify.getAttribute("Acq");
			release = notify.getAttribute("Rel");
			alert = notify.getAttribute("Ale");
			overdue = notify.getAttribute("Ove");
			reasign = notify.getAttribute("Rea");
			elevate = notify.getAttribute("Ele");
			delegate = notify.getAttribute("Del");
			
			if (cols[i] == "U" || cols[i] == "E"){ //Usuario Creador Proceso || Usuario Creador entidad
				$("chk"+"Asi"+"Not"+cols[i]).checked = (asig == "-2");
				$("chk"+"Com"+"Not"+cols[i]).checked = (compleat == "-2");
				$("chk"+"Acq"+"Not"+cols[i]).checked = (acquired == "-2");
				$("chk"+"Rel"+"Not"+cols[i]).checked = (release == "-2");
				$("chk"+"Ale"+"Not"+cols[i]).checked = (alert == "-2");
				$("chk"+"Ove"+"Not"+cols[i]).checked = (overdue == "-2");
				$("chk"+"Rea"+"Not"+cols[i]).checked = (reasign == "-2");
				$("chk"+"Ele"+"Not"+cols[i]).checked = (elevate == "-2");
				$("chk"+"Del"+"Not"+cols[i]).checked = (delegate == "-2");
			} else { //Grupo del usuario creador || Grupo asignado a tarea
				if (asig >= 0){
					$("cmb"+"Asi"+"Not"+cols[i]).value = "0";
					$("levXcmb"+"Asi"+"Not"+cols[i]).value = asig;
				} else {
					$("cmb"+"Asi"+"Not"+cols[i]).value = asig;
					$("levXcmb"+"Asi"+"Not"+cols[i]).value = "";
					$("levXcmb"+"Asi"+"Not"+cols[i]).disabled = true;
				}
				if (compleat >= 0){
					$("cmb"+"Com"+"Not"+cols[i]).value = "0";
					$("levXcmb"+"Com"+"Not"+cols[i]).value = compleat;
				} else {
					$("cmb"+"Com"+"Not"+cols[i]).value = compleat;
					$("levXcmb"+"Com"+"Not"+cols[i]).value = "";
					$("levXcmb"+"Com"+"Not"+cols[i]).disabled = true;
				}
				if (acquired >= 0){
					$("cmb"+"Acq"+"Not"+cols[i]).value = "0";
					$("levXcmb"+"Acq"+"Not"+cols[i]).value = acquired;
				} else {
					$("cmb"+"Acq"+"Not"+cols[i]).value = acquired;
					$("levXcmb"+"Acq"+"Not"+cols[i]).value = "";
					$("levXcmb"+"Acq"+"Not"+cols[i]).disabled = true;
				}
				if (release >= 0){
					$("cmb"+"Rel"+"Not"+cols[i]).value = "0";
					$("levXcmb"+"Rel"+"Not"+cols[i]).value = release;
				} else {
					$("cmb"+"Rel"+"Not"+cols[i]).value = release;
					$("levXcmb"+"Rel"+"Not"+cols[i]).value = "";
					$("levXcmb"+"Rel"+"Not"+cols[i]).disabled = true;
				}
				if (alert >= 0){
					$("cmb"+"Ale"+"Not"+cols[i]).value = "0";
					$("levXcmb"+"Ale"+"Not"+cols[i]).value = alert;
				} else {
					$("cmb"+"Ale"+"Not"+cols[i]).value = alert;
					$("levXcmb"+"Ale"+"Not"+cols[i]).value = "";
					$("levXcmb"+"Ale"+"Not"+cols[i]).disabled = true;
				}
				if (overdue >= 0){
					$("cmb"+"Ove"+"Not"+cols[i]).value = "0";
					$("levXcmb"+"Ove"+"Not"+cols[i]).value = overdue;
				} else {
					$("cmb"+"Ove"+"Not"+cols[i]).value = overdue;
					$("levXcmb"+"Ove"+"Not"+cols[i]).value = "";
					$("levXcmb"+"Ove"+"Not"+cols[i]).disabled = true;
				}
				if (reasign >= 0){
					$("cmb"+"Rea"+"Not"+cols[i]).value = "0";
					$("levXcmb"+"Rea"+"Not"+cols[i]).value = reasign;
				} else {
					$("cmb"+"Rea"+"Not"+cols[i]).value = reasign;
					$("levXcmb"+"Rea"+"Not"+cols[i]).value = "";
					$("levXcmb"+"Rea"+"Not"+cols[i]).disabled = true;
				}
				if (elevate >= 0){
					$("cmb"+"Ele"+"Not"+cols[i]).value = "0";
					$("levXcmb"+"Ele"+"Not"+cols[i]).value = elevate;
				} else {
					$("cmb"+"Ele"+"Not"+cols[i]).value = elevate;
					$("levXcmb"+"Ele"+"Not"+cols[i]).value = "";
					$("levXcmb"+"Ele"+"Not"+cols[i]).disabled = true;
				}
				if (delegate >= 0){
					$("cmb"+"Del"+"Not"+cols[i]).value = "0";
					$("levXcmb"+"Del"+"Not"+cols[i]).value = delegate;
				} else {
					$("cmb"+"Del"+"Not"+cols[i]).value = delegate;
					$("levXcmb"+"Del"+"Not"+cols[i]).value = "";
					$("levXcmb"+"Del"+"Not"+cols[i]).disabled = true;
				}
			}
		}
		
		//Grupos
		var pools = notifications.item(0).getElementsByTagName("pools");
		if (pools != null && pools.length > 0 && pools.item(0) != null) {
			pools = pools.item(0).getElementsByTagName("pool");
			for(var i = 0; i < pools.length; i++){
				var pool = pools[i];
				var pEvent = traslateEvent(pool.getAttribute("event"));
				var pId = pool.getAttribute("id");
				var pName = pool.getAttribute("name");
				createPoolNotif(pId,pName,pEvent);
			}
		}
		
		//Mensajes
		var msgs = notifications.item(0).getElementsByTagName("messages");
		if (msgs != null && msgs.length > 0 && msgs.item(0) != null) {
			msgs = msgs.item(0).getElementsByTagName("message");
			for(var i = 0; i < msgs.length; i++){
				var msg = msgs[i];
				var mEvent = traslateEvent(msg.getAttribute("event"));
				var msgText = $("msgText"+mEvent);
				msgText.value = msg.getAttribute("text");
				var msgSubject = $("msgSub"+mEvent);
				msgSubject.value = msg.getAttribute("subject");
			}
		}
	}
	
	fixTable();
}

function createPoolNotif(pId,pName,evt){
	var before = $("addPool"+evt);
	if (!$("pNot"+evt+pId)){
		var p = new Element("div",{'id': "pNot"+evt+pId, 'class': 'option optionTextOverflow optionRemoveTD optionWidth75', html: pName, 'title': pName}).inject(before,"before");
		p.setAttribute("pIdNum",pId);
		p.setAttribute("pName",pName);
		p.addEvent("click",function(evt){ this.destroy(); fixTable(); });
	}	
}

function processPoolsModalReturn(ret){
	ret.each(function(pool){
		createPoolNotif(pool.getRowId(),pool.getRowContent()[0],evtNotif);	
	});
	fixTable();
}

function processMsgNotifModalReturn(ret){
	var inputMsgNot = $("msgText"+evtNotif);
	inputMsgNot.value = ret.message;
	var inputSubNot = $("msgSub"+evtNotif);
	inputSubNot.value = ret.subject;
	
	
}

function executeBeforeConfirmTabActions(){
	var array = new Array("Asi","Com","Acq","Rel","Ale","Ove","Rea","Ele","Del");
	
	var poolsId;
	var container;
	var values;
	for (var i = 0; i < array.length; i++){
		poolsId = $("poolsId"+array[i]);
		container = $("containerPools"+array[i]);
		values = "";
		
		container.getElements("div.optionRemoveTD").each(function (option){
			if (values != "") values += ";";
			values += option.getAttribute("pIdNum");
			values += PRIMARY_SEPARATOR;
			values += option.getAttribute("pName"); 
		});
		
		poolsId.value = values;
	}	
	
	return true;
}

function fixTable(){
	var table = $('tableData');
	addScrollTable(table);
}

function traslateEvent(event){
	if (event == "C"){
		return "Asi";
	} else if (event == "E"){
		return "Com";
	} else if (event == "Q"){
		return "Acq";
	} else if (event == "R"){
		return "Rel";
	} else if (event == "A"){
		return "Ale";
	} else if (event == "O"){
		return "Ove";
	} else if (event == "S"){
		return "Rea";
	} else if (event == "V"){
		return "Ele";
	} else if (event == "D"){
		return "Del";
	}
	return "";
}


