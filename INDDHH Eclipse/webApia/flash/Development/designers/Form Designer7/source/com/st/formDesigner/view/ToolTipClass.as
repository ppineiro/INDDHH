/////////////////////////////////////////////////////////////////
// START TOOL TIP CLASS
/////////////////////////////////////////////////////////////////
// Version 5 - persist - persist  pixelplay.org
// Version 6 - Nathan Derksen - www.nathanderksen.com - June 4 2004
//              - Port to ActionScript 2
//              - Enable multi-line ability
//              - Enable HTML text option
//               - Add getter/setter to customize delay
//              - Add getter/setter for enabling/disabling shadow
//              - Add getter/setter for tool tip colour
// Version 6.1 - Nathan Derksen - June 8, 2004
//              - Add width property to allow a fixed width, variable height scenario.
// 
// Usage:
//               var toolTip = new ToolTipClass(_level0);
//
//              toolTip.setHTML("the quick brown fox\n jumped over the lazy dog");
//       or toolTip.setText("the quick brown fox\n jumped over the lazy dog");
//
//              toolTip.clearText();


class com.st.formDesigner.view.ToolTipClass {

 // Private properties
 private var pDelay:Number;             // Delay interval in ms
 private var pEnableHTML:Boolean;       // Keep track of whether or not to show HTML. Uset by setHTML/setText.
 private var pHolderMovie:MovieClip;    // Container movie clip for tool tip.
 private var pKill:Boolean;             // If clearText() is called before setInterval takes effect, 
                                        // make sure the setInterval doesn't do anything
 private var pDelayInterval:Number;     // Id for setInterval call.
 private var pTag:String;               // String to show
 private var pTextHolder:TextField;     // Handle to text field
 private var pTextFormat:TextFormat;    // Handle to text format
 private var pTimelineHandle:MovieClip; // Handle to timeline that the tool tip should display in.
 private var pShadowEnabled:Boolean;    // Enable/disable shadows
 private var pFillColour:Number;         // Tool tip fill colour
 private var pWidth:Number;             // Width of tool tip. If <= 0, set to variable width;

 // ***************************************************************
 // Constructor method. Initialization code should go in init method.
 public function ToolTipClass(timelineHandle:MovieClip) {
        init.apply(this, arguments);
 }

 // ***************************************************************
 // Initialization method. Called by constructor, but can also be called separately.
 private function init(timelineHandle:MovieClip):Void {
        
        pTimelineHandle = timelineHandle;
        pTimelineHandle.createEmptyMovieClip("holderMovie", 60000);
        pHolderMovie = pTimelineHandle.holderMovie;
        pTextFormat = new TextFormat();
        
        // Create a bunch of movie clips for shadow. They will be offset and will
        // have different alphas to create blur effect.
        for (var i=0; i < 4; i++) {
         pHolderMovie.createEmptyMovieClip("shadow"+i, 60001 + i);
        }
        
        pHolderMovie.createTextField("textHolder", 60006, 0, 0, 140, 20);
        pTextHolder = pHolderMovie.textHolder;
        
        pDelay = 750;
        pKill = false;
        pShadowEnabled = true;
        pEnableHTML = true;
        pFillColour = 0xFFFFE1;
        pWidth = 0;
 }

 // ***************************************************************
 public function setText(tag:String):Void {
        clearInterval(pDelayInterval);
        pTag = tag;
        pEnableHTML = false;
        pDelayInterval = setInterval(this, "createToolTip", pDelay);
 }

 // ***************************************************************
 public function setHTML(tag:String):Void {
        clearInterval(pDelayInterval);
        pTag = tag;
        pEnableHTML = true;
        pDelayInterval = setInterval(this, "createToolTip", pDelay);
        
 }

 // ***************************************************************
 public function get delay():Number {
        return pDelay;
 }

 // ***************************************************************
 public function set delay(delayPeriod:Number):Void {
        pDelay = delayPeriod;
 }

 // ***************************************************************
 // Get what the fixed width setting is set to. Note the actual tool tip
 // may be narrower because the text doesn't flow the full width due to
 // line wrapping.
 public function get width():Number {
        return pWidth;
 }

 // ***************************************************************
 // If width is set to 0 or -1, the text field is a one line floating width field,
 // otherwise set the maximum pixel width. Note that if none of the lines go right
 // to the end, as can happen with left-justified text, then take up the slack and
 // shrink the text field to fit the actual text width.
 public function set width(lWidth:Number):Void {
        pWidth = lWidth;
 }

 // ***************************************************************
 public function get fillColour():Number {
        return pFillColour;
 }

 // ***************************************************************
 public function set fillColour(lColour:Number):Void {
        pFillColour = lColour;
 }


 // ***************************************************************
 public function get shadowEnabled():Boolean {
        return pShadowEnabled;
 }

 // ***************************************************************
 public function set shadowEnabled(lShadowEnabled:Boolean):Void {
        pShadowEnabled = lShadowEnabled;
 }

