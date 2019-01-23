package solicitudsalonactos;

import java.text.SimpleDateFormat;
import java.util.Date;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.MessageTemplate;

public class EnviarCorreoFinal extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity();
		String aprobacion = currEnt.getAttribute("INDDHH_SA_APROBACION_STR").getValueAsString();

		// Solicitante
		String nombreSolicitante = currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_NOMBRES_STR").getValueAsString()
				+ " " + currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_APELLIDOS_STR").getValueAsString();
		String correoSolicitante = currEnt.getAttribute("INDDHH_CORREO_CONTACTO_STR").getValueAsString();

		// Fecha y Hora
		Date fechaActividad = (Date) currEnt.getAttribute("INDDHH_SA_FECHA_ACTIVIDAD_FEC").getValue();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		String fechaActividadStr = sdf.format(fechaActividad);
		String horaInicio = currEnt.getAttribute("INDDHH_SA_HORA_INICIO_STR").getValueAsString();
		String horaFin = currEnt.getAttribute("INDDHH_SA_HORA_FINALIZACION_STR").getValueAsString();

		if (aprobacion.compareTo("1") == 0) { // Solicitud Aprobada
			solAprobadaSolicitante(this, nombreSolicitante, correoSolicitante, fechaActividadStr, horaInicio, horaFin);
			solAprobadaINDDHH(this, fechaActividadStr, horaInicio, horaFin);
		} else if (aprobacion.compareTo("2") == 0) {
			solRechazadaSolicitante(this, nombreSolicitante, correoSolicitante, fechaActividadStr, horaInicio, horaFin);
		}

	}

	private static void solAprobadaSolicitante(ApiaAbstractClass apia, String nombreSolicitante,
			String correoSolicitante, String fechaActividad, String horaInicio, String horaFin)
			throws BusClassException {
		// Datos del responsable
		String responsableNombre = apia.getCurrentEntity().getAttribute("INDDHH_SA_NOMBRE_RESPONSABLE_STR")
				.getValueAsString();
		String responsableCorreo = apia.getCurrentEntity().getAttribute("INDDHH_SA_CORREO_RESPONSABLE_STR")
				.getValueAsString();

		String[] destinos = { correoSolicitante };

		String asunto = "Solicitud de Salón de Actos INDDHH aprobada";

		String texto = "Estimados,<br><br>La solicitud del Salón de Actos de la Institución ha sido aprobada.<br><br>"
				+ "Fecha de la actividad: " + fechaActividad + "<br>" + "Hora de inicio: " + horaInicio + "<br>"
				+ "Hora de fin: " + horaFin + "<br><br>" + "Responsable por INDDHH del salón: " + responsableNombre
				+ "<br>" + "Correo electrónico del responsable: " + responsableCorreo + "<br><br>"
				+ "Ante cualquier duda o inconveniente comunicarse a secretaria@inddhh.gub.uy o al teléfono 1948.<br><br>"
				+ "Saludos cordiales,<br>" + "Secretaría General.<br>"
				+ "Institución Nacional de Derechos Humanos y Defensoría del Pueblo.";

		apia.sendMail(destinos, asunto, texto);
	}

	private static void solAprobadaINDDHH(ApiaAbstractClass apia, String fechaActividad, String horaInicio,
			String horaFin) throws BusClassException {
		// Datos del responsable
		String responsableNombre = apia.getCurrentEntity().getAttribute("INDDHH_SA_NOMBRE_RESPONSABLE_STR")
				.getValueAsString();
		String responsableCorreo = apia.getCurrentEntity().getAttribute("INDDHH_SA_CORREO_RESPONSABLE_STR")
				.getValueAsString();

		String secGral = apia.getUser("inddhh_secgral").getEmail();
		String mantenimiento = apia.getUser("inddhh_mantenimiento").getEmail();
		String seguridad = apia.getUser("inddhh_seguridad").getEmail();
		String comunicaciones = apia.getUser("inddhh_com").getEmail();
		String cooperativa = apia.getUser("inddhh_cooperativa").getEmail();

		String[] destinos = { secGral, mantenimiento, seguridad, comunicaciones, cooperativa };

		String asunto = "Solicitud de Salón de Actos INDDHH aprobada";

		String texto = "Estimados,<br><br>La solicitud del Salón de Actos de la Institución ha sido aprobada.<br><br>"
				+ "Fecha de la actividad: " + fechaActividad + "<br>" + "Hora de inicio: " + horaInicio + "<br>"
				+ "Hora de fin: " + horaFin + "<br><br>" + "Responsable del salón: " + responsableNombre + "<br>"
				+ "Correo electrónico del responsable: " + responsableCorreo + "<br><br>"
				+ "Ante cualquier duda o inconveniente comunicarse a secretaria@inddhh.gub.uy o al teléfono 1948.<br><br>"
				+ "Saludos cordiales,<br>" + "Secretaría General.<br>"
				+ "Institución Nacional de Derechos Humanos y Defensoría del Pueblo.";

		apia.sendMail(destinos, asunto, texto);

		if (inddhh.Helpers.validarEmail(responsableCorreo)) {
			String[] destResp = { responsableCorreo };
			apia.sendMail(destResp, asunto, texto);
		}
	}

	private static void solRechazadaSolicitante(ApiaAbstractClass apia, String nombreSolicitante,
			String correoSolicitante, String fechaActividad, String horaInicio, String horaFin)
			throws BusClassException {
		// Motivo de rechazo
		String motivoRechazo = apia.getCurrentEntity().getAttribute("INDDHH_SA_MOTIVO_RECHAZO_STR").getValueAsString();

		String[] destinos = { correoSolicitante };

		String asunto = "Solicitud de Salón de Actos INDDHH rechazada";

		String texto = "Estimados,<br><br>La solicitud del Salón de Actos de la Institución ha sido rechazada.<br><br>"
				+ "Fecha de la actividad: " + fechaActividad + "<br>" + "Hora de inicio: " + horaInicio + "<br>"
				+ "Hora de fin: " + horaFin + "<br><br>" + "Motivo de rechazo: " + motivoRechazo + "<br><br>"
				+ "Ante cualquier duda o inconveniente comunicarse a secretaria@inddhh.gub.uy o al teléfono 1948.<br><br>"
				+ "Saludos cordiales,<br>" + "Secretaría General.<br>"
				+ "Institución Nacional de Derechos Humanos y Defensoría del Pueblo.";

		apia.sendMail(destinos, asunto, texto);
	}

}
