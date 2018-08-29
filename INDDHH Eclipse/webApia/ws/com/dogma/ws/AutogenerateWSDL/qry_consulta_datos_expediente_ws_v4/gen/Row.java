/**
 * Row.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.dogma.ws.AutogenerateWSDL.qry_consulta_datos_expediente_ws_v4.gen;

public class Row  implements java.io.Serializable {
    private java.lang.String dependencia;

    private java.lang.String area;

    private java.lang.String oficinaActual;

    private java.lang.String asunto;

    private java.util.Date fechaCreacion;

    private java.lang.String tipoexpstr;

    private java.lang.String usuarioActual;

    private java.lang.String confidencial;

    private java.lang.String prioridad;

    private java.lang.String documentacionFisica;

    private java.lang.String oficinaCreadora;

    public Row() {
    }

    public Row(
           java.lang.String dependencia,
           java.lang.String area,
           java.lang.String oficinaActual,
           java.lang.String asunto,
           java.util.Date fechaCreacion,
           java.lang.String tipoexpstr,
           java.lang.String usuarioActual,
           java.lang.String confidencial,
           java.lang.String prioridad,
           java.lang.String documentacionFisica,
           java.lang.String oficinaCreadora) {
           this.dependencia = dependencia;
           this.area = area;
           this.oficinaActual = oficinaActual;
           this.asunto = asunto;
           this.fechaCreacion = fechaCreacion;
           this.tipoexpstr = tipoexpstr;
           this.usuarioActual = usuarioActual;
           this.confidencial = confidencial;
           this.prioridad = prioridad;
           this.documentacionFisica = documentacionFisica;
           this.oficinaCreadora = oficinaCreadora;
    }


    /**
     * Gets the dependencia value for this Row.
     * 
     * @return dependencia
     */
    public java.lang.String getDependencia() {
        return dependencia;
    }


    /**
     * Sets the dependencia value for this Row.
     * 
     * @param dependencia
     */
    public void setDependencia(java.lang.String dependencia) {
        this.dependencia = dependencia;
    }


    /**
     * Gets the area value for this Row.
     * 
     * @return area
     */
    public java.lang.String getArea() {
        return area;
    }


    /**
     * Sets the area value for this Row.
     * 
     * @param area
     */
    public void setArea(java.lang.String area) {
        this.area = area;
    }


    /**
     * Gets the oficinaActual value for this Row.
     * 
     * @return oficinaActual
     */
    public java.lang.String getOficinaActual() {
        return oficinaActual;
    }


    /**
     * Sets the oficinaActual value for this Row.
     * 
     * @param oficinaActual
     */
    public void setOficinaActual(java.lang.String oficinaActual) {
        this.oficinaActual = oficinaActual;
    }


    /**
     * Gets the asunto value for this Row.
     * 
     * @return asunto
     */
    public java.lang.String getAsunto() {
        return asunto;
    }


    /**
     * Sets the asunto value for this Row.
     * 
     * @param asunto
     */
    public void setAsunto(java.lang.String asunto) {
        this.asunto = asunto;
    }


    /**
     * Gets the fechaCreacion value for this Row.
     * 
     * @return fechaCreacion
     */
    public java.util.Date getFechaCreacion() {
        return fechaCreacion;
    }


    /**
     * Sets the fechaCreacion value for this Row.
     * 
     * @param fechaCreacion
     */
    public void setFechaCreacion(java.util.Date fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }


    /**
     * Gets the tipoexpstr value for this Row.
     * 
     * @return tipoexpstr
     */
    public java.lang.String getTipoexpstr() {
        return tipoexpstr;
    }


    /**
     * Sets the tipoexpstr value for this Row.
     * 
     * @param tipoexpstr
     */
    public void setTipoexpstr(java.lang.String tipoexpstr) {
        this.tipoexpstr = tipoexpstr;
    }


    /**
     * Gets the usuarioActual value for this Row.
     * 
     * @return usuarioActual
     */
    public java.lang.String getUsuarioActual() {
        return usuarioActual;
    }


    /**
     * Sets the usuarioActual value for this Row.
     * 
     * @param usuarioActual
     */
    public void setUsuarioActual(java.lang.String usuarioActual) {
        this.usuarioActual = usuarioActual;
    }


    /**
     * Gets the confidencial value for this Row.
     * 
     * @return confidencial
     */
    public java.lang.String getConfidencial() {
        return confidencial;
    }


    /**
     * Sets the confidencial value for this Row.
     * 
     * @param confidencial
     */
    public void setConfidencial(java.lang.String confidencial) {
        this.confidencial = confidencial;
    }


    /**
     * Gets the prioridad value for this Row.
     * 
     * @return prioridad
     */
    public java.lang.String getPrioridad() {
        return prioridad;
    }


    /**
     * Sets the prioridad value for this Row.
     * 
     * @param prioridad
     */
    public void setPrioridad(java.lang.String prioridad) {
        this.prioridad = prioridad;
    }


    /**
     * Gets the documentacionFisica value for this Row.
     * 
     * @return documentacionFisica
     */
    public java.lang.String getDocumentacionFisica() {
        return documentacionFisica;
    }


    /**
     * Sets the documentacionFisica value for this Row.
     * 
     * @param documentacionFisica
     */
    public void setDocumentacionFisica(java.lang.String documentacionFisica) {
        this.documentacionFisica = documentacionFisica;
    }


    /**
     * Gets the oficinaCreadora value for this Row.
     * 
     * @return oficinaCreadora
     */
    public java.lang.String getOficinaCreadora() {
        return oficinaCreadora;
    }


    /**
     * Sets the oficinaCreadora value for this Row.
     * 
     * @param oficinaCreadora
     */
    public void setOficinaCreadora(java.lang.String oficinaCreadora) {
        this.oficinaCreadora = oficinaCreadora;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Row)) return false;
        Row other = (Row) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.dependencia==null && other.getDependencia()==null) || 
             (this.dependencia!=null &&
              this.dependencia.equals(other.getDependencia()))) &&
            ((this.area==null && other.getArea()==null) || 
             (this.area!=null &&
              this.area.equals(other.getArea()))) &&
            ((this.oficinaActual==null && other.getOficinaActual()==null) || 
             (this.oficinaActual!=null &&
              this.oficinaActual.equals(other.getOficinaActual()))) &&
            ((this.asunto==null && other.getAsunto()==null) || 
             (this.asunto!=null &&
              this.asunto.equals(other.getAsunto()))) &&
            ((this.fechaCreacion==null && other.getFechaCreacion()==null) || 
             (this.fechaCreacion!=null &&
              this.fechaCreacion.equals(other.getFechaCreacion()))) &&
            ((this.tipoexpstr==null && other.getTipoexpstr()==null) || 
             (this.tipoexpstr!=null &&
              this.tipoexpstr.equals(other.getTipoexpstr()))) &&
            ((this.usuarioActual==null && other.getUsuarioActual()==null) || 
             (this.usuarioActual!=null &&
              this.usuarioActual.equals(other.getUsuarioActual()))) &&
            ((this.confidencial==null && other.getConfidencial()==null) || 
             (this.confidencial!=null &&
              this.confidencial.equals(other.getConfidencial()))) &&
            ((this.prioridad==null && other.getPrioridad()==null) || 
             (this.prioridad!=null &&
              this.prioridad.equals(other.getPrioridad()))) &&
            ((this.documentacionFisica==null && other.getDocumentacionFisica()==null) || 
             (this.documentacionFisica!=null &&
              this.documentacionFisica.equals(other.getDocumentacionFisica()))) &&
            ((this.oficinaCreadora==null && other.getOficinaCreadora()==null) || 
             (this.oficinaCreadora!=null &&
              this.oficinaCreadora.equals(other.getOficinaCreadora())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getDependencia() != null) {
            _hashCode += getDependencia().hashCode();
        }
        if (getArea() != null) {
            _hashCode += getArea().hashCode();
        }
        if (getOficinaActual() != null) {
            _hashCode += getOficinaActual().hashCode();
        }
        if (getAsunto() != null) {
            _hashCode += getAsunto().hashCode();
        }
        if (getFechaCreacion() != null) {
            _hashCode += getFechaCreacion().hashCode();
        }
        if (getTipoexpstr() != null) {
            _hashCode += getTipoexpstr().hashCode();
        }
        if (getUsuarioActual() != null) {
            _hashCode += getUsuarioActual().hashCode();
        }
        if (getConfidencial() != null) {
            _hashCode += getConfidencial().hashCode();
        }
        if (getPrioridad() != null) {
            _hashCode += getPrioridad().hashCode();
        }
        if (getDocumentacionFisica() != null) {
            _hashCode += getDocumentacionFisica().hashCode();
        }
        if (getOficinaCreadora() != null) {
            _hashCode += getOficinaCreadora().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Row.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "Row"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("dependencia");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "Dependencia"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("area");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "Area"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("oficinaActual");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "OficinaActual"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("asunto");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "asunto"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("fechaCreacion");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "FechaCreacion"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "date"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("tipoexpstr");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "tipoexpstr"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("usuarioActual");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "UsuarioActual"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("confidencial");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "Confidencial"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("prioridad");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "Prioridad"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("documentacionFisica");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "DocumentacionFisica"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("oficinaCreadora");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.apiasolutions.com/WebServices", "OficinaCreadora"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
