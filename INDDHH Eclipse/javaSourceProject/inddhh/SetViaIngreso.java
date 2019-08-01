package inddhh;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;

public class SetViaIngreso extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();

		String viaInicio = currEnt.getAttribute("INDDHH_VIA_INICIO_STR").getValueAsString();
		if (viaInicio != null && !viaInicio.isEmpty()) {
			int viaInicioInt = Integer.valueOf(viaInicio);

			Entity viaInicioEnt = this.getEntity("VIA", viaInicioInt, null);
			currEnt.getAttribute("INDDHH_VIA_INICIO_VALOR_STR")
					.setValue(viaInicioEnt.getAttribute("A_CODIGUERA_VALUE").getValueAsString());
		} else {
			currEnt.getAttribute("INDDHH_VIA_INICIO_VALOR_STR").setValue("En Línea");
		}
	}

}
