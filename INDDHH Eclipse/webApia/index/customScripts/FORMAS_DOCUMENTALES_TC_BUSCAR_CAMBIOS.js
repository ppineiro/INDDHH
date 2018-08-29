
function FORMAS_DOCUMENTALES_TC_BUSCAR_CAMBIOS(evtSource, par_frm_name, par_att_aux_name, par_btn_name, par_value, par_destino, par_intervalo) { 
window.setInterval(function(){

  var xmlhttp;

  if(window.XMLHttpRequest){
    xmlhttp=new XMLHttpRequest();
  }else{
    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }

  xmlhttp.onreadystatechange=function(){
    if(xmlhttp.readyState==4 && xmlhttp.status==200){
      var res = xmlhttp.responseText;
      if(res == par_value){
        ApiaFunctions.getForm(par_frm_name).getField(par_btn_name).fireClickEvent();
      }
    }
  }
  
  var aux = ApiaFunctions.getForm(par_frm_name).getField(par_att_aux_name).getValue();
  xmlhttp.open("POST", par_destino, true);
  xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
  xmlhttp.send("a=" + aux + "&" + "t=" + Date.now());

}, par_intervalo);
return true; // END
} // END
