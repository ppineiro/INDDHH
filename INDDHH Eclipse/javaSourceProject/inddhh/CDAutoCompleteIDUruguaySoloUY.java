package inddhh;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Form;
import com.dogma.controller.ThreadData;
import com.dogma.vo.IProperty;
import com.gxc.saml.SAMLAssertion;

public class CDAutoCompleteIDUruguaySoloUY extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {

		Entity currEnt = this.getCurrentEntity();
		Form currForm = this.getCurrentForm();

		SAMLAssertion samlAssertion = new SAMLAssertion();

		if (!this.isFromMonitor() && this.getCurrentTask() != null) {

			if (this.getCurrentTask().getTaskName().compareTo("CARGA_DATOS_TRAMITE") == 0) {

				if (ThreadData.getUserData().getUserAttributes() != null) {

					if (ThreadData.getUserData().getUserAttributes().get("samlAssertion") != null) {
						// Inició con ID Uruguay: Inicio ciudadano online
						currEnt.getAttribute("INDDHH_CD_VERIFICACION_VIA_INGRESO_STR").setValue("Online"); 

						samlAssertion = (SAMLAssertion) ThreadData.getUserData().getUserAttributes()
								.get("samlAssertion");

						String attDocNum = this.getParameter("docNum").getValueAsString();
						String attNombre = this.getParameter("nombre").getValueAsString();
						String attApellido = this.getParameter("apellido").getValueAsString();
						String attEmail = this.getParameter("email").getValueAsString();
						String attTipoDoc = this.getParameter("tipoDoc").getValueAsString();
						String attPaisEmisor = this.getParameter("pais").getValueAsString();

						String paisDoc = samlAssertion.getPaisDocumento();
						String numDoc = samlAssertion.getDocumento();
						String nombreCompleto = samlAssertion.getNombreCompleto();
						String email = samlAssertion.getEmail();

						if (paisDoc.compareTo("uy") == 0) {
							currForm.getFieldByAttributeName(attTipoDoc).setProperty(IProperty.PROPERTY_READONLY, true);
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
					} else {
						// No inició con ID Uruguay: Inicio funcionario
						currEnt.getAttribute("INDDHH_CD_VERIFICACION_VIA_INGRESO_STR").setValue("Presencial");
					}

				} else {
					// No inició con ID Uruguay: Inicio funcionario
					currEnt.getAttribute("INDDHH_CD_VERIFICACION_VIA_INGRESO_STR").setValue("Presencial");
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
