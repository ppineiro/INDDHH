package regorgsociales;

import java.util.ArrayList;
import java.util.Collection;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.EntityFilter;
import com.dogma.busClass.object.Identifier;

public class GenerarNroSolicitud extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {

		if (!this.isFromMonitor()) {
			if (this.getCurrentTask() != null) {
				if (this.getCurrentTask().getTaskName().compareTo("CARGA_DATOS_TRAMITE") == 0) {
					Entity currEnt = this.getCurrentEntity();

					Collection<EntityFilter> colFilters = new ArrayList<EntityFilter>();

					// Busca entidades de solicitudes
					Collection<Identifier> solicitudes = this.findEntities("INDDHH_REGISTRO_ORG", colFilters);
					int nroSolicitudes = solicitudes.size();

					int nroAsignarSolActual = nroSolicitudes + 1;

					currEnt.getAttribute("INDDHH_ROS_NRO_SOLICITUD_STR").setValue(String.valueOf(nroAsignarSolActual));
				}
			}
		}
	}

}
