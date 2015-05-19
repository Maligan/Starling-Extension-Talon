package talon.starling
{
	import starling.display.Image;
	import starling.events.Event;
	import starling.filters.FragmentFilter;
	import starling.textures.Texture;

	import talon.Attribute;
	import talon.Node;
	import talon.utils.ITalonElement;

	public class TalonImage extends Image implements ITalonElement
	{
		private static var _empty:Texture;

		private var _node:Node;

		public function TalonImage()
		{
			super(_empty || (_empty = Texture.empty(1, 1)));

			_node = new Node();
			_node.width.auto = _node.minWidth.auto = _node.maxWidth.auto = getAutoWidth;
			_node.height.auto = _node.minHeight.auto = _node.maxHeight.auto = getAutoHeight;
			_node.addListener(Event.CHANGE, onNodeChange);
			_node.addListener(Event.RESIZE, onNodeResize);
		}

		// Make calculation if one is auto and one is not auto
		private function getAutoWidth(width:Number, height:Number):Number { return (texture == _empty) ? 0 : texture.width; }
		private function getAutoHeight(width:Number, height:Number):Number { return (texture == _empty) ? 0 : texture.height; }

		private function onNodeChange():void
		{
//			if (e.data == "src")
//			{
//				var texture:Texture = node.getAttribute("src") as Texture;
//				if (texture != null)
//				{
//					this.texture = texture;
//					node.width.isAuto   && node.dispatchEventWith(Event.CHANGE, false, Attribute.WIDTH);
//					node.height.isAuto  && node.dispatchEventWith(Event.CHANGE, false, Attribute.HEIGHT);
//				}
//			}
		}

		private function onNodeResize():void
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
