package browser.dom.assets
{
	import browser.dom.log.DocumentMessage;

	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;

	import starling.textures.AtfData;
	import starling.textures.Texture;

	public class TextureAsset extends Asset
	{
		protected override function onRefresh():void
		{
			reportCleanup();

			var bytes:ByteArray = file.readBytes();

			if (AtfData.isAtfData(bytes))
			{
				document.tasks.begin();
				addTexture(bytes);
				document.tasks.end();
			}
			else
			{
				document.tasks.begin();
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader.loadBytes(bytes);

				function onComplete(e:*):void
				{
					addTexture(loader.content);
					document.tasks.end();
				}

				function onIOError(e:*):void
				{
					report(DocumentMessage.FILE_CONTAINS_WRONG_IMAGE_FORMAT, file.url);
					document.tasks.end();
				}
			}
		}

		private function addTexture(data:*):void
		{
			try
			{
				var id:String = document.factory.getResourceId(file.url);
				var texture:Texture = Texture.fromData(data);
				document.factory.addResource(id, texture);
			}
			catch (e:Error)
			{
				report(DocumentMessage.TEXTURE_ERROR, file.url);
			}
		}

		protected override function onExclude():void
		{
			document.tasks.begin();
			document.factory.removeResource(document.factory.getResourceId(file.url));
			document.tasks.end();
		}
	}
}