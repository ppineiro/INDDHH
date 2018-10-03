package regorgsociales;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;

public class EnviarAprobadoFaltaFirma extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();
		int nroSolicitud = ((Double) currEnt.getAttribute("INDDHH_ROS_NRO_SOLICITUD_NUM").getValue()).intValue();

		String tieneFirmaElectronica = currEnt.getAttribute("TRM_TIENE_FIRMA_ELECTRONICA_STR").getValueAsString(); // NO("1")-SI("2")
		String chkFirmaPendiente = currEnt.getAttribute("INDDHH_ROS_HA_FIRMADO_STR").getValueAsString(); // "true"-"false"
		String aprobacion = currEnt.getAttribute("INDDHH_ROS_APROBACION_STR").getValueAsString(); // Aprobado("1")-Rechazado("2")

		String organizacion = currEnt.getAttribute("INDDHH_ROS_NOMBRE_ORGANIZACION_STR").getValueAsString();
		String correo = currEnt.getAttribute("INDDHH_CORREO_CONTACTO_STR").getValueAsString();

		if (aprobacion.compareTo("1") == 0) { // Aprobado
			if (tieneFirmaElectronica.compareTo("1") == 0 && chkFirmaPendiente.compareTo("true") != 0) {
				// No firmó digitalmente y no pasó a firmar por la oficina
				envioAprobadoNoFirmo(this, correo, nroSolicitud, organizacion);
			}
		}
	}

	private static void envioAprobadoNoFirmo(ApiaAbstractClass apia, String correo, int nroSolicitud,
			String organizacion) throws BusClassException {

		String[] destinos = { correo };

		String asunto = "INDDHH - Registro con Nº de solucitud " + nroSolicitud + " aprobado";

		String texto = "Estimados,<br><br>La solicitud de registro de " + organizacion
				+ " ante la Institución fue APROBADA.<br>"
				+ "Debe pasar por nuestras oficinas en Bvar. Gral. Artigas 1532 a firmar.<br>"
				+ "Una vez lo haga le será dado su número de registro.<br><br>" + "Saludamos atentamente.<br>"
				+ "Institución Nacional de Derechos Humanos y Defensoría del Pueblo.";

		apia.sendMail(destinos, asunto, texto);
	}

}
