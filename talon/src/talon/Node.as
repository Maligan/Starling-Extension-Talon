package talon
{
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;

	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	import talon.layout.Layout;
	import talon.types.Gauge;
	import talon.types.GaugePair;
	import talon.types.GaugeQuad;
	import talon.utils.FillMode;
	import talon.utils.Orientation;
	import talon.utils.Visibility;

	public final class Node extends EventDispatcher
	{
		//
		// Strong typed attributes
		//
		public const width:Gauge = new Gauge();
		public const minWidth:Gauge = new Gauge();
		public const maxWidth:Gauge = new Gauge();

		public const height:Gauge = new Gauge();
		public const minHeight:Gauge = new Gauge();
		public const maxHeight:Gauge = new Gauge();

		public const margin:GaugeQuad = new GaugeQuad();
		public const padding:GaugeQuad = new GaugeQuad();
		public const anchor:GaugeQuad = new GaugeQuad();

		public const position:GaugePair = new GaugePair();
		public const origin:GaugePair = new GaugePair();
		public const pivot:GaugePair = new GaugePair();

		//
		// Private properties
		//
		private var _attributes:Dictionary = new Dictionary();
		private var _style:StyleSheet;
		private var _resources:Object;
		private var _parent:Node;
		private var _children:Vector.<Node> = new Vector.<Node>();
		private var _bounds:Rectangle = new Rectangle();

		/** @private */
		public function Node():void
		{
			const ZERO:String = "0px";
			const TRANSPARENT:String = "transparent";
			const WHITE:String = "white";
			const FALSE:String = "false";
			const AUTO:String = "auto";
			const ONE:String = "1";
			const NULL:String = null;

			width.auto = minWidth.auto = maxWidth.auto = measureAutoWidth;
			height.auto = minHeight.auto = maxHeight.auto = measureAutoHeight;

			// Style (Block styling)
			init(Attribute.ID, NULL, false);
			init(Attribute.TYPE, NULL, false);
			init(Attribute.CLASS, NULL, false);
			init(Attribute.STATE, NULL, false);

			// Bounds
			init(Attribute.WIDTH, Gauge.AUTO, true, width);
			init(Attribute.MIN_WIDTH, Gauge.NONE, true, minWidth);
			init(Attribute.MAX_WIDTH, Gauge.NONE, true, maxWidth);
			init(Attribute.HEIGHT, Gauge.AUTO, true, height);
			init(Attribute.MIN_HEIGHT, Gauge.NONE, true, minHeight);
			init(Attribute.MAX_HEIGHT, Gauge.NONE, true, maxHeight);

			// Margin
			init(Attribute.MARGIN, ZERO, true, margin);
			init(Attribute.MARGIN_TOP, ZERO, true, margin.top);
			init(Attribute.MARGIN_RIGHT, ZERO, true, margin.right);
			init(Attribute.MARGIN_BOTTOM, ZERO, true, margin.bottom);
			init(Attribute.MARGIN_LEFT, ZERO, true, margin.left);

			// Padding
			init(Attribute.PADDING, ZERO, true, padding);
			init(Attribute.PADDING_TOP, ZERO, true, padding.top);
			init(Attribute.PADDING_RIGHT, ZERO, true, padding.right);
			init(Attribute.PADDING_BOTTOM, ZERO, true, padding.bottom);
			init(Attribute.PADDING_LEFT, ZERO, true, padding.left);

			// Anchor (Absolute Position)
			init(Attribute.ANCHOR, Gauge.NONE, true, anchor);
			init(Attribute.ANCHOR_TOP, Gauge.NONE, true, anchor.top);
			init(Attribute.ANCHOR_RIGHT, Gauge.NONE, true, anchor.right);
			init(Attribute.ANCHOR_BOTTOM, Gauge.NONE, true, anchor.bottom);
			init(Attribute.ANCHOR_LEFT, Gauge.NONE, true, anchor.left);

			// Background
			init(Attribute.BACKGROUND_IMAGE, NULL, true);
			init(Attribute.BACKGROUND_TINT, WHITE, true);
			init(Attribute.BACKGROUND_9SCALE, ZERO, true);
			init(Attribute.BACKGROUND_COLOR, TRANSPARENT, true);
			init(Attribute.BACKGROUND_FILL_MODE, FillMode.SCALE, true);

			// Appearance
			init(Attribute.ALPHA, ONE, true);
			init(Attribute.CLIPPING, FALSE, true);
			init(Attribute.CURSOR, MouseCursor.AUTO, true);

			// Font
			init(Attribute.FONT_COLOR, Attribute.INHERIT, true);
			init(Attribute.FONT_NAME, Attribute.INHERIT, true);
			init(Attribute.FONT_SIZE, Attribute.INHERIT, true);

			// Layout
			init(Attribute.LAYOUT, Layout.FLOW, true);
			init(Attribute.VISIBILITY, Visibility.VISIBLE, true);

			init(Attribute.ORIENTATION, Orientation.HORIZONTAL, true);
			init(Attribute.HALIGN, HAlign.LEFT, true);
			init(Attribute.VALIGN, VAlign.TOP, true);
			init(Attribute.GAP, ZERO, true);
			init(Attribute.INTERLINE, ZERO, true);
			init(Attribute.WRAP, AUTO, true);

			init(Attribute.POSITION, ZERO, true, position);
			init(Attribute.X, ZERO, true, position.x);
			init(Attribute.Y, ZERO, true, position.y);

			init(Attribute.PIVOT, ZERO, true, pivot);
			init(Attribute.PIVOT_X, ZERO, true, pivot.x);
			init(Attribute.PIVOT_Y, ZERO, true, pivot.y);

			init(Attribute.ORIGIN, ZERO, true, origin);
			init(Attribute.ORIGIN_X, ZERO, true, origin.x);
			init(Attribute.ORIGIN_Y, ZERO, true, origin.y);

			addEventListener(Event.CHANGE, onAttributeChange);
		}

		private function init(name:String, initial:String, styleable:Boolean, source:* = null):void
		{
			var setter:Function = source ? source["parse"] : null;
			var getter:Function = source ? source["toString"] : null;
			var dispatcher:EventDispatcher = source;

			var attribute:Attribute = getOrCreateAttribute(name);
			attribute.bind(dispatcher, getter, setter);
			attribute.initial = initial;
			attribute.inheritable = initial == Attribute.INHERIT;
			attribute.styleable = styleable;
		}

		//
		// Attribute
		//
		/** Get attribute <strong>expanded</strong> value. */
		public function getAttribute(name:String):* { return getOrCreateAttribute(name).expanded; }

		/** Set attribute string <strong>assigned</strong> value. */
		public function setAttribute(name:String, value:String):void { getOrCreateAttribute(name).assigned = value; }

		/** @private Get (create if doesn't exists) attribute. */
		public function getOrCreateAttribute(name:String):Attribute { return _attributes[name] || (_attributes[name] = new Attribute(this, name)); }

		//
		// Styling
		//
		public function setStyleSheet(style:StyleSheet):void
		{
			_style = style;
			restyle();
		}

		public function getStyle(node:Node):Object
		{
			if (_style == null && _parent != null) return _parent.getStyle(node);
			if (_style != null && _parent == null) return _style.getStyle(node);
			if (_style != null && _parent != null) return _style.getStyle(node, _parent.getStyle(node));
			return new Object();
		}

		/** Recursive apply style to current node. */
		private function restyle():void
		{
			var style:Object = getStyle(this);

			// Fill all the existing attributes
			for each (var attribute:Attribute in _attributes)
			{
				attribute.styled = style[attribute.name];
				delete style[attribute.name];
			}

			// Addition attributes defined by style
			for (var name:String in style)
			{
				attribute = getOrCreateAttribute(name);
				attribute.styled = style[name];
			}

			// Recursive children restyling
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:Node = getChildAt(i);
				child.restyle();
			}
		}

		/** CCS classes which determine node style. TODO: Optimize. */
		public function get classes():Vector.<String> { return Vector.<String>(getAttribute(Attribute.CLASS) ? getAttribute(Attribute.CLASS).split(" ") : []) }
		public function set classes(value:Vector.<String>):void { setAttribute(Attribute.CLASS, value.join(" ")); restyle(); }

		/** Current active states (aka CSS pseudoClasses: hover, active, checked etc.). TODO: Optimize. */
		public function get states():Vector.<String> { return Vector.<String>(getAttribute(Attribute.STATE) ? getAttribute(Attribute.STATE).split(" ") : []) }
		public function set states(value:Vector.<String>):void { setAttribute(Attribute.STATE, value.join(" ")); restyle(); }

		//
		// Resource
		//
		/** Set current node resources (an object containing key-value pairs). */
		public function setResources(resources:Object):void
		{
			_resources = resources;
			resource();
		}

		/** Find resource in self or ancestors resources. */
		public function getResource(key:String):*
		{
			// Find self resource
			if (_resources && _resources[key]) return _resources[key];
			// Find inherited resource
			if (_parent) return _parent.getResource(key);
			// Not found
			return null;
		}

		private function resource():void
		{
			// Notify resource change
			for each (var attribute:Attribute in _attributes)
			{
				if (attribute.isResource) dispatchEventWith(Event.CHANGE, false, attribute.name);
			}

			// Recursive children notify resource change
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:Node = getChildAt(i);
				child.resource();
			}
		}

		//
		// Layout
		//
		/** Apply bounds changes: dispatch RESIZE event, arrange children. */
		public function commit():void
		{
			// Update self view object attached to node
			dispatchEventWith(Event.RESIZE);

			// Update children nodes
			layout.arrange(this, bounds.width, bounds.height);
		}

		/** Actual node bounds in pixels. */
		public function get bounds():Rectangle { return _bounds; }

		/** Pixel per point. (Also known as (csf) content scale factor) */
		public function get pppt():Number { return Starling.current.contentScaleFactor; }

		/** Pixels per millimeter (in current node). */
		public function get ppmm():Number { return Capabilities.screenDPI / 25.4; }

		/** Current node 'fontSize' expressed in pixels.*/
		public function get ppem():Number
		{
			var base:int = 12;
			var inherit:Number =  parent ? parent.ppem : base;
			var attribute:Attribute = getOrCreateAttribute(Attribute.FONT_SIZE);
			if (attribute.isInherit) return inherit;
			return Gauge.toPixels(attribute.value, ppmm, inherit, pppt, inherit, 0, 0, 0, 0);
		}

		/** This is 'auto' callback for gauges: width, minWidth, maxWidth. */
		private function measureAutoWidth(width:Number, height:Number):Number
		{
			return layout.measureAutoWidth(this, width, height);
		}

		/** This is 'auto' callback for gauges: height, minHeight, maxHeight. */
		private function measureAutoHeight(width:Number, height:Number):Number
		{
			return layout.measureAutoHeight(this, width, height);
		}

		/** talon.Node layout strategy class. */
		private function get layout():Layout
		{
			return Layout.getLayoutByAlias(getAttribute(Attribute.LAYOUT));
		}

		private function onAttributeChange(e:Event):void
		{
			var layoutName:String = getAttribute(Attribute.LAYOUT);
			var invalidate:Boolean = Layout.isObservableAttribute(layoutName, e.data as String);
			if (invalidate) commit();
		}

		private function onChildAttributeChange(e:Event):void
		{
			var layoutName:String = getAttribute(Attribute.LAYOUT);
			var invalidate:Boolean = Layout.isObservableChildrenAttribute(layoutName, e.data as String);
			if (invalidate) commit();
		}

		//
		// Complex
		//
		/** The node that contains this node. */
		public function get parent():Node { return _parent; }

		/** The number of children of this node. */
		public function get numChildren():int { return _children.length; }

		/** Adds a child to the container. It will be at the frontmost position. */
		public function addChild(child:Node):void
		{
			_children.push(child);
			child._parent = this;
			child.restyle();
			child.resource();
			child.addEventListener(Event.CHANGE, onChildAttributeChange);
			child.dispatchEventWith(Event.ADDED);
		}

		/** Removes a child from the container. If the object is not a child throws ArgumentError */
		public function removeChild(child:Node):void
		{
			var indexOf:int = _children.indexOf(child);
			if (indexOf == -1) throw new ArgumentError("Supplied node must be a child of the caller");
			_children.splice(indexOf, 1);
			child.removeEventListener(Event.CHANGE, onChildAttributeChange);
			child.dispatchEventWith(Event.REMOVED);
			child._parent = null;
			child.restyle();
			child.resource();
		}

		/** Returns a child object at a certain index. */
		public function getChildAt(index:int):Node
		{
			if (index < 0 || index >= numChildren) new RangeError("Invalid child index");

			return _children[index];
		}
	}
}