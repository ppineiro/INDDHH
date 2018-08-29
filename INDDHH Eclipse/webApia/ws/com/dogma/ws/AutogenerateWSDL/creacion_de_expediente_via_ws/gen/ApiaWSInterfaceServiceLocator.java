/**
 * ApiaWSInterfaceServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen;

public class ApiaWSInterfaceServiceLocator extends org.apache.axis.client.Service implements com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen.ApiaWSInterfaceService {

    public ApiaWSInterfaceServiceLocator() {
    }


    public ApiaWSInterfaceServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public ApiaWSInterfaceServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for ApiaWScreacion_de_expediente_via_ws
    private java.lang.String ApiaWScreacion_de_expediente_via_ws_address = "http://localhost:8989/Dogma2.0/services/ApiaWScreacion_de_expediente_via_ws";

    public java.lang.String getApiaWScreacion_de_expediente_via_wsAddress() {
        return ApiaWScreacion_de_expediente_via_ws_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String ApiaWScreacion_de_expediente_via_wsWSDDServiceName = "ApiaWScreacion_de_expediente_via_ws";

    public java.lang.String getApiaWScreacion_de_expediente_via_wsWSDDServiceName() {
        return ApiaWScreacion_de_expediente_via_wsWSDDServiceName;
    }

    public void setApiaWScreacion_de_expediente_via_wsWSDDServiceName(java.lang.String name) {
        ApiaWScreacion_de_expediente_via_wsWSDDServiceName = name;
    }

    public com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen.ApiaWSInterface getApiaWScreacion_de_expediente_via_ws() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(ApiaWScreacion_de_expediente_via_ws_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getApiaWScreacion_de_expediente_via_ws(endpoint);
    }

    public com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen.ApiaWSInterface getApiaWScreacion_de_expediente_via_ws(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen.ApiaWSSoapBindingStub _stub = new com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen.ApiaWSSoapBindingStub(portAddress, this);
            _stub.setPortName(getApiaWScreacion_de_expediente_via_wsWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setApiaWScreacion_de_expediente_via_wsEndpointAddress(java.lang.String address) {
        ApiaWScreacion_de_expediente_via_ws_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen.ApiaWSInterface.class.isAssignableFrom(serviceEndpointInterface)) {
                com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen.ApiaWSSoapBindingStub _stub = new com.dogma.ws.AutogenerateWSDL.creacion_de_expediente_via_ws.gen.ApiaWSSoapBindingStub(new java.net.URL(ApiaWScreacion_de_expediente_via_ws_address), this);
                _stub.setPortName(getApiaWScreacion_de_expediente_via_wsWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("ApiaWScreacion_de_expediente_via_ws".equals(inputPortName)) {
            return getApiaWScreacion_de_expediente_via_ws();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "ApiaWSInterfaceService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "ApiaWScreacion_de_expediente_via_ws"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("ApiaWScreacion_de_expediente_via_ws".equals(portName)) {
            setApiaWScreacion_de_expediente_via_wsEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
