package regorgsociales;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.def.EntityDef;
import com.dogma.busClass.object.Attribute;
import java.util.*;

public class CargarActividades extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		if (!this.isFromMonitor()) {
			Entity currEnt = this.getCurrentEntity();
			List<String> actividades = new ArrayList<>();
			List<Object> actividadesObj = new ArrayList<>();

			Attribute actividadesTabla = currEnt.getAttribute("INDDHH_ROS_ACTIVIDAD_STR");
			String otra = null;

			for (int i = 1; i <= 15; i++) { // 15 temáticas de trabajo
				Entity ent = this.getEntity("COD_INDDHH_ROS_ACTIVIDAD", null, i, null);
				String actividadStr = ent.getAttribute("A_CODIGUERA_VALUE").getValueAsString();
				if (actividadStr.compareToIgnoreCase("Otra") == 0) {
					otra = actividadStr;
				} else {
					actividades.add(actividadStr);
				}
			}

			Collections.sort(actividades); // Ordeno la lista de derechos
			actividadesObj.addAll(actividades); // Agrego a la lista de objects para usar el metodo de Apia
			actividadesObj.add(otra); // Agrego valor "Otra" a lo último de la la lista

			actividadesTabla.setValues(actividadesObj); // set values
		}
	}
}
