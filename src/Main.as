package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import states.StateManager;
	/**
	 * ...
	 * @author Leonid Trofimchuk
	 */
	[SWF(backgroundColor = "#272729", frameRate = "30", width = "800", height = "600")]
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		
		private var stateMng:StateManager;				 	//State Manager

		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stateMng = new StateManager(stage, this);
		}

	}

}