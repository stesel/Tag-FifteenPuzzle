package events {
	import components.Index;
	import flash.events.Event;
	import mvc.Model;

    /**
	 * Custom event for notification of changes in the model
	 * 
	 * @author Albul Alexandr
	 */
	public class ModelEvent extends Event {
		
		public static const MATRIX_CHANGE:String = "matrixChange";
		public static const TIME_CHANGE:String = "timeChange";
		public static const GAME_COMPLETE:String = "gameComplete";
		
		private var _numBox:int;
		private var _indx:Index;

		public function ModelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, numBox:int = 0, indx:Index = null) 
		{
			super(type, bubbles, cancelable);
			
			this._numBox = numBox;
			this._indx = indx;
		}
		
		public override function clone():Event 
		{ 
			return new ModelEvent(type, bubbles, cancelable, _numBox, _indx);
		} 
		
		public override function toString():String
		{ 
			return formatToString("EventModel", "numBox", "indx", "bubbles", "cancelable", "eventPhase");
		} 
		
		public function get numBox():int
		{
			return _numBox;
		}

		public function get indx():Index 
		{
			return _indx;
		}

	}

}