package inddhh;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;

public class SetFechaStr extends ApiaAbstractClass{

	@Override
	protected void executeClass() throws BusClassException {
		String attFechaDate = this.getParameter("fechaDate").getValueAsString(); 
		String attFechaStr = this.getParameter("fechaStr").getValueAsString(); 
		
		Entity currEnt = this.getCurrentEntity();
		
		Date fecha = (Date) currEnt.getAttribute(attFechaDate).getValue();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		String fechaStr = sdf.format(fecha);
		
		currEnt.getAttribute(attFechaStr).setValue(fechaStr);
	}

}
