package
{
	import designer.DesignerController;

	import flash.desktop.NativeApplication;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	import starling.core.Starling;

	import starling.display.Sprite;
	import starling.events.Event;

	[SWF(backgroundColor="#444444")]
	public class DesignerApplication extends MovieClip
	{
		private var _dropTarget:flash.display.Sprite;
		private var _controller:DesignerController;
		private var _invoke:String;

		public function DesignerApplication()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);

			// NativeDragManager do not work with empty document root
			// add this object to fix this problem
			_dropTarget = new flash.display.Sprite();
			addChild(_dropTarget);

			NativeApplication.nativeApplication.setAsDefaultApplication(DesignerConstants.DESIGNER_FILE_EXTENSION);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);

			new Starling(starling.display.Sprite, stage);
			Starling.current.addEventListener(Event.ROOT_CREATED, onRootCreated);
			Starling.current.start();
			Starling.current.showStats = false;

			onResize(null);
		}

		private function onResize(e:*):void
		{
			Starling.current.stage.stageWidth = stage.stageWidth;
			Starling.current.stage.stageHeight = stage.stageHeight;
			Starling.current.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

			_dropTarget.graphics.beginFill(0xFFFFFF, 0);
			_dropTarget.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_dropTarget.graphics.endFill();

			_controller && _controller.resizeTo(stage.stageWidth, stage.stageHeight);
		}

		private function onRootCreated(e:*):void
		{
			_controller = new DesignerController(this, Starling.current.root as starling.display.Sprite);
			_invoke && _controller.invoke(_invoke);
		}

		private function onInvoke(e:InvokeEvent):void
		{
			if (e.arguments.length > 0)
			{
				_invoke = e.arguments[0];
				_controller && _controller.invoke(_invoke);
			}
		}
	}
}