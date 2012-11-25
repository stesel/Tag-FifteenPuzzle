package mvc 
{
	import events.GameEvent;
	import events.ModelEvent;
	import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
	import flash.display.Sprite;
    /**
	 * ...
	 * @author Leonid Trofimchuk
	 */
	public class Controller extends EventDispatcher 
	{
        private var _container:Sprite;
		private var _model:Model;
		
		public function Controller(model:Model = null) 
		{
			this._model = model;
			startGame()
		}
		
//-------------------------------------------------------------------------------------------------
//
//  Methods
//
//-------------------------------------------------------------------------------------------------
		
        public function startGame():void 
		{
			this._model.addEventListener(ModelEvent.GAME_COMPLETE, onGameComplete);
        }
		
		public function stopGame():void 
		{
			this._model = null;
		}
		
		public function menuButtonPressed():void 
		{
			this.dispatchEvent(new GameEvent(GameEvent.CALL_MENU));
		}
		
		public function onBoxClick(numBox:int):void 
		{
			_model.tryChange(numBox);
		}
		
//-------------------------------------------------------------------------------------------------
//
//  Event handlers
//
//-------------------------------------------------------------------------------------------------
			
		private function onGameComplete(e:ModelEvent):void 
		{
			this._model.removeEventListener(ModelEvent.GAME_COMPLETE, onGameComplete);
			this.dispatchEvent(new GameEvent(GameEvent.GAME_COMPLETE));
			stopGame();
		}
		
    }
 
}