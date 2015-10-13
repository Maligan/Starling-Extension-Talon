package talon.browser.document
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import talon.Node;
	import talon.starling.TalonFactoryStarling;

	/** Extended version of TalonFactory for browser purpose. */
	public final class DocumentTalonFactory extends TalonFactoryStarling
	{
		private var _document:Document;
		private var _styles:StyleSheetCollection;
		private var _timer:Timer;
		private var _csf:Number;
		private var _dpi:Number;

		public function DocumentTalonFactory(document:Document):void
		{
			_resources = new ObjectWithAccessLogger();
			_document = document;
			_styles = new StyleSheetCollection();
			_timer = new Timer(1);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
		}

		private function dispatchChange():void
		{
			_timer.reset();
			_timer.start();
		}

		private function onTimer(e:TimerEvent):void
		{
			_document.tasks.begin();
			_document.tasks.end();
			_timer.reset();
		}

		public override function produce(id:String, includeStyleSheet:Boolean = true, includeResources:Boolean = true):*
		{
			resources.reset();
			_style = _styles.getMergedStyleSheet();

			return super.produce(id, includeStyleSheet, includeResources);
		}

		protected override function getElementNode(element:*):Node
		{
			var node:Node = super.getElementNode(element);

			if (node)
			{
				if (csf == csf) node.ppdp = csf;
				if (dpi == dpi) node.ppmm = dpi / 25.4;
			}

			return node;
		}

		public function get csf():Number { return _csf; }
		public function set csf(value:Number):void
		{
			if (_csf != value)
			{
				_csf = value;
				dispatchChange();
			}
		}

		public function get dpi():Number { return _dpi; }
		public function set dpi(value:Number):void
		{
			if (_dpi != value)
			{
				_dpi = value;
				dispatchChange();
			}
		}

		//
		// Templates
		//
		public function hasTemplate(id:String):Boolean
		{
			return _templates[id] != null;
		}

		public override function addTemplate(xml:XML):void
		{
			super.addTemplate(xml);
			dispatchChange();
		}

		public override function removeTemplate(id:String):void
		{
			super.removeTemplate(id);
			dispatchChange();
		}

		public function get templateIds():Vector.<String>
		{
			var result:Vector.<String> = new Vector.<String>();
			for (var id:String in _templates) result[result.length] = id;
			return result.sort(byName);
		}

		private function byName(string1:String, string2:String):int
		{
			if (string1 > string2) return +1;
			if (string1 < string2) return -1;
			return 0;
		}

		//
		// Resources
		//
		public function getResourceId(url:String):String
		{
			return getName(url);
		}

		private final function getName(path:String):String
		{
			var regexp:RegExp = /([^\?\/\\]+?)(?:\.([\w\-]+))?(?:\?.*)?$/;
			var matches:Array = regexp.exec(path);
			if (matches && matches.length > 0)
			{
				return matches[1];
			}
			else
			{
				return null;
			}
		}

		public function getResource(id:String):*
		{
			return _resources[id];
		}

		public function get resourceIds():Vector.<String>
		{
			var result:Vector.<String> = new Vector.<String>();
			for (var resourceId:String in _resources.inner) result[result.length] = resourceId;
			return result.sort(byName);
		}

		public function get missedResourceIds():Vector.<String>
		{
			return resources.missed;
		}

		public function removeResource(id:String):void
		{
			delete _resources[id];
			dispatchChange();
		}

		public override function addResource(id:String, resource:*):void
		{
			super.addResource(id, resource);
			dispatchChange();
		}

		private function get resources():ObjectWithAccessLogger
		{
			return ObjectWithAccessLogger(_resources);
		}

		//
		// Styles
		//
		public override function addStyleSheet(css:String):void
		{
			throw new Error("Use addStyleSheetWithId");
		}

		public function addStyleSheetWithId(key:String, css:String):void
		{
			_styles.insert(key, css);
			dispatchChange();
		}

		public function removeStyleSheetWithId(key:String):void
		{
			_styles.remove(key);
			dispatchChange();
		}
	}
}

import flash.utils.Dictionary;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

import talon.StyleSheet;

use namespace flash_proxy;

class ObjectWithAccessLogger extends Proxy
{
	private var _innerObject:Object;
	private var _used:Object;

	public function ObjectWithAccessLogger():void
	{
		_innerObject = new Object();
		_used = new Object();
	}

	public function reset():void
	{
		_used = new Object();
	}

	public function get used():Vector.<String>
	{
		var result:Vector.<String> = new <String>[];
		for each (var property:String in _used) result[result.length] = property;
		return result;
	}

	public function get unused():Vector.<String>
	{
		var result:Vector.<String> = new <String>[];

		for (var property:String in _innerObject)
			if (_used.hasOwnProperty(property) == false)
				result[result.length] = property;

		return result;
	}

	public function get missed():Vector.<String>
	{
		return used.filter(notExists);
	}

	private function notExists(property:String, index:int, vector:Vector.<String>):Boolean
	{
		return _innerObject.hasOwnProperty(property) == false;
	}

	public function get inner():Object
	{
		return _innerObject;
	}

	flash_proxy override function getProperty(name:*):* { return hasProperty(name) ? _innerObject[name] : null; }
	flash_proxy override function setProperty(name:*, value:*):void { _innerObject[name] = value; }
	flash_proxy override function hasProperty(name:*):Boolean { _used[name] = name; return _innerObject.hasOwnProperty(name); }
	flash_proxy override function deleteProperty(name:*):Boolean { return (delete _innerObject[name]); }
}

class StyleSheetCollection
{
	private var _cache:StyleSheet;
	private var _sources:Dictionary = new Dictionary();
	private var _keys:Vector.<String> = new <String>[];

	public function insert(key:String, css:String):void
	{
		if (_sources[key] == null) _keys.push(key);
		_sources[key] = css;
		_cache = null;
	}

	public function remove(key:String):void
	{
		if (key in _sources)
		{
			_keys.splice(_keys.indexOf(key), 1);
			delete _sources[key];
			_cache = null;
		}
	}

	public function getMergedStyleSheet():StyleSheet
	{
		if (_cache == null)
		{
			_cache = new StyleSheet();

			for each (var key:String in _keys)
			{
				var source:String = _sources[key];
				_cache.parse(source);
			}
		}

		return _cache;
	}
}