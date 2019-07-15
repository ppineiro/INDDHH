
function DEFAULT_INDDHH_JS_GRUPO_ETNICO_ESPECIFICAR(evtSource, par_nameFrm, par_nameAttGenero, par_nameAttEspecificar) { 
var form = ApiaFunctions.getForm(par_nameFrm);
var grupoEtnico = form.getField(par_nameAttGenero).getValue();
var especifique = form.getField(par_nameAttEspecificar);

if(grupoEtnico == '5')
{
	especifique.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
} 
else
{
	especifique.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
}



return true; // END
} // END
