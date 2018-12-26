package regorgsociales;

import java.util.ArrayList;
import java.util.Collection;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.EntityFilter;
import com.dogma.busClass.object.Identifier;

public class GenerarNroRegistro extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		// TODO Auto-generated method stub
		Entity currEnt = this.getCurrentEntity();

		Collection<EntityFilter> colFilters = new ArrayList<EntityFilter>();

		EntityFilter resolucion = new EntityFilter("1", 8, EntityFilter.COLUMN_FILTER_EQUAL); // 1 = Aprobado

		colFilters.add(resolucion);

		// Busca entidades de solicitudes que han finalizado y fueron aprobadas
		Collection<Identifier> solicitudesFinalizadasAprobadas = this.findEntities("INDDHH_REGISTRO_ORG", colFilters);
		int nroSolicitudesFinalizadasAprobadas = solicitudesFinalizadasAprobadas.size();
		
		int nroArrancarNroRegistro = Double.valueOf(this.getParameter("nroArrancar").getValueAsString()).intValue();

		int nroAsignarSolActual = nroSolicitudesFinalizadasAprobadas + nroArrancarNroRegistro + 1;

		currEnt.getAttribute("INDDHH_ROS_NRO_REGISTRO_STR").setValue(String.valueOf(nroAsignarSolActual));
	}

}
