package ddhh.manejoXML.apiaXml;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;

import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Attribute;
import com.dogma.busClass.object.Document;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Field;
import com.dogma.busClass.object.Process;
import com.dogma.busClass.object.Task;
import com.dogma.vo.custom.CmbDataVo;
/**
 * Clase con métodos generales que involucran a apia
 *
 */
public class ApiaHelper {

	/**
	 * Cancela todas las tareas en ejecución, excepto la actual
	 * @param proceso Instancia del proceso del cual se quiere cancelar las tareas
	 * @throws BusClassException
	 */
	public static void cancelarTareasEnEjecución(Process proceso) throws BusClassException {

		//obtiene todas las tareas en ejecución de la instancia actual del proceso, excepto la actual
		Collection availableTasks = proceso.getAvailableTasks();

		//cancela todas las tareas en ejecución 
		for (Iterator iterator = availableTasks.iterator(); iterator.hasNext();) {
			((Task) iterator.next()).cancel();			
		}
	}

	//TODO: Metodo para cargar valores en combo



	/**
	 * Suma dias a calendario de apia y retorna la fecha correspondiente
	 * @param inicio
	 * @param diasHabiles
	 * @param apiaCalendar
	 * @return
	 * @throws BusClassException
	 */
	public static Date calcularFechaSegunDiasHabiles(Date inicio, int diasHabiles,com.dogma.busClass.object.Calendar apiaCalendar ) throws BusClassException{


		java.util.Calendar cal = new GregorianCalendar();
		cal.setTimeInMillis(inicio.getTime());
		int i =0;
		while (i< diasHabiles)
		{

			cal.add(java.util.Calendar.DAY_OF_MONTH, 1);
			int typeOfDay = apiaCalendar.checkCalendarDay(cal.getTime());
			if( typeOfDay!=1 && typeOfDay != 2)
			{
				i++;
			}
		}
		return cal.getTime();


	}


	public static Task findTask(String name, Integer index, Collection<Task> tasks) throws BusClassException {
		for (Task task : tasks) {
			if (task.getTaskName().equals(name) && task.getTaskIndex().equals(index)) return task;
		}

		return null;
	}


	/**
	 * Retorna el texto del possibleValue con valor value, del atributo att.
	 * */
	public static String getTextFromValue(Attribute att, String value) {
		Collection<CmbDataVo> col = att.getPossibleValues();
		for(Iterator<CmbDataVo> it = col.iterator(); it.hasNext();) {
			CmbDataVo cdv = it.next();
			String itVal = cdv.getValue();
			if(itVal.equals(value)) {
				return cdv.getText();
			}
		}
		return null;		
	}

	/**
	 * Retorna el valor del possibleValue con texto text, del atributo att.
	 * */
	public static String getValueFromText(Attribute att, String text) {
		Collection<CmbDataVo> col = att.getPossibleValues();
		for(Iterator<CmbDataVo> it = col.iterator(); it.hasNext();) {
			CmbDataVo cdv = it.next();
			String itText = cdv.getText();
			if(itText.equals(text)) {
				return cdv.getValue();
			}
		}
		return null;		
	}

	/**
	 * Limpia una grilla
	 * 
	 * @param ent
	 * @param form
	 * @param grilla
	 * @throws BusClassException
	 */
	public static void limpiarGrilla(Entity ent, String form, String grilla) throws BusClassException {

		int filasGrilla = ent.getForm(form).getField(grilla).getGridSize();

		if(filasGrilla > 0){

			Field grid = ent.getForm(form).getField(grilla);
			Collection<Field> col = grid.getChildren();
			Iterator<Field> it = col.iterator();
			while(it.hasNext()){
				Field columna = it.next();
				if(columna.getAttribute()!=null)
					columna.getAttribute().clear();

			}
		}
	}

	/**
	 * Elimina o setea una propiedad para una columna de una grilla (todas sus posicicones)
	 * @param ent
	 * @param form
	 * @param grilla
	 * @param nomFld
	 * @param prop
	 * @throws BusClassException
	 */
	public static void removeOrSetProperty(Entity ent,
			String form, String grilla,
			String nomFld, int prop, boolean dec, boolean isAttribute) throws BusClassException {

		int filasGrilla = ent.getForm(form).getField(grilla).getGridSize();

		if(filasGrilla > 0){
			Field campo = null;
			if(isAttribute)
				campo = ent.getForm(form).getFieldByAttributeName(nomFld);
			else
				campo = ent.getForm(form).getField(nomFld);

			for(int i = 0; i<filasGrilla;i++){
				campo.setProperty(i,prop, dec);
			}

		}


	}

