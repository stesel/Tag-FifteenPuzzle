package {
	import components.InfoText;
	import components.SimplePreloader;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Leonid Trofimchuk
	 * This class is used to check the donwnloaded progress 
	 */
	public class Preloader extends Sprite
	{
		private var preloaderClip:SimplePreloader;	//Preloader Exemplar
		private var value:Number;					//Value of 	Preloader Bar Scale
		private var header:InfoText;				//Welcome text
		
		public function Preloader() 
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init)
		}
		
		private function init(e:Event = null):void 
		{
			if(hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, init);
				
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			
			header = new InfoText(80, 0xffba16, true);
			header.setText("Welcome");
			header.x = (stage.stageWidth - header.width) / 2;
			header.y = header.height * 1.7;
			addChild(header);
			//Add Listeners
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			preloaderClip = new SimplePreloader();
			preloaderClip.x = (stage.stageWidth - preloaderClip.width) / 2;
			preloaderClip.y = (stage.stageHeight - preloaderClip.height) / 2;
			addChild(preloaderClip);
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		//Progress Receiver
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			value = e.target.bytesLoaded / e.target.bytesTotal;
			preloaderClip.setBar(value);
			
			if (value == 1)
				loadingFinished();
		}
			
		//On Finish
		private function loadingFinished():void 
		{
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			setTimeout(startup, 2000);
		}
		
		// TODO hide loader
		private function removeLoader():void
		{
			if(preloaderClip)
				removeChild(preloaderClip);
			preloaderClip = null;
			
			removeChild(header);
			header = null;
			
		}
		
		//Start Main
		private function startup():void 
		{
			removeLoader();
			//Add Main Class
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}