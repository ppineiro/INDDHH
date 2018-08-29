	import flash.display.BitmapData;
	import flash.net.FileReference;
	import mx.events.EventDispatcher;
	
	import mx.utils.Delegate;
	
	class com.util.BitmapExporter {
		
		//public  static var gatewayURL:String           = "http://stw126:8080/Apia2.3/imageUpload.jsp";
		//public  static var gatewayURL:String			= _global.PROCESS_ACTION + "processImageUpload";
		public  static var gatewayURL:String			= "administration.ProcessAction.do?action=processImageUpload"+_global.windowId;
		public  static var timeslice:Number            	= 1000;
		public  static var blocksize:Number            	= 150000;
		public  static var connectionTimeout:Number   	= 5000;
		public  static var deleteAfterDownload:Boolean 	= true;
		
		
		private static var instance:BitmapExporter;
		
   	 	private static var dispatchEvent:Function;
		
		private var connectionTimeoutID:Number;
		private var timeoutID:Number;
		
		
		private var initialized:Boolean    = false;
		private var busy:Boolean           = false;
		private var dontRetrieve:Boolean   = false;
		private var saveMode:String;
		private var fileRef:FileReference;
		private var status:String = "idle";
		private var lastY:Number;
		private var lastX:Number;
		private var pixels:Array;
		private var pixels_r:Array;
		private var pixels_g:Array;
		private var pixels_b:Array;
		
		private var palette:Array;
		
		private var totaltimer:Number;
		private var uniqueID:String;
		private var filename:String;
		private var jpegQuality:Number;
		private var bitmap:BitmapData;
		private var bitmapWidth:Number;
		private var bitmapHeight:Number;
		private var sentBytes:Number;
		private var bitmask:Number;
		private var service:LoadVars;
		private var encodeBase:Number = 128;
		private var lastHTTPStatus:Number;
		
		private var linesPerPackage=10;
		
		private static var b64chars:Array;
		
		private function BitmapExporter()
		{
			EventDispatcher.initialize ( BitmapExporter ) ;
			initArrays();
		}
		
		static public function addEventListener( event:String, listener:Object ):Void
		{
			if ( instance == undefined )
			{
				instance = new BitmapExporter();
			}
			addEventListener( event, listener );
		}
		
		static public function removeEventListener( event:String, listener:Object ):Void
		{
			if ( instance == undefined )
			{
				instance = new BitmapExporter();
			}
			removeEventListener( event, listener );
		}
		
		static public function saveBitmap( bitmap:BitmapData,lossBits:Number, jpegQuality:Number, dontRetrieve:Boolean ):Boolean
		{
			// currently supported modes are:
			//
			// "turboscan":  pixels are converted to base10 - no timeout checking, no bitmask. Fastest scan, but biggest data size.
			// "fastscan":   pixels are converted to base36 - with timer check, 
			// "default":    pixels are converted to base128 
			// "palette":    a lookup table is created and the pixels are run length encoded
			// "rgb_rle":    
			
			return BitmapExporter.getInstance()._saveBitmap( bitmap, lossBits, jpegQuality, dontRetrieve );
		}
		
		static public function getStatus():String
		{
			return BitmapExporter.getInstance().status;
		}
		static public function getService():LoadVars
		{
			return BitmapExporter.getInstance().service;
		}
		
		static public function resetStatus():Void
		{
			BitmapExporter.getInstance().reset();
		}
		
		static public function cancel():Void
		{
			if ( BitmapExporter.getStatus() != "idle" )
			{
				BitmapExporter.getInstance().dropImageHandle();
				BitmapExporter.getInstance().setStatus( "cancelled" );
			}
		}
		
		static public function getInstance():BitmapExporter
		{
			if ( instance == undefined )
			{
				instance = new BitmapExporter();
			}
			return instance;
		}
		
		static public function deleteImage( externalID:String ):Void
		{
			BitmapExporter.getInstance().dropImageHandle( externalID );
		}
		
		private function _saveBitmap( _bitmap:BitmapData, lossBits:Number, _jpegQuality:Number, _dontRetrieve:Boolean ):Boolean	{
			if ( status == "idle" && _bitmap != null && _bitmap.height > 0 && _bitmap.width > 0){
				totaltimer 					= getTimer();
				bitmap                  = _bitmap.clone();
				//filename                = _filename;
				jpegQuality             = ( _jpegQuality == null ? 75 : _jpegQuality );
				bitmapWidth             = bitmap.width;
				bitmapHeight            = bitmap.height;
				dontRetrieve            = ( _dontRetrieve == true );

				
				var mode = "default";
				saveMode                = mode.toLowerCase()
				
				lossBits = Math.floor( Number( lossBits ) );
				if ( isNaN ( lossBits ) ) lossBits = 0;
				if ( lossBits < 0)        lossBits = 0;
				if ( lossBits > 7)        lossBits = 7;
				bitmask = 0xff - ( Math.pow( 2, lossBits ) - 1 );
				bitmask = ( bitmask << 16 ) | ( bitmask << 8 ) | bitmask; 
				
				if ( filename.split(".").pop().toLowerCase() == "bmp" )
				{
					flipBMP();
				}
				
				getImageHandle();
				
				onScanProgress ( 0, "initializing" );
				
				return true;
				
			} else {
				error( "saveBitmap Arguments are not correct" );
				return false;
				
			}
		}
		
		private function reset( keepImage:Boolean ):Void
		{
			if ( !keepImage && uniqueID != null ) dropImageHandle();
			
			setStatus( "idle" );
			busy = false;
			
			bitmap.dispose();
			
			_global.clearTimeout( timeoutID );
			
			delete uniqueID;
			delete saveMode;
			delete filename;
			delete jpegQuality;
			delete pixels;
			delete palette;
			delete bitmapWidth;
			delete bitmapHeight;
		}
		
		private function initArrays():Void{
			b64chars = String('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/').split("");
		}
		
		private function getImageHandle():Void{
			setStatus( "contacting server" );
				
			connectionTimeoutID = _global.setTimeout( this, "onConnectionTimeout", connectionTimeout );
			
			initService();
			service.mode    = "getImageHandle";
			service.width   = bitmapWidth;
			service.height  = bitmapHeight;
			service.onLoad  = Delegate.create( this, onImageHandle );
			service.addRequestHeader("Content-length",(service.toString().length+100)+"");
			service.sendAndLoad( gatewayURL, service, "POST" );
		}
		
		private function scanBitmap():Void{
			var pixel:Number;
			if(busy){
				timeoutID = _global.setTimeout( this, "scanBitmap", 50 );
				return;
			}
			//trace("scanBitmap "+busy+" "+lastY);
			//trace("scanBitmap "+lastY +" "+ bitmapHeight);
			if ( status == "contacting server" ){
				setStatus( "sending" );
				lastX     = 0;
				lastY     = 0;
				sentBytes = 0;
				busy      = false;
				
			} else if ( lastY >= bitmapHeight ){
				if ( !busy ){
					onScanProgress ( 0.95, "retrieving" );
					save();
				} else {
					timeoutID = _global.setTimeout( this, "scanBitmap", 50 );
				}
				return;
			}
			
			var x:Number;
			var y:Number      = lastY;
			var timer:Number  = getTimer();
			var lines:Number  = 0;
			var firstX:Number = lastX;
			var thebitmask:Number = this.bitmask;
            var thebitmapWidth:Number = this.bitmapWidth;
            var thebitmapHeight:Number = this.bitmapHeight;
					
			onScanProgress ( 0.05 + 0.9 * ( lastY / thebitmapHeight ), "reading pixels" );
			
			var p:Number = 0;
			pixels = [];
			
			var tempPixels:Array  = [];
			
			do {
				x = lastX;
				lastX = 0;
				do {
					pixels[p++] =  bitmap.getPixel( x, y ) & thebitmask ;
					//pixels[p++] =  bitmap.getPixel( x, y );
				} while ( ++x  < thebitmapWidth && ( getTimer() - timer < timeslice ) )
				if ( x == thebitmapWidth ){
					lines++;
				} else {
					lastX = x;
					break;
				}
				/*if(y  < thebitmapHeight){
					addPixelBlock( lastY, lines );
				}*/
				y++;
			}  while ( ( y < (lastY+linesPerPackage) )  &&  y<bitmapHeight && ( getTimer() - timer < timeslice ))
				
		
			addPixelBlock( lastY, lines );
			
			lastY  = y;
			lastX %= thebitmapWidth;
		}
		
		private function dropImageHandle( externalID:String ):Void{
			
			initService();
			service.mode         = "dropImageHandle";
			service.uniqueID     = ( externalID != null ? externalID : uniqueID );
			service.onLoad       = Delegate.create( this, onDropImageHandle );
			service.addRequestHeader("Content-length",(service.toString().length+100)+"");
			service.sendAndLoad( gatewayURL, service, "POST" );
			
		}
			
		private function addPixelBlock( top:Number, lines:Number ):Void{
			//trace(" addPixelBlock "+busy);
			if (!busy){
				onScanProgress ( 0.05 + 0.9 * ( ( top + lines ) / bitmapHeight ), "sending" );
			
				busy = true;
				
				initService();
				service.mode      = "default";
				service.sentBytes = 0;
				service.uniqueID  = uniqueID;
				
				service.bitmapString  = arrayToBase64( pixels, 24 );
				
				service.onHTTPStatus = Delegate.create( this, onHTTPStatus );
				service.onLoad       = Delegate.create( this, onAddPixelBlock );
				service.addRequestHeader("Content-length",(service.toString().length+100)+"");
				service.sendAndLoad( gatewayURL, service, "POST" );
				
				timeoutID = _global.setTimeout( this, "scanBitmap", 50 );
				
			} else {
				onScanProgress ( 0.05 + 0.9 * ( ( top + lines ) / bitmapHeight ), "Waiting for Server..." );
				timeoutID = _global.setTimeout( this, "addPixelBlock" , 100, top, lines );
			}
		}
		
		private function save():Void{
			//trace(" save ");
			if ( status == "sending" ){
				delete pixels;
				delete palette;
				
				setStatus( "retrieving" );
				
				initService();
				service.mode         = "save";
				service.width        = bitmapWidth;
				service.height       = bitmapHeight;
				service.uniqueID     = uniqueID;
				service.filename     = filename;
				service.quality      = jpegQuality;
				service.onLoad       = Delegate.create( this, onSave );
				service.addRequestHeader("Content-length",(service.toString().length+100)+"");
				service.sendAndLoad( gatewayURL, service, "POST" );
			}
		}
		
		function arrayToBase64( data:Array, bits:Number ):String
		{
			
			var l:Number = data.length;
			var n:Number;
			var a:String = "";
			var i:Number = 0;
			var remain:Number;
			var b64:Array = b64chars;
			
			switch ( bits )
			{
				case 8:
					remain = l % 3;
					l-=remain;
					while ( l  > 0 ){
						n = data[ i++ ] << 16 | data[ i++ ] << 8 | data[ i++ ];
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
						l-=3;
					}  
					if ( remain == 1 )
					{
						n = data[ i ];
						a += b64[(n>>2) & 0x3F];
						a += b64[(n<<4) & 0x3F];
						a += "=";
					} else if ( remain == 2 )
					{
						n = (data[ i++ ] << 8) | data[ i ];
						a += b64[(n>>10) & 0x3F];
						a += b64[(n>>4) & 0x3F];
						a += b64[(n<<2) & 0x3F];
						a += "=";
						
					}
					
				break;
				
				case 16:
				
					remain = l % 3;
					l-=remain;
					while ( l  > 0 ) {
						n = (data[ i++ ] << 16) | data[ i ];
						a += b64[(n>>26) & 0x3F];
						a += b64[(n>>20) & 0x3F];
						a += b64[(n>>14) & 0x3F];
						a += b64[(n>> 8) & 0x3F];
						a += b64[(n>> 2) & 0x3F];
						n = ((data[i++] & 0x3) << 16) | data[i++];
						a += b64[(n>>12) & 0x3F];
						a += b64[(n>>6) & 0x3F];
						a += b64[n & 0x3F];
						l-=3;
					} 
					
					if ( remain == 1 )
					{
						n = data[ i ];
						a += b64[(n>>10) & 0x3F];
						a += b64[(n>>4) & 0x3F];
						a += b64[(n<<2) & 0x3F];
						a += "=";
					} else if ( remain == 2 )
					{
						n = (data[ i++ ] << 16) | data[ i ];
						a += b64[(n>>26) & 0x3F ];
						a += b64[(n>>20) & 0x3F ];
						a += b64[(n>>14) & 0x3F ];
						a += b64[(n>> 8) & 0x3F ];
						a += b64[(n>> 2) & 0x3F ];
						n = ( (data[i]<< 4) & 0x3F );
						a += b64[n];
						a += "==";
					}
					
				break;
				
				case 24:
					 while ( l--  > 0 ) {
						n = data[ i++ ];
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
					} 
				break;
				
				case 32:
					remain = l % 3;
					l-=remain;
					
					while ( l  > 0 ) {
						
						n = (data[ i ] >> 8) & 0xffffff;
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
						
						n = ((data[ i++ ] & 0xff) << 16) | ((data[ i ] >> 16)& 0xffff);
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
						
						n = ((data[ i++ ] & 0xffff) << 8) | ((data[ i ] >> 24) & 0xff);
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
						
						n = (data[ i++ ] & 0xffffff);
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
						
						l-=3;
					}  
					
					if ( remain == 1)
					{
						n = data[ i ];
						a += b64[(n>>26) & 0x3F ];
						a += b64[(n>>20) & 0x3F ];
						a += b64[(n>>14) & 0x3F ];
						a += b64[(n>> 8) & 0x3F ];
						a += b64[(n>> 2) & 0x3F ];
						a += b64[(n<< 4) & 0x3F ];
						a += "==";
					}  else if ( remain == 2)
					{
						n = (data[ i ] >> 8) & 0xffffff;
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[ n & 0x3F];
						
						n = ((data[ i++ ] & 0xff) << 16) | ((data[ i ] >> 16)& 0xffff) ;
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a += b64[n & 0x3F];
						
						n = ((data[ i++ ] & 0xffff) << 8) 
						a += b64[(n>> 18)  & 0x3F];
						a += b64[(n>> 12)  & 0x3F];
						a += b64[(n>> 6) & 0x3F];
						a+="=";
						
					} 
					
				break;
			}
			
			return a;
			
		}
			
		private function initService():Void
		{
			service              = new LoadVars();
			service.success      = 0;
			service.onHTTPStatus = Delegate.create( this, onHTTPStatus );
			lastHTTPStatus       = null;
		}
			
		private function error( message:String ):Void
		{
			trace( message );		
			
			BitmapExporter.dispatchEvent({
										 type:    "error", 
										 target:  this, 
										 message: "ERROR: " + message
										 });
		
			reset();
		}
		
		private function flipBMP():Void
		{
			var temp_bitmap:BitmapData = bitmap.clone();
			bitmap.fillRect( bitmap.rectangle, 0 );
			bitmap.draw( temp_bitmap, new flash.geom.Matrix( -1, 0, 0, 1, bitmap.width, 0 ) );
			temp_bitmap.dispose();
		}
		
		/*----------------------------------------------------------
								EVENTS
		----------------------------------------------------------*/
			
		private function onImageHandle( success:Boolean ):Void
		{
			_global.clearTimeout( connectionTimeoutID );
			
			if (!success)
			{
				error( "[onImageHandle] HTTP Error " + lastHTTPStatus );
				return;
			}
			
			if  ( status == "cancelled" )
			{
				reset();
				return;
			}
			
			if ( service.success == "1" )
			{
					uniqueID = service.uniqueID;
					onScanProgress( 0.05, "Analysing Bitmap" );
					timeoutID = _global.setTimeout( this, "scanBitmap" ,50 );
			} else 
			{
				error( "[onImageHandle] " + service.error );
			}
		}
		
		private function onHTTPStatus( httpStatus:Number ):Void
		{
			lastHTTPStatus = httpStatus;
			
			if ( httpStatus >= 400 )
			{
				error( "HTTP error " + httpStatus );
			}
		}
			
		private function onAddPixelBlock( success:Boolean ):Void{
			//trace("onAddPixelBlock");
			busy = false;
			
			if ( !success )
			{
				error( "[onAddPixelBlock] HTTP error " + lastHTTPStatus );
				return;
			} 
			
			if  ( status == "cancelled" )
			{
				reset();
				return;
			}
			if ( service.success == "1" ){
				sentBytes += Number( service.sentBytes );
				status="sending";
				timeoutID = _global.setTimeout( this, "scanBitmap" ,50 );
			} else if ( service.success == "0" ){
				error( "[onAddPixelBlock] " + service.error );
			} else {
				error( "[onAddPixelBlock] No Server Response (possible silent PHP crash)");
			}
			
		}
		
		private function onSave( success:Boolean ):Void
		{
			if (!success)
			{
				error( "[onSave] HTTP error "+lastHTTPStatus );
				return;
			}
			
			if  ( status == "cancelled" )
			{
				reset();
				return;
			}
			
			if ( service.success=="1" )	{
				totaltimer = getTimer() - totaltimer;
				if ( !dontRetrieve )
				{
					setStatus( "downloading" );
					
					//fileRef = new FileReference();
					//fileRef.addListener( this );
					
					//onProgress( fileRef, 0 , 0 );
					
					/*if( !fileRef.download( service.url + ( deleteAfterDownload ? "&delete=1" : "" ), filename ) ) 
					{
						error( "[onSave] Dialog box failed to open." );
					}*/
				} else {
					onSaved( service.url, service.filename );
				}
			} else 
			{
				error( "[onSave] " + service.error );
			}
		}
		
		private function onDropImageHandle( success:Boolean ):Void
		{
			if (!success)
			{
				error( "[onDropImageHandle] HTTP error "+ lastHTTPStatus );
			}
		}
		
		
		private function onScanProgress( progress:Number, message:String ):Void {
			BitmapExporter.dispatchEvent({
										 type:    "progress", 
										 target:  BitmapExporter, 
										 current: progress, 
										 total:   1, 
										 message: message 
										 })
		}
		
		private function onSelect( file:FileReference ):Void 
		{
    		BitmapExporter.dispatchEvent({
										 type:   "select", 
										 target: BitmapExporter 
										 })
		}

		private function onCancel( file:FileReference ):Void 
		{
    		BitmapExporter.dispatchEvent({
										 type:   "cancel", 
										 target: BitmapExporter 
										 })
			reset();
		}

		private function onOpen(file:FileReference):Void 
		{
    		BitmapExporter.dispatchEvent({
										 type:     "open", 
										 target:   BitmapExporter, 
										 filename: file.name 
										 })
		}

		private function onProgress( file:FileReference, bytesLoaded:Number, bytesTotal:Number):Void 
		{
    		BitmapExporter.dispatchEvent({
										 type:    "progress", 
										 target:  BitmapExporter, 
										 current: bytesLoaded, 
										 total:   bytesTotal, 
										 message: "downloading" 
										 })
		}

		private function onComplete( file:FileReference ):Void 
		{
			BitmapExporter.dispatchEvent({
										 type:             "complete", 
										 target:           BitmapExporter, 
										 filename:         file.name,
										 sentBytes:		   sentBytes,
										 time:			   totaltimer,
										 compressionRatio: sentBytes / (bitmapWidth * bitmapHeight * 4)
										 });
			reset();
		}
		
		private function onSaved( serviceUrl:String, fileName:String ):Void 
		{
			BitmapExporter.dispatchEvent({
										 type:             "saved", 
										 target:           BitmapExporter, 
										 url:              serviceUrl,
										 fileName:		   fileName,
										 uniqueID:		   uniqueID,
										 sentBytes:		   sentBytes,
										 time:			   totaltimer,
										 compressionRatio: sentBytes / (bitmapWidth * bitmapHeight * 4)
										 });
			reset( true );
		}

		private function onIOError( file:FileReference ):Void 
		{
			error ( "IO error with file " + file.name);
		}
		
		private function onConnectionTimeout():Void {
			error ( "Connection Timeout - no response from server" );
		}

		private function setStatus( _status:String ):Void
		{
			status = _status;
			BitmapExporter.dispatchEvent({
										 type:   "status", 
										 target: BitmapExporter, 
										 status: status
										 });
			
		}
		
	}
