package talon.browser.platform
{
	import flash.utils.getDefinitionByName;

	public class AppConstants
	{
		//
		// Application info
		//
		public static const APP_NAME:String = "Talon Browser";
		public static const APP_UPDATE_URL:String = "https://raw.githubusercontent.com/Maligan/Talon/master/browser/desktop/TalonBrowserUpdate.xml";
		public static const APP_DOCUMENTATION_URL:String = "https://github.com/Maligan/Talon/blob/master/docs/index.md";
		public static function get APP_VERSION():String
		{
			try
			{
				var napp:Class = getDefinitionByName("flash.desktop.NativeApplication") as Class;
				var xml:XML = napp["nativeApplication"]["applicationDescriptor"];
				var ns:Namespace = xml.namespace();
				return xml.ns::versionNumber;
			}
			catch (e:Error)
			{
				return "";
			}
		}

		public static const BROWSER_DOCUMENT_EXTENSION:String = "talon";
		public static const BROWSER_PUBLISH_EXTENSION:String = "zip";
		public static const BROWSER_PLUGIN_EXTENSION:String = "swf";
		public static const BROWSER_SCREENSHOT_EXTENSION:String = "png";
		public static const BROWSER_SUPPORTED_IMAGE_EXTENSIONS:Vector.<String> = new <String>["atf", "png", "jpg", "gif"];
		public static const BROWSER_DEFAULT_DOCUMENT_FILENAME:String = "." + BROWSER_DOCUMENT_EXTENSION;

		public static const PLUGINS_DIR:String = "plugins";
		public static const ZOOM_MIN:int = 25;
		public static const ZOOM_MAX:int = 300;
		public static const RECENT_HISTORY:int = 10;

		public static const SETTING_BACKGROUND:String = "background";
		public static const SETTING_BACKGROUND_DARK:String = "dark";
		public static const SETTING_BACKGROUND_LIGHT:String = "light";
		public static const SETTING_BACKGROUND_DEFAULT:String = SETTING_BACKGROUND_DARK;
		public static const SETTING_BACKGROUND_STAGE_COLOR:Object = { "dark": 0x3F4142, "light": 0xBFBFBF };
		public static const SETTING_STATS:String = "stats";
		public static const SETTING_OUTLINE:String = "outline";
		public static const SETTING_ZOOM:String = "zoom";
		public static const SETTING_LOCK_RESIZE:String = "lockWindowResize";
		public static const SETTING_ALWAYS_ON_TOP:String = "alwaysOnTop";
		public static const SETTING_AUTO_REOPEN:String = "autoReopen";
		public static const SETTING_RECENT_DOCUMENTS:String = "recentDocuments";
		public static const SETTING_RECENT_TEMPLATE:String = "recentTemplate";
		public static const SETTING_PROFILE:String = "profile";
		public static const SETTING_CHECK_FOR_UPDATE_ON_STARTUP:String = "checkForUpdateOnStartup";
		public static const SETTING_WINDOW_POSITION:String = "windowPosition";
		public static const SETTING_DETACHED_PLUGINS:String = "detachedPlugins";

		//
		// Language
		//
		public static const T_OPEN_TITLE:String                             = "Open Document Root Folder";
		public static const T_EXPORT_TITLE:String                           = "Export";
		public static const T_SCREENSHOT_TITLE:String                       = "Select Screenshot File";
		public static const T_PROJECT_ROOT_TITLE:String                     = "Select Document Folder";
	}
}
