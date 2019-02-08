package inddhh;

import java.util.Date;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Form;
import com.dogma.vo.IProperty;

public class SetValorOrgCoordinacion extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {

		Entity currEnt = this.getCurrentEntity();
		String org = currEnt.getAttribute("INDDHH_ORGANISMO_COORDINAR_STR").getValueAsString();
		String otroOrg = currEnt.getAttribute("INDDHH_OTRO_ORG_COORDINAR_STR").getValueAsString();

		if (org.compareTo("1") == 0) {
			currEnt.getAttribute("INDDHH_ORGANISMO_COORDINAR_VALOR_STR")
					.setValue("Comisionado Parlamentario Penitenciario");
		} else if (org.compareTo("2") == 0) {
			currEnt.getAttribute("INDDHH_ORGANISMO_COORDINAR_VALOR_STR")
					.setValue("Defensoría de Vecinas y Vecinos de Montevideo");
		} else if (org.compareTo("3") == 0) {
			currEnt.getAttribute("INDDHH_ORGANISMO_COORDINAR_VALOR_STR")
					.setValue("Comisión Honoraria contra el Racismo, la Xenofobia y toda otra forma de Discriminación");
		} else if (org.compareTo("4") == 0) {
			currEnt.getAttribute("INDDHH_ORGANISMO_COORDINAR_VALOR_STR").setValue(otroOrg);
		}
	}

}
