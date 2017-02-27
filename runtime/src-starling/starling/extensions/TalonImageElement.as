package starling.extensions
{
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.rendering.Painter;
	import starling.textures.Texture;
	import starling.utils.Pool;

	import talon.Attribute;
	import talon.Node;

	public class TalonImageElement extends Quad implements ITalonElement
	{
		private static var _sRectangle:Rectangle = new Rectangle();

		private var _bridge:TalonDisplayObjectBridge;
		private var _node:Node;
		private var _vertexOffset:Point;
		private var _manual:Boolean;

		public function TalonImageElement()
		{
			_vertexOffset = new Point();

			super(1, 1);

			_node = new Node();
			_node.width.auto = measureWidth;
			_node.height.auto = measureHeight;
			_node.addTriggerListener(Event.RESIZE, onNodeResize);

			_bridge = new TalonDisplayObjectBridge(this, node);
			_bridge.addAttributeChangeListener(Attribute.SOURCE, onSourceChange);

			_vertexOffset = new Point();

			pixelSnapping = true;
		}

		private function measureWidth(height:Number):Number
		{
			return (texture ? measure(height, texture.height, texture.width) : 0)
				 + node.paddingLeft.toPixels(node)
				 + node.paddingRight.toPixels(node);
		}

		private function measureHeight(width:Number):Number
		{
			return (texture ? measure(width,  texture.width,  texture.height) : 0)
				 + node.paddingTop.toPixels(node)
				 + node.paddingBottom.toPixels(node);
		}

		private function measure(knownDimension:Number, knownDimensionOfTexture:Number, measuredDimensionOfTexture:Number):Number
		{
			// If there is no texture - size is zero
			if (texture == null) return 0;
			// If no limit on image size - return original texture size
			if (knownDimension == Infinity) return measuredDimensionOfTexture;
			// Else calculate new size preserving texture aspect ratio
			return measuredDimensionOfTexture * (knownDimension/knownDimensionOfTexture);
		}

		private function onSourceChange():void
		{
			texture = node.getAttributeCache(Attribute.SOURCE) as Texture;
			if (node.width.isNone || node.height.isNone) node.invalidate();
		}

		private function onNodeResize():void
		{
			pivotX = node.pivotX.toPixels(node, node.bounds.width);
			pivotY = node.pivotY.toPixels(node, node.bounds.height);

			if (!manual)
			{
				x = node.bounds.x + pivotX;
				y = node.bounds.y + pivotY;
			}

			var paddingLeft:Number = node.paddingLeft.toPixels(node);
			var paddingRight:Number = node.paddingRight.toPixels(node);
			var paddingTop:Number = node.paddingTop.toPixels(node);
			var paddingBottom:Number = node.paddingBottom.toPixels(node);

			_vertexOffset.setTo(paddingLeft, paddingTop);

			readjustSize(node.bounds.width-paddingLeft-paddingRight, node.bounds.height-paddingTop-paddingBottom);
		}

		protected override function setupVertices():void
		{
			super.setupVertices();

			// Offset vertices by padding

			var posAttr:String = "position";
			var point:Point = Pool.getPoint();

			for (var i:int = 0; i < vertexData.numVertices; i++)
			{
				point = vertexData.getPoint(i, posAttr, point);
				point.offset(_vertexOffset.x, _vertexOffset.y);
				vertexData.setPoint(i, posAttr, point.x, point.y);
			}

			Pool.putPoint(point);
		}

		public override function render(painter:Painter):void
		{
			_bridge.renderCustom(super.render, painter);
		}

		public override function getBounds(targetSpace:DisplayObject, out:Rectangle = null):Rectangle
		{
			return _bridge.getBoundsCustom(super.getBounds, targetSpace, out);
		}

		public override function hitTest(localPoint:Point):DisplayObject
		{
			if (!visible || !touchable) return null;
			if (mask && !hitTestMask(localPoint)) return null;
			return getBounds(this, _sRectangle).containsPoint(localPoint) ? this : null;
		}

		public override function dispose():void
		{
			_bridge.dispose();
			super.dispose();
		}

		public function get node():Node
		{
			return _node;
		}

		public function get manual():Boolean
		{
			return _manual;
		}

		public function set manual(value:Boolean):void
		{
			_manual = value;
		}
	}
}
