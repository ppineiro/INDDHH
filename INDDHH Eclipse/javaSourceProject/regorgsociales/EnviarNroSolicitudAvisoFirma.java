package regorgsociales;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;

public class EnviarNroSolicitudAvisoFirma extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();

		String nroSolicitud = currEnt.getAttribute("INDDHH_ROS_NRO_SOLICITUD_STR").getValueAsString();

		String tieneFirmaElectronica = currEnt.getAttribute("TRM_TIENE_FIRMA_ELECTRONICA_STR").getValueAsString(); // NO-SI

		String organizacion = currEnt.getAttribute("INDDHH_ROS_NOMBRE_ORGANIZACION_STR").getValueAsString();
		String tipoOrg = currEnt.getAttribute("INDDHH_ROS_TIPO_ORGANIZACION_STR").getValueAsString();
		String correo = currEnt.getAttribute("INDDHH_CORREO_CONTACTO_STR").getValueAsString();

		if (tieneFirmaElectronica.compareTo("1") == 0 && tipoOrg.compareTo("2") == 0) { // No
			envioNoTieneFirmaElectronica(this, correo, nroSolicitud, organizacion);
		} else if (tieneFirmaElectronica.compareTo("1") == 0 && tipoOrg.compareTo("2") != 0) { // No
			envioNoTieneFirmaElectronicaGubInt(this, correo, nroSolicitud, organizacion);
		} else if (tieneFirmaElectronica.compareTo("2") == 0) { // S�
			envioTieneFirmaElectronica(this, correo, nroSolicitud, organizacion);
		}

	}

	private static void envioTieneFirmaElectronica(ApiaAbstractClass apia, String correo, String nroSolicitud,
			String organizacion) throws BusClassException {

		String[] destinos = { correo };

		String asunto = "INDDHH - Registro ingresado correctamente con Nº de solicitud " + nroSolicitud;

		String texto = "Estimados,<br><br>La solicitud de registro de <b>" + organizacion
				+ "</b> ante la Institución fue ingresada correctamente.<br>" + "Su número de solicitud es: <b>"
				+ nroSolicitud + "</b><br>" + "En los próximos días será evaluada y comunicada oportunamente.<br><br>"
				+ "Saludos cordiales,<br>" + "Secretaría General.<br>"
				+ "Institución Nacional de Derechos Humanos y Defensoría del Pueblo.";

		apia.sendMail(destinos, asunto, texto);
	}

	private static void envioNoTieneFirmaElectronica(ApiaAbstractClass apia, String correo, String nroSolicitud,
			String organizacion) throws BusClassException {

		String[] destinos = { correo };

		String asunto = "INDDHH - Registro ingresado correctamente con Nº de solicitud " + nroSolicitud;

		String texto = "Estimados,<br><br>La solicitud de registro de <b>" + organizacion
				+ "</b> ante la Institución fue ingresada correctamente.<br>" + "Su número de solicitud es: <b>"
				+ nroSolicitud + "</b><br>" + "En los próximos días será evaluada y comunicada oportunamente.<br>"
				+ "<b>Recuerde que debe pasar por nuestras oficinas en Bvar. Gral. Artigas 1532 a firmar.</b><br><br>"
				+ "Saludos cordiales,<br>" + "Secretaría General.<br>"
				+ "Institución Nacional de Derechos Humanos y Defensoría del Pueblo.";

		apia.sendMail(destinos, asunto, texto);
	}

	private static void envioNoTieneFirmaElectronicaGubInt(ApiaAbstractClass apia, String correo, String nroSolicitud,
			String organizacion) throws BusClassException {

		String[] destinos = { correo };

		String asunto = "INDDHH - Registro ingresado correctamente con Nº de solicitud " + nroSolicitud;

		String texto = "Estimados,<br><br>La solicitud de registro de <b>" + organizacion
				+ "</b> ante la Institución fue ingresada correctamente.<br>" + "Su número de solicitud es: <b>"
				+ nroSolicitud + "</b><br>" + "En los próximos días será evaluada y comunicada oportunamente.<br>"
				+ "Saludos cordiales,<br>" + "Secretaría General.<br>"
				+ "Institución Nacional de Derechos Humanos y Defensoría del Pueblo.";

		apia.sendMail(destinos, asunto, texto);
	}

}
