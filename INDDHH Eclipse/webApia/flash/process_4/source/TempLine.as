

class TempLine extends MovieClip {
	
	function TempLine(){
		_visible = false;
	};
	
	function show(p_originPointX:Number,p_originPointY:Number){
		this._xscale = 0;
		this._yscale = 0;
		this._x = p_originPointX;
		this._y = p_originPointY;
		
		this.onEnterFrame = function(){
			this._xscale = _root._xmouse - this._x;
			this._yscale = _root._ymouse - this._y;
			updateAfterEvent();
		}
		this._visible = true;
	};
	
	function hide(){
		this._visible = false;
		this.onEnterFrame = null;
		delete this.onEnterFrame;
	};
	
}