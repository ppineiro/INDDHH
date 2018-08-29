var objError = null;

function retomarTramite(){
	//if(CURRENT_TASK_NAME == 'CARGA_DATOS_TRAMITE'){
	  var retoma = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_RETOMA_TRAMITE_STR").getValue();
	  //alert("Valor de retoma " + retoma);
	  if(retoma=='SI'){
		ApiaFunctions.getForm("TRM_TITULO").getField("TRM_RETOMA_TRAMITE_STR").setValue("NO");
		if(CURRENT_TASK_NAME == 'CARGA_DATOS_TRAMITE'){
		    var stepSiguiente = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_STEP_ACTUAL_NUM").getValue();
		    //alert("Valor de stepActual antes de presionar el boton de siguiente " + stepSiguiente);
		    if(stepSiguiente != 1){
			    //btnSiguiente = $("btnNext").getElement("button");
			    //btnSiguiente.click();
			    document.getElementById("btnNext").click();
		    }
		    //ApiaFunctions.hideActionButton(ActionButton.BTN_NEXT);
		}
	  }
	//}
}

function presionarBtnNextStep(){
	
	var formDatosPagosGwItc = ApiaFunctions.getForm("TRM_DATOS_GW_ITC_PAGOS")
	var habilita = formDatosPagosGwItc.getField("habilitarBtnConfirmar").getValue();
	divBtnSiguiente = $("btnNext");
	if(divBtnSiguiente != null){
		if(habilita == 'true'){
			//btnSiguiente = divBtnSiguiente.getElement("button");
			//btnSiguiente.click();
			document.getElementById("btnNext").click();
		}
	}
	    
}

function presionarBtnConfirmarPago(){
	
	var formDatosPagosGwItc = ApiaFunctions.getForm("TRM_DATOS_GW_ITC_PAGOS")
	var habilita = formDatosPagosGwItc.getField("habilitarBtnConfirmar").getValue();
	if(habilita == 'true'){
		divBtnSiguiente = $("btnConf");
		if(divBtnSiguiente != null){
			//btnSiguiente = divBtnSiguiente.getElement("button");
			//btnSiguiente.click();
			document.getElementById("btnConf").click();
		}
		
	}
	
}

function chStep(stepNum){
	var frmTitulo = ApiaFunctions.getForm("TRM_TITULO");
	var fldCurrStep = frmTitulo.getField("TRM_STEP_ACTUAL_NUM");
	var btnSetStep = frmTitulo.getField("CHANGE_STEP");
	
	if(fldCurrStep.getValue() > 0 && fldCurrStep.getValue() > stepNum){
		
		var xmlhttp;

		if (window.XMLHttpRequest) {
			xmlhttp = new XMLHttpRequest();
		} else {
			xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		}

		xmlhttp.open("POST", "helpHTML/ProgressBar.jsp", false);
		xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		xmlhttp.send("stepNum=" + stepNum + "&tabId=" + getTabId() + "&tokenId=" + getTokenId());
		
		btnSetStep.fireClickEvent();
	}
	
	return false;
}

function getTokenId(){
    var tokenId = getURLParameter("tokenId");
    
    if(tokenId === "Not found"){
    	throw new Exception("Token Id not found");
    }
    
    return tokenId;
}

function getTabId(){
    var tabId = getURLParameter("tabId");
    
    if(tabId === "Not found"){
    	throw new Exception("Tab Id not found");
    }
    
    return tabId;
}

function getURLParameter(parName){
    var result = "Not found";
    var tmp = [];
    var items = location.search.substr(1).split("&");
    
    for(var index = 0; index < items.length; index++){
        tmp = items[index].split("=");
        if(tmp[0] === parName){
        	result = decodeURIComponent(tmp[1]);
        }
    }
    
    return result;
}

function validateDate(inputText){  

	var dateformat = /^(0?[1-9]|[12][0-9]|3[01])[\/\-](0?[1-9]|1[012])[\/\-]\d{4}$/;  
	// Match the date format through regular expression  
	if(inputText.match(dateformat)){  
		  
		//Test which seperator is used '/' or '-'  
		var opera1 = inputText.split('/');  
		var opera2 = inputText.split('-');  
		lopera1 = opera1.length;  
		lopera2 = opera2.length;  
		// Extract the string into month, date and year  
		if (lopera1>1){  
			var pdate = inputText.split('/');  
		}else if (lopera2>1){  
			var pdate = inputText.split('-');  
		}  
		var dd = parseInt(pdate[0]);  
		var mm  = parseInt(pdate[1]);  
		var yy = parseInt(pdate[2]);  

		// Create list of days of a month [assume there is no leap year by default]  
		var ListofDays = [31,28,31,30,31,30,31,31,30,31,30,31];  
		if (mm==1 || mm>2){  
			if (dd>ListofDays[mm-1]){  				 
				return false;  
			}  
		}  
		if (mm==2){  
			var lyear = false;  
			if ( (!(yy % 4) && yy % 100) || !(yy % 400)){  
				lyear = true;  
			} 
			if ((lyear==false) && (dd>=29)){  				 
				return false;  
			} 
			if ((lyear==true) && (dd>29)) {  				 
				return false;  
			}  
		}  
	}else{  		  		
		return false;  
	}  
	
	return true;
} 


