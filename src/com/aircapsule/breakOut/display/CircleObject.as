package com.aircapsule.breakOut.display
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.shape.Circle;

	public class CircleObject extends PhysicObject
	{
		public var _radius:Number = 15;
		
		public function CircleObject($radius:Number=10)
		{
			_radius = $radius;
			
			shape = new Circle(_radius);
			World.getVisual().addShape(shape);
			
			// test graphics
			this.graphics.beginFill(0x00FF00, 1);
			this.graphics.drawCircle(0, 0, _radius+shape._margin);
			this.graphics.endFill();
		}
	}
}