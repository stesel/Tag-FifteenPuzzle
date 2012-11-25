package states
{
	import adobe.utils.CustomActions;
	import components.FPSText;
	import events.GameEvent;
	import events.StateEvent;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.fscommand;
	import flash.utils.setTimeout;
	/**
	 * ...	State Manager
	 * @author Leonid Trofimchuk
	 */
	public class StateManager
	{
		private var _stage:Stage;				//Main Stage 
		private var _container:Sprite;			//Main Container
		
		private var gameSound:Boolean = true;	//Sound in game
		private var resume:Boolean = false;		//Resume in menu
		
		private var _game:Game;					//Game State
		private var _menu:Menu;					//Menu State 
		private var result:String;							
		
		/**
		 * Constructor
		 * @param	stage		Main Stage 
		 * @param	container	Main Container
		 */
		public function StateManager(stage:Stage, container: Sprite) 
		{
			this._stage = stage;
			this._container = container;
			initMenu();
		}
			
//-------------------------------------------------------------------------------------------------
//
//	Methods Definition
//
//-------------------------------------------------------------------------------------------------	
			
		private function initMenu():void 
		{
			_menu = new Menu(_stage, _container, gameSound, resume);
			_menu.addEventListener(StateEvent.STATE_CHANGED, menu_stateChanged);
		}
			
		private function removeMenu():void
		{
			_menu.removeEventListener(StateEvent.STATE_CHANGED, menu_stateChanged);
			_menu = null;
		}
			
		private function setSound():void
		{
			gameSound = !gameSound;
			if (_game != null)
				_game.withSound = gameSound;
		}
		
		private function leaveGame():void
		{
			
			if (_game != null)
			{
				_game.removeGame();
				_game = null;
			}
		}
		
		private function initGame():void
		{	
			_game = new Game(_container);
			_game.addEventListener(GameEvent.GAME_COMPLETE, gameComplete);
			_game.addEventListener(GameEvent.CALL_MENU, game_callMenu);
			_game.withSound = gameSound;
		}
			
		private function closeApp():void 
		{
			fscommand("quit");
		}
		
//-------------------------------------------------------------------------------------------------
//
//	Event Handlers Definition
//
//-------------------------------------------------------------------------------------------------	
		
		private function gameComplete(e:GameEvent):void 
		{
			result = _game.result;
			var message:Messages;
			message = new Messages(_stage, _container, String("Congratulations!!! \n Game Complete \n "  + result), 0x3bb437);
			message.addEventListener(Messages.REMOVE_MESSAGE, onGameComplete);
		}
		
		private function game_callMenu(e:GameEvent):void 
		{
			if (_menu != null)
				return;
			_game.deactivateGame();
			resume = true;
			initMenu();
		}
			
		private function menu_stateChanged(e:StateEvent):void 
		{
			switch (e.onState)
			{
				case "RESUME":
					_game.activateGame();
					removeMenu();
					break;
				case "NEW GAME":
					initGame();
					removeMenu();
					break;
				case "EXIT":
					closeApp();
				case "soundSwitch":
					setSound();
					break;
				default:
					closeApp();
			}
		}
		
		private function onGameComplete(e:Event):void 
		{
			leaveGame();
			resume = false;
			initMenu();
		}
	}

}