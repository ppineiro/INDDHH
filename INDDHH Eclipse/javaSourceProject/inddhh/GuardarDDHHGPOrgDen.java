package inddhh;

import java.util.ArrayList;
import java.util.Collection;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.PossibleValue;

public class GuardarDDHHGPOrgDen extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();

		guardarDerechosVulnerados(currEnt, "INDDHH_SELECCIONAR_DERECHO_STR", "INDDHH_DERECHO_STR",
				"INDDHH_DERECHOS_SELECCIONADOS_STR");

		guardarGruposPoblacionales(currEnt, "INDDHH_SELECCIONAR_GRUPO_POBLACIONAL_STR", "INDDHH_GRUPO_POBLACIONAL_STR",
				"INDDHH_GRUPOS_POBLACIONALES_SELECCIONADOS_STR");

		guardarOrgDenunciados(currEnt, "INDDHH_ORG_INCISO_TABLA_STR", "INDDHH_ORGANISMOS_DENUNCIADOS_AGREGADOS_STR");

		guardarUnEjDenunciadas(currEnt, "INDDHH_ORG_UNIDAD_EJECUTORA_TABLA_STR",
				"INDDHH_UNIDEJ_DENUNCIADAS_AGREGADOS_STR");
	}

	private void guardarDerechosVulnerados(Entity ent, String nomAttSeleccionar, String nomAttValores,
			String nomAttGuardar) throws BusClassException {

		ArrayList derechosVuln = new ArrayList();

		Object[] valsSeleccionar = ent.getAttribute(nomAttSeleccionar).getValues().toArray();
		Object[] valsDerechosVuln = ent.getAttribute(nomAttValores).getValues().toArray();

		int ctd = valsDerechosVuln.length;

		for (int i = 0; i < ctd; i++) {

			String seleccion = valsSeleccionar[i].toString();
			String valorDerecho = valsDerechosVuln[i].toString();
			// this.addMessage("Seleccion 1: "+seleccion+"<br>");
			// this.addMessage("Valor derecho: "+valorDerecho + "<br>");

			if (seleccion.compareTo("true") == 0) {
				derechosVuln.add(valorDerecho + "; ");
				ent.getAttribute(nomAttGuardar).setValues(derechosVuln);
			}
		}
	}

	private void guardarGruposPoblacionales(Entity ent, String nomAttSeleccionar, String nomAttValores,
			String nomAttGuardar) throws BusClassException {

		ArrayList gruposPobl = new ArrayList();

		Object[] valsSeleccionar = ent.getAttribute(nomAttSeleccionar).getValues().toArray();
		Object[] valsGruposPoblacionales = ent.getAttribute(nomAttValores).getValues().toArray();

		int ctd = valsGruposPoblacionales.length;

		for (int i = 0; i < ctd; i++) {
			String seleccion = valsSeleccionar[i].toString();
			String valorGrupoPobl = valsGruposPoblacionales[i].toString();
			// this.addMessage("Seleccion 2: "+seleccion+"<br>");
			// this.addMessage("Valor gp: "+valorGrupoPobl + "<br>");

			if (seleccion.compareTo("true") == 0) {
				gruposPobl.add(valorGrupoPobl + "; ");
				ent.getAttribute(nomAttGuardar).setValues(gruposPobl);
			}
		}
	}

	private void guardarOrgDenunciados(Entity ent, String nomAttValores, String nomAttGuardar)
			throws BusClassException {

		ArrayList orgsDen = new ArrayList();

		Object[] valsOrganismos = ent.getAttribute(nomAttValores).getValues().toArray();

		int ctd = valsOrganismos.length;

		for (int i = 0; i < ctd; i++) {
			if (valsOrganismos[i] != null) {
				String valorOrg = valsOrganismos[i].toString();
				// this.addMessage("Valor org: "+valorOrg + "<br>");

				orgsDen.add(valorOrg + "; ");
				ent.getAttribute(nomAttGuardar).setValues(orgsDen);
			}
		}
	}

	private void guardarUnEjDenunciadas(Entity ent, String nomAttValores, String nomAttGuardar)
			throws BusClassException {

		ArrayList unEjsDen = new ArrayList();

		Object[] valsUnEjs = ent.getAttribute(nomAttValores).getValues().toArray();

		int ctd = valsUnEjs.length;

		for (int i = 0; i < ctd; i++) {
			if (valsUnEjs[i] != null) {
				String valorUnEj = valsUnEjs[i].toString();
				// this.addMessage("Valor UE: "+valorUnEj + "<br>");

				unEjsDen.add(valorUnEj + "; ");
				ent.getAttribute(nomAttGuardar).setValues(unEjsDen);
			}
		}
	}

}
