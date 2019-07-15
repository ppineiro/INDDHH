package ddhh.manejoXML.apiaXml.load;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;

import ddhh.manejoXML.apiaXml.LogApiaObjectCreationLoader;
import ddhh.manejoXML.apiaXml.vo.AttributeVo;
import st.helper.ArrayListHelper;
import st.vo.FileVo;

import com.dogma.busClass.BusClassException;
import com.dogma.busClass.object.Entity;
import com.dogma.busClass.object.Process;

import biz.statum.helper.CalendarDateHelper;

public class LoadApiaAttributesFromApiaXML {
	
	
public static void loadProcessAttributes(Process p,ArrayList<AttributeVo> attsP, Entity ent,ArrayList<AttributeVo> attsE, ArrayList<FileVo> archivos, boolean addDocs2Ent) throws BusClassException{
		
		ArrayList<FileVo> filesCopy = ArrayListHelper.copyArray(archivos);		
		
		for(AttributeVo a : attsP){
			String name = a.getNombre();
			String value = a.getValue();
			int index = a.getIndex();
			boolean isFile = a.isFile();
			LogApiaObjectCreationLoader.logger.log("Nombre: "+name);
			LogApiaObjectCreationLoader.logger.log("Valor: "+value);
			LogApiaObjectCreationLoader.logger.log("Indice: "+index);
			LogApiaObjectCreationLoader.logger.log("Es archivo: "+isFile);
			
			
			if(!isFile){
				String apiaAttType = p.getAttribute(name).getType();
				if(apiaAttType.equals("S")){
					if(index == 0){
						if(value!=null && value.length()>=255){
							//p.getAttribute(name).setValueLargeStr(value);
							p.getAttribute(name).setValue(value);
						}else{
							p.getAttribute(name).setValue(value);
						}
					}else{
						p.getAttribute(name).setValue(value,index);
					}			
				}else if(apiaAttType.equals("N")){
					try{
						Double valorN = Double.parseDouble(value);
						p.getAttribute(name).setValue(valorN,index);	
					}catch(NumberFormatException nfe){
						throw new BusClassException("El valor obtenido no corresponde al tipo de datos del atributo de destino. Valor: "+value+" Tipo: N");
					}
				}else if (apiaAttType.equals("D")){
						Date fecha = CalendarDateHelper.obtenerDateDeString(value,"");	
						p.getAttribute(name).setValue(fecha,index);
				}
			}else{
				
				Iterator<FileVo> files = archivos.iterator();			
						
				int i = 0;
				while(files.hasNext()){
					FileVo file = files.next();
					if(file != null && file.getName().equals(value)){
						p.getAttribute(name).addDocument(file.getPath(), value, value, true);
						filesCopy.set(i, null);
					}
					i++;
				}			
				
			}
		}
		
		if(ent!=null && attsE!=null){
			if(addDocs2Ent)
				LoadApiaAttributesFromApiaXML.loadEntityAttributes(ent, attsE, filesCopy,addDocs2Ent);
			else
				LoadApiaAttributesFromApiaXML.loadEntityAttributes(ent, attsE, archivos,addDocs2Ent);
		}
		
	}
	
	public static void loadEntityAttributes(Entity e,ArrayList<AttributeVo> atts, ArrayList<FileVo> archivos, boolean addDocs2Ent) throws BusClassException{
		
		ArrayList<FileVo> filesCopy = ArrayListHelper.copyArray(archivos);		
		
		
		for(AttributeVo a : atts){
			String name = a.getNombre();
			String value = a.getValue();
			int index = a.getIndex();
			boolean isFile = a.isFile();
			LogApiaObjectCreationLoader.logger.log("Nombre: "+name);
			LogApiaObjectCreationLoader.logger.log("Valor: "+value);
			LogApiaObjectCreationLoader.logger.log("Indice: "+index);
			LogApiaObjectCreationLoader.logger.log("Es archivo: "+isFile);
			if(!isFile){
				String apiaAttType = e.getAttribute(name).getType();
				if(apiaAttType.equals("S")){					
					if(index == 0){
						if(value!=null && value.length()>=255){
							//e.getAttribute(name).setValueLargeStr(value);
							e.getAttribute(name).setValue(value);
						}else{
							e.getAttribute(name).setValue(value);
						}						
					}else{
						e.getAttribute(name).setValue(value,index);
					}
				}else if(apiaAttType.equals("N")){
					try{
						Double valorN = Double.parseDouble(value);
						e.getAttribute(name).setValue(valorN,index);	
					}catch(NumberFormatException nfe){
						throw new BusClassException("El valor obtenido no corresponde al tipo de datos del atributo de destino. Valor: "+value+" Tipo: N");
					}
				}else if (apiaAttType.equals("D")){
						Date fecha = CalendarDateHelper.obtenerDateDeString(value,"");	
						e.getAttribute(name).setValue(fecha,index);
				}
			}else{
				
				Iterator<FileVo> files = archivos.iterator();	
				int i = 0;
				while(files.hasNext()){
					FileVo file = files.next();
					if(file != null && file.getName().equals(value)){
						e.getAttribute(name).addDocument(file.getPath(), value, value, true);
						filesCopy.set(i, null);
					}
					i++;
				}		

			}
		}
		
		if(addDocs2Ent){
			Iterator<FileVo> filesExtras = filesCopy.iterator();	
			while(filesExtras.hasNext()){
				FileVo fExtra = filesExtras.next();
				e.addDocument(fExtra.getPath(), fExtra.getName(), "", true);
			}	
		}
		
		
		
	}
	
	

}
