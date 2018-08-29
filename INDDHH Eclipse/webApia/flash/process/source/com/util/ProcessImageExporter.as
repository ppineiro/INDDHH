import flash.display.BitmapData;
import com.util.BitmapExporter;

import flash.net.FileReference;
import mx.events.EventDispatcher;

import mx.utils.Delegate;

import flash.geom.Matrix;

class com.util.ProcessImageExporter extends MovieClip{
	var updateBar:MovieClip;
	
	private static var dispatchEvent:Function;
	
	var bmpExporter:BitmapExporter;
	var xStart=0;
	
	function ProcessImageExporter(){
		EventDispatcher.initialize (this) ;
	}
	
	function onLoad(){
		xStart=updateBar._x;
	}
	
	function exportToBmp(mc:MovieClip){
		
		var myBitmap:BitmapData = new BitmapData(mc._width, mc._height);
		
		myBitmap.draw(mc);
		//bmpExporter=new BitmapExporter();
		var tmp=this;
		var lst:Object=new Object();
		lst.progress=function(evt){
			//trace("PROG "+evt.current+" "+evt.total);
			tmp.updateBar._x=tmp.xStart+(tmp.updateBar._width*evt.current);
		}
		
		lst.status=function(evt){
			if(evt.status=="retrieving"){
				tmp.dispatchEvent({
								 type:    "uploaded", 
								 message: "OK "
								 });
			}
		}
	
		lst.error=function(){
			//trace("ERR");
		}
		
		BitmapExporter.addEventListener( "progress", lst);
		BitmapExporter.addEventListener( "status", lst);	
		BitmapExporter.addEventListener( "error", lst);
		
		BitmapExporter.saveBitmap(myBitmap , 0 );
		
	}
	
	function moveAndExportToBmp(mc:MovieClip,moveX,moveY){
		
		var myBitmap:BitmapData = new BitmapData(mc._width, mc._height);
		
		if(moveX!=undefined && moveX!=null && moveY!=undefined && moveY!=null){
			var matrix:Matrix=new Matrix();
			matrix.a=1;
			matrix.b=0;
			matrix.c=0;
			matrix.d=1;
			matrix.tx=-moveX;
			matrix.ty=-moveY;
			myBitmap.draw(mc,matrix);
		}else{
			myBitmap.draw(mc);
		}
		//bmpExporter=new BitmapExporter();
		var tmp=this;
		var lst:Object=new Object();
		lst.progress=function(evt){
			//trace("PROG "+evt.current+" "+evt.total);
			tmp.updateBar._x=tmp.xStart+(tmp.updateBar._width*evt.current);
		}
		lst.status=function(evt){
			if(evt.status=="retrieving"){
				tmp.dispatchEvent({
								 type:    "uploaded", 
								 message: "OK "
								 });
			}
		}
	
		lst.error=function(){
			//trace("ERR");
		}
		
		BitmapExporter.addEventListener( "progress", lst);
		BitmapExporter.addEventListener( "status", lst);	
		BitmapExporter.addEventListener( "error", lst);
		
		BitmapExporter.saveBitmap(myBitmap , 0 );
		
	}
	
	function exportToBmpBmp(myBitmap:BitmapData){
		
		//bmpExporter=new BitmapExporter();
		var tmp=this;
		var lst:Object=new Object();
		lst.progress=function(evt){
			//trace("PROG "+evt.current+" "+evt.total);
			tmp.updateBar._x=tmp.xStart+(tmp.updateBar._width*evt.current);
		}
		
		lst.status=function(){
			//trace("STAT");
		}
	
		lst.error=function(){
			//trace("ERR");
		}
		
		BitmapExporter.addEventListener( "progress", lst);
		BitmapExporter.addEventListener( "status", lst);	
		BitmapExporter.addEventListener( "error", lst);
		
		trace(myBitmap+" "+myBitmap.width);
		
		BitmapExporter.saveBitmap(myBitmap , 0,100, false );
		
	}
	
	
	
	
}