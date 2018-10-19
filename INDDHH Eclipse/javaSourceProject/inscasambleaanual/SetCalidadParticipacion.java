package inscasambleaanual;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Attribute;
import com.dogma.busClass.object.Entity;

public class SetCalidadParticipacion extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		// TODO Auto-generated method stub
		Entity currEnt = this.getCurrentEntity();

		Attribute calidad = currEnt.getAttribute("INDDHH_AA_CALIDAD_PARTICIPACION_STR");
		String tipoOrg = currEnt.getAttribute("INDDHH_AA_TIPO_ORGANIZACION_STR").getValuesAsString();
		// 1. Organización Social / 2. Gubernamental / 3. Organismo internacional
		String nroReg = currEnt.getAttribute("INDDHH_AA_NUMERO_REGISTRO_STR").getValuesAsString();

		switch (tipoOrg) {
		case "1":
			if (nroReg != null && !nroReg.isEmpty()) { //Tiene Nro. Reg.
				calidad.setValue("Observador con Voz y Voto");
			} else { //No tiene Nro. Reg.
				calidad.setValue("Observador sin Voz ni Voto");
			}
			break;
		case "2":
			calidad.setValue("Observador con Voz y Voto");
			break;
		case "3":
			calidad.setValue("Observador sin Voz ni Voto");
			break;
		default: //Persona
			calidad.setValue("Observador sin Voz ni Voto");
			break;
		}
	}

}
