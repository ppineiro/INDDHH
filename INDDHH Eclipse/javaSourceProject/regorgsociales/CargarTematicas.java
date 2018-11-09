package regorgsociales;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.def.EntityDef;
import com.dogma.busClass.object.Attribute;
import java.util.*;

public class CargarTematicas extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		if (!this.isFromMonitor()) {
			Entity currEnt = this.getCurrentEntity();
			List<String> tematicas = new ArrayList<>();
			List<Object> tematicasObj = new ArrayList<>();

			Attribute tematicaTabla = currEnt.getAttribute("INDDHH_ROS_TEMATICA_TRABAJO_STR");
			String otra = null;

			for (int i = 1; i <= 15; i++) { // 15 temáticas de trabajo
				Entity ent = this.getEntity("COD_INDDHH_ROS_AREA_TEMATICA", null, i, null);
				String tematicaStr = ent.getAttribute("A_CODIGUERA_VALUE").getValueAsString();
				if (tematicaStr.compareToIgnoreCase("Otra") == 0) {
					otra = tematicaStr;
				} else {
					tematicas.add(tematicaStr);
				}
			}

			Collections.sort(tematicas); // Ordeno la lista de derechos
			tematicasObj.addAll(tematicas); // Agrego a la lista de objects para usar el metodo de Apia
			tematicasObj.add(otra); // Agrego valor "Otra" a lo último de la la lista

			tematicaTabla.setValues(tematicasObj); // set values
		}
	}
}
