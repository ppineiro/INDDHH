package regorgsociales;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;

public class GenerarNroSolicitud extends ApiaAbstractClass{

	@Override
	protected void executeClass() throws BusClassException {
		// TODO Auto-generated method stub
		Entity currEnt = this.getCurrentEntity();
		int nroEnt = currEnt.getIdentifierObject().getNumber();
		
		currEnt.getAttribute("INDDHH_ROS_NRO_SOLICITUD_STR").setValue(String.valueOf(nroEnt));
		
	}

}
