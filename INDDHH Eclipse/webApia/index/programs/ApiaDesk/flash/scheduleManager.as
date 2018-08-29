class scheduleManager extends MovieClip{
	var theList:MovieClip;
	var btnGridDelete:MovieClip;
	var btnMore:MovieClip;
	var closeBtn:MovieClip;
		
	var daysArray:Array;
	
	var clickBlocker:MovieClip;
	
	function scheduleManager(){
	}
	function setDays(days:Array){
		daysArray=days;
	}
	/*function onRelease(){
		
	}*/
	function onLoad(){
		theList.generateList(daysArray);
		var tmp=this;
		clickBlocker.onRelease=function(){}
		clickBlocker.useHandCursor=false;
		var myDropFilter = new flash.filters.DropShadowFilter();
		myDropFilter.distance=0;
		myDropFilter.strength=3;
		myDropFilter.blurX=2;
		myDropFilter.blurY=2;
		var myFilters:Array = btnGridDelete.filters;
		myFilters.push(myDropFilter);
		btnGridDelete.filters=myFilters;
		btnMore.filters=myFilters;
		closeBtn.filters=myFilters;
		
		btnGridDelete.onRelease=function(){
			var dates="";
			for(var i=0;i<tmp.theList.selectedItems.length;i++){
				dates+=tmp.theList.selectedItems[i].value+";";
			}
			tmp.theList.removeSelectedElements();
			tmp._parent.removeScheduledDays(dates);
		}
		btnMore.onRelease=function(){
			if(tmp.theList.selectedItems.length==1){
				tmp._parent.showDaySchedule(tmp.theList.selectedItems[0].value);
			}
		}
		closeBtn.onRelease=function(){
			tmp.close();
		}
	}
	
	function close(){
		this._parent.closeList();
	}
}

