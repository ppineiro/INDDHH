package inddhh;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.def.EntityDef;
import com.dogma.busClass.object.Attribute;
import java.util.*;

public class CargarDerechos extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();
		List<String> derechos = new ArrayList<>();
		List<Object> derechosObj = new ArrayList<>();

		Attribute attDerechoTabla = currEnt.getAttribute("INDDHH_DERECHO_STR");

		for (int i = 1; i <= 33; i++) { // 33 derechos
			Entity ent = this.getEntity("COD_DERECHO", null, i, null);
			String derechoStr = ent.getAttribute("A_CODIGUERA_VALUE").getValueAsString();
			derechos.add(derechoStr);
		}
		
		Collections.sort(derechos); //Ordeno la lista de derechos
		derechosObj.addAll(derechos); //Agrego a la lista de objects para usar el metodo de Apia
		
		attDerechoTabla.setValues(derechosObj); //set values
	}

}
