/**
 * qry_consulta_datos_expediente_ws_v4Impl.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.dogma.ws.AutogenerateWSDL.qry_consulta_datos_expediente_ws_v4.gen;
import java.util.Date;
import com.dogma.ws.AutogenerateWSDL.WSMethodLinker;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Iterator;

public class qry_consulta_datos_expediente_ws_v4Impl implements com.dogma.ws.AutogenerateWSDL.qry_consulta_datos_expediente_ws_v4.gen.ApiaWSInterface{
    public com.dogma.ws.AutogenerateWSDL.qry_consulta_datos_expediente_ws_v4.gen.ExecResultType qry_consulta_datos_expediente_ws_v4(com.dogma.ws.AutogenerateWSDL.qry_consulta_datos_expediente_ws_v4.gen.ApiaWSInputType qry_consulta_datos_expediente_ws_v4Input) throws java.rmi.RemoteException {
		ExecResultType execResultType = new ExecResultType();
		try{
			WSMethodLinker wsMethodLinker = new WSMethodLinker(); 
			HashMap returnValue = wsMethodLinker.callWSMethod("qry_consulta_datos_expediente_ws_v4", qry_consulta_datos_expediente_ws_v4Input); 
			boolean isError = returnValue.containsKey(Integer.valueOf(-1)); 
			execResultType.setResultCode(isError ? -1 : 0);
			execResultType.setResultMessage(returnValue.get(Integer.valueOf(isError ? -1 : 0)).toString());
			ArrayList a = (ArrayList)returnValue.get(Integer.valueOf(1));
			Iterator it = a.iterator();
			ArrayList b;
			Row[] rows = new Row[a.size()];
			int j=0;
			Double d;
			while(it.hasNext()){
				b=(ArrayList)it.next();
				Row row = new Row();
				if(b.get(0)!=null){
					row.setDependencia(b.get(0).toString());
				}else{
					row.setDependencia(null);
				}
				if(b.get(1)!=null){
					row.setArea(b.get(1).toString());
				}else{
					row.setArea(null);
				}
				if(b.get(2)!=null){
					row.setOficinaActual(b.get(2).toString());
				}else{
					row.setOficinaActual(null);
				}
				if(b.get(3)!=null){
					row.setAsunto(b.get(3).toString());
				}else{
					row.setAsunto(null);
				}
				if(b.get(4)!=null){
					row.setFechaCreacion((Date)b.get(4));
				}else{
					row.setFechaCreacion(null);
				}
				if(b.get(5)!=null){
					row.setTipoexpstr(b.get(5).toString());
				}else{
					row.setTipoexpstr(null);
				}
				if(b.get(6)!=null){
					row.setUsuarioActual(b.get(6).toString());
				}else{
					row.setUsuarioActual(null);
				}
				if(b.get(7)!=null){
					row.setConfidencial(b.get(7).toString());
				}else{
					row.setConfidencial(null);
				}
				if(b.get(8)!=null){
					row.setPrioridad(b.get(8).toString());
				}else{
					row.setPrioridad(null);
				}
				if(b.get(9)!=null){
					row.setDocumentacionFisica(b.get(9).toString());
				}else{
					row.setDocumentacionFisica(null);
				}
				if(b.get(10)!=null){
					row.setOficinaCreadora(b.get(10).toString());
				}else{
					row.setOficinaCreadora(null);
				}
				rows[j]=row;
				j++;
			}
			execResultType.setResultQueryRows(rows);
		}catch(Exception e){
			execResultType.setResultCode(-1);
			execResultType.setResultMessage(e.getMessage());
		}
		return execResultType;
    }

}
