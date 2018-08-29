package inddhh;

import java.time.Period;
import java.util.Calendar;
import java.util.Date;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Attribute;
import com.dogma.busClass.object.Entity;

public class CalculoEdad extends ApiaAbstractClass{

	@Override
	protected void executeClass() throws BusClassException {
		// TODO Auto-generated method stub
		Entity currEnt = this.getCurrentEntity();
		String nombreAttEdad = this.getParameter("edad").getValueAsString();
		//addMessage(this.getParameter("edad").getValueAsString()); 
		Attribute attEdad = currEnt.getAttribute(nombreAttEdad);
		
		//Date fechaNac = (Date) currEnt.getAttribute("INDDHH_PERSONA_FISICA_FECHA_NACIMIENTO_DTE").getValue();
		Date fechaNac = (Date) this.getParameter("fechaNacimiento").getAttribute().getValue();
		Calendar calNac = Calendar.getInstance();
		calNac.setTime(fechaNac);
		
		Double edad = new Double(calcularEdad(calNac));
		
		attEdad.setValue(edad);	
	}
	
	private static int calcularEdad(Calendar fechaNac) {
	    Calendar today = Calendar.getInstance();
	    int diffYear = today.get(Calendar.YEAR) - fechaNac.get(Calendar.YEAR);
	    int diffMonth = today.get(Calendar.MONTH) - fechaNac.get(Calendar.MONTH);
	    int diffDay = today.get(Calendar.DAY_OF_MONTH) - fechaNac.get(Calendar.DAY_OF_MONTH);
	    // Si está en ese año pero todavía no los ha cumplido
	    if (diffMonth < 0 || (diffMonth == 0 && diffDay < 0)) {
	        diffYear = diffYear - 1;
	    }
	    
	    return diffYear;
	}

}
