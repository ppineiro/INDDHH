package inddhh;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Attribute;
import com.dogma.busClass.object.Entity;

public class CargarDatosPersonalesPresencial extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {

		Entity currEnt = this.getCurrentEntity();

		// Datos personales que se rellena en Inicio de Tmt Presencial
		String tipoDoc = currEnt.getAttribute("TRM_PRS_PERSONA_FISICA_DOC_TIPO_STR").getValueAsString();
		String numDoc = currEnt.getAttribute("TRM_PRS_PERSONA_FISICA_DOC_TIPO_STR").getValueAsString();
		Object fecNac = currEnt.getAttribute("TRM_PRS_PERSONA_FISICA_FECHA_NACIMIENTO_DTE").getValue();
		String primerAp = currEnt.getAttribute("TRM_PRS_PERSONA_FISICA_APELLIDO_PRIMER_STR").getValueAsString();
		String segAp = currEnt.getAttribute("TRM_PRS_PERSONA_FISICA_APELLIDO_SEGUNDO_STR").getValueAsString();
		String primerNom = currEnt.getAttribute("TRM_PRS_PERSONA_FISICA_NOMBRE_PRIMER_STR").getValueAsString();
		String segNom = currEnt.getAttribute("TRM_PRS_PERSONA_FISICA_NOMBRE_SEGUNDO_STR").getValueAsString();

		// Datos de contacto que se rellena en Inicio de Tmt Presencial
		String tel = currEnt.getAttribute("TRM_DATOS_CONTACTO_TELEFONO_STR").getValueAsString();
		String otroTel = currEnt.getAttribute("TRM_DATOS_CONTACTO_OTRO_TELEFONO_STR").getValueAsString();
		String correo = currEnt.getAttribute("TRM_EMAIL_USUARIO_STR").getValueAsString();

		// Completo datos que ya se rellenaron
		if (!tipoDoc.isEmpty()) {
			String apellidos = primerAp + " " + segAp;
			String nombres = primerNom + " " + segNom;

			currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_DOC_TIPO_STR").setValue(tipoDoc);
			currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_DOC_NUM_STR").setValue(numDoc);
			currEnt.getAttribute("INDDHH_PERSONA_FISICA_FECHA_NACIMIENTO_DTE").setValue(fecNac);
			currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_APELLIDOS_STR").setValue(apellidos);
			currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_NOMBRES_STR").setValue(nombres);

			currEnt.getAttribute("INDDHH_TELEFONO_CONTACTO_STR").setValue(tel);
			currEnt.getAttribute("INDDHH_OTRO_TEL_CONTACTO_STR").setValue(otroTel);
			currEnt.getAttribute("INDDHH_CORREO_CONTACTO_STR").setValue(correo);
		}

	}

}
