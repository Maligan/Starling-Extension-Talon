package talon.starling
{
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	import talon.Attribute;
	import talon.utils.ITalonElement;
	import talon.Node;

	public class ImageElement extends Image implements ITalonElement
	{
		private static var _empty:Texture;

		private var _node:Node;

		public function ImageElement()
		{
			super(_empty || (_empty = Texture.empty(1, 1)));

			_node = new Node();
			_node.width.auto = _node.minWidth.auto = _node.maxWidth.auto = getAutoWidth;
			_node.height.auto = _node.minHeight.auto = _node.maxHeight.auto = getAutoHeight;
			_node.addEventListener(Event.CHANGE, onNodeChange);
			_node.addEventListener(Event.RESIZE, onNodeResize);
		}

		// Make calculation if one is auto and one is not auto
		private function getAutoWidth(width:Number, height:Number):Number { return (texture == _empty) ? 0 : texture.width; }
		private function getAutoHeight(width:Number, height:Number):Number { return (texture == _empty) ? 0 : texture.height; }

		private function onNodeChange(e:Event):void
		{
			if (e.data == "src")
			{
				var texture:Texture = node.getAttribute("src") as Texture;
				if (texture != null)
				{
					this.texture = texture;
					node.width.isAuto   && node.dispatchEventWith(Event.CHANGE, false, Attribute.WIDTH);
					node.height.isAuto  && node.dispatchEventWith(Event.CHANGE, false, Attribute.HEIGHT);
				}
			}
		}

		private function onNodeResize(e:Event):void
		{
			x = Math.ceil(node.bounds.x);
			y = Math.ceil(node.bounds.y);
			width = Math.ceil(node.bounds.width);
			height = Math.ceil(node.bounds.height);
		}

		public function get node():Node
		{
			return _node;
		}
	}
}
