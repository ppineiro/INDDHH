
function fnc_1001_3996(evtSource) { 
var index = evtSource.index;
var form = ApiaFunctions.getForm('FRM_RSV_MOD_RESERVA');
var attName = 'RSV_NRO_EXP_NOT_GRUPOS';
var pools = form.getFieldColumn(attName)[index];
var attPoMail = 'RSV_NRO_EXP_NOT_POR_MAIL';
var attPorMsg = 'RSV_NRO_EXP_NOT_POR_MSG';

var porMail = form.getFieldColumn(attPoMail)[index].getValue();
var porMsg = form.getFieldColumn(attPorMsg)[index].getValue();
if(!porMail && !porMsg) return;

var rets = ModalController.openWinModal("/expedientes/notificationPools.jsp?pools="+pools.getValue(), 600, 500, null, null, null, true, true);

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
