package com.aircapsule.breakOut.display
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.shape.Rectangle;
	import com.aircapsule.geom.Vector2D;
	
	import flash.geom.Point;

	public class Box extends PhysicObject
	{
		public var _actualWidth:Number;
		
		public var _actualHeight:Number
		
		public function Box($x:Number, $y:Number, $width:Number, $height:Number)
		{
			shape = new Rectangle($x, $y, $width, $height);
			
			_actualWidth = $width+shape._margin*2;
			_actualHeight = $height+shape._margin*2;
			
			World.getVisual().addShape(shape);
			
			this.graphics.beginFill(0xFF0000, 1);
			this.graphics.drawRect($x-shape._margin, $y-shape._margin, $width+shape._margin*2, $height+shape._margin*2);
			this.graphics.endFill();
		}
		
		public function get margin():Number{
			return shape._margin;
		}
	}
}