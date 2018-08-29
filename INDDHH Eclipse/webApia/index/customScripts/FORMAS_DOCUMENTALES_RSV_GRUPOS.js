
function fnc_1001_3983(evtSource) { 
var index = evtSource.index;
var form = ApiaFunctions.getForm('FRM_RSV_NRO_RESERVA');
var attName = 'RSV_NRO_EXP_PERM_GRUPOS';
	
var pools = form.getField(attName);

var rets =  ModalController.openWinModal("/expedientes/notificationPools.jsp?pools="+pools.getValue(), 600, 500, null, null, null, true, true);
var doAfter=function(rets){
       if (rets!=null){
       	   var attPools = form.getField(attName);
            attPools.setValue(rets);
        }
}
rets.onclose=function(){
	doAfter(rets.returnValue);
}
return true; // END
} // END
