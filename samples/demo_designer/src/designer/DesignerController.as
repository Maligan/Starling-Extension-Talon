package designer
{
	import designer.commands.DesignerCommand;
	import designer.commands.OpenCommand;
	import designer.commands.ExportCommand;

	import designer.dom.Document;

	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.ui.Keyboard;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class DesignerController
	{
		private var _launcher:DesignerApplication;
		private var _host:DisplayObjectContainer;
		private var _document:Document;
		private var _prototype:String;
		private var _interface:DesignerInterface;

		public function DesignerController(application:DesignerApplication, host:DisplayObjectContainer)
		{
			_launcher = application;
			_launcher.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_launcher.console.addCommand("resources", cmdResourceSearch, "RegExp based search project resources", "regexp");

			_interface = new DesignerInterface(this);
			_interface.addEventListener(DesignerInterfaceEvent.COMMAND, onCommand);

			_host = host;
			_host.addChild(_interface);

			resizeTo(_host.stage.stageWidth, _host.stage.stageHeight);
		}

		private function onCommand(e:Event):void
		{
			var command:DesignerCommand = DesignerCommand(e.data);
			command.execute();

			if (command is OpenCommand) setCurrentDocument(OpenCommand(command).document);
		}

		private function onKeyDown(e:KeyboardEvent):void
		{
			if (e.ctrlKey && e.keyCode == Keyboard.S)
			{
				var file:File = new File("/interface.zip");
				file.browseForSave("Export");
				file.addEventListener(Event.SELECT, onFileSelect);
			}

			function onFileSelect(e:*):void
			{
				var archive:File = File(e.target);
				new ExportCommand(_document, archive).execute();
			}
		}

		private function onDocumentChange(e:Event):void
		{
			refresh();
		}

		private function refresh():void
		{
			// Document/Prototype not selected
			if (_document == null || _prototype == null)
			{
				_interface.showEmpty();
				return;
			}

			// Document is in process
			if (_document.isBusy)
			{
				_interface.showBusyIndicator();
				return;
			}

			// Bad prototype name
			if (_document.factory.hasPrototype(_prototype) == false)
			{
				_interface.showError("ERROR");
				return;
			}

			// If all is ok - build and show view
			_interface.showPrototype(_document.factory.build(_prototype));
		}

		public function resizeTo(width:int, height:int):void
		{
			_interface.resizeTo(width, height);
		}

		public function invoke(filePath:String):void
		{
			var file:File = new File(filePath);
			var open:OpenCommand = new OpenCommand(file);
			open.execute();

			setCurrentDocument(open.document);
		}

		public function setCurrentDocument(document:Document):void
		{
			_document && _document.removeEventListener(Event.CHANGE, onDocumentChange);
			_document = document;
			_document && _document.addEventListener(Event.CHANGE, onDocumentChange);

			_prototype = _document.factory.prototypeIds.length > 0 ? _document.factory.prototypeIds[0] : null;
			_interface.setDocument(_document);

			refresh();
		}

		public function getCurrentPrototype():String
		{
			return _prototype;
		}

		public function setCurrentPrototype(value:String):void
		{
			if (_prototype != value)
			{
				_prototype = value;
				refresh();
			}
		}

		//
		// Console command
		//
		private function cmdResourceSearch(query:String):void
		{
			if (_document == null) throw new Error("Document not opened");

			var split:Array = query.split(" ");
			var regexp:RegExp = query.length > 1 ? new RegExp(split[1]) : /.*/;
			var resourceIds:Vector.<String> = _document.factory.resourceIds.filter(byRegExp(regexp));

			if (resourceIds.length == 0) _launcher.console.println("Resources not found");
			else
			{
				for each (var resourceId:String in resourceIds)
				{
					_launcher.console.println("*", resourceId);
				}
			}
		}

		private function byRegExp(regexp:RegExp):Function
		{
			return function (value:String, index:int, vector:Vector.<String>):Boolean
			{
				return regexp.test(value);
			}
		}
	}
}