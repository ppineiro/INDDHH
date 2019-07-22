package inddhh;

import java.time.Period;
import java.util.Calendar;
import java.util.Date;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Attribute;
import com.dogma.busClass.object.Document;
import com.dogma.busClass.object.Entity;

public class CopiarArchivoGenerado extends ApiaAbstractClass {

	@Override
	protected void executeClass() throws BusClassException {
		// TODO Auto-generated method stub
		Entity currEnt = this.getCurrentEntity();
		Document archivoGenerado = currEnt.getAttribute("TRM_FILE_DATOS_STR").getDocumentValue();
		String path = archivoGenerado.download();
		String name = archivoGenerado.getName();
		
		currEnt.getAttribute("INDDHH_ARCHIVO_GENERADO_STR").addDocument(path, name, "", false);
		
	}

}
