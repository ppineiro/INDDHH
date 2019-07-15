
function DEFAULT_INDDHH_JS_CLAUSULA_CONSENTIMIENTO(evtSource) { 
var form = ApiaFunctions.getForm('INDDHH_FRM_CLAUSULA_CONSENTIMIENTO_INFORMADO');
var field = form.getField('INDDHH_CLAUSULA_STR');

field.setValue('De conformidad con la Ley Nº 18.331, de 11 de agosto de 2008, de Protección de Datos Personales y Acción de Habeas Data (LPDP), ' +
'los datos suministrados por usted quedarán incorporados en la base de datos, la cual será procesada exclusivamente para la siguiente finalidad: '+
'Consulta o Denuncia en la Institución Nacional de Derechos Humanos del Uruguay (INDDHH). '+
'Los datos personales serán tratados con el grado de protección adecuado, tomándose las medidas de seguridad necesarias para evitar su alteración, '+
'pérdida, tratamiento o acceso no autorizado por parte de terceros. El responsable de la Base de datos es la INDDHH y la dirección donde podrá ejercer' +
'los derechos de acceso, rectificación, actualización, inclusión o supresión, es Bulevar General Artigas 1532.');

return true; // END
} // END
