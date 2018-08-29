package inddhh;

import java.util.ArrayList;
import java.util.Collection;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Field;

public class EliminarOrgDenunciado extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();

		Collection ids = currEnt.getAttribute("INDDHH_ORG_INCISO_TABLA_STR").getValues();
		ArrayList arrIdOrgs = new ArrayList();
		arrIdOrgs.addAll(ids);

		Collection unEjs = currEnt.getAttribute("INDDHH_ORG_UNIDAD_EJECUTORA_TABLA_STR").getValues();
		ArrayList arrUnEj = new ArrayList();
		arrUnEj.addAll(unEjs);
	
		Field currBtn = (Field) this.getEvtSource();
		int index = currBtn.getFireIndex();

		arrIdOrgs.remove(index);
		arrUnEj.remove(index);

		currEnt.getAttribute("INDDHH_ORG_INCISO_TABLA_STR").setValues(arrIdOrgs);
		currEnt.getAttribute("INDDHH_ORG_UNIDAD_EJECUTORA_TABLA_STR").setValues(arrUnEj);
	}
}
