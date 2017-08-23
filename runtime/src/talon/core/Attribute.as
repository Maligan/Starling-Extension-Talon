package talon.core
{
	import talon.enums.*;
	import talon.layouts.Layout;
	import talon.utils.*;

	public final class Attribute
	{
        public static const INHERIT:String      = "inherit";
        public static const NONE:String         = "none";

        private static const FALSE:String        = "false";
        private static const TRUE:String         = "true";

		//
		// Standard Attribute list
		//
		public static const ID:String                              = registerAttribute("id",                    null, null,  false);
		public static const TYPE:String                            = registerAttribute("type",                  null, null,  false);
		public static const CLASS:String                           = registerAttribute("class",                 null, null,  false);
		public static const STATE:String                           = registerAttribute("state",                 null, null,  false);

		public static const WIDTH:String                           = registerAttribute("width",                 NONE);
		public static const MIN_WIDTH:String                       = registerAttribute("minWidth",              NONE);
		public static const MAX_WIDTH:String                       = registerAttribute("maxWidth",              NONE);

		public static const HEIGHT:String                          = registerAttribute("height",                NONE);
		public static const MIN_HEIGHT:String                      = registerAttribute("minHeight",             NONE);
		public static const MAX_HEIGHT:String                      = registerAttribute("maxHeight",             NONE);

		public static const MARGIN_TOP:String                      = registerAttribute("marginTop",             NONE);
		public static const MARGIN_RIGHT:String                    = registerAttribute("marginRight",           NONE);
		public static const MARGIN_BOTTOM:String                   = registerAttribute("marginBottom",          NONE);
		public static const MARGIN_LEFT:String                     = registerAttribute("marginLeft",            NONE);
		public static const MARGIN:String                          = registerComposite("margin",                [MARGIN_TOP, MARGIN_RIGHT, MARGIN_BOTTOM, MARGIN_LEFT]);

		public static const PADDING_TOP:String                     = registerAttribute("paddingTop",            NONE);
		public static const PADDING_RIGHT:String                   = registerAttribute("paddingRight",          NONE);
		public static const PADDING_BOTTOM:String                  = registerAttribute("paddingBottom",         NONE);
		public static const PADDING_LEFT:String                    = registerAttribute("paddingLeft",           NONE);
		public static const PADDING:String                         = registerComposite("padding",               [PADDING_TOP, PADDING_RIGHT, PADDING_BOTTOM, PADDING_LEFT]);

		public static const TOP:String                      	   = registerAttribute("top",                   NONE);
		public static const RIGHT:String                    	   = registerAttribute("right",                 NONE);
		public static const BOTTOM:String                   	   = registerAttribute("bottom",                NONE);
		public static const LEFT:String                     	   = registerAttribute("left",                  NONE);
		public static const ANCHOR:String                          = registerComposite("anchor",                [TOP, RIGHT, BOTTOM, LEFT]);

		public static const FILL:String                            = registerAttribute("fill",                  NONE);
		public static const FILL_STRETCH_GRID_TOP:String           = registerAttribute("fillStretchGridTop",    NONE);
		public static const FILL_STRETCH_GRID_RIGHT:String         = registerAttribute("fillStretchGridRight",  NONE);
		public static const FILL_STRETCH_GRID_BOTTOM:String        = registerAttribute("fillStretchGridBottom", NONE);
		public static const FILL_STRETCH_GRID_LEFT:String          = registerAttribute("fillStretchGridLeft",   NONE);
		public static const FILL_STRETCH_GRID:String               = registerComposite("fillStretchGrid",       [FILL_STRETCH_GRID_TOP, FILL_STRETCH_GRID_RIGHT, FILL_STRETCH_GRID_BOTTOM, FILL_STRETCH_GRID_LEFT]);
		public static const FILL_ALPHA:String                      = registerAttribute("fillAlpha",             "1");
		public static const FILL_SCALE_HORIZONTAL:String           = registerAttribute("fillScaleHorizontal",	"1");
		public static const FILL_SCALE_VERTICAL:String             = registerAttribute("fillScaleVertical",	    "1");
		public static const FILL_SCALE:String                      = registerComposite("fillScale",	    		[FILL_SCALE_HORIZONTAL, FILL_SCALE_VERTICAL]);
		public static const FILL_MODE_HORIZONTAL:String            = registerAttribute("fillModeHorizontal",    FillMode.STRETCH);
		public static const FILL_MODE_VERTICAL:String              = registerAttribute("fillModeVertical",      FillMode.STRETCH);
		public static const FILL_MODE:String                       = registerComposite("fillMode",              [FILL_MODE_HORIZONTAL, FILL_MODE_VERTICAL]);
		public static const FILL_BLEND_MODE:String                 = registerAttribute("fillBlendMode",         "auto");
		public static const FILL_ALIGN_HORIZONTAL:String           = registerAttribute("fillAlignHorizontal",   "left");
		public static const FILL_ALIGN_VERTICAAL:String            = registerAttribute("fillAlignVertical",     "top");
		public static const FILL_ALIGN:String                 	   = registerComposite("fillAlign",             [FILL_ALIGN_HORIZONTAL, FILL_ALIGN_VERTICAAL]);
		public static const FILL_TINT:String					   = registerAttribute("fillTint",				"#FFFFFF")

		public static const FONT_COLOR:String                      = registerAttribute("fontColor",             INHERIT, "#FFFFFF");
		public static const FONT_NAME:String                       = registerAttribute("fontName",              INHERIT, "mini");
		public static const FONT_SIZE:String                       = registerAttribute("fontSize",              INHERIT, "12px"); // Has hardcoded value in Node.ppem method
		public static const FONT_AUTO_SCALE:String                 = registerAttribute("fontAutoScale",         INHERIT, "false");

		public static const TOUCH_MODE:String                      = registerAttribute("touchMode",             TouchMode.BRANCH);
		public static const TOUCH_EVENTS:String                    = registerAttribute("touchEvents",           FALSE);
		public static const CURSOR:String                          = registerAttribute("cursor",                "auto");

		public static const LAYOUT:String                          = registerAttribute("layout",                Layout.ANCHOR);
		public static const TRANSFORM:String 					   = registerAttribute("transform",			    NONE);
		public static const MESH_STYLE:String 					   = registerAttribute("meshStyle",			    NONE);
		public static const BLEND_MODE:String                      = registerAttribute("blendMode",             "auto");
		public static const VISIBLE:String                         = registerAttribute("visible",               TRUE);
		public static const FILTER:String                          = registerAttribute("filter",                NONE);
		public static const ALPHA:String                           = registerAttribute("alpha",                 "1");

		public static const PIVOT_X:String                         = registerAttribute("pivotX",                NONE);
		public static const PIVOT_Y:String                         = registerAttribute("pivotY",                NONE);
		public static const PIVOT:String                           = registerComposite("pivot",                 [PIVOT_X, PIVOT_Y]);

		public static const HALIGN:String                          = registerAttribute("halign",                "left");
		public static const VALIGN:String                          = registerAttribute("valign",                "top");
		public static const ALIGN:String                           = registerComposite("align",                 [HALIGN, VALIGN]);

		public static const ORIENTATION:String                     = registerAttribute("orientation",           Orientation.HORIZONTAL);
		public static const GAP:String                             = registerAttribute("gap",                   NONE);
		public static const INTERLINE:String                       = registerAttribute("interline",             NONE);
		public static const WRAP:String                            = registerAttribute("wrap",                  FALSE);
		public static const HALIGN_SELF:String                     = registerAttribute("halignSelf",            "left");
		public static const VALIGN_SELF:String                     = registerAttribute("valignSelf",            "top");
		public static const ALIGN_SELF:String					   = registerComposite("alignSelf",				[HALIGN_SELF, VALIGN_SELF]);

		public static const BREAK_BEFORE:String                    = registerAttribute("breakBefore",           BreakMode.SOFT);
		public static const BREAK_AFTER:String                     = registerAttribute("breakAfter",            BreakMode.SOFT);
		public static const BREAK:String                           = registerComposite("break",                 [BREAK_BEFORE, BREAK_AFTER]);

		public static const TEXT:String                            = registerAttribute("text");
		public static const SOURCE:String                          = registerAttribute("source");
		public static const SOURCE_TINT:String                     = registerAttribute("sourceTint",			"#FFFFFF");

		//
		// Defaults
		//
		private static var _defInited:Object;
		private static var _defInherit:Object;
		private static var _defIsStyleable:Object;
		private static var _defCompositeFormat:Object;

		private static var _inheritable:Vector.<String>;

		public static function registerAttribute(name:String, inited:String = null, inherit:String = null, isStyleable:Boolean = true):String
		{
			_defInited ||= {};
			_defInited[name] = inited;

			_defInherit ||= {};
			_defInherit[name] = inherit;

			_defIsStyleable ||= {};
			_defIsStyleable[name] = isStyleable;

			if (inherit != null)
			{
				_inheritable ||= new <String>[];
				_inheritable[_inheritable.length] = name;
			}

			return name;
		}

		public static function registerComposite(name:String, attributes:Array):String
		{
			_defCompositeFormat ||= {};
			_defCompositeFormat[name] = attributes;

			return name;
		}

		/** @private */
		public static function getInheritableAttributeNames():Vector.<String>
		{
			return _inheritable || new Vector.<String>();
		}

		private static function buildSolver(attribute:Attribute):ISolver
		{
			var attributes:Array = _defCompositeFormat[attribute.name];
			if (attributes)
			{
				var format:String = attributes.length == 4 ? CompositeSolver.FORMAT_QUAD : CompositeSolver.FORMAT_PAIR;

				var solvers:Vector.<ISolver> = new <ISolver>[];
				for each (var attributeName:String in attributes)
					solvers[solvers.length] = attribute.node.getOrCreateAttribute(attributeName)._solver;

				return new CompositeSolver(format, solvers);
			}
			else if (_defInherit[attribute.name])
			{
				return new InheritableSolver(attribute, _defInherit[attribute.name]);
			}

			var styleable:Boolean = attribute.name in _defIsStyleable ? _defIsStyleable[attribute.name] : true;
			return new SimpleSolver(styleable ? -1 : 1);
		}

		//
		// Attribute Implementation
		//
		private var _node:Node;
		private var _name:String;
		private var _change:Trigger;
		private var _solver:ISolver;

		private var _valueCache:*;
		private var _valueCacheIsResource:Boolean;
		private var _valueCached:Boolean;

		/** @private */
		public function Attribute(node:Node, name:String)
		{
			if (node == null) throw new ArgumentError("Parameter node must be non-null");
			if (name == null) throw new ArgumentError("Parameter name must be non-null");

			_node = node;
			_name = name;
			_change = new Trigger(this);
			_solver = buildSolver(this);
			_solver.change.addListener(dispatchChange);

			if (!isComposite) inited = _defInited[name];
		}

		//
		// Value
		//
		/** The node that contains this attribute. */
		public function get node():Node { return _node; }

		/** Unique (in-node) attribute name. */
		public function get name():String { return _name; }

		/** Default attribute value. */
		public function get inited():String { return _solver.getValue(0, name); }
		public function set inited(value:String):void { _solver.setValue(0, name, value); }

		/** Attribute value from node style sheet. */
		public function get styled():String { return _solver.getValue(1, name); }
		public function set styled(value:String):void { _solver.setValue(1, name, value); }

		/** Explicit setted attribute value via code or markup. */
		public function get setted():String { return _solver.getValue(2, name); }
		public function set setted(value:String):void { _solver.setValue(2, name, value); }

		/** This value used as fallback value for inheritable attributes with value == 'inherit' but without parent. */
		public function get based():String { return isInheritable ? InheritableSolver(_solver).based : null; }

		/** Value calculated from (inited->styled->setted) and inherit parent attribute. */
		public function get value():String { return _solver.value; }

		/** NB! Optimized <code>value</code>property. Which can extract mapped resource. */
		public function get valueCache():*
		{
			if (_valueCached == false)
			{
				// By default equal to value
				_valueCache = value;
				_valueCacheIsResource = false;
				_valueCached = true;

				// Extract resource value
                // TODO: Stack overflow (loops)
				while (_valueCache is String)
				{
					var key:String = ParseUtil.parseResource(_valueCache);
					if (key == null) break;

					_valueCacheIsResource = true;
					_valueCache = node.getResource(key);
				}
			}

			return _valueCache;
		}

		//
		// Props
		//
		/** Use styled property when calculating attribute value. */
		public function get isStyleable():Boolean { return SimpleSolver(_solver).ignore != 1; }

		/** Attribute has composite format. */
		public function get isComposite():Boolean { return _solver is CompositeSolver; }

		/** If attribute value == 'inherit' concrete value must be taken from parent node. */
		public function get isInheritable():Boolean { return _solver is InheritableSolver; }

		/** Attribute 'value' is inherit from parent. */
		public function get isInherit():Boolean { return isInheritable && InheritableSolver(_solver).isInherit; }

		/** Attribute 'value' is mapped to resource. */
		public function get isResource():Boolean { valueCache; return _valueCacheIsResource; }

		//
		// Misc
		//
		/** @private */
		public function upstream(attribute:Attribute):void
		{
			_solver.change.removeListener(dispatchChange);
			_solver = attribute._solver;
			_solver.change.addListener(dispatchChange);
			dispatchChange();
		}

		public function dispose():void
		{
			_valueCache = null;
			_valueCached = false;
			_change.removeListeners();
		}

		/** @private Value change trigger. */
		public function get change():Trigger
		{
			return _change;
		}

		internal function dispatchChange():void
		{
			_valueCache = null;
			_valueCached = false;
			change.dispatch();
		}

		public function toString():String
		{
			return '[Attribute name="' + name + '", value="' + value + '"]';
		}
	}
}

