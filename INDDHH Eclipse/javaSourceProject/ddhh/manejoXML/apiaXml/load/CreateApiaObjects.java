package ddhh.manejoXML.apiaXml.load;

import java.util.ArrayList;

import ddhh.manejoXML.apiaXml.LogApiaObjectCreationLoader;
import ddhh.manejoXML.apiaXml.vo.AttributeVo;
import ddhh.manejoXML.apiaXml.vo.EntityVo;
import ddhh.manejoXML.apiaXml.vo.InformationVo;
import ddhh.manejoXML.apiaXml.vo.ProcessVo;
import st.vo.FileVo;

import com.dogma.busClass.ApiaAbstractClass;
import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Process;

public class CreateApiaObjects {

	/**
	 * Crea los objetos de apia
	 * @param aac: ApiaAbstractClass actual
	 * @param info: InformationVo object conteniendo el parseo del xml
	 * @param pathFiles: ArrayList con el path de los archivos de los fileuploads
	 * @throws BusClassException
	 */
	public static void createObjects(ApiaAbstractClass aac ,InformationVo info, ArrayList<FileVo> pathFiles, boolean addDocs2Ent) throws BusClassException{
		LogApiaObjectCreationLoader.logger.log("#####################");
		LogApiaObjectCreationLoader.logger.log("Creo los objetos de apia");
		ArrayList<EntityVo> entidades = info.getEntidades();
		ArrayList<ProcessVo> procesos = info.getProcesos();

		if(entidades!=null){
			LogApiaObjectCreationLoader.logger.log("Creo entidades");
			for(EntityVo ent : entidades){
				String nomEnt = ent.getNombre();
				LogApiaObjectCreationLoader.logger.log("Nombre de la entidad: "+nomEnt);
				Entity nuevaEnt = null;
				if(nomEnt!=null && !nomEnt.isEmpty()){
					Integer nro = ent.getNum();
					if(nro!=null && nro.intValue()>0){
						String pre = ent.getPre();
						String pos = ent.getPos();
						if(pre!=null && pre.isEmpty())
							pre = null;
						if(pos!=null && pos.isEmpty())
							pos = null;
						nuevaEnt = aac.getEntity(nomEnt, pre, nro.intValue(), pos);
					}else{
						nuevaEnt = aac.createEntity(nomEnt);					
					}		
				}else{
					nuevaEnt = aac.getCurrentEntity();
				}
				if(nuevaEnt!=null){
					LogApiaObjectCreationLoader.logger.log("Cargo los atributos de la entidad");
					ArrayList<AttributeVo> atributos = ent.getAttributes();
					LoadApiaAttributesFromApiaXML.loadEntityAttributes(nuevaEnt, atributos,pathFiles,addDocs2Ent);
					nuevaEnt.persist();
				}
			}

		}

		if(procesos!=null){

			for(ProcessVo pro : procesos){
				LogApiaObjectCreationLoader.logger.log("Creo procesos");
				String nomPro = pro.getNombre();
				LogApiaObjectCreationLoader.logger.log("Nombre del proceso: "+nomPro);
				Process nuevoP = null;
				if(nomPro!=null && !nomPro.isEmpty()){
					Integer nro = pro.getNum();
					if(nro!=null && nro.intValue()>0){
						String pre = pro.getPre();
						String pos = pro.getPos();
						if(pre!=null && pre.isEmpty())
							pre = null;
						if(pos!=null && pos.isEmpty())
							pos = null;
						nuevoP = aac.getProcess(nomPro, pre, nro, pos);
					}else{
						nuevoP = aac.createCreationProcess(nomPro);				
					}		

				}else{
					nuevoP = aac.getCurrentProcess();
				}
				if(nuevoP != null){
					Entity entPro = nuevoP.getEntity();					
					ArrayList<AttributeVo> atributos = pro.getAttributes();
					ArrayList<AttributeVo> atributosE = pro.getEnt().getAttributes();
					LogApiaObjectCreationLoader.logger.log("Cargo los atributos de la entidad y el proceso");
					LoadApiaAttributesFromApiaXML.loadProcessAttributes(nuevoP,atributos,entPro,atributosE, pathFiles,addDocs2Ent);
					nuevoP.persist();	
				}
			}

		}



	}

}
