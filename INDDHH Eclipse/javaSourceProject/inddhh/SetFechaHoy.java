package inddhh;

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
		
		String parNombreAtt = getParameter("nombreAtt").getValuesAsString();
		
		if (!this.isFromMonitor()) {
			this.getCurrentEntity().getAttribute(parNombreAtt).setValue(dateTmt1);
		}
	}

}
