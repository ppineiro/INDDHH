var tl;
function onLoad(startTimeline,intervalUnit1,intervalUnit2) {
  var eventSource = new Timeline.DefaultEventSource();
  var bandInfos = [    
    Timeline.createBandInfo({
        showEventText:  false,
        trackHeight:    0.5,
        trackGap:       0.2,
        eventSource:    eventSource,
        date:           startTimeline,
        width:          "70%", 
        intervalUnit:   intervalUnit1, 
        intervalPixels: 200,
        zoomIndex:      10,
        zoomSteps:      new Array(
          {pixelsPerInterval: 280,  unit: Timeline.DateTime.HOUR},
          {pixelsPerInterval: 140,  unit: Timeline.DateTime.HOUR},
          {pixelsPerInterval:  70,  unit: Timeline.DateTime.HOUR},
          {pixelsPerInterval:  35,  unit: Timeline.DateTime.HOUR},
          {pixelsPerInterval: 400,  unit: Timeline.DateTime.DAY},
          {pixelsPerInterval: 200,  unit: Timeline.DateTime.DAY},
          {pixelsPerInterval: 100,  unit: Timeline.DateTime.DAY},
          {pixelsPerInterval:  50,  unit: Timeline.DateTime.DAY},
          {pixelsPerInterval: 400,  unit: Timeline.DateTime.MONTH},
          {pixelsPerInterval: 200,  unit: Timeline.DateTime.MONTH},
          {pixelsPerInterval: 100,  unit: intervalUnit1} // DEFAULT zoomIndex
        )
    })
    ,
    Timeline.createBandInfo({
        showEventText:  false,
        trackHeight:    0.5,
        trackGap:       0.2,
        eventSource:    eventSource,
        date:           startTimeline,
        width:          "30%", 
        intervalUnit:   intervalUnit2, 
        intervalPixels: 200,
        overview:true
    })
  ];
  
  bandInfos[1].syncWith = 0;
  bandInfos[1].highlight = true;
 
  tl = Timeline.create(document.getElementById("timeLineDiv"), bandInfos);
  
  var url =  CONTEXT + URL_REQUEST_AJAX + '?action=getTimelineEvents&isAjax=true' + TAB_ID_REQUEST;
  Timeline.loadXML(url, function(xml, url) { eventSource.loadXML(xml, url); });
}

Timeline.OriginalEventPainter.prototype._showBubble = function(x, y, evt) {
	if (evt.getDescription()!=""){
		var request = new Request({
			method: 'post',
			url: CONTEXT + evt.getDescription(),
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send(); 
	}
		
} 