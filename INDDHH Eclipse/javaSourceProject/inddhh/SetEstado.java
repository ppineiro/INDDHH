package inddhh;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Attribute;
import com.dogma.busClass.object.Entity;

public class SetEstado extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {

		Entity currEnt = this.getCurrentEntity();
		// Se setea el estado según el parámetro pasado
		String parEstado = getParameter("estado").getValuesAsString();
		String parNombreAtt = getParameter("nombreAtt").getValuesAsString();

		currEnt.getAttribute(parNombreAtt).setValue(parEstado);

	}

}
