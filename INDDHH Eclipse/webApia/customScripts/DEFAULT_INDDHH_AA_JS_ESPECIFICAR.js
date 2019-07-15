
function DEFAULT_INDDHH_AA_JS_ESPECIFICAR(evtSource, par_nameFrm, par_nameAttCombo, par_nameAttEspecificar, par_valCombo) { 
var form = ApiaFunctions.getForm(par_nameFrm);
var genero = form.getField(par_nameAttCombo).getValue();
var especifique = form.getField(par_nameAttEspecificar);

if(genero == par_valCombo)
{
	especifique.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
} 
else
{
	especifique.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
}




return true; // END
} // END
