package designer.dom
{
	import designer.utils.TalonDesignerFactory;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.filesystem.File;

	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;

	[Event(name="change", type="starling.events.Event")]
	public class Document extends EventDispatcher
	{
		private var _files:Vector.<DocumentFile>;
		private var _factory:TalonDesignerFactory;
		private var _root:File;
		private var _properties:Object;

		public function Document(properties:Object):void
		{
			_properties = properties;
			_files = new Vector.<DocumentFile>();
			_factory = new TalonDesignerFactory();
		}

		private function onFileChange(e:Event):void
		{
			var file:DocumentFile = DocumentFile(e.target);
			apply(file);
		}

		private function apply(file:DocumentFile, dispatch:Boolean = true):void
		{
			if (file.type == DocumentFileType.DIRECTORY)
			{

			}
			if (file.type == DocumentFileType.PROTOTYPE)
			{
				var xml:XML = new XML(file.data);
				var type:String = xml.@type;
				var config:XML = xml.*[0];
				_factory.addLibraryPrototype(type, config);
				dispatch && dispatchEventWith(Event.CHANGE);
			}
			else if (file.type == DocumentFileType.STYLE)
			{
				var text:String = file.data.toString();
				_factory.clearStyle(); // FIXME: A lot of CSS
				_factory.addLibraryStyleSheet(text);
				dispatch && dispatchEventWith(Event.CHANGE);
			}
			else if (file.type == DocumentFileType.IMAGE)
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				loader.loadBytes(file.data);

				function onComplete(e:*):void
				{
					var texture:Texture = Texture.fromBitmap(loader.content as Bitmap);
					var key:String = file.url.substring(file.url.lastIndexOf("/") + 1, file.url.lastIndexOf("."));
					_factory.addLibraryResource(key, texture);
					dispatchEventWith(Event.CHANGE); // Всегда диспатчить
				}
			}
		}

		public function addFile(documentFile:DocumentFile, silent:Boolean = false):void
		{
			for each (var file:DocumentFile in _files)
				if (file.equals(documentFile))
					return;

			_files[_files.length] = documentFile;
			apply(documentFile, !silent);
			documentFile.addEventListener(Event.CHANGE, onFileChange);
		}

		public function get factory():TalonDesignerFactory
		{
			return _factory;
		}

		public function get files():Vector.<DocumentFile>
		{
			return new <DocumentFile>[];
//			var result:Vector.<DocumentFile> = _files.slice();
//			var indexOfRoot:int = result.indexOf(_root);
//			result[indexOfRoot] = result[result.length - 1];
//			result.length--;
//			return result;
		}

		/** Get document file name. */
		public function getRelativeName(documentFile:DocumentFile):String
		{
			return _root.parent.getRelativePath(documentFile.file);
		}

		public function setRoot(file:File):void
		{
			_root = file;
		}
	}
}