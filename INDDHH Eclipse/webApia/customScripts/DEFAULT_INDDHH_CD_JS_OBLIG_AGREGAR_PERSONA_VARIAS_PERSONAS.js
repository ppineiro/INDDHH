
function DEFAULT_INDDHH_CD_JS_OBLIG_AGREGAR_PERSONA_VARIAS_PERSONAS(evtSource) { 
var frmConsDen = ApiaFunctions.getEntityForm('INDDHH_FRM_CONSULTANTE_DENUNCIANTE');
var frmVvariasPersonas = ApiaFunctions.getEntityForm('INDDHH_FRM_CONSULTANTE_DENUNCIANTE_VARIAS_PERSONAS');
var tipoPersona = frmConsDen.getField('INDDHH_TIPO_PERSONA_STR').getValue();

if(tipoPersona == '2') //varias personas
{
    var myGrid = frmVvariasPersonas.getField('tblVariasPersonas');
    var ctdValores = frmVvariasPersonas.getFieldColumn('INDDHH_ATT_VARIAS_PERSONAS_DOC_TIPO_STR').length;
     
    if (ctdValores < 1) {
      showMsgConfirm("error", 'Debe agregar alguna persona.', "setFocoObj");
      return false;
    } else {
      return true;
    }
}




return true; // END
} // END
