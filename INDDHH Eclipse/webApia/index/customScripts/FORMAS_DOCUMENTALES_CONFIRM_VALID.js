
function fnc_1001_4211(evtSource, par_msg, par_form, par_att, par_value) { 
var myform = ApiaFunctions.getForm(par_form);
var valueAtt = myform.getField(par_att).getValue();
if(valueAtt == par_value){
    var conf = confirm(par_msg);
    if(!conf){
       return false;
   }
}


return true; // END
} // END
