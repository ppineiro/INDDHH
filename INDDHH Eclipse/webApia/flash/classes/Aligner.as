/*
* Class: Aligner
* Purpose: This class is intended to align objects relative to the stage.
* 
* 
*/

class Aligner extends Object
{
	static private var __instance:Aligner;
	static private var stageListener:Object;
	static private var __objects:Array;
	
	static var stageTotalWidth:Number;
	static var stageTotalHeight:Number;
	
	
	static var stageXOffsetCiel:Number;	
	static var stageXOffsetFloor:Number;
	static var stageYOffsetCiel:Number;
	static var stageYOffsetFloor:Number;
	
	static var isInited:Boolean;
	
	function Aligner()
	{
		init();
	}
	
	static function init():Void
	{
			
			Stage.scaleMode = "showAll";
			stageTotalWidth = Stage.width;
			stageTotalHeight = Stage.height;
			Stage.scaleMode = "noScale";
			
			stageXOffsetCiel = Math.ceil((stageTotalWidth - Stage.width) / 2);
			stageXOffsetFloor = Math.floor((stageTotalWidth - Stage.width) / 2);
			stageYOffsetCiel = Math.ceil((stageTotalHeight - Stage.height) / 2);
			stageYOffsetFloor = Math.floor((stageTotalHeight - Stage.height) / 2);
			
			stageListener = new Object();
			stageListener.onResize = stageResized;			
			Stage.addListener(stageListener);
			
			__objects = new Array();
			
			isInited = true;			
	}
	
	private static function updateOffsets():Void
	{
			stageXOffsetCiel = Math.ceil((stageTotalWidth - Stage.width) / 2);
			stageXOffsetFloor = Math.floor((stageTotalWidth - Stage.width) / 2);
			stageYOffsetCiel = Math.ceil((stageTotalHeight - Stage.height) / 2);
			stageYOffsetFloor = Math.floor((stageTotalHeight - Stage.height) / 2);
	}
	
	public static function repositionObjects():Void
	{
		for (var i = 0; i < __objects.length; i++)
		{
			switch(__objects[i].alignment)
			{
				case "left":
					left(__objects[i].obj, __objects[i].margin, true);
					break;
				case "right":
					right(__objects[i].obj, __objects[i].margin, true);
					break;
				case "top":
					top(__objects[i].obj, __objects[i].margin, true);
					break;				
				case "bottom":
					bottom(__objects[i].obj, __objects[i].margin, true);
					break;
				case "center":
					center(__objects[i].obj, true);
					break;
				case "centerH":
					centerH(__objects[i].obj, true);
					break;					
				case "centerV":
					centerV(__objects[i].obj, true);
					break;			}			
		}
	}
	
	private static function stageResized():Void
	{
		updateOffsets();
		repositionObjects();
	}
	
	static function left(o:Object, margin:Number, noPush:Boolean):Void
	{ 
		if (isInited == undefined) init();
		if (margin == undefined) margin = 0;
		if (noPush == undefined || noPush == false) __objects.push({obj:o, alignment:"left", margin:margin});		
		o._x = stageXOffsetCiel + margin;
	}
	
	static function right(o:Object, margin:Number, noPush:Boolean):Void
	{ 
		if (isInited == undefined) init();
		if (margin == undefined) margin = 0;
		if (noPush == undefined || noPush == false) __objects.push({obj:o, alignment:"right", margin:margin});		
		o._x = stageTotalWidth - stageXOffsetFloor - o._width - margin;		
	}
	
	static function top(o:Object, margin:Number, noPush:Boolean):Void
	{ 
		if (isInited == undefined) init();
		if (margin == undefined) margin = 0;
		if (noPush == undefined || noPush == false) __objects.push({obj:o, alignment:"top", margin:margin});		
		o._y = stageYOffsetCiel + margin;				
	}
	
	static function bottom(o:Object, margin:Number, noPush:Boolean):Void
	{ //defined
		if (isInited == undefined) init();
		if (margin == undefined) margin = 0;
		if (noPush == undefined || noPush == false) __objects.push({obj:o, alignment:"bottom", margin:margin});		
		o._y = stageTotalHeight - stageYOffsetFloor - o.height - margin;
	}
	
	static function topLeft(o:Object, tMargin:Number, lMargin:Number):Void
	{
		if (isInited == undefined) init();
		if (tMargin == undefined) tMargin = 0;
		if (lMargin == undefined) lMargin = 0;
		top(o, tMargin, false);
		left(o, lMargin, false);
	}
	
	static function topRight(o:Object, tMargin:Number, rMargin:Number):Void
	{
		if (isInited == undefined) init();
		top(o, tMargin, false);
		right(o, rMargin, false);
	}
	
	static function bottomLeft(o:Object, bMargin:Number, lMargin:Number):Void
	{
		if (isInited == undefined) init();
		if (bMargin == undefined) bMargin = 0;
		if (lMargin == undefined) lMargin = 0;
		bottom(o, bMargin, false);
		left(o, lMargin, false);
	}
	
	static function bottomRight(o:Object, bMargin:Number, rMargin:Number):Void
	{
		if (isInited == undefined) init();
		if (bMargin == undefined) bMargin = 0;
		if (rMargin == undefined) rMargin = 0;		
		bottom(o, bMargin, false);
		right(o, rMargin, false);
	}
	
	static function center(o:Object, noPush:Boolean):Void
	{
		if (isInited == undefined) init();
		if (noPush == undefined) __objects.push({obj:o, alignment:"center"});
		if (noPush == false) __objects.push({obj:o, alignment:"center"});
		o._x = Math.round(stageTotalWidth / 2) - Math.round(o._width / 2);
		o._y = Math.round(stageTotalHeight / 2) - Math.round(o._height / 2);		
	}	
	
	static function centerH(o:Object, noPush:Boolean):Void
	{
		if (isInited == undefined) init();
		if (noPush == undefined) __objects.push({obj:o, alignment:"centerH"});
		if (noPush == false) __objects.push({obj:o, alignment:"centerH"});
		o._x = Math.round(stageTotalWidth / 2) - Math.round(o._width / 2);		
	}

	static function centerV(o:Object, noPush:Boolean):Void
	{
		if (isInited == undefined) init();
		if (noPush == undefined) __objects.push({obj:o, alignment:"centerV"});
		if (noPush == false) __objects.push({obj:o, alignment:"centerV"});		
		o._y = Math.round(stageTotalHeight / 2) - Math.round(o._height / 2);
	}	
}