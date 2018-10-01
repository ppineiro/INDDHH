package solicitudsalonactos;

import java.util.Calendar;
import java.util.Date;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;

public class SetFechaHoy extends ApiaAbstractClass{

	@Override
	protected void executeClass() throws BusClassException {
		Date date = new Date();
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		Date dateTmt1 = cal.getTime();
		
		if (!this.isFromMonitor()) {
			this.getCurrentEntity().getAttribute("INDDHH_SA_FECHA_SOLICITUD_FEC").setValue(dateTmt1);
		}
	}

}
