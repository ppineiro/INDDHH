package inddhh;

import java.util.Collection;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.PossibleValue;

public class GuardarDDHHGPOrgDen extends ApiaAbstractClass{

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();
		
		
	}
	
	private void guardarGruposPoblacionales(Entity ent, String nomAttSeleccionar,String nomAttValores,String nomAttGuardar) throws BusClassException {
		
		Object[] valsSeleccionar = ent.getAttribute(nomAttSeleccionar).getValues().toArray();
		Object[] valsGruposPoblacionales = ent.getAttribute(nomAttValores).getValues().toArray();
		
		int ctd = valsGruposPoblacionales.length;
		
		for (int i = 0; i < ctd; i++) {
			String seleccion = valsSeleccionar[i].toString();
			String valorGrupoPobl = valsGruposPoblacionales[i].toString();
			
			if(seleccion.compareTo("true") == 0) {
				PossibleValue posVal = new PossibleValue(valorGrupoPobl, valorGrupoPobl);
				ent.getAttribute(nomAttGuardar).addPossibleValues(posVal);
			}
		}
	}

}
