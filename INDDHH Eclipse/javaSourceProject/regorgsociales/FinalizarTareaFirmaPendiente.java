package regorgsociales;

import java.util.Collection;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Process;
import com.dogma.busClass.object.Task;

public class FinalizarTareaFirmaPendiente extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();
		String aprobacion = currEnt.getAttribute("INDDHH_ROS_APROBACION_STR").getValueAsString();

		if (aprobacion.compareTo("2") == 0) { //Rechazado
			Process proceso = this.getCurrentProcess();

			Collection<Task> colTareas = proceso.getAvailableTasks();

			for (Task t : colTareas) {
				if (t.getTaskName().compareTo("INDDHH_ROS_FIRMA_PENDIENTE") == 0) {
					t.complete();
					break;
				}
			}
		}
	}

}