import flash.events.Event;

import talon.core.Attribute;
import talon.utils.Trigger;

interface ISolver
{
	function getValue(priority:int, key:String):String;
	function setValue(priority:int, key:String, value:String):void;
	function get change():Trigger;
	function get value():String;
}

class SimpleSolver implements ISolver
{
	private var _change:Trigger;
	private var _values:Vector.<Object>;
	private var _orders:Vector.<Vector.<String>>;
	private var _ignore:int;

	public function SimpleSolver(ignore:int = -1):void
	{
		_change = new Trigger(this);
		_values = new Vector.<Object>();
		_orders = new Vector.<Vector.<String>>(3);
		_ignore = ignore;
	}

	public function getValue(priority:int, key:String):String
	{
		return (priority<_values.length && _values[priority]) ? _values[priority][key] : null;
	}

	public function setValue(priority:int, key:String, string:String):void
	{
		var prev:String = value;

		if (_values.length < priority + 1)
			_values.length = priority + 1;

		var values:Object = _values[priority] || (_values[priority] = {});
		var orders:Vector.<String> = _orders[priority] || (_orders[priority] = new Vector.<String>());

		// Mark as last changed key
		var indexOf:int = orders.indexOf(key);
		if (indexOf != -1) orders.removeAt(indexOf);
		orders[orders.length] = key;

		// Set new value
		values[key] = string;

		// Dispatch change
		if (prev != value) _change.dispatch();
	}

