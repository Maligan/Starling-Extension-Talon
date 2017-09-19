package talon.browser.platform
{
	import flash.display.Stage;
	import flash.display3D.Context3DProfile;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.DisplayObjectContainer;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.extensions.TalonFactory;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.textures.Texture;
	import starling.utils.Align;
	import starling.utils.Color;

	import talon.browser.platform.document.Document;
	import talon.browser.platform.document.DocumentEvent;
	import talon.browser.platform.plugins.PluginManager;
	import talon.browser.platform.popups.PopupManager;
	import talon.browser.platform.utils.DeviceProfile;
	import talon.browser.platform.utils.Locale;
	import talon.browser.platform.utils.Storage;
	import talon.browser.platform.utils.registerClassAlias;

	public class AppPlatform extends EventDispatcher
	{
		private var _stage:Stage;
		private var _document:Document;
		private var _templateId:String;
		private var _settings:Storage;
		private var _profile:DeviceProfile;
		private var _starling:Starling;
		private var _factory:TalonFactory;
		private var _plugins:PluginManager;
		private var _popups:PopupManager;
		private var _locale:Locale;
	    private var _lastInvokeArgs:Array;
		private var _started:Boolean;

		public function AppPlatform(stage:Stage)
		{
			_stage = stage;

			registerClassAlias(Rectangle);
			registerClassAlias(Point);
			registerClassAlias(DeviceProfile);

			_lastInvokeArgs = [];
			_settings = Storage.fromSharedObject("settings");
			_profile = _settings.getValue(AppConstants.SETTING_PROFILE, DeviceProfile) || new DeviceProfile(stage.stageWidth, stage.stageHeight, 1, Capabilities.screenDPI);
			_factory = new TalonFactory();
			_plugins = new PluginManager(this);
			_popups = new PopupManager(this);
			_locale = new Locale();

			// WARNING: NOT work after starling creating!
			var colorName:String = _settings.getValue(AppConstants.SETTING_BACKGROUND, String, AppConstants.SETTING_BACKGROUND_DEFAULT);
			var color:uint = AppConstants.SETTING_BACKGROUND_STAGE_COLOR[colorName];
			stage.color = color;
			// --------------------------------------

			// With "baselineConstrained" there are same issues:
			// * stage.color while starling inited have misbehavior
			// * take screenshot have no alpha
			_starling = new Starling(Sprite, stage, null, null, "auto", Context3DProfile.BASELINE);
			_starling.skipUnchangedFrames = true;
			_starling.addEventListener(Event.ROOT_CREATED, onStarlingRootCreated);
			_starling.stage.addEventListener(Event.RESIZE, onStageResize);

			// Resize listeners
			_stage.stageWidth = _profile.width;
			_stage.stageHeight = _profile.height;
			_profile.addEventListener(Event.CHANGE, onProfileChange);
		}

		private function onStarlingRootCreated(e:Event):void
		{
			_starling.removeEventListener(Event.ROOT_CREATED, onStarlingRootCreated);
			_starling.juggler.add(_popups.juggler);

			if (_started) start();
		}

//		[Embed(source="/FiraSans.fnt", mimeType="application/octet-stream")] private static const FONT_FNT:Class;
//		[Embed(source="/FiraSans.0.png")] private static const FONT_PNG:Class;
		
		public function start():void
		{
			_started = true;

			// If starling already initialized
			if (_starling.root)
			{
				_starling.start();
				_plugins.start();
				
//				var font:BitmapFont = new BitmapFont(
//					Texture.fromEmbeddedAsset(FONT_PNG),
//					XML(new FONT_FNT)
//				);
//				TextField.registerCompositor(font, "FiraSans");

//				var tf:TextField = new TextField(100, font.lineHeight, "The quick brown fox jumps over the lazy dog");
//				tf.format.font = "FiraSans";
//				tf.format.size = 16;
//				tf.format.color = Color.GRAY;
//				tf.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
//				tf.border = true;
//				tf.x = tf.y = 100;
//				_starling.stage.addChild(tf);
//				addComment(tf, "autoSize = BOTH_DIRECTIONS");
//
//				var tf:TextField = new TextField(100, font.lineHeight, "--e qu-c- -rown -ox -umps over --e -azy -og");
//				tf.format.font = "FiraSans";
//				tf.format.size = 16;
//				tf.format.color = Color.GRAY;
//				tf.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
//				tf.border = true;
//				tf.x = 100;
//				tf.y = 150;
//				_starling.stage.addChild(tf);
//				addComment(tf, "autoSize = BOTH_DIRECTIONS, Chars with ascender replaced by '-'");
//
//				var tf:TextField = new TextField(100, font.lineHeight, "--e +u-c- -rown -ox -um+s over --e -az+ -o+");
//				tf.format.font = "FiraSans";
//				tf.format.size = 16;
//				tf.format.color = Color.GRAY;
//				tf.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
//				tf.border = true;
//				tf.x = 100;
//				tf.y = 200;
//				_starling.stage.addChild(tf);
//				addComment(tf, "autoSize = BOTH_DIRECTIONS, Chars with ascender/descender replaced by '-'/'+'");
//				
//				function addComment(to:TextField, message:String):void
//				{
//					var tf:TextField = new TextField(100, 100, message + ", height = " + to.height);
//					tf.format.color = Color.WHITE;
//					tf.format.font = BitmapFont.MINI;
//					tf.format.size = 8;
//					tf.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
//					tf.y = to.y - tf.height- 2;
//					tf.x = to.x;
//					_starling.stage.addChild(tf);
//				}

				dispatchEventWith(AppPlatformEvent.STARTED, false, _lastInvokeArgs);
			}
		}

		public function invoke(args:Array):void
		{
			_lastInvokeArgs = args || [];

			if (_started && _lastInvokeArgs && _lastInvokeArgs.length > 0)
			{
				dispatchEventWith(AppPlatformEvent.INVOKE, false, _lastInvokeArgs);
			}
		}

		//
		// Properties (Open API)
		//
		/** Native Flash Stage. */
		public function get stage():Stage { return _stage; }

		/** Application configuration file (for read AND write). */
		public function get settings():Storage { return _settings; }

		/** Current device profile. */
		public function get profile():DeviceProfile { return _profile; }

		/** Special popup manager (@see PopupManager#host) */
		public function get popups():PopupManager { return _popups; }

		/** Application plugin list (all: attached, detached, broken). */
		public function get plugins():PluginManager { return _plugins; }

	    /** Current Starling instance (preferably use this accessor). */
	    public function get starling():Starling { return _starling; }

		/** Application localization information. */
		public function get locale():Locale { return _locale; }

		/** Talon factory for all browser UI. */
		public function get factory():TalonFactory { return _factory; }

	    /** Current opened document or null. */
	    public function get document():Document { return _document; }
		public function set document(value:Document):void
		{
			if (_document != value)
			{
				templateId = null;

				if (_document)
					_document.dispose();

				_document = value;

				if (_document)
				{
					_document.addEventListener(DocumentEvent.CHANGE, dispatchEvent);
					_document.factory.dpi = _profile.dpi;
					_document.factory.csf = _profile.csf;
				}

				dispatchEventWith(AppPlatformEvent.DOCUMENT_CHANGE);
			}
		}

		/** Current selected template name or null. */
		public function get templateId():String { return _templateId; }
		public function set templateId(value:String):void
		{
			if (_templateId != value)
			{
				_templateId = value;
				settings.setValue(AppConstants.SETTING_RECENT_TEMPLATE, value);
				dispatchEventWith(AppPlatformEvent.TEMPLATE_CHANGE);
			}
		}

		//
		// Resize listeners
		//
		private function onStageResize(e:* = null):void
		{
			_starling.stage.stageWidth = _stage.stageWidth;
			_starling.stage.stageHeight = _stage.stageHeight;
			_starling.viewPort = new Rectangle(0, 0, _stage.stageWidth, _stage.stageHeight);
		}

		private function onProfileChange(e:*):void
		{
			if (_document)
			{
				_document.factory.dpi = _profile.dpi;
				_document.factory.csf = _profile.csf;
			}

			_settings.setValue(AppConstants.SETTING_PROFILE, _profile);
		}
	}
}