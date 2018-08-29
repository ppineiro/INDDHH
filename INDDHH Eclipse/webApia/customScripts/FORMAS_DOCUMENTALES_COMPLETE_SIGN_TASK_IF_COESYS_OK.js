
function FORMAS_DOCUMENTALES_COMPLETE_SIGN_TASK_IF_COESYS_OK(evtSource) { 
var integracionCoesys = "";
var completeTask= "";
var myForm = ApiaFunctions.getForm("FIRMA");


if (myForm != null && myForm.getField("EXP_COMPLETE_TASK_FIRMA_COESYS_FLAG_STR") != null){
  completeTask = myForm.getField("EXP_COMPLETE_TASK_FIRMA_COESYS_FLAG_STR").value;
}  

if (myForm != null && myForm.getField("EXP_FIRMA_CON_COESYS_STR") != null){
  integracionCoesys = myForm.getField("EXP_FIRMA_CON_COESYS_STR").value;
}

if(integracionCoesys != null && integracionCoesys == 'true'){
 if(completeTask== 'OK'){
	setTimeout(apretarConfirmar(),5000);
 }
}	
return true; // END
} // END
