package states 
{
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.BlurFilter;
	import flash.filters.GradientGlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	/**
	 * This class creates Messages
	 * @author Leonid Trofimchuk
	 */
	public class Messages extends Sprite implements IState
	{
		static public const REMOVE_MESSAGE:String = "removeMessage";
		
		private var myTextBox:TextField = new TextField(); 
       	private var format:TextFormat = new TextFormat();
		private var intID:uint;
		private var bkgr:Shape;
		private var _stage:Stage;
		private var _container:Sprite;
		
		public function Messages(mainStage: Stage, container:Sprite, text:String = "empty", backColor:uint = 0x5481e8) 
		{
			_stage = mainStage;
			_container = container;
			//Background
			bkgr = new Shape();
			bkgr.graphics.beginFill(0x000000, 1);
			bkgr.graphics.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
			bkgr.alpha = 0;
			addChild(bkgr);
			//Text Format
			format.font = "Times New Roman"; 
            format.color = 0xffd21e; 
            format.size = 50; 
			format.align = "center";
			format.bold = true; 
            //Text Field
			myTextBox.defaultTextFormat = format; 
			myTextBox.htmlText = text; 
			myTextBox.autoSize = TextFieldAutoSize.LEFT;
			myTextBox.multiline = true; 
            myTextBox.wordWrap = true;
            myTextBox.width = _stage.stageWidth - 50; 
           	myTextBox.selectable = false;
            myTextBox.background = true; 
            myTextBox.backgroundColor = backColor; 
            myTextBox.border = true; 
			//Glow
			var gradientGlow: GradientGlowFilter = new GradientGlowFilter(); 
			gradientGlow.distance = 0; 
			gradientGlow.angle = 45; 
			gradientGlow.colors = [0x000000, 0xffffff];
			gradientGlow.alphas = [0, 1]; 
			gradientGlow.ratios = [0, 255]; 
			gradientGlow.blurX = 10; 
			gradientGlow.blurY = 10; 
			gradientGlow.strength = 2;
			gradientGlow.quality = BitmapFilterQuality.HIGH;
			gradientGlow.type = BitmapFilterType.OUTER;
			//Filters
			var myBlurFilter:BlurFilter = new BlurFilter(1, 1, 2);
			var myArrayFilters:Array = new Array(myBlurFilter, gradientGlow);
			myTextBox.filters = myArrayFilters;
			//TextField Align
			myTextBox.x = (_stage.stageWidth - myTextBox.width) / 2;
			myTextBox.y = (_stage.stageHeight - myTextBox.height) / 2 - 10;
			addChild(myTextBox);
			
			enterState();
		}
		
//-------------------------------------------------------------------------------------------------
//
//  Interface  Methods definition
//
//-------------------------------------------------------------------------------------------------
		
		public function enterState():void 
		{
			_container.addChild(this);
				
			TweenLite.to(myTextBox, 0.5, { alpha: 1 } );
			TweenLite.to(bkgr, 0.5, { alpha: 0.2 } );
				
			intID = setTimeout(tweenThis, 4000);
		}
		
		public function leaveState():void 
		{
			this.dispatchEvent(new Event(Messages.REMOVE_MESSAGE));
			if(_container.contains(this))
				_container.removeChild(this);
		}
		
//-------------------------------------------------------------------------------------------------
//
//  Methods
//
//-------------------------------------------------------------------------------------------------
		
		private function tweenThis():void 
		{
			TweenLite.to(myTextBox, 1, { alpha: 0 } );
			TweenLite.to(bkgr, 1, { alpha: 0, onComplete: leaveState} );
			
		}
		
	}

}