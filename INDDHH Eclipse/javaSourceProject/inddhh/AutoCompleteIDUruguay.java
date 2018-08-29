package inddhh;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.controller.ThreadData;

import com.gxc.saml.SAMLAssertion;

public class AutoCompleteIDUruguay extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		SAMLAssertion samlAssertion = new SAMLAssertion();

		if (ThreadData.getUserData().getUserAttributes() != null) {
			if (ThreadData.getUserData().getUserAttributes().get("samlAssertion") != null) {
				samlAssertion = (SAMLAssertion) ThreadData.getUserData().getUserAttributes().get("samlAssertion");
			}
		}

		String tipoDoc = samlAssertion.getTipoDocumento();
		String ci = samlAssertion.getDocumento();
		String nombreCompleto = samlAssertion.getNombreCompleto();
		String email = samlAssertion.getEmail();
		
		//String datos = "Tipo Doc: "+tipoDoc+" CI: "+ci+" Nombre: "+nombreCompleto+" email: "+email;
		//addMessage(datos);
		
		Entity currEnt = this.getCurrentEntity();
		currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_DOC_NUM_STR").setValue(ci);
		currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_NOMBRES_STR").setValue(getNombres(nombreCompleto));
		currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_APELLIDOS_STR").setValue(getApellidos(nombreCompleto));
		currEnt.getAttribute("INDDHH_CORREO_CONTACTO_STR").setValue(email);
	}
	
	private String getNombres(String nombreCompleto) {
		String nombres = "";
		
		String[] partesNombre = nombreCompleto.split(" ");
		int largo = partesNombre.length;
		
		if(largo == 4) {
			nombres = partesNombre[0]+" "+partesNombre[1];
		} else if (largo == 2 || largo == 3) {
			nombres = partesNombre[0];
		}
		
		//addMessage("Nombres: "+nombres);
		
		return nombres;
	}
	
	private String getApellidos(String nombreCompleto) {
		String apellidos = "";
		
		String[] partesNombre = nombreCompleto.split(" ");
		int largo = partesNombre.length;
		
		if(largo == 4 || largo == 3) {
			apellidos = partesNombre[2]+" "+partesNombre[3];
		} else if (largo == 2) {
			apellidos = partesNombre[1];
		}
		
		//addMessage("Apellidos: "+apellidos);
		
		return apellidos;
	}
	


}