	/**
	 * Copia los valores de un atributo con varios indices a un atributo separados por un separador
	 * @param ent
	 * @param attNameFrom
	 * @param attNameTo
	 * @param separator
	 * @throws BusClassException
	 */

	public static void copyAndJoinAttributeValues(Entity ent, String attNameFrom, String attNameTo, String separator) throws BusClassException{

		String type = ent.getAttribute(attNameFrom).getType();
		String typeTo = ent.getAttribute(attNameTo).getType();
		if(!typeTo.equals("S")){
			throw new BusClassException("El atributo de destino debe ser del tipo String");
		}

		String result = "";
		boolean first = true;
		if(type.equals("S")){
			Collection<Object> values = ent.getAttribute(attNameFrom).getValues();
			if(values!=null){
				Iterator<Object> ite = values.iterator();
				while(ite.hasNext()){
					if(first){
						result = ite.next().toString();
						first = false;
					}else{
						result = result + separator + ite.next();
					}
				}
				ent.getAttribute(attNameTo).setValue(result);
			}

		}else if(type.equals("N")){
			Collection<Object> values = ent.getAttribute(attNameFrom).getValues();
			if(values!=null){
				Iterator<Object> ite = values.iterator();
				while(ite.hasNext()){
					Double val = (Double) ite.next();
					String valS = "";
					if(val!=null)
						valS = String.valueOf(val.intValue());

					if(first){

						result =valS;
						first = false;
					}else{
						result = result + separator + valS;
					}
				}
				ent.getAttribute(attNameTo).setValue(result);
			}

		}else if (type.equals("D")){
			if(separator.equals("/"))
				throw new BusClassException("El separador no puede ser '/' para un campo de origen de tipo fecha");

			Collection<Object> values = ent.getAttribute(attNameFrom).getValues();
			Iterator<Object> ite = values.iterator();
			while(ite.hasNext()){
				Date val = (Date) ite.next();
				if(values!=null){
					String valS = "";
					if(val!=null){
						SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

						valS = sdf.format(val);
					}
					if(first){

						result =valS;
						first = false;
					}else{
						result = result + separator + valS;
					}
				}
			}
			ent.getAttribute(attNameTo).setValue(result);

		}



	}
	
	/**
	 * Copia los valores de un atributo con varios indices a un atributo separados por un separador
	 * @param ent
	 * @param attNameFrom
	 * @param attNameTo
	 * @param separator
	 * @throws BusClassException
	 */

	public static void copyAndJoinAttributeValues(Process p, String attNameFrom, String attNameTo, String separator) throws BusClassException{

		String type = p.getAttribute(attNameFrom).getType();
		String typeTo = p.getAttribute(attNameTo).getType();
		if(!typeTo.equals("S")){
			throw new BusClassException("El atributo de destino debe ser del tipo String");
		}

		String result = "";
		boolean first = true;
		if(type.equals("S")){
			Collection<Object> values = p.getAttribute(attNameFrom).getValues();
			if(values!=null){
				Iterator<Object> ite = values.iterator();
				while(ite.hasNext()){
					if(first){
						result = ite.next().toString();
						first = false;
					}else{
						result = result + separator + ite.next();
					}
				}
				p.getAttribute(attNameTo).setValue(result);
			}

		}else if(type.equals("N")){
			Collection<Object> values = p.getAttribute(attNameFrom).getValues();
			if(values!=null){
				Iterator<Object> ite = values.iterator();
				while(ite.hasNext()){
					Double val = (Double) ite.next();
					String valS = "";
					if(val!=null)
						valS = String.valueOf(val.intValue());

					if(first){

						result =valS;
						first = false;
					}else{
						result = result + separator + valS;
					}
				}
				p.getAttribute(attNameTo).setValue(result);
			}

		}else if (type.equals("D")){
			if(separator.equals("/"))
				throw new BusClassException("El separador no puede ser '/' para un campo de origen de tipo fecha");

			Collection<Object> values = p.getAttribute(attNameFrom).getValues();
			Iterator<Object> ite = values.iterator();
			while(ite.hasNext()){
				Date val = (Date) ite.next();
				if(values!=null){
					String valS = "";
					if(val!=null){
						SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

						valS = sdf.format(val);
					}
					if(first){

						result =valS;
						first = false;
					}else{
						result = result + separator + valS;
					}
				}
			}
			p.getAttribute(attNameTo).setValue(result);

		}



	}
	
