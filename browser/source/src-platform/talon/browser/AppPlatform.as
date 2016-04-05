package talon.browser
{
	import air.update.ApplicationUpdaterUI;

	import flash.display.NativeWindow;
	import flash.display.Stage;
	import flash.display3D.Context3DProfile;
	import flash.events.NativeWindowBoundsEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	import talon.browser.commands.CommandManager;

	import talon.browser.plugins.desktop.commands.OpenDocumentCommand;
	import talon.browser.document.Document;
	import talon.browser.document.DocumentEvent;
	import talon.browser.plugins.PluginManager;
	import talon.browser.popups.PopupManager;
	import talon.browser.utils.DeviceProfile;
	import talon.browser.utils.OrientationMonitor;
	import talon.browser.utils.Storage;
	import talon.browser.utils.registerClassAlias;
	import talon.starling.TalonFactoryStarling;

	public class AppPlatform extends EventDispatcher
	{
		private var _stage:Stage;
		private var _document:Document;
		private var _templateId:String;
		private var _settings:Storage;
		private var _orientation:OrientationMonitor;
		private var _profile:DeviceProfile;
		private var _starling:Starling;
		private var _factory:TalonFactoryStarling;
		private var _plugins:PluginManager;
		private var _popups:PopupManager;
		private var _commands:CommandManager;
	    private var _invokeArgs:Array;
		private var _started:Boolean;

		public function AppPlatform(stage:Stage)
		{
			_stage = stage;

			registerClassAlias(Point);
			registerClassAlias(DeviceProfile);

			_invokeArgs = [];
			_settings = Storage.fromSharedObject("settings");
			_profile = _settings.getValueOrDefault(AppConstants.SETTING_PROFILE, DeviceProfile) || new DeviceProfile(stage.stageWidth, stage.stageHeight, 1, Capabilities.screenDPI);
			_orientation = new OrientationMonitor(stage);
			_factory = new TalonFactoryStarling();
			_plugins = new PluginManager(this);
			_popups = new PopupManager(this);
			_commands = new CommandManager();

			// WARNING: NOT work after starling creating!
			var colorName:String = _settings.getValueOrDefault(AppConstants.SETTING_BACKGROUND, String, AppConstants.SETTING_BACKGROUND_DEFAULT);
			var color:uint = AppConstants.SETTING_BACKGROUND_STAGE_COLOR[colorName];
			stage.color = color;
			// --------------------------------------

			// With "baselineConstrained" there are same issues:
			// * stage.color while starling inited have misbehavior
			// * take screenshot have no alpha
			_starling = new Starling(Sprite, stage, null, null, "auto", Context3DProfile.BASELINE);
			_starling.addEventListener(Event.ROOT_CREATED, onStarlingRootCreated);

			initializeWindowMonitor();
		}

		public function start():void
		{
			_started = true;

			// If starling already initialized
			if (_starling.root)
			{
				_starling.start();
				_plugins.start();

				dispatchEventWith(AppPlatformEvent.START);

				invokeAndRestore();
			}
		}

		public function invoke(args:Array):void
		{
			_invokeArgs = args || [];

			if (_started && _invokeArgs && _invokeArgs.length > 0)
			{
				// Open
				var path:String = _invokeArgs[0];
				var file:File = new File(path);
				if (file.exists)
				{
					var open:OpenDocumentCommand = new OpenDocumentCommand(this, file);
					open.execute();
				}
			}
		}

		//
		// Properties
		//
		/** Talon factory for all browser UI. */
		public function get factory():TalonFactoryStarling { return _factory; }

		/** Special popup manager (@see PopupManager#host) */
		public function get popups():PopupManager { return _popups; }

	    /** Current Starling instance (preferably use this accessor, browser may work in multi windowed mode). */
	    public function get starling():Starling { return _starling; }

	    /** Application configuration file (for read AND write). */
		public function get settings():Storage { return _settings; }

	    /** Native Flash Stage. */
		public function get stage():Stage { return _stage; }

	    /** Device profile. */
		public function get profile():DeviceProfile { return _profile; }

	    /** Application plugin list (all: attached, detached, broken). */
	    public function get plugins():PluginManager { return _plugins; }

		public function get commands():CommandManager { return _commands; }

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
		// [Events] Move And Resize
		//
		private function initializeWindowMonitor():void
		{
			_stage.addEventListener(Event.RESIZE, onStageResize);
			_stage.nativeWindow.minSize = new Point(200, 100);
			_stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.MOVE, onWindowMove);
			_stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING, onWindowResizing);
			_profile.addEventListener(Event.CHANGE, onProfileChange);

			// Restore window position
			var position:Point = settings.getValueOrDefault(AppConstants.SETTING_WINDOW_POSITION, Point);
			if (position)
			{
				_stage.nativeWindow.x = position.x;
				_stage.nativeWindow.y = position.y;
			}

			// Restore window size / DPI / CSF
			onProfileChange(null);
		}

		private function onStageResize(e:* = null):void
		{
			if (_starling)
			{
				_starling.stage.stageWidth = _stage.stageWidth;
				_starling.stage.stageHeight = _stage.stageHeight;
				_starling.viewPort = new Rectangle(0, 0, _stage.stageWidth, _stage.stageHeight);
			}

			_profile.setSize(_stage.stageWidth, _stage.stageHeight);
		}

		private function onProfileChange(e:*):void
		{
			resizeWindowTo(profile.width, profile.height);

			if (_document)
			{
				_document.factory.dpi = _profile.dpi;
				_document.factory.csf = _profile.csf;
			}

			_settings.setValue(AppConstants.SETTING_PROFILE, _profile);
		}

		private function resizeWindowTo(stageWidth:int, stageHeight:int):void
		{
			if (stage.stageWidth != stageWidth || stage.stageHeight != stageHeight)
			{
				var window:NativeWindow = stage.nativeWindow;
				var deltaWidth:int = window.width - stage.stageWidth;
				var deltaHeight:int = window.height - stage.stageHeight;
				window.width = Math.max(stageWidth + deltaWidth, window.minSize.x);
				window.height = Math.max(stageHeight + deltaHeight, window.minSize.y);
			}
		}

		private function onWindowResizing(e:NativeWindowBoundsEvent):void
		{
			// NativeWindow#resizable is read only, this is fix:
			var needPrevent:Boolean = settings.getValueOrDefault(AppConstants.SETTING_LOCK_RESIZE, Boolean, false);
			if (needPrevent) e.preventDefault();
		}

		private function onWindowMove(e:NativeWindowBoundsEvent):void
		{
			settings.setValue(AppConstants.SETTING_WINDOW_POSITION, e.afterBounds.topLeft);
		}

		//
		// Starling
		//
		private function onStarlingRootCreated(e:Event):void
		{
			_starling.removeEventListener(Event.ROOT_CREATED, onStarlingRootCreated);

			if (_started) start();
		}

		private function invokeAndRestore():void
		{
			var invArgs:Array = _invokeArgs;
			var invTemplate:String = null;

			// Document can be opened via invoke (click on document file)
			// in this case need omit autoReopen feature
			var isEnableReopen:Boolean = settings.getValueOrDefault(AppConstants.SETTING_AUTO_REOPEN, Boolean, false);
			if (isEnableReopen && invArgs.length == 0)
			{
				var template:String = settings.getValueOrDefault(AppConstants.SETTING_RECENT_TEMPLATE, String);
				if (template != null)
				{
					var recentArray:Array = settings.getValueOrDefault(AppConstants.SETTING_RECENT_DOCUMENTS, Array);
					var recentPath:String = recentArray && recentArray.length ? recentArray[0] : null;
					if (recentPath)
					{
						invArgs = [recentPath];
						invTemplate = template;
					}
				}
			}

			// Do reopen
			if (invArgs != null) invoke(invArgs);
			if (invTemplate != null) templateId = invTemplate;
		}
	}
}