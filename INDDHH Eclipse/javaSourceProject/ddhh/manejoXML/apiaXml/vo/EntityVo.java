package ddhh.manejoXML.apiaXml.vo;

import java.util.ArrayList;

public class EntityVo {
	
	private String nombre;
	private String pre;
	private int num;
	private String pos;
	private ArrayList<AttributeVo> attributes;
	
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getPre() {
		return pre;
	}
	public void setPre(String pre) {
		this.pre = pre;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getPos() {
		return pos;
	}
	public void setPos(String pos) {
		this.pos = pos;
	}
	public ArrayList<AttributeVo> getAttributes() {
		return attributes;
	}
	public void setAttributes(ArrayList<AttributeVo> attributes) {
		this.attributes = attributes;
	}
	
	
	

}
