package states {

	import events.GameEvent;
	import events.StateEvent;
    import flash.display.Sprite;
    import flash.events.Event;
	import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
    import flash.utils.setTimeout;
	import mvc.Controller;
	import mvc.Model;
	import mvc.View;
	
	/**
	 * ...
	 * @author Leonid Trofimchuk
	 */
	public class Game extends EventDispatcher implements IState{

		private var controller:Controller;
		private var model:Model;
		private var view:View;
		private var _container:Sprite;
		private var _result:String;
		
		private var _withSound:Boolean;
		
		public function Game(container:Sprite) 
		{
            this._container = container;
			
			enterState();
		}


//-------------------------------------------------------------------------------------------------
//
//  Interface Methods definition
//
//-------------------------------------------------------------------------------------------------

		public function enterState():void 
		{
            model = new Model();
			controller = new Controller(model);
			view = new View(model, controller);
			
			_container.addChild(view);
			controller.addEventListener(GameEvent.CALL_MENU, controller_callMenu);
			controller.addEventListener(GameEvent.GAME_COMPLETE, onGameComplete);
		}

		public function leaveState():void 
		{
			controller.stopGame();
            while (_container.numChildren != 0)
                _container.removeChildAt(0);
			
			controller.removeEventListener(GameEvent.CALL_MENU, controller_callMenu);
			controller.removeEventListener(GameEvent.GAME_COMPLETE, onGameComplete);
			model = null;
			controller = null;
			view = null;
		}
		
		public function activateGame():void
		{
			view.initListeners();
		}
		
		public function deactivateGame():void
		{
			view.removeListeners();
		}
		
		public function removeGame():void
		{
			view.removeAll();
		}
		
        private function showResults():void 
		{
            this.dispatchEvent(new GameEvent(GameEvent.GAME_COMPLETE));
        }
//-------------------------------------------------------------------------------------------------
//
//  Events handlers
//
//-------------------------------------------------------------------------------------------------
		
		private function controller_callMenu(e:GameEvent):void 
		{
			this.dispatchEvent(new GameEvent(GameEvent.CALL_MENU));
		}
		
		private function onGameComplete(e:GameEvent):void 
		{
			
			_result = view.result;
			setTimeout(showResults, 3000);
		}
		
//-------------------------------------------------------------------------------------------------
//
//  Getters and Setters
//
//-------------------------------------------------------------------------------------------------
		
		public function get withSound():Boolean
		{
			return _withSound;
		}
		
		public function set withSound(value:Boolean):void
		{
			_withSound = value;
			view.withSound = _withSound;
		}
		
		public function get result():String
		{
			return _result;
		}
	}

}