 // ***************************************************************
 public function clearText():Void {
	 	//--------
	 	//pHolderMovie.onEnterFrame = null;
	 	//delete pHolderMovie.onEnterFrame;
		//---------
        pHolderMovie._visible = false;
        pKill = false;
        clearInterval(pDelayInterval);
 }

 // ***************************************************************
 private function createToolTip():Void {
        // Check to see if the show tool tip request has been cancelled in the meantime.
        if (pKill == false) {
         pKill = true;
         
		 
         // Place the movie clip by the mouse
         pHolderMovie._visible = true;
         pHolderMovie._x = _xmouse;
         pHolderMovie._y = _ymouse+21;
        
         // Set up font characteristics
         pTextFormat.font = "Verdana";
         pTextFormat.align = "left";
         pTextFormat.size = 9;
         pTextFormat.leftMargin = 2;
         pTextFormat.rightMargin = 2;
         
         // Set up text field properties
         if (pWidth > 0) {
                // Set tool tip to a fixed width, let it line wrap and grow vertically.
                pTextHolder._width = pWidth;
                pTextHolder.autoSize = "left";
                pTextHolder.multiline = true;
                pTextHolder.wordWrap = true;
                
                // Set the text content
                if (pEnableHTML == true) {
                 pTextHolder.html = true;
                 pTextHolder.htmlText = pTag;
                } else {
                 pTextHolder.html = false;
                 pTextHolder.text = pTag;
                }
                
                pTextHolder.setTextFormat(pTextFormat);
                pTextHolder._width = pWidth; // Set the width, forcing it into multiple lines
                pTextHolder._width = pTextHolder.textWidth + 10; // Get rid of excess space on the right
         } else {
                // Keep the tool tip to one line.
                pTextHolder.autoSize = "left";
                pTextHolder.multiline = false;
                pTextHolder.wordWrap = false;
                
                // Set the text content
                if (pEnableHTML == true) {
                 pTextHolder.html = true;
                 pTextHolder.htmlText = pTag;
                } else {
                 pTextHolder.html = false;
                 pTextHolder.text = pTag;
                }
         }
         pTextHolder.selectable = false;
         
         pTextHolder.setTextFormat(pTextFormat);
         pTextHolder.border = true;
         pTextHolder.background = true;
         pTextHolder.backgroundColor = pFillColour;
         pHolderMovie._x += 1;
         
         // Check to see if the tool tip hits the edge of the screen.
         checkOverlap();
		 
		 //modificacion [ONENETERFRAME] para seguir el mouse;
		 /*
		 pHolderMovie.onEnterFrame = function(){
			 this._x = _xmouse;
         	 this._y = _ymouse + 21;
		 };*/
		 //-----------------//
         
         // Make sure the callback function only is called once per invocation.
         clearInterval(pDelayInterval);
		 
       }
 }

 // ***************************************************************
 // Check to see if the tool tip is going to be off screen, and re-position accordingly
 private function checkOverlap():Void {
        
        if ((pHolderMovie._x + pTextHolder.textWidth) > Stage.width) {
         pHolderMovie._x -= (pTextHolder.textWidth) - 10;
        }
        
        if ((pHolderMovie._y + pTextHolder.textHeight) > Stage.height) {
         pHolderMovie._y = ( _ymouse - (pTextHolder.textHeight));
        }
        
        if (pShadowEnabled == true) {
         createShadow();
        }
 }

 // ***************************************************************
 // Draw out a bunch of rectangles, set their alphas to something small, and overlap
 // them to create a blur effect.
 private function createShadow():Void {
        var shadowHandle:MovieClip;
        var previousShadowHandle:MovieClip;
        
        shadowHandle = pHolderMovie["shadow0"];
        shadowHandle.clear();
        shadowHandle._alpha = 20;
        drawRectangle(shadowHandle, pTextHolder._width, pTextHolder._height, 2, 0x000000, 0, 0x000000);
        shadowHandle._x = pTextHolder._x + 1;
        shadowHandle._y = pTextHolder._y + 1;
        for(var i = 1; i < 4; i++){
         shadowHandle = pHolderMovie["shadow" + i];
         previousShadowHandle = pHolderMovie["shadow" + (i-1)];
         shadowHandle.clear();
         drawRectangle(shadowHandle, pTextHolder._width, pTextHolder._height, 2, 0x000000, 0, 0x000000);
         shadowHandle._x = pTextHolder._x + (i * 1);
         shadowHandle._y = pTextHolder._y + (i * 1);
         shadowHandle._alpha = previousShadowHandle._alpha - 5;
        }
 }

 // ***************************************************************
 private function drawRectangle(target:MovieClip, width:Number, height:Number, 
                fillColour:Number, thickness:Number, lineColour:Number):Void {
        target.lineStyle(thickness, lineColour);
        target.moveto(0, 0);
        if (fillColour != null) {
         target.beginFill(fillColour);
        }
        target.lineTo(width, 0);
        target.lineTo(width, height);
        target.lineTo(0, height);
        target.lineTo(0, 0);
        target.endFill();
 }
}
/////////////////////////////////////////////////////////////////
// END TOOL TIP CLASS
/////////////////////////////////////////////////////////////////