	/**
	 * Agrega un documento al atributo especificado y borra el archivo original si asi se desea
	 * @param ent
	 * @param nomAtt
	 * @param pathSalida
	 * @param nameDoc
	 * @param desc
	 * @param lockDoc
	 * @param deleteOrigFile
	 * @throws BusClassException
	 */
	public static void addDocumentToAttribute(Entity ent, String nomAtt, String pathSalida, String nameDoc, String desc, boolean lockDoc, boolean deleteOrigFile) throws BusClassException{

		ent.getAttribute(nomAtt).addDocument(pathSalida, nameDoc, desc, lockDoc);
		//ent.persist();

		if(deleteOrigFile){
			File f1 = new File(pathSalida); 		
			if(f1.exists()){
				f1.delete();
			}else{
				throw new BusClassException("El archivo especificado no existe!."); 
			}			
		}


	}
	
	
	/**
	 * Agrega un documento al atributo especificado y borra el archivo original si asi se desea
	 * @param ent
	 * @param nomAtt
	 * @param pathSalida
	 * @param nameDoc
	 * @param desc
	 * @param lockDoc
	 * @param deleteOrigFile
	 * @throws BusClassException
	 */
	public static void addDocumentToAttribute(Process p, String nomAtt, String pathSalida, String nameDoc, String desc, boolean lockDoc, boolean deleteOrigFile) throws BusClassException{

		p.getAttribute(nomAtt).addDocument(pathSalida, nameDoc, desc, lockDoc);
		//p.persist();

		if(deleteOrigFile){
			File f1 = new File(pathSalida); 		
			if(f1.exists()){
				f1.delete();
			}else{
				throw new BusClassException("El archivo especificado no existe!."); 
			}			
		}


	}
	
	

	/**
	 * Dado un atributo, si este tiene un documento asociado, retorna su nombre
	 * 
	 * @param entIn
	 * @param nomAttIn
	 * @param indexAttIn
	 * @return
	 * @throws BusClassException
	 */


	public static String getAttributeDocNameValue(Entity entIn, String nomAttIn,
			int indexAttIn) throws BusClassException {

		if(nomAttIn != null && !nomAttIn.isEmpty()){
			Document doc = entIn.getAttribute(nomAttIn).getDocumentValue(indexAttIn);
			if(doc!=null)
				return doc.getName();
			else
				return null;
		}else{
			return null;



		}

	}
	
	/**
	 * Dado un atributo, si este tiene un documento asociado, retorna su nombre
	 * 
	 * @param entIn
	 * @param nomAttIn
	 * @param indexAttIn
	 * @return
	 * @throws BusClassException
	 */


	public static String getAttributeDocPathValue(Entity entIn, String nomAttIn,
			int indexAttIn) throws BusClassException {

		if(nomAttIn != null && !nomAttIn.isEmpty()){
			Document doc = entIn.getAttribute(nomAttIn).getDocumentValue(indexAttIn);
			if(doc!=null){				
				return doc.download(true);
			}else{
				return null;
			}
		}else{
			return null;
		}

	}

	/**
	 * Dado un atributo, si este tiene un documento asociado, retorna su nombre
	 * 
	 * @param entIn
	 * @param nomAttIn
	 * @param indexAttIn
	 * @return
	 * @throws BusClassException
	 */
	public static String getAttributeDocNameValue(Process p, String nomAttIn,
			int indexAttIn) throws BusClassException {
		if(nomAttIn != null && !nomAttIn.isEmpty()){
			Document doc = p.getAttribute(nomAttIn).getDocumentValue(indexAttIn);
			if(doc!=null)
				return doc.getName();
			else
				return null;
		}else{
			return null;



		}
	}
	
	public static ArrayList<String> getEntityDocsPaths(Entity e,ArrayList<String> paths) throws BusClassException{
		ArrayList<Document> docs = (ArrayList<Document>) e.getDocuments();
		if(docs!=null){
			Iterator<Document> docsI = docs.iterator();
			while(docsI.hasNext()){
				Document d = docsI.next();
				String path = d.download(true);
				paths.add(path);
			}
		}
		return paths;		
	}




}
