/**
 * ursea_tramite_internoImpl.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.dogma.ws.AutogenerateWSDL.ursea_tramite_interno.gen;
import java.util.Date;
import com.dogma.ws.AutogenerateWSDL.WSMethodLinker;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Date;
import com.dogma.ws.AutogenerateWSDL.WSMethodLinker;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Date;
import com.dogma.ws.AutogenerateWSDL.WSMethodLinker;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Date;
import com.dogma.ws.AutogenerateWSDL.WSMethodLinker;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Iterator;

public class ursea_tramite_internoImpl implements com.dogma.ws.AutogenerateWSDL.ursea_tramite_interno.gen.ApiaWSInterface{
    public com.dogma.ws.AutogenerateWSDL.ursea_tramite_interno.gen.ExecResultType ursea_tramite_interno(com.dogma.ws.AutogenerateWSDL.ursea_tramite_interno.gen.ApiaWSInputType ursea_tramite_internoInput) throws java.rmi.RemoteException {
		ExecResultType execResultType = new ExecResultType();
		try{
			WSMethodLinker wsMethodLinker = new WSMethodLinker(); 
			HashMap returnValue = wsMethodLinker.callWSMethod("ursea_tramite_interno", ursea_tramite_internoInput); 
			boolean isError = returnValue.containsKey(Integer.valueOf(-1)); 
			execResultType.setResultCode(isError ? -1 : 0);
			execResultType.setResultMessage(returnValue.get(Integer.valueOf(isError ? -1 : 0)).toString());
		}catch(Exception e){
			execResultType.setResultCode(-1);
			execResultType.setResultMessage(e.getMessage());
		}
		return execResultType;
    }

}
