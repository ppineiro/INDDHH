
function DEFAULT_INDDHH_CD_JS_OBLIG_AGREGAR_UN_ORG(evtSource) { 
var frmDerechosOrganismos = ApiaFunctions.getEntityForm('INDDHH_FRM_DDHH_VULN_ORG_DENUNCIADO');

    var myGrid = frmDerechosOrganismos.getField('tblOrganismos');
    var ctdValores = frmDerechosOrganismos.getFieldColumn('INDDHH_ORG_INCISO_TABLA_STR').length;
     
    if (ctdValores < 1) {
      showMessage('Debe agregar al menos un organismo.');
      return false;
    }





return true; // END
} // END
