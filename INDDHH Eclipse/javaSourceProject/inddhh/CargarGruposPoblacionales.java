package inddhh;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Attribute;
import com.dogma.busClass.object.Entity;

public class CargarGruposPoblacionales extends ApiaAbstractClass{

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();
		List<String> gruposPobl = new ArrayList<>();
		List<Object> gruposObj = new ArrayList<>();

		Attribute attGrupoPoblacionalTabla = currEnt.getAttribute("INDDHH_GRUPO_POBLACIONAL_STR");

		for (int i = 1; i <= 9; i++) { //9 grupos poblacionales
			Entity ent = this.getEntity("COD_GRUPOS_POBLACIONALES", null, i, null);
			String grupoStr = ent.getAttribute("A_CODIGUERA_VALUE").getValueAsString();
			gruposPobl.add(grupoStr);
		}
		
		Collections.sort(gruposPobl); //Ordeno la lista de derechos
		gruposObj.addAll(gruposPobl); //Agrego a la lista de objects para usar el metodo de Apia
		
		attGrupoPoblacionalTabla.setValues(gruposObj); //set values
	}

}
