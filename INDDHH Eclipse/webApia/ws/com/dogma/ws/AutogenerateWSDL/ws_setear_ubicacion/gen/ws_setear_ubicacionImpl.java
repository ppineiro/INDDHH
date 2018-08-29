/**
 * ws_setear_ubicacionImpl.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.dogma.ws.AutogenerateWSDL.ws_setear_ubicacion.gen;
import java.util.Date;
import com.dogma.ws.AutogenerateWSDL.WSMethodLinker;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Iterator;

public class ws_setear_ubicacionImpl implements com.dogma.ws.AutogenerateWSDL.ws_setear_ubicacion.gen.ApiaWSInterface{
    public com.dogma.ws.AutogenerateWSDL.ws_setear_ubicacion.gen.ExecResultType ws_setear_ubicacion(com.dogma.ws.AutogenerateWSDL.ws_setear_ubicacion.gen.ApiaWSInputType ws_setear_ubicacionInput) throws java.rmi.RemoteException {
		ExecResultType execResultType = new ExecResultType();
		try{
			WSMethodLinker wsMethodLinker = new WSMethodLinker(); 
			HashMap returnValue = wsMethodLinker.callWSMethod("ws_setear_ubicacion", ws_setear_ubicacionInput); 
			boolean isError = returnValue.containsKey(Integer.valueOf(-1)); 
			execResultType.setResultCode(isError ? -1 : 0);
			execResultType.setResultMessage(returnValue.get(Integer.valueOf(isError ? -1 : 0)).toString());
			if (! isError) {
				ArrayList names = (ArrayList)returnValue.get(Integer.valueOf(1));
				Iterator namesIt = names.iterator();
				ArrayList values = (ArrayList)returnValue.get(Integer.valueOf(2));
				Iterator it = values.iterator();
				Object obj;
				String name;
				Parameter parameter = new Parameter();
				int j=0;
				while(it.hasNext()){
					obj=it.next();
					name=namesIt.next().toString();
					j++;
			}
				execResultType.setParameters(parameter);
			}
		}catch(Exception e){
			execResultType.setResultCode(-1);
			execResultType.setResultMessage(e.getMessage());
		}
		return execResultType;
    }

}
