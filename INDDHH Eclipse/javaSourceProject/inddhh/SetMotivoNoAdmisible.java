package inddhh;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Attribute;
import com.dogma.busClass.object.Entity;

public class SetMotivoNoAdmisible extends ApiaAbstractClass{

	@Override
	protected void executeClass() throws BusClassException {
		
		Entity currEnt = this.getCurrentEntity();
		
		String motivoSel = currEnt.getAttribute("INDDHH_MOTIVO_NO_ADMISIBLE_STR").getValueAsString();
		Attribute motivoValor = currEnt.getAttribute("INDDHH_MOTIVO_NO_ADMISIBLE_VALOR_STR");
		
		if(motivoSel.compareTo("1") == 0) {
			motivoValor.setValue("Fuera de plazo");
		}
		else if(motivoSel.compareTo("2") == 0) {
			motivoValor.setValue("Incompetencia");
		}
		else if(motivoSel.compareTo("3") == 0) {
			motivoValor.setValue("Inadmisibilidad manifiesta");
		}
		else if(motivoSel.compareTo("4") == 0) {
			motivoValor.setValue("Falta de fundamentos");
		}
		else if(motivoSel.compareTo("5") == 0) {
			motivoValor.setValue("Evidente mala fe");
		}
	}

}
