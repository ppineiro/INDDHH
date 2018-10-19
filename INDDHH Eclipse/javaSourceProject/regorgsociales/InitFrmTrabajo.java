package regorgsociales;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Field;
import com.dogma.vo.IProperty;

public class InitFrmTrabajo extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {

		Entity currEnt = this.getCurrentEntity();
		String tipoOrg = currEnt.getAttribute("INDDHH_ROS_TIPO_ORGANIZACION_STR").getValueAsString();

		if (tipoOrg.compareTo("1") == 0) {
			// Gubernamental
			this.getCurrentForm().getField("tblActividad").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			this.getCurrentForm().getField("tblRedes").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
		} else if (tipoOrg.compareTo("2") == 0) {
			// Social
			this.getCurrentForm().getField("tblActividad").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
			this.getCurrentForm().getField("tblRedes").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
		}

	}

}
