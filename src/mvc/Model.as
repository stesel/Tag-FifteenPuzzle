package mvc {
	import components.AMap;
	import components.Index;
	import components.RandomArray;
	import events.ModelEvent;
    import flash.events.EventDispatcher;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /**
     * ...
     * @author Leonid Trofimchuk
     */
    public class Model extends EventDispatcher 
	{
		
        public static const AMOUNT:int = 15;	// Puzzle Ammount
        public static const ROWS:int = 4;		// Rows
        public static const COLS:int = 4;		// Collons
		
        private var _matrix:AMap;   			// Puzzle Matrix
        private var _steps:int;     			// Steps Acount
		private var _time:int;					//Elapsed time
		
        public function Model() 
		{
            init();
        }

//-------------------------------------------------------------------------------------------------
//
//  Public methods
//
//-------------------------------------------------------------------------------------------------
		
		
        public function tryChange(numBox:int):void 
		{
            if (nearEmpty(numBox)) 
			{               						 	
                _matrix.swap(0, numBox);            																			
                _steps++;
				
                this.dispatchEvent(new ModelEvent(ModelEvent.MATRIX_CHANGE, false, false, numBox, _matrix.getIndex(numBox)));	// Notify listeners of changes
				
                if (boxInPlace(numBox)) 
				{
                    this.dispatchEvent(new ModelEvent(ModelEvent.GAME_COMPLETE));												// If all the boxes in place to notify the end of the game
                }
            }
        }

//-------------------------------------------------------------------------------------------------
//
//  Private methods
//
//-------------------------------------------------------------------------------------------------
		
        /**
         * @private
         * Model Init
         */
        private function init():void {
            _matrix = new AMap(); 
			
            // Create a random selection of the array of numbers
            var randArr:RandomArray = new RandomArray();
            randArr.createRandom(randArr.createArrayIndx(new Array(AMOUNT + 1)));
			
            // Create a matrix
            for (var i:int = 1; i <= ROWS; i++) {
                for (var j:int = 1; j <= COLS; j++) {
                    this._matrix.put(i.toString() + "," + j.toString(), randArr.getRandomItem()) ;
                }
            }
        }

        /**
         * 
         * Searching for an empty place near the box
         */
        private function nearEmpty(numBox:int):Boolean
        {
            var indx:Index = this._matrix.getIndex(numBox);

            if ((this._matrix.getValue(indx.generateIndx(1, 0).index) == 0)            // bottom
                    || (this._matrix.getValue(indx.generateIndx(-1, 0).index) == 0)    // top
                    || (this._matrix.getValue(indx.generateIndx(0, 1).index) == 0)     // right
                    || (this._matrix.getValue(indx.generateIndx(0, -1).index) == 0)) {	// left
                return true;
            } else {
                return false;
            }
        }

        /**
         * @private
         * Checking the completion of the game
         */
        private function boxInPlace(numBox:int):Boolean {
            var curI:int = _matrix.getIndex(numBox).i;
            var curJ:int = _matrix.getIndex(numBox).j;
            var origI:int = (numBox % 4 > 0? Math.floor(numBox / 4) + 1 : (numBox / 4) as int);
            var origJ:int = (numBox % 4 != 0)? (numBox % 4) : 4;
            if (curI == origI && curJ == origJ) 								// If the current box is in place, then check all the boxes
			{								
                for (var i:int = 1; i <= Model.AMOUNT; i++)
				{
                    curI = _matrix.getIndex(i).i;       						// Get Index
                    curJ = _matrix.getIndex(i).j;
                    origI = (i % 4 > 0? Math.floor(i / 4) + 1 : (i / 4) as int);
                    origJ = (i % 4 != 0)? (i % 4) : 4;
                    if (curI != origI && curJ != origJ) 						//If any out of place
					{					
                        return false;
                    }
                }
            }
            else 
			{
                return false;
            }
            return true;														// Returns true if everything in its place
        }
		
//--------------------------------------------------------------------------
//
//  Getters
//
//--------------------------------------------------------------------------


        public function get matrix():Object
		{
            return _matrix;
        }
		
        public function get steps():int
		{
            return _steps;
        }
		
    }

}