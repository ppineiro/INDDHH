package solicitudsalonactos;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;

public class CargarReglamentoDoc extends ApiaAbstractClass{

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();
		currEnt.getAttribute("INDDHH_SA_REGLAMENTO_DOC_STR").addDocument("C:\\Users\\INDDHH\\Documents\\Reglamento.txt", 
				"Reglamento", "Reglamento Salón de actos", false);
	}

}
