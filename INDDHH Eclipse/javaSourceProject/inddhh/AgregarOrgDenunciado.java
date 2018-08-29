package inddhh;

import java.util.Collection;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Attribute;
import com.dogma.busClass.object.Entity;
import com.dogma.vo.custom.CmbDataVo;

public class AgregarOrgDenunciado extends ApiaAbstractClass{

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();
		
		Attribute attOrg = currEnt.getAttribute("INDDHH_ORG_INCISO_DENUNCIADO_STR");
		Attribute attOrgAux = currEnt.getAttribute("INDDHH_ORG_INCISO_DENUNCIADO_AUX_STR");
		
		String orgCod = attOrg.getValueAsString();
		String org = ""; // Organismo
		
		Collection<CmbDataVo> colOrg = attOrgAux.getPossibleValues();
		for (CmbDataVo o : colOrg) {
			if (o.getValue().compareTo(orgCod) == 0) {
				org = o.getText();
				break;
			}	
		}
		
		Attribute attUnEjec = currEnt.getAttribute("INDDHH_ORG_UNIDAD_EJECUTORA_DENUNCIADO_STR");
		Attribute attUnEjecAux = currEnt.getAttribute("INDDHH_ORG_UNIDAD_EJECUTORA_DENUNCIADO_AUX_STR");
		
		String unEjecCod = attUnEjec.getValueAsString();
		String unEjec = ""; // Organismo
		
		Collection<CmbDataVo> colUnEjec = attUnEjecAux.getPossibleValues();
		for (CmbDataVo u : colUnEjec) {
			if (u.getValue().compareTo(unEjecCod) == 0) {
				unEjec = u.getText();
				break;
			}
		}
		
		int ctdOrgs = currEnt.getAttribute("INDDHH_ORG_INCISO_TABLA_STR").getValues().size();
		
		if(ctdOrgs == 0) {
			currEnt.getAttribute("INDDHH_ORG_INCISO_TABLA_STR").setValue(org);
			currEnt.getAttribute("INDDHH_ORG_UNIDAD_EJECUTORA_TABLA_STR").setValue(unEjec);
		} else {
			currEnt.getAttribute("INDDHH_ORG_INCISO_TABLA_STR").setValue(org, ctdOrgs);
			currEnt.getAttribute("INDDHH_ORG_UNIDAD_EJECUTORA_TABLA_STR").setValue(unEjec, ctdOrgs);
		}		
	}

}
