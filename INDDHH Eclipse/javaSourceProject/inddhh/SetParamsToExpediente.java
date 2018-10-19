package inddhh;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;

public class SetParamsToExpediente extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		// TODO Auto-generated method stub
		/*Se deben cargar los siguientes atributos:
	 	- TRM_PARAMETROS_DESDE_DEFINICION_STR con el valor false.
		- DEF_TRM_EXPEDIENTE_OFICINA_ORIGEN_STR: oficina que va a recibir el expediente generado (debe existir en ApiaDocumentum)
		- DEF_TRM_EXPEDIENTE_CLASIFICACION_STR:  clasificación del expediente 
		- DEF_TRM_EXPEDIENTE_DOC_FISICA_STR: si contiene documentación física ( 1=No, 2= Si)
		- DEF_TRM_EXPEDIENTE_CONFIDENCIALIDAD_STR:  nivel de confidencialidad del expedientes
		- DEF_TRM_EXPEDIENTE_PRIORIDAD_STR: prioridad
		- DEF_TRM_EXPEDIENTE_ASUNTO_STR: asunto del expediente
		- DEF_TRM_EXPEDIENTE_TIPO_STR: tipo de expediente (debe existir en ApiaDocumentum)
		- DEF_TRM_EXPEDIENTE_ADJUNTO_STR: si se envía documento adjunto del trámite ( 1=No, 2= Si)
		- DEF_TRM_CONCATENAR_PDF_STR: si se concatena los pdf del trámtie y se envían al expediente. ( 1=No, 2= Si)
		*/
		
		Entity currEnt = this.getCurrentEntity();
		
		String paramsDef = this.getParameter("paramsDef").getValueAsString();
		String ofiOrigen = this.getParameter("ofiOrigen").getValueAsString();
		String clasif = this.getParameter("clasif").getValueAsString();
		String docFisica = this.getParameter("docFisica").getValueAsString();
		String confidenc = this.getParameter("confidenc").getValueAsString();
		String prioridad = this.getParameter("prioridad").getValueAsString();
		String asunto = this.getParameter("asunto").getValueAsString();
		String tipo = this.getParameter("tipo").getValueAsString();
		String adjunto = this.getParameter("adjunto").getValueAsString();
		String pdf = this.getParameter("pdf").getValueAsString();
		
		currEnt.getAttribute("TRM_PARAMETROS_DESDE_DEFINICION_STR").setValue(paramsDef);
		currEnt.getAttribute("DEF_TRM_EXPEDIENTE_OFICINA_ORIGEN_STR").setValue(ofiOrigen);
		currEnt.getAttribute("DEF_TRM_EXPEDIENTE_CLASIFICACION_STR").setValue(clasif);
		currEnt.getAttribute("DEF_TRM_EXPEDIENTE_DOC_FISICA_STR").setValue(docFisica);
		currEnt.getAttribute("DEF_TRM_EXPEDIENTE_CONFIDENCIALIDAD_STR").setValue(confidenc);
		currEnt.getAttribute("DEF_TRM_EXPEDIENTE_PRIORIDAD_STR").setValue(prioridad);
		currEnt.getAttribute("DEF_TRM_EXPEDIENTE_ASUNTO_STR").setValue(asunto);
		currEnt.getAttribute("DEF_TRM_EXPEDIENTE_TIPO_STR").setValue(tipo);
		currEnt.getAttribute("DEF_TRM_EXPEDIENTE_ADJUNTO_STR").setValue(adjunto);
		currEnt.getAttribute("DEF_TRM_CONCATENAR_PDF_STR").setValue(pdf);
		
	}

}
