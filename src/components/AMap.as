package components {
    import flash.utils.Dictionary;
		
	/**
     * ...
     * @author Leonid Trofimchuk
     */
    public class AMap {

        private var map:Dictionary;

        public function AMap() 
		{
            map = new Dictionary();
        }

        public function put(key:String, value:*):void 
		{
            map[key] = value;
        }

        public function removeByKey(key:String):* 
		{
            var value:* = map[key];
            delete map[key];
            return value;
        }

        public function getValue(key:String):* 
		{
            return map[key];
        }

        public function getValueByIndex(indx:Index):* 
		{
            return map[indx.index];
        }

        public function getKey(value:*):String 
		{
            for (var k:String in map) {
                if (map[k] == value) return k;
            }
            return null;
        }

        public function getIndex(value:*):Index
		{
            var k:String = getKey(value);
            var indx:Index;
			
            if (k != null) {
                indx = new Index(k);
            }
            return indx;
        }

        public function size():int 
		{
            var n:int = 0;
            for (var v:String in map)
			{
                n++;
            }
            return n;
        }

        public function isEmpty():Boolean 
		{
            return size() == 0;
        }

        public function containsKey(key:String):Boolean 
		{
            return map[key] != null;
        }

        public function clear():void {
            map = new Dictionary();
        }

        public function values():Dictionary {
            var values:Dictionary = new Dictionary();
            for (var k:String in map) {
                values[k] = getValue(k);
            }
            return values;
        }

        public function swap(val1:*, val2:*):void 
		{
            var key1:* = getKey(val1);
            var key2:* = getKey(val2);
            put(key1, val2);
            put(key2, val1);
        }

    }
}

