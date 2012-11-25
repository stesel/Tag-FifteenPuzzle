package components 
{
     /**
     * ...	Class presents 2D Array in String type 121,123
     * @author Leonid Trofimchuk
     */
    public class Index 
	{
        private var _i:int;
		private var _j:int;
        private var _index:String;
		
        public function Index(index:String = null) 
		{
            this.index = index;
        }
		
        public function put(index:String):void
		{
            this.index = index;
        }
		
        public function putIJ(i:int, j:int):void
		{
            this.i = i;
            this.j = j;
        }
		
        public function generateIndx(incI:int, incJ:int):Index
		{
            var result:Index = new Index();
            result.putIJ(this.i + incI, this.j + incJ);
            return result;
        }
		
        public function get index():String 
		{
            return _index;
        }
		
        public function set index(value:String):void 
		{
            if (value == null || value == "") return;
            this._index = value;
            this._i = int(value.substring(0, value.indexOf(",")));
            this._j = int(value.substring(value.indexOf(",") + 1, value.length));
        }
		
        public function get i():int
		{
            return _i;
        }
		
        public function get j():int 
		{
            return _j;
        }
		
        public function set i(value:int):void 
		{
            this.index = value.toString() + "," + j.toString();
        }
		
        public function set j(value:int):void 
		{
            this.index = i.toString() + "," + value.toString();
        }
		
        public function isEmpty():Boolean
		{
            return index == null;
        }
    }

}
