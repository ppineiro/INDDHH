package inddhh;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Form;
import com.dogma.controller.ThreadData;
import com.dogma.vo.IProperty;
import com.gxc.saml.SAMLAssertion;

public class AutoCompleteIDUruguaySoloUY extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		if (!this.isFromMonitor()) {

			SAMLAssertion samlAssertion = new SAMLAssertion();

			if (ThreadData.getUserData().getUserAttributes() != null) {
				if (ThreadData.getUserData().getUserAttributes().get("samlAssertion") != null) {
					samlAssertion = (SAMLAssertion) ThreadData.getUserData().getUserAttributes().get("samlAssertion");

					Form currForm = this.getCurrentForm();

					String attDocNum = this.getParameter("docNum").getValueAsString();
					String attNombre = this.getParameter("nombre").getValueAsString();
					String attApellido = this.getParameter("apellido").getValueAsString();
					String attEmail = this.getParameter("email").getValueAsString();
					String attTipoDoc= this.getParameter("tipoDoc").getValueAsString();
					String attPaisEmisor = this.getParameter("pais").getValueAsString();

					String paisDoc = samlAssertion.getPaisDocumento();
					String numDoc = samlAssertion.getDocumento();
					String nombreCompleto = samlAssertion.getNombreCompleto();
					String email = samlAssertion.getEmail();

					Entity currEnt = this.getCurrentEntity();

					if (paisDoc.compareTo("uy") == 0) {
						currForm.getFieldByAttributeName(attTipoDoc).setProperty(IProperty.PROPERTY_READONLY,
								true);
						currForm.getFieldByAttributeName(attPaisEmisor).setProperty(IProperty.PROPERTY_READONLY,
								true);
						
						if (!attDocNum.isEmpty() && attDocNum != null) {
							if (!numDoc.isEmpty() && numDoc != null) {
								currEnt.getAttribute(attDocNum).setValue(numDoc);
								currForm.getFieldByAttributeName(attDocNum).setProperty(IProperty.PROPERTY_READONLY,
										true);
							}
						}
						if (!attNombre.isEmpty() && attNombre != null) {
							if (!nombreCompleto.isEmpty() && nombreCompleto != null) {
								currEnt.getAttribute(attNombre).setValue(getNombres(nombreCompleto));
							}
						}
						if (!attApellido.isEmpty() && attApellido != null) {
							if (!nombreCompleto.isEmpty() && nombreCompleto != null) {
								currEnt.getAttribute(attApellido).setValue(getApellidos(nombreCompleto));
							}
						}
						if (!attEmail.isEmpty() && attEmail != null) {
							if (!email.isEmpty() && email != null) {
								currEnt.getAttribute(attEmail).setValue(email);
								
							}
						}
					}
				}
			}
		}
	}

	private String getNombres(String nombreCompleto) {
		String nombres = "";

		String[] partesNombre = nombreCompleto.split(" ");
		int largo = partesNombre.length;

		if (largo == 4) {
			nombres = partesNombre[0] + " " + partesNombre[1];
		} else if (largo == 2 || largo == 3) {
			nombres = partesNombre[0];
		}

		// addMessage("Nombres: "+nombres);

		return nombres;
	}

	private String getApellidos(String nombreCompleto) {
		String apellidos = "";

		String[] partesNombre = nombreCompleto.split(" ");
		int largo = partesNombre.length;

		if (largo == 4 || largo == 3) {
			apellidos = partesNombre[2] + " " + partesNombre[3];
		} else if (largo == 2) {
			apellidos = partesNombre[1];
		}

		// addMessage("Apellidos: "+apellidos);

		return apellidos;
	}

}
