
function fnc_1_1000(evtSource) { 
alert("evento ejecutado "+document.getElementById("FORMTEST_NOMBRE_hidden").options.length);

var list=document.getElementById("FORMTEST_NOMBRE_hidden");
for (n=0;n<3;n++){
/*    list[n].value = "POLLO "+n;
    list[n].text = "POLLO "+n;*/
    var obj = new Option( "pollo","pollo", false, false );
    
    list.options.push(obj);
    
}





return true; // END
} // END
