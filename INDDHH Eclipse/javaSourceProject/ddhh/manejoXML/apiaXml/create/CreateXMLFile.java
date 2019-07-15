package ddhh.manejoXML.apiaXml.create;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.util.ArrayList;

import org.apache.xmlbeans.XmlError;
import org.apache.xmlbeans.XmlOptions;

import com.dogma.busClass.BusClassException;

import ddhh.manejoXML.apiaXml.vo.AttributeVo;
import ddhh.manejoXML.apiaXml.vo.EntityVo;
import ddhh.manejoXML.apiaXml.vo.InformationVo;
import ddhh.manejoXML.apiaXml.vo.ProcessVo;
import uy.com.st.xml.AttributeXSDocument.AttributeXS;
import uy.com.st.xml.AttributesXSDocument.AttributesXS;
import uy.com.st.xml.EntitiesXSDocument.EntitiesXS;
import uy.com.st.xml.EntityXSDocument.EntityXS;
import uy.com.st.xml.InformationXSDocument;
import uy.com.st.xml.InformationXSDocument.InformationXS;
import uy.com.st.xml.ValueXSDocument.ValueXS;

public class CreateXMLFile {

	public static void createApiaXMLFile(InformationVo info, String pathSalida) throws BusClassException{

		InformationXSDocument infoXML = InformationXSDocument.Factory.newInstance();		
		InformationXS infoXML1 = infoXML.addNewInformationXS();

		ArrayList<EntityVo> entidades = info.getEntidades();
		ArrayList<ProcessVo> procesos = info.getProcesos();

		if(entidades!=null){
			EntitiesXS entitiesXML = infoXML1.addNewEntitiesXS();

			for(EntityVo entVo : entidades){
				EntityXS entityXML = entitiesXML.addNewEntityXS();				
				String nombre = entVo.getNombre();
				entityXML.setName(nombre);
				ArrayList<AttributeVo> attsEnt = entVo.getAttributes();
				AttributesXS attributesXML = entityXML.addNewAttributesXS();
				for(AttributeVo at : attsEnt){
					//Para cada atributo
					AttributeXS attributeXML = attributesXML.addNewAttributeXS();
					attributeXML.setIsFile(at.isFile());
					attributeXML.setName(at.getNombre());
					ValueXS valueXML = attributeXML.addNewValueXS();
					valueXML.setIndex(new BigInteger(String.valueOf(at.getIndex())));
					valueXML.setStringValue(at.getValue());

				}			

			}

		}
	

		/*	
		if(procesos!=null){
			ProcessesXS processesXML = infoXML1.addNewProcessesXS();

			for(ProcessVo proVo : procesos){
				ProcessXS processXML = processesXML.addNewProcessXS();				
				String nombre = proVo.getNombre();
				processXML.setName(nombre);
				ArrayList<AttributeVo> attsPro = proVo.getAttributes();
				if(attsPro!=null&&!attsPro.isEmpty()){
					AttributesXS attributesXML = processXML.addNewAttributesXS();
					for(AttributeVo at : attsPro){
						//Para cada atributo
						AttributeXS attributeXML = attributesXML.addNewAttributeXS();
						attributeXML.setIsFile(at.isFile());
						attributeXML.setName(at.getNombre());
						ValueXS valueXML = attributeXML.addNewValueXS();
						valueXML.setIndex(new BigInteger(String.valueOf(at.getIndex())));
						valueXML.setStringValue(at.getValue());

					}
				}

				EntityVo proEnt = proVo.getEnt();

				if(proEnt!=null){
					EntityXS entityXML =processXML.addNewEntityXS();		
					String nombreEnt = proEnt.getNombre();
					entityXML.setName(nombreEnt);
					ArrayList<AttributeVo> attsEnt = proEnt.getAttributes();
					if(attsEnt!=null&&!attsEnt.isEmpty()){
						AttributesXS attributesEntXML = entityXML.addNewAttributesXS();
						for(AttributeVo at : attsEnt){
							//Para cada atributo
							AttributeXS attributeXML = attributesEntXML.addNewAttributeXS();
							attributeXML.setIsFile(at.isFile());
							attributeXML.setName(at.getNombre());
							ValueXS valueXML = attributeXML.addNewValueXS();
							valueXML.setIndex(new BigInteger(String.valueOf(at.getIndex())));
							valueXML.setStringValue(at.getValue());

						}			
					}
				}	
			}

		}*/

		XmlOptions validateOptions = new XmlOptions();
		ArrayList errors = new ArrayList();
		validateOptions.setErrorListener(errors);

		boolean ok = infoXML.validate(validateOptions);
		StringBuffer errorMsgs = new StringBuffer();
		if (!ok) {
			for (int i = 0; i < errors.size(); i++) {
				XmlError error = (XmlError)errors.get(i);

				errorMsgs.append("\n");
				errorMsgs.append("Message: " + error.getMessage() + "\n");
				errorMsgs.append("Location of invalid XML: " + error.getCursorLocation().xmlText() + "\n");
			}
			throw new BusClassException(errorMsgs.toString());
		}

		try{
			//escribir archivo xml
			PrintWriter out = new PrintWriter(new File(pathSalida),"UTF-8");
			out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");    //esto sería: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
			out.println(infoXML);
			if (out.checkError()) {
				throw new BusClassException("Ocurrió un error escribiendo el archivo XML.");
			}

		}catch(UnsupportedEncodingException ioe){
			throw new BusClassException("Ocurrió un error escribiendo el archivo XML: " +ioe.getMessage());
		}catch(FileNotFoundException fnfe){
			throw new BusClassException("Ocurrió un error escribiendo el archivo XML: " +fnfe.getMessage());
		}


	}

}
