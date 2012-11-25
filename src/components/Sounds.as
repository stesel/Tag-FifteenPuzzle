package components 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	/**
	 * ... Play sounds
	 * @author Leonid Trofimchuk
	 */
	public class Sounds extends	EventDispatcher
	{
		[Embed(source="../../lib/onStepSound.mp3")]				//Embed Step Sound file
		static private const sStep:Class;
		
		[Embed(source="../../lib/onCompleteSound.mp3")]			//Embed Complete Sound file
		static private const sComplete:Class;
				
		private var soundStep: Sound;							//Step Sound
		private var soundComplete: Sound;						//Complete Sound
		
		private var sStepChannel: SoundChannel;					//Complete Sound
		private var sCompleteChannel: SoundChannel;				//Complete Sound
			
		//Constructor
		public function Sounds() 
		{
			soundStep = (new sStep) as Sound;
			soundComplete = (new sComplete) as Sound;
			
		}
		
//-------------------------------------------------------------------------------------------------
//
//	Methods Definition
//
//-------------------------------------------------------------------------------------------------		
		
		public function onStep(type:int = 1):void
		{
			sStepChannel = soundStep.play(0, 0);
			sStepChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		}
		
		public function onComplete():void
		{
			sCompleteChannel = soundComplete.play(0, 0);
			sCompleteChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		}
		
//-------------------------------------------------------------------------------------------------
//
//	Event Handlers
//
//-------------------------------------------------------------------------------------------------	
			
		private function onSoundComplete(e:Event):void 
		{
			var channal:SoundChannel;
			channal = e.target as SoundChannel;
			channal.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			channal = null;
		}

	}

}