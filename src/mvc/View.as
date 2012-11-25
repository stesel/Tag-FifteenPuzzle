package mvc {
	import com.greensock.TweenMax;
	import components.Index;
	import components.InfoText;
	import components.Sounds;
	import events.ModelEvent;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
    import flash.sampler.ClassFactory;
    import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
    /**
	 * ...
	 * @author Leonid Trofimchuk
	 */
	public class View extends Sprite 
	{
		public static const GAP:uint = 5;       		// Gap Beetween  Puzzles
		public static const MARGIN_LEFT:uint = 34;   	// Left offset
		public static const MARGIN_TOP:uint = 58;   	// Top offset
		public static const DURATION:Number = 0.4; 		// Shift Time
		
		private var boxArray:Array;						//Box Array
		
		private var _model:Model;           			// Model
		private var _controller:Controller;         	// Controller
		
		private var board:Board_graphics;	    		// Board
		private var menuButton:MenuButton_graphics;	    // Menu Button
		private var stepText:InfoText;					// Steps Text
		private var timeText:InfoText;					// Time Text
		private var time:int;     						// Time
        private var timer:Timer;   						// Timer
		private var timeString:String;					
		private var _results:String;									
		
        private var sounds:Sounds;						//Sounds
		private var _withSound:Boolean;					//Sound availible
		
        public function View(model:Model, controller:Controller)
		{
			this._model = model;						// Reference to the model
			this._controller = controller;				// Reference to the model
			init();
		}
		
//-------------------------------------------------------------------------------------------------
//
//  Methods
//
//-------------------------------------------------------------------------------------------------
		/**
		 * @private
		 */
		private function init():void 
		{
			initSounds();
			createBoard();
			createBoxes();
			arrangeBoxes();
			initTimer();
            initListeners();
		}
		
		
        public function initListeners():void 
		{
            _model.addEventListener(ModelEvent.MATRIX_CHANGE, onModelChange);
            _model.addEventListener(ModelEvent.GAME_COMPLETE, onGameComplete);
			menuButton.addEventListener(MouseEvent.CLICK, menuButton_click);
			menuButton.enabled = true;
			for (var i:int = 1; i < boxArray.length; i++) 
			{
				boxArray[i].buttonMode = true;
				boxArray[i].addEventListener(MouseEvent.CLICK, box_onMouseClick);
            }
			
			timer.addEventListener(TimerEvent.TIMER, onTimer);
            timer.start();
        }
		
		public function removeListeners():void 
		{
            _model.removeEventListener(ModelEvent.MATRIX_CHANGE, onModelChange);
            _model.removeEventListener(ModelEvent.GAME_COMPLETE, onGameComplete);
			menuButton.removeEventListener(MouseEvent.CLICK, menuButton_click);
			menuButton.enabled = false;
			for (var i:int = 1; i < boxArray.length; i++) 
			{
				boxArray[i].buttonMode = false;
				boxArray[i].removeEventListener(MouseEvent.CLICK, box_onMouseClick);
            }
			
			timer.removeEventListener(TimerEvent.TIMER, onTimer);
            timer.stop();
        }
		
		public function removeAll():void 
		{
			for (var i:int = 1; i < boxArray.length; i++)
			{
				if(board.contains(boxArray[i]))
				board.removeChild(boxArray[i]);
			}
			this.removeChild(board);
			this.removeChild(menuButton);
			this.removeChild(stepText);
			this.removeChild(timeText);
			this.boxArray.length = 0;
			this.board = null;
			this.menuButton = null;
			this.stepText = null;
			this.timeText = null;
			this.timer = null;
		}
		
		private function initTimer():void 
		{
			timer = new Timer(1000);
		}
		
		private function initSounds():void 
		{
			sounds = new Sounds();
		}
		
		private function createBoard():void 
		{
			board = new Board_graphics();
			this.addChildAt(board, 0);
            			
			menuButton = new MenuButton_graphics();
			menuButton.enabled = false;
			menuButton.x = 580;
			menuButton.y = 450;
			this.addChild(menuButton);
			
			stepText = new InfoText(55);
			stepText.autoSize = TextFieldAutoSize.CENTER;
			stepText.x = 660;
			stepText.y = 148;
			stepText.setText("0");
			this.addChild(stepText);
			
			timeText = new InfoText(55);
			timeText.autoSize = TextFieldAutoSize.CENTER;
			timeText.x = 660;
			timeText.y = 289;
			timeText.setText("--:--");
			this.addChild(timeText);
		}
		
		private function createBoxes():void 
		{
			boxArray = new Array();
			boxArray.push(0);
			boxArray.push(new Box01_graphics());
            boxArray.push(new Box02_graphics());
            boxArray.push(new Box03_graphics());
            boxArray.push(new Box04_graphics());
            boxArray.push(new Box05_graphics());
            boxArray.push(new Box06_graphics());
            boxArray.push(new Box07_graphics());
            boxArray.push(new Box08_graphics());
            boxArray.push(new Box09_graphics());
            boxArray.push(new Box10_graphics());
            boxArray.push(new Box11_graphics());
            boxArray.push(new Box12_graphics());
            boxArray.push(new Box13_graphics());
            boxArray.push(new Box14_graphics());
            boxArray.push(new Box15_graphics());
		}
		
		private function arrangeBoxes():void 
		{
			var box:Sprite;
            var indx:Index;
			
            for (var i:int = 1; i <= Model.AMOUNT; i++) 
			{
                indx = _model.matrix.getIndex(i);              				// Get puzzle index
                box = boxArray[i];                               				// Take puzzle from array
                box.x = MARGIN_LEFT + (indx.j - 1) * (box.width + GAP);  	// Set position
                box.y = MARGIN_TOP + (indx.i - 1) * (box.height + GAP);
                board.addChild(box);
            }
		}

        /**
		 * @private
		 * Move the box according to its index
		 */
		private function moveBox(box:Sprite, indx:Index):void 
		{
			var toX:int = MARGIN_LEFT + (indx.j - 1) * (box.width + GAP);
			var toY:int = MARGIN_TOP + (indx.i - 1) * (box.height + GAP);
			board.addChild(box);
			
			TweenMax.to(box, DURATION, { x:toX, y: toY } );
			if(_withSound)
				sounds.onStep();
		}

        public function getNumBox(box:*):int 
		{
            for (var i:int; i < boxArray.length; i++) {
                if (boxArray[i] == box) {
                    return i;
                }
            }
            return NaN;
        }

//--------------------------------------------------------------------------
//
//  Event handlers
//
//--------------------------------------------------------------------------
		
		private function onModelChange(e:ModelEvent):void
		{
            var numBox:int = e.numBox;
            var indx:Index = e.indx;
            var box:Sprite = this.boxArray[numBox];
			
			moveBox(box, e.indx);
			stepText.text = String(this._model.steps);
		}
			
		private function menuButton_click(e:MouseEvent):void 
		{
			_controller.menuButtonPressed();
		}
		
		private function onGameComplete(e:ModelEvent):void
		{
			if(_withSound)
				sounds.onComplete();
			removeListeners();
		}
			
		private function onTimer(e:TimerEvent):void 
		{
            this.time = timer.currentCount;
			var min:int = time / 60;
            var sec:int = time % 60;
			timeString = (min >= 10? min.toString(): "0" + min.toString()) + ":" + (sec >= 10? sec.toString(): "0" + sec.toString());
			timeText.text = timeString;
        }
			
		private function box_onMouseClick(e:MouseEvent):void 
		{
			var target:Sprite = Sprite(e.target);
            var numBox:int;
            numBox = getNumBox(target);
			
            _controller.onBoxClick(numBox);
		}
		
//--------------------------------------------------------------------------
//
//  Getters and Setters
//
//--------------------------------------------------------------------------

		public function get model():Model
		{ 
			return this._model; 
		}
		
		public function set model(value:Model):void
		{
			this._model = value;
		}
		
		public function get withSound():Boolean
		{
			return _withSound;
		}
		
		public function set withSound(value:Boolean):void
		{
			_withSound = value;
		}
		
		public function get result():String
		{
			_results = "Total time: " + timeString + " \n Total steps: " + stepText.text;  
			return _results;
		}
    }

}