	public function get change():Trigger
	{
		return _change;
	}

	public function get value():String
	{
		for (var i:int = _values.length-1; i >= 0; i--)
		{
			if (i == ignore) continue;
			var hash:Object = _values[i];
			if (hash == null) continue;
			var order:Vector.<String> = _orders[i];

			var j:int = order.length;
			while (--j >= 0)
			{
				var last:String = order[j];
				var lastValue:String = hash[last];
				if (lastValue) return lastValue;
			}
		}

		return null;
	}

	public function get ignore():int
	{
		return _ignore;
	}
}

class InheritableSolver extends SimpleSolver
{
	private var _attribute:Attribute;
	private var _parent:Attribute;
	private var _based:String;

	public function InheritableSolver(attribute:Attribute, based:String)
	{
		_based = based;
		_attribute = attribute;
		_attribute.node.addListener(Event.ADDED, onAdded);
		_attribute.node.addListener(Event.REMOVED, onRemoved);
	}

	private function onAdded():void
	{
		var prev:String = value;
		_parent = _attribute.node.parent.getOrCreateAttribute(_attribute.name);
		_parent.change.addListener(onParentChange);
		if (prev != value) change.dispatch();
	}

	private function onRemoved():void
	{
		var prev:String = value;
		_parent.change.removeListener(onParentChange);
		_parent = null;
		if (prev != value) change.dispatch();
	}

