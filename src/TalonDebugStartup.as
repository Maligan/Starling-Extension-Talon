package
{
	import feathers.textures.Scale9Textures;

	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;

	import starling.events.Event;
	import starling.extensions.talon.core.Node;

	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	import starling.extensions.talon.display.ITalonComponent;

	import starling.extensions.talon.display.TalonComponentBase;
	import starling.extensions.talon.core.StyleSheet;
	import starling.extensions.talon.display.TalonLabel;
	import starling.extensions.talon.layout.Layout;
	import starling.extensions.talon.layout.FlowLayout;
	import starling.extensions.talon.utils.TalonFactory;
	import starling.textures.Texture;

	public class TalonDebugStartup extends MovieClip
	{
		[Embed(source="../assets/up.png")] private static const UP_BYTES:Class;
		[Embed(source="../assets/over.png")] private static const OVER_BYTES:Class;
		[Embed(source="../assets/down.png")] private static const DOWN_BYTES:Class;

		private var _document:Sprite;

		private var _talon:TalonComponentBase;
		private var _bundle:Object;

		public function TalonDebugStartup()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);

			new Starling(Sprite, stage);
			Starling.current.addEventListener(Event.ROOT_CREATED, onRootCreated);
			Starling.current.start();
			Starling.current.showStats = true;
		}

		private function onResize(e:*):void
		{
			Starling.current.stage.stageWidth = stage.stageWidth;
			Starling.current.stage.stageHeight = stage.stageHeight;
			Starling.current.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

			if (_talon != null)
			{
				_talon.node.bounds.setTo(0, 0, stage.stageWidth, stage.stageHeight);
				_talon.node.commit();
			}
		}

		private function onRootCreated(e:Event):void
		{
			_document = Sprite(Starling.current.root);
			_bundle = new Object();

			var css:String =
			<literal><![CDATA[
				.tmp .brown
				{
					backgroundImage: /img/up.png;
					backgroundColor: 0x964B00;
					width: 100%;
					height: 128px;
				}

				#4d *
				{
					backgroundImage: /img/up.png;
					backgroundColor: 0x0000ff;
					width: *;
				}
			]]></literal>.valueOf();

			var config:XML =
				<node id="root" layout="flow" orientation="vertical" valign="center" halign="center" gap="4px">
					<node id="play" width="50%" height="20%"/>
					<node layout="flow" class="tmp" orientation="vertical" width="50%" padding="0px 8px" gap="4px">
						<node id="2d" width="100%" height="48px" backgroundColor="0x888888" />
						<node id="3d" class="brown" width="100%" height="128px" />
						<node id="4d" layout="flow" orientation="horizontal" gap="4px" width="100%">
							<node id="prev" height="100%"/>
							<node id="stop" layout="flow" orientation="vertical" gap="8px" padding="8px">
								<label text="Hello World 1" width="100%" fontName="Trebuchet MS" fontSize="18" />
								<label text="Hello World 2" width="100%" fontName="Consolas" />
							</node>
							<node id="next" height="100%"/>
						</node>
					</node>
					<node id="leaders" width="256px" height="48px" backgroundColor="0x888899" />
					<node id="mother ship" width="256px" height="48px" backgroundColor="0xFF000" />
				</node>;


			var builder:TalonFactory = new TalonFactory();
			builder.setLinkage("label", TalonLabel);
			builder.addLibraryPrototype("root", config);
			builder.addLibraryStyleSheet(css);
			builder.addLibraryResource("/img/up.png", getTexture(UP_BYTES));
			builder.addLibraryResource("/img/over.png", getTexture(OVER_BYTES));
			builder.addLibraryResource("/img/down.png", getTexture(DOWN_BYTES));

			_talon = builder.build("root") as TalonComponentBase;
			_document.addChild(_talon);
			onResize(null)
		}

		private static function getTexture(asset:Class):Texture
		{
			return Texture.fromEmbeddedAsset(asset);
		}
	}
}