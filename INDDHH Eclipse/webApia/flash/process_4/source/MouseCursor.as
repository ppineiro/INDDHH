


class MouseCursor{
	
	var root:MovieClip;
	
	function MouseCursor(p_root){
		root = p_root;
		var aux = root.attachMovie("cursor_delete","cursor_delete",500,{_visible:false,m_mode:3});
		var aux2 = root.attachMovie("cursor_add","cursor_add",501,{_visible:false,m_mode:4});
		var aux3 = root.attachMovie("cursor_cross","cursor_cross",502,{_visible:false,m_mode:2});
		
		aux.addEventListener("onMouseMoved",this);
		aux2.addEventListener("onMouseMoved",this);
		aux3.addEventListener("onMouseMoved",this);
	};
	
	function onMouseMoved(p_eventObj){
		//trace("---->>>> "  + p_eventObj.target._name)
		var op_mode = _global.p_mode;
		var cursor_name = p_eventObj.target._name;
		
		if(op_mode==2 && cursor_name == "cursor_cross"){
			setToolCursor(p_eventObj.target)
		}
		if(op_mode==3 && cursor_name == "cursor_delete"){
			setToolCursor(p_eventObj.target)
		}
		if((op_mode >=4 && op_mode <=9) && (cursor_name == "cursor_add")){
			setToolCursor(p_eventObj.target)
		}
	};
	
	
	function setToolCursor(thisMouseClip){
		if(mouseOverWorkArea(thisMouseClip)){
			thisMouseClip._visible = true;
			Mouse.hide();
			thisMouseClip._x = _root._xmouse;
			thisMouseClip._y = _root._ymouse;
			updateAfterEvent();
		}else{
			thisMouseClip._visible = false;
			Mouse.show();	
		}
	};
	
	function mouseOverWorkArea(thisMouseClip){
		//change cursor to default when mouseovering these...
		if(root["bg_mc"].hitTest(root._xmouse,root._ymouse,1)){
			if(root["btnBarMc"].hitTest(root._xmouse,root._ymouse,1) || 
			root.finderWindow.hitTest(_root._xmouse,_root._ymouse,1) ||
			root["screenNavigator"].hitTest(root._xmouse,root._ymouse,1)){
				return false;
			}else{
				return true;
			}
		}else{
			return false;
		}
	};
	
}