	private function onParentChange():void
	{
		if (isInherit) change.dispatch();
	}

	public override function get value():String
	{
		// If value == 'inherit' and there is a parent - return parent value
		if (isInherit) return _parent.value;
		// If value == 'inherit' but there is no parent - return basic value
		if (super.value == Attribute.INHERIT) return _based;
		// Else return self value
		return super.value;
	}

	public function get based():String
	{
		return _based;
	}

	public function get isInherit():Boolean
	{
		return _parent && super.value == Attribute.INHERIT;
	}
}

/** Solver for composite attributes (e.g. padding, margin, align etc.) */
class CompositeSolver extends SimpleSolver
{
	private var _solvers:Vector.<ISolver>;
	private var _formats:Array;
	private var _isSuppressed:Boolean;
	private var _hasSuppressedChange:Boolean;

	public function CompositeSolver(format:String, solvers:Vector.<ISolver>)
	{
		_solvers = solvers;
		_formats = prepare(format, solvers);

		for each (var solver:ISolver in solvers)
			solver.change.addListener(onSolverChange);
	}

	private function onSolverChange():void
	{
		if (!_isSuppressed)
			change.dispatch();
		else
			_hasSuppressedChange = true;
	}

	private function suppress(value:Boolean):void
	{
		var needDispatchChange:Boolean = !value && _hasSuppressedChange;

		_isSuppressed = value;
		_hasSuppressedChange = false;

		if (needDispatchChange) change.dispatch();
	}

