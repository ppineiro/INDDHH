package inddhh;

import java.util.Date;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Form;
import com.dogma.vo.IProperty;

public class SetROFormsRecepcion extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {

		Entity currEnt = this.getCurrentEntity();
		String canalInicioTmt = currEnt.getAttribute("INDDHH_VIA_INICIO_VALOR_STR").getValueAsString();

		Form form = currEnt.getForm("INDDHH_FRM_DATOS_PERSONALES");

		if (canalInicioTmt.compareTo("En Línea") == 0) {

			form.setFormProperty(IProperty.PROPERTY_READONLY, true);
		} else {

			form.setFormProperty(IProperty.PROPERTY_READONLY, false);
		}
	}

}
