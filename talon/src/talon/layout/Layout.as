package talon.layout
{
	import flash.utils.Dictionary;

	import talon.Node;

	public class Layout
	{
		//
		// Static Layout Registry
		//
		public static const ABSOLUTE:String = "abs";
		public static const FLOW:String = "flow";
		public static const GRID:String = "grid";

		private static var _initialized:Boolean = false;
		private static var _layout:Dictionary = new Dictionary();
		private static var _observableAttribute:Dictionary = new Dictionary();
		private static var _observableChildrenAttribute:Dictionary = new Dictionary();

		public static function registerLayoutAlias(aliasName:String, layout:Layout, observableAttribute:Array = null, observableChildrenAttribute:Array = null):void
		{
			if (_layout[aliasName] != null) throw new ArgumentError("Layout alias " + aliasName + "already registered");

			_layout[aliasName] = layout;

			var helper:Dictionary;
			var attribute:String;

			helper = new Dictionary();
			for each (attribute in observableAttribute) helper[attribute] = true;
			_observableAttribute[aliasName] = helper;

			helper = new Dictionary();
			for each (attribute in observableChildrenAttribute) helper[attribute] = true;
			_observableChildrenAttribute[aliasName] = helper;
		}

		/** Get layout strategy by it's name. */
		public static function getLayoutByAlias(aliasName:String):Layout
		{
			initialize();
			return _layout[aliasName];
		}

		/** Layout must be invalidated if node attribute changed. */
		public static function isObservableAttribute(layout:String, attributeName:String):Boolean
		{
			initialize();
			return _observableAttribute[layout][attributeName];
		}

		/** Layout must be invalidated if node child attribute changed. */
		public static function isObservableChildrenAttribute(layout:String, attributeName:String):Boolean
		{
			initialize();
			return _observableChildrenAttribute[layout][attributeName];
		}

		private static function initialize():void
		{
			if (_initialized == false)
			{
				_initialized = true;
				if (!_layout[ABSOLUTE]) registerLayoutAlias(ABSOLUTE, new AbsoluteLayout(), null, ["width", "height"]);
				if (!_layout[FLOW]) registerLayoutAlias(FLOW, new FlowLayout(), null, ["width", "height"]);
				if (!_layout[GRID]) registerLayoutAlias(GRID, new GridLayout());
			}
		}

		//
		// Layout methods
		//
		/** This method will be call while arranging, and must calculate node width in pixels, based on node children. */
		public function measureAutoWidth(node:Node, width:Number, height:Number):Number
		{
			return 0;
		}

		/** This method will be call while arranging, and must calculate node height in pixels, based on node children. */
		public function measureAutoHeight(node:Node, width:Number, height:Number):Number
		{
			return 0;
		}

		/** Arrange (define bounds and commit) children within size. */
		public function arrange(node:Node, width:Number, height:Number):void
		{
			// NOP
		}
	}
}