function validarFechaMayorQue(fechaInicial,fechaFinal){
    valuesStart=fechaInicial.split("/");
    valuesEnd=fechaFinal.split("/");

    // Verificamos que la fecha no sea posterior a la actual
    var dateStart=new Date(valuesStart[2],(valuesStart[1]-1),valuesStart[0]);
    var dateEnd=new Date(valuesEnd[2],(valuesEnd[1]-1),valuesEnd[0]);
    if(dateStart<dateEnd){
        return true;
    }else{
    	return false;
    }
}

function validarFechaMayorIgualQue(fechaInicial,fechaFinal){
    valuesStart=fechaInicial.split("/");
    valuesEnd=fechaFinal.split("/");

    // Verificamos que la fecha no sea posterior a la actual
    var dateStart=new Date(valuesStart[2],(valuesStart[1]-1),valuesStart[0]);
    var dateEnd=new Date(valuesEnd[2],(valuesEnd[1]-1),valuesEnd[0]);
    if(dateStart<=dateEnd){
        return true;
    }else{
    	return false;
    }
}


function showMsgError(par_frm, par_atr, par_msg) {
	showMessage(par_msg);
}

function limpiarErroresFnc() {
	
}
function hideMsgError(par_frm, par_atr, par_msg) { 
	
}
//---
function validarFechaMenorQue(fechaInicial,fechaFinal){
    valuesStart=fechaInicial.split("/");
    valuesEnd=fechaFinal.split("/");

    // Verificamos que la fecha no sea posterior a la actual
    var dateStart=new Date(valuesStart[2],(valuesStart[1]-1),valuesStart[0]);
    var dateEnd=new Date(valuesEnd[2],(valuesEnd[1]-1),valuesEnd[0]);
    if(dateStart>dateEnd){
        return true;
    }else{
    	return false;
    }
}

function validarFechaMenorIgualQue(fechaInicial,fechaFinal){
    valuesStart=fechaInicial.split("/");
    valuesEnd=fechaFinal.split("/");

    // Verificamos que la fecha no sea posterior a la actual
    var dateStart=new Date(valuesStart[2],(valuesStart[1]-1),valuesStart[0]);
    var dateEnd=new Date(valuesEnd[2],(valuesEnd[1]-1),valuesEnd[0]);
    if(dateStart>=dateEnd){
        return true;
    }else{
    	return false;
    }
}

function getFechaHoy(){
	var today = new Date();
	var dd = today.getDate();
	var mm = today.getMonth()+1; //January is 0!

	var yyyy = today.getFullYear();
	if(dd<10){
		dd='0'+dd;
	} 
	if(mm<10){
		mm='0'+mm;
	} 
	var today = dd+'/'+mm+'/'+yyyy;
	return today;	
}	

function sumarFecha (dias, fecha){ 
	
	 var Fecha = new Date();
	 var sFecha = fecha || (Fecha.getDate() + "/" + (Fecha.getMonth() +1) + "/" + Fecha.getFullYear());
	 var sep = sFecha.indexOf('/') != -1 ? '/' : '-'; 
	 var aFecha = sFecha.split(sep);
	 var fecha = aFecha[2]+'/'+aFecha[1]+'/'+aFecha[0];
	 fecha= new Date(fecha);
	 fecha.setDate(fecha.getDate()+parseInt(dias));
	 
	 var anno=fecha.getFullYear();
	 var mes= fecha.getMonth()+1;
	 var dia= fecha.getDate();
	 mes = (mes < 10) ? ("0" + mes) : mes;
	 dia = (dia < 10) ? ("0" + dia) : dia;
	 var fechaFinal = dia+sep+mes+sep+anno;
	 return (fechaFinal);
	 
 }

function ajustarAnchoColumna(){	
	try{
		var x = document.getElementsByClassName("css-file-input");
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				
				var el = x[i];
				
				el = el.parentNode;
				el = el.parentNode;
				el = el.parentNode;
				el = el.parentNode;
				el = el.parentNode;
				
				//Acciones
				var el1 = el.children[0].children[0].children[0].children[0].children[0];
							
				el1.style.width = "100px";
				
				//adjutnos
				var el2 = el.children[0].children[0].children[0].children[0].children[1];
							
				el2.style.width = "500px";
				
			}			
		}
		
		var x = document.getElementsByClassName("docData");
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				var el = x[i];
				if (el.innerHTML != ""){
					var l = el.innerHTML.length;	
					var m = (l * 6);					
					el.parentNode.children[5].style.marginLeft = m;
				}
			}
		}
		
	} catch (e) {
	}
}

