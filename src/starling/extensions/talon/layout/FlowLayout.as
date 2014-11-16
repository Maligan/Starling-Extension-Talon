package starling.extensions.talon.layout
{
	import flash.sampler.getSize;

	import starling.extensions.talon.core.Gauge;
	import starling.extensions.talon.core.Node;
	import starling.extensions.talon.utils.Orientation;

	public class FlowLayout extends Layout
	{
		private static const GAP:String = "gap";
		private static const INTERLINE:String = "interline";
		private static const ORIENTATION:String = "orientation";
		private static const WRAP:String = "wrap";
		private static const BREAK:String = "break";
		private static const TRUE:String = "true";

		private static const _gauge:Gauge = new Gauge();

		private static function toPixels(source:String, pppt:Number, ppem:Number, target:Number, stars:int):Number
		{
			_gauge.parse(source);
			return _gauge.toPixels(pppt, ppem, target, 0, stars);
		}

		public override function arrange(node:Node, width:Number, height:Number):void
		{
			var orientation:String = node.getAttribute(ORIENTATION);
			var isHorizontal:Boolean = orientation == Orientation.HORIZONTAL;
			var isVertical:Boolean = orientation == Orientation.VERTICAL;

			var wrap:Boolean = node.getAttribute(WRAP) == TRUE;

			var gap:Number = toPixels(node.getAttribute(GAP), node.pppt, node.ppem, (isHorizontal ? width : height), 0);
			var interline:Number = toPixels(node.getAttribute(INTERLINE), node.pppt, node.ppem, (isHorizontal ? width : height), 0);

			// ----
			var lineOffset:Number = 0;
			var lineFirstChildIndex:int = 0;
			var lineLastChildIndex:int = 0;
			var lineLengthLimit:Number = isHorizontal ? width : height;
			var lineLength:Number = 0;
			var lineThickness:Number = 0;
			var lineThicknessLimit:Number = isVertical ? width : height;
			var lineStarsCount:int = 0;
			var lineStarsTarget:Number = 0;

			while (lineFirstChildIndex < node.numChildren)
			{
				trace(lineFirstChildIndex);

				lineLength = 0;
				lineThickness = 0;
				lineStarsCount = 0;
				lineStarsTarget = 0;

				for (var i:int = lineFirstChildIndex; i < node.numChildren; i++)
				{
					var child:Node = node.getChildAt(i);

					// If child require new line - break it
					var childIsBreak:Boolean = wrap && (i != lineFirstChildIndex) && (child.getAttribute(BREAK) == TRUE);
					if (childIsBreak) break;

					var size:Gauge = isHorizontal ? child.width     : child.height;
					var minSize:Gauge = isHorizontal ? child.minWidth  : child.minHeight;
					var maxSize:Gauge = isHorizontal ? child.maxWidth  : child.maxHeight;
					var margin1:Gauge = isHorizontal ? child.margin.left : child.margin.top;
					var margin2:Gauge = isHorizontal ? child.margin.right : child.margin.bottom;

					// Define margin
					var margin:Number = 0;
					margin += margin1.toPixels(child.pppt, child.ppem, lineLengthLimit, 0, 0);
					margin += margin2.toPixels(child.pppt, child.ppem, lineLengthLimit, 0, 0);

					// Star unit doesn't add any length
					if (size.unit == Gauge.STAR)
					{
						lineStarsCount += size.amount;
						if (i != lineFirstChildIndex) lineLength += gap;
					}
					else
					{
						// Define size
						var childLength:Number = getSize(size, minSize, maxSize, child.pppt, child.ppem, lineLengthLimit, 0, 0) + margin;
						if (i != lineFirstChildIndex) childLength += gap;

						if (wrap && (i != lineFirstChildIndex))
						{
							var isOverflow:Boolean = lineLength + childLength > lineLengthLimit;
							if (isOverflow) break;
						}

						lineLength += childLength;
					}

					lineLastChildIndex = i;

					// Calculate line thickness
					size = isVertical ? child.width     : child.height;
					minSize = isVertical ? child.minWidth  : child.minHeight;
					maxSize = isVertical ? child.maxWidth  : child.maxHeight;
					margin1 = isVertical ? child.margin.left : child.margin.top;
					margin2 = isVertical ? child.margin.right : child.margin.bottom;

					margin = margin1.toPixels(node.pppt, node.ppem, lineThicknessLimit, 0, 0) + margin2.toPixels(node.pppt, node.ppem, lineThicknessLimit, 0, 0);
					lineThickness = Math.max(lineThickness, getSize(size, minSize, maxSize, child.pppt, child.ppem, lineThicknessLimit, 0, 0) + margin);
				}

				lineStarsTarget = Math.max(0, lineLengthLimit - lineLength);
				//-------------

				var offset:Number = 0;
				for (i = lineFirstChildIndex; i <= lineLastChildIndex; i++)
				{
					child = node.getChildAt(i);

					if (isHorizontal)
					{
						child.bounds.width = getSize(child.width, child.minWidth, child.maxWidth, child.pppt, child.ppem, width, lineStarsTarget, lineStarsCount);
						child.bounds.height = getSize(child.height, child.minHeight, child.maxHeight, child.pppt, node.ppem, height, lineThickness, 1);
						offset += child.margin.left.toPixels(node.pppt, node.ppem, width, 0, 0);
						child.bounds.x = offset;
						offset += child.bounds.width;
						offset += child.margin.right.toPixels(node.pppt, node.ppem, width, 0, 0);
						offset += gap;
						child.bounds.y = lineOffset;
					}
					else if (isVertical)
					{
						child.bounds.width = getSize(child.width, child.minWidth, child.maxWidth, child.pppt, child.ppem, width, lineThickness, 1);
						child.bounds.height = getSize(child.height, child.minHeight, child.maxHeight, child.pppt, node.ppem, height, lineStarsTarget, lineStarsCount);
						offset += child.margin.top.toPixels(node.pppt, node.ppem, width, 0, 0);
						child.bounds.y = offset;
						offset += child.bounds.height;
						offset += child.margin.bottom.toPixels(node.pppt, node.ppem, width, 0, 0);
						offset += gap;
						child.bounds.x = lineOffset;
					}

					child.commit();
				}

				lineOffset += lineThickness + interline;
				lineFirstChildIndex = lineLastChildIndex+1;
			}
		}

		private function getSize(size:Gauge, min:Gauge, max:Gauge, pppt:Number, ppem:Number, percentTarget:Number, starTarget:Number = 0, starCount:Number = 0):Number
		{
			var value:Number = size.toPixels(pppt, ppem, percentTarget, starTarget, starCount);
			if (!min.isNone) value = Math.max(value, min.toPixels(pppt, ppem, percentTarget, starTarget, starCount));
			if (!max.isNone) value = Math.min(value, max.toPixels(pppt, ppem, percentTarget, starTarget, starCount));
			return value;
		}
	}
}