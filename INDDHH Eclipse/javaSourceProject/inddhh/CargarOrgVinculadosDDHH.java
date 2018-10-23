package inddhh;

import java.util.ArrayList;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Attribute;
import com.dogma.busClass.object.Entity;

public class CargarOrgVinculadosDDHH extends ApiaAbstractClass {
	
	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();
		ArrayList<Object> orgVinculados = new ArrayList<>();
		
		Attribute attOrgVincTabla = currEnt.getAttribute("INDDHH_OTRO_ORGANISMO_TABLA_STR");
		
		for(int i = 1; i<=4; i++) { //5 Organismos (incluido "Otro")
			Entity ent = this.getEntity("COD_ORGANISMO_VINCULADOS_DDHH", null, i, null);
			String orgVinculado = ent.getAttribute("A_CODIGUERA_VALUE").getValueAsString();
			orgVinculados.add(orgVinculado);
		}
		
		attOrgVincTabla.setValues(orgVinculados);
	}

}
