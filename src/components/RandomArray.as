package components {
	
	/**
     * ...
     * @author Leonid Trofimchuk
     */
	public class RandomArray extends Object 
	{
		
		public var isPrinted:Boolean;
		
		private var arrayIndx:Array;				// Index Array
		private var arrayData:Array;				// Data Array
		private var i:int;							// Counter
		
		public function RandomArray() 
		{
			
		}
		
//--------------------------------------------------------------------------
//
//  Methods
//
//--------------------------------------------------------------------------
		
		
		public function createRandom(array:Array):void 
		{
			this.arrayData = array;
			this.arrayIndx = createArrayIndx(array);
			this.i = 0;
			this.isPrinted = false;
			
			var k:int;
			while (k <= array.length * 2) 
			{					
				var r1:int = Math.random() * array.length;
				var r2:int = Math.random() * array.length;
				this.arrayIndx = swap(r1, r2, this.arrayIndx);
				k++;
			}
		}
		
		public function getRandomItem():* 
		{
			var item:* = this.arrayData[this.arrayIndx[i]];
			if (i == arrayIndx.length - 1)					
				isPrinted = true;
			i++;
			return item;
		}
		
		public function createArrayIndx(array:Array):Array 
		{
			var arrResult:Array = new Array();
			for (var i:int = 0; i < array.length; i++) 
			{
				arrResult.push(i);
			}
			return arrResult;
		}		
		
		public function swap(indxItem1:int, indxItem2:int, array:Array):Array 
		{
			var tmpItem:* = array[indxItem1];
			array[indxItem1] = array[indxItem2];
			array[indxItem2] = tmpItem;
			return array;
		}
		
		
	}
	
}