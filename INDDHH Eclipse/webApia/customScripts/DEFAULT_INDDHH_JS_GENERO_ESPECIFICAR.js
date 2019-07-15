
function DEFAULT_INDDHH_JS_GENERO_ESPECIFICAR(evtSource, par_nameFrm, par_nameAttGenero, par_nameAttEspecificar) { 
var form = ApiaFunctions.getForm(par_nameFrm);
var genero = form.getField(par_nameAttGenero).getValue();
var especifique = form.getField(par_nameAttEspecificar);

if(genero == '4')
{
	especifique.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
} 
else
{
	especifique.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
}


return true; // END
} // END
