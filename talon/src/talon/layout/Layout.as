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
		private static var _observableSelfAttribute:Dictionary = new Dictionary();
		private static var _observableChildAttribute:Dictionary = new Dictionary();

		public static function registerLayoutAlias(aliasName:String, layout:Layout, observableSelfAttribute:Array = null, observableChildAttribute:Array = null):void
		{
			if (_layout[aliasName] != null) throw new ArgumentError("Layout alias " + aliasName + "already registered");

			_layout[aliasName] = layout;

			var helper:Dictionary;
			var attribute:String;

			helper = new Dictionary();
			for each (attribute in observableSelfAttribute) helper[attribute] = true;
			_observableSelfAttribute[aliasName] = helper;

			helper = new Dictionary();
			for each (attribute in observableChildAttribute) helper[attribute] = true;
			_observableChildAttribute[aliasName] = helper;
		}

		/** Get layout strategy by it's name. */
		public static function getLayoutByAlias(aliasName:String):Layout
		{
			initialize();
			return _layout[aliasName];
		}

		/** Layout must be invalidated if node attribute changed. */
		public static function isObservableSelfAttribute(layout:String, attributeName:String):Boolean
		{
			initialize();
			return _observableSelfAttribute[layout] && _observableSelfAttribute[layout][attributeName];
		}

		/** Layout must be invalidated if node child attribute changed. */
		public static function isObservableChildAttribute(layout:String, attributeName:String):Boolean
		{
			initialize();
			return _observableChildAttribute[layout] && _observableChildAttribute[layout][attributeName];
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
		public function measureAutoWidth(node:Node, availableWidth:Number, availableHeight:Number):Number
		{
			throw new Error("Method not implemented");
		}

		/** This method will be call while arranging, and must calculate node height in pixels, based on node children. */
		public function measureAutoHeight(node:Node, availableWidth:Number, availableHeight:Number):Number
		{
			throw new Error("Method not implemented");
		}

		/** Arrange (define bounds and commit) children within size. */
		public function arrange(node:Node, width:Number, height:Number):void
		{
			throw new Error("Method not implemented");
		}
	}
}