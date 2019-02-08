package inscasambleaanual;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;

public class GenerarYEnviarTickets extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		Entity currEnt = this.getCurrentEntity(); 

		// Obtenciï¿½n de valores de atributos
		String nroDocumento = currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_DOC_NUM_STR").getValuesAsString();
		String nombre = currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_NOMBRES_STR").getValuesAsString();
		String apellido = currEnt.getAttribute("INDDHH_ATT_DATOS_PERSONALES_APELLIDOS_STR").getValuesAsString();
		String correo = currEnt.getAttribute("INDDHH_CORREO_CONTACTO_STR").getValuesAsString();
		String pertenenciaInst = currEnt.getAttribute("INDDHH_AA_PERTENECE_A_INSTITUCION_STR").getValuesAsString();

		String nombreInst = currEnt.getAttribute("INDDHH_AA_NOMBRE_INSTITUCION_STR").getValuesAsString();
		String tipoInst = currEnt.getAttribute("INDDHH_AA_TIPO_INSTITUCION_STR").getValuesAsString();
		String instRegistrada = currEnt.getAttribute("INDDHH_AA_INSTITUCION_REGISTRADA_STR").getValuesAsString();
		
		String especNombreOrgEstado = currEnt.getAttribute("INDDHH_ROS_ESPECIFIQUE_ORG_GUB").getValuesAsString();

		String GUID = currEnt.getAttribute("TRM_GUID_STR").getValuesAsString();

		// Valores para crear ticket
		String xUbicacionAGuardar = this.getParameter("ubicAGuardar").getValueAsString();
		String xNombreCompleto = nombre.toUpperCase() + " " + apellido.toUpperCase();
		String xNombreOrganizacion;
		String xCalidad;
		String xUbicacionImgLogo = this.getParameter("ubicLogo").getValueAsString();

		// Determinar nombre de organizacion (Persona/Organizacion)
		if (pertenenciaInst.compareTo("1") == 0) {
			// Si pertenece a institucion
			if (tipoInst.compareTo("1") == 0 || tipoInst.compareTo("3") == 0) { //Social o Internacional
				xNombreOrganizacion = nombreInst.toUpperCase();
			} else if (tipoInst.compareTo("2") == 0) { //Org. del Estado
				xNombreOrganizacion = especNombreOrgEstado.toUpperCase();
			} else {
				xNombreOrganizacion = "-";
			}
		} else {
			xNombreOrganizacion = "-";
		}

		// Determinar la calidad
		if (pertenenciaInst.compareTo("1") == 0) {
			if ((tipoInst.compareTo("1") == 0 && instRegistrada.compareTo("1") == 0)
					|| (tipoInst.compareTo("2") == 0)) {
				// Si pertenece a institucion y esta registrada, o es org. del estado
				xCalidad = "PARTICIPANTE";
			} else {
				xCalidad = "OBSERVADOR";
			}
		} else {
			xCalidad = "OBSERVADOR";
		}

		currEnt.getAttribute("INDDHH_AA_CALIDAD_PARTICIPACION_STR").setValue(xCalidad);

		try {
			File ticket = crearTicket(xUbicacionAGuardar, nroDocumento, xNombreCompleto, xNombreOrganizacion, xCalidad,
					xUbicacionImgLogo);

			enviarMailConTicket(this, correo, ticket, nombre, GUID);

		} catch (Exception e) {
			throw new BusClassException(e);
		}

	}

	private static void enviarMailConTicket(ApiaAbstractClass apia, String correo, File ticket, String nombre,
			String GUID) throws BusClassException {

		String[] destinos = { correo };

		String asunto = "INDDHH - Inscripción a Asamblea Anual de Derechos Humanos completada";

		String texto = "Estimado/a " + nombre + ",<br><br>"
				+ "Su inscripción a la Asamblea Anual de Derechos Humanos se ha realizado exitosamente.<br>"
				+ "Le enviamos adjunto su ticket de entrada.<br><br>"
				+ "Ante cualquier duda o inconveniente comunicarse a asamblea@inddhh.gub.uy o al teléfono 1948.<br><br>"
				+ "El Código para realizar el seguimiento en línea del estado del trámite es: <font size=4><b>" + GUID
				+ "</b></font>; para ello, copie el código y pegue en la siguiente página: https://tramites.gub.uy/seguimiento.<br><br>"
				+ "Saludos cordiales,<br>" + "Secretaría General.<br>"
				+ "Institución Nacional de Derechos Humanos y Defensoría del Pueblo.";

		Collection<String> archivos = new ArrayList<>();
		archivos.add(ticket.getAbsolutePath());

		apia.sendMail(destinos, asunto, texto, archivos);
	}

	private static File crearTicket(String ubicacionAGuardar, String nroDocumento, String nombreCompleto,
			String nombreOrganizacion, String calidad, String ubicacionImgLogo) throws DocumentException, IOException {

		FileOutputStream archivo = new FileOutputStream(ubicacionAGuardar);
		Document documento = new Document();
		PdfWriter.getInstance(documento, archivo);

		documento.open();

		// Logo
		Paragraph lineaLogo = new Paragraph();
		Image foto = Image.getInstance(ubicacionImgLogo);
		foto.scaleAbsolute((float) 304, (float) 84.5);
		Chunk i = new Chunk(foto, 0, 0, true);
		lineaLogo.add(i);
		lineaLogo.setAlignment(Element.ALIGN_CENTER);
		documento.add(lineaLogo);

		// Documento
		documento.add(new Paragraph()); // Salto de linea
		Paragraph lineaDocumento = new Paragraph();

		Chunk tlDocumento = new Chunk("DOCUMENTO", FontFactory.getFont("Arial", 16, Font.BOLD));
		Chunk elDosPtos = new Chunk(": ", FontFactory.getFont("Arial", 16, Font.BOLD));
		Chunk elDocumento = new Chunk(nroDocumento, FontFactory.getFont("Arial", 16));

		lineaDocumento.add(tlDocumento);
		lineaDocumento.add(elDosPtos);
		lineaDocumento.add(elDocumento);
		lineaDocumento.setAlignment(Element.ALIGN_CENTER);
		lineaDocumento.setLeading(0, 2);

		documento.add(lineaDocumento);
		documento.add(new Paragraph()); // Salto de linea

		// Nombre
		documento.add(new Paragraph()); // Salto de linea
		Paragraph lineaNombre = new Paragraph();

		Chunk tlNombre = new Chunk("NOMBRE", FontFactory.getFont("Arial", 16, Font.BOLD));
		Chunk elNombre = new Chunk(nombreCompleto, FontFactory.getFont("Arial", 16));

		lineaNombre.add(tlNombre);
		lineaNombre.add(elDosPtos);
		lineaNombre.add(elNombre);
		lineaNombre.setAlignment(Element.ALIGN_CENTER);
		lineaNombre.setLeading(0, 2);

		documento.add(lineaNombre);
		documento.add(new Paragraph()); // Salto de linea

		// Organizaciï¿½n
		documento.add(new Paragraph()); // Salto de linea
		Paragraph lineaOrganizacion = new Paragraph();

		Chunk tlOrganizacion = new Chunk("ORGANIZACIÓN", FontFactory.getFont("Arial", 16, Font.BOLD));
		Chunk elOrganizacion = new Chunk(nombreOrganizacion, FontFactory.getFont("Arial", 16));

		lineaOrganizacion.add(tlOrganizacion);
		lineaOrganizacion.add(elDosPtos);
		lineaOrganizacion.add(elOrganizacion);
		lineaOrganizacion.setAlignment(Element.ALIGN_CENTER);
		lineaOrganizacion.setLeading(0, 2);

		documento.add(lineaOrganizacion);
		documento.add(new Paragraph()); // Salto de linea

		// Calidad
		documento.add(new Paragraph()); // Salto de linea
		Paragraph lineaCalidad = new Paragraph();

		Chunk tlCalidad = new Chunk("CALIDAD", FontFactory.getFont("Arial", 16, Font.BOLD));
		Chunk elCalidad = new Chunk(calidad, FontFactory.getFont("Arial", 16));

		lineaCalidad.add(tlCalidad);
		lineaCalidad.add(elDosPtos);
		lineaCalidad.add(elCalidad);
		lineaCalidad.setAlignment(Element.ALIGN_CENTER);
		lineaCalidad.setLeading(0, 2);

		documento.add(lineaCalidad);
		documento.add(new Paragraph()); // Salto de linea

		documento.close();

		File f = new File(ubicacionAGuardar);
		return f;
	}

}
