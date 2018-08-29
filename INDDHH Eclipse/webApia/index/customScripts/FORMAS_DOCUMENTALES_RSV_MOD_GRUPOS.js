
function fnc_1001_3995(evtSource) { 
var index = evtSource.index;
var form = ApiaFunctions.getForm('FRM_RSV_MOD_RESERVA');
var attName = 'RSV_NRO_EXP_PERM_GRUPOS';
var attTodos = 'RSV_NRO_EXP_PERM_TODOS';
	
var pools = form.getFieldColumn(attName)[index];
var todos = form.getFieldColumn(attTodos)[index].getValue();
if (todos) return;
if ("Todos" == pools.getValue()) pools.setValue("");
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
