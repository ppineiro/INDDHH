package inddhh;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;

public class CargarAttDeInicioTmt extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {

		String attOrigen = this.getParameter("orig").getValueAsString();
		String attDestino = this.getParameter("dest").getValueAsString();
		
		Entity currEnt = this.getCurrentEntity();
		Object origen = currEnt.getAttribute(attOrigen).getValue();

		if (origen != null && !origen.toString().isEmpty()) {
			currEnt.getAttribute(attDestino).setValue(origen);
		}

	}

}