	public override function setValue(priority:int, key:String, string:String):void
	{
		// Set value for getValue call work correctly (and attribute styled/setted were real)
		super.setValue(priority, key, string);

		// Forward value to sub solvers
		suppress(true);
		compositeSetValues(_formats, string, priority, key);
		suppress(false);
	}

	public override function get value():String
	{
		return compositeGetValue(_formats);
	}

	//
	// Static
	//
	public static const FORMAT_PAIR:String = "{0, 1} | {0} {1}";
	public static const FORMAT_QUAD:String = "{0, 1, 2, 3} | {0, 2} {1, 3} | {0} {1, 3} {2} | {0} {1} {2} {3}";


	/** Convert to more comfortable structure. */
	private static function prepare(format:String, solvers:Vector.<ISolver>):Array
	{
		var result:Array = [];

		var alternates:Array = format.split(/\s*\|\s*/);
		for (var a:int = 0; a < alternates.length; a++)
		{
			var groups:Array = alternates[a].split(/\}\s*\{/);
			for (var g:int = 0; g < groups.length; g++)
			{
				var items:Array = groups[g].replace(/[{}]/g, "").split(/\s*,\s*/);
				for (var i:int = 0; i < items.length; i++)
				{
					result[a] ||= [];
					result[a][g] ||= [];
					result[a][g][i] = solvers[parseInt(items[i])];
				}
			}
		}

		return result;
	}

	private static function compositeGetValue(formats:Array):String
	{
		// Search matched pattern
		enumeration:
			for each (var format:Array in formats)
			{
				for each (var group:Array in format)
					for (var i:int = 0; i < group.length; i++)
						if (group[i].value != group[0].value)
							continue enumeration;

				break;
			}

		// Build string
		var builder:Array = [];
		for each (group in format) builder[builder.length] = ISolver(group[0]).value;
		return builder.join(' ');
	}

	private static function compositeSetValues(formats:Array, value:String, priority:int, key:String):void
	{
		var split:Array = value ? value.split(' ') : [''];
		if (split.length > formats.length)
			split.length = formats.length;

		var format:Array = formats[split.length - 1];

		for (var i:int = 0; i < format.length; i++)
			for each (var solver:ISolver in format[i])
				solver.setValue(priority, key, value ? split[i] : null);
	}
}