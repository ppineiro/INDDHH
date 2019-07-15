package ddhh.manejoXML.apiaXml.parse;

import java.math.BigInteger;
import java.util.ArrayList;

import org.apache.xmlbeans.XmlException;

import ddhh.manejoXML.apiaXml.LogParserApiaXML;
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
import uy.com.st.xml.ProcessXSDocument.ProcessXS;
import uy.com.st.xml.ProcessesXSDocument.ProcessesXS;
import uy.com.st.xml.ValueXSDocument.ValueXS;

import com.dogma.busClass.BusClassException;

/**
 * Parsea un string con un xml que contiene informacion para crear una instancia de cierto proceso/entidad de Apia
 * @author lbriozzo
 *
 */

public class ParserXMLApia{

	public InformationVo parserApia(String xmlString) throws XmlException, BusClassException{
		LogParserApiaXML.logger.log("########################");
		LogParserApiaXML.logger.log("Comienza el parseo");
		InformationVo infVo = new InformationVo();
		ArrayList<EntityVo> entitiesVo = new ArrayList<EntityVo>();
		ArrayList<ProcessVo> processesVo = new ArrayList<ProcessVo>();
		InformationXSDocument information = null;
		try {
			LogParserApiaXML.logger.log("Obtengo el elemento principal");
			information = InformationXSDocument.Factory.parse(xmlString);
		}
		catch (XmlException xmle) {throw xmle;}

		if (information != null) {
			InformationXS info = information.getInformationXS();

			EntitiesXS entities = info.getEntitiesXS();
			ProcessesXS processes = info.getProcessesXS();

			if(entities!=null){
				LogParserApiaXML.logger.log("Obtengo las entidades");
				EntityXS[] entArray = entities.getEntityXSArray();

				if(entArray!=null && entArray.length>0){
					LogParserApiaXML.logger.log("Obtengo los atributos para cada entidad");
					entitiesVo = this.getEntityVoArrayList(entArray);	
					infVo.setEntidades(entitiesVo);
				}	

			}

			if(processes!=null){
				LogParserApiaXML.logger.log("Obtengo los procesos");
				ProcessXS[] proArray = processes.getProcessXSArray();

				if(proArray!=null && proArray.length>0){
					LogParserApiaXML.logger.log("Obtengo los atributos para cada proceso");
					for( ProcessXS pro : proArray){
						LogParserApiaXML.logger.log("----");
						ProcessVo proVo = new ProcessVo();
						EntityVo entVo = new EntityVo();
						ArrayList<AttributeVo> attsVoP = new ArrayList<AttributeVo>();

						String nameP = pro.getName();
						String prefixP = pro.getPrefix();
						String posP = pro.getPostfix();
						proVo.setNombre(nameP);
						proVo.setPre(prefixP);
						BigInteger nro =  pro.getNumber();
						if(nro!=null){
							int numberP = pro.getNumber().intValue();
							proVo.setNum(numberP);
						}					
						proVo.setPos(posP);

						AttributesXS attsP = pro.getAttributesXS();
						attsVoP = this.getAttributeVoArray(attsP);

						proVo.setAttributes(attsVoP);
						LogParserApiaXML.logger.log("Obtengo la entidad del proceso");
						EntityXS ent = pro.getEntityXS();

						String nameE = ent.getName();
						String prefixE = ent.getPrefix();
						String posE = ent.getPostfix();
						entVo.setNombre(nameE);						
						BigInteger nroE =  ent.getNumber();
						if(nroE!=null){
							int numberE = ent.getNumber().intValue();
							entVo.setNum(numberE);
						}	
						entVo.setPre(prefixE);
						entVo.setPos(posE);
						LogParserApiaXML.logger.log("Obtengo los atributos de la entidad entidad");
						AttributesXS atts = ent.getAttributesXS();			
						ArrayList<AttributeVo> attsVo = this.getAttributeVoArray(atts);

						entVo.setAttributes(attsVo);

						proVo.setEnt(entVo);
						processesVo.add(proVo);		

					}			

					infVo.setProcesos(processesVo);

				}	

			}


			return infVo;
		}else{
			return null;
		}
	}

	private ArrayList<EntityVo> getEntityVoArrayList(EntityXS[] entArray) {

		ArrayList<EntityVo> arrEntityVo = new ArrayList<EntityVo>();

		for( EntityXS ent : entArray){		
			EntityVo entVo = new EntityVo();

			String name = ent.getName();
			String prefix = ent.getPrefix();

			String pos = ent.getPostfix();

			entVo.setNombre(name);
			BigInteger nroE =  ent.getNumber();
			if(nroE!=null){
				int numberE = ent.getNumber().intValue();
				entVo.setNum(numberE);
			}	
			entVo.setPre(prefix);
			entVo.setPos(pos);

			AttributesXS atts = ent.getAttributesXS();			
			ArrayList<AttributeVo> attsVo = this.getAttributeVoArray(atts);

			entVo.setAttributes(attsVo);

			arrEntityVo.add(entVo);			
		}

		if(arrEntityVo.isEmpty())
			return null;
		else
			return arrEntityVo;

	}

	private ArrayList<AttributeVo> getAttributeVoArray(AttributesXS atts) {

		if(atts!=null){			

			ArrayList<AttributeVo> attsVo = new ArrayList<AttributeVo>();
			AttributeXS[] attsArray = atts.getAttributeXSArray();
			if(attsArray!=null && attsArray.length>0){				
				for(AttributeXS att : attsArray){
					AttributeVo attVo = new AttributeVo();
					LogParserApiaXML.logger.log("Datos del atributo");
					
					boolean isFile = att.getIsFile();
					String nombre = att.getName();
					LogParserApiaXML.logger.log("Nombre: "+nombre);
					attVo.setFile(isFile);
					LogParserApiaXML.logger.log("Es archivo: "+isFile);
					attVo.setNombre(nombre);

					ValueXS valor = att.getValueXS();
					
					if(valor!=null){
						
						BigInteger index =valor.getIndex();
						if(index!=null){
							int numberE = valor.getIndex().intValue();
							attVo.setIndex(numberE);	
							LogParserApiaXML.logger.log("Indice: "+numberE);
						}else{
							attVo.setIndex(0);
						}
						String val = valor.getStringValue();
						attVo.setValue(val);
						attsVo.add(attVo);
						LogParserApiaXML.logger.log("Valor: "+val);

					}	

				}
			}
			if(attsVo.isEmpty())
				return null;
			else
				return attsVo;
		}else{
			return null;
		}


	}
}
