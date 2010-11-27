package com.aircapsule.breakOut.display
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.shape.Rectangle;
	import com.aircapsule.geom.Vector2D;

	public class Box extends PhysicDO
	{
		public function Box($x:Number, $y:Number, $width:Number, $height:Number)
		{
			shape = new Rectangle($x, $y, $width, $height);
			
			World.getVisual().addShape(shape);
			
			this.graphics.beginFill(0xFF0000, 0);
			this.graphics.lineStyle(1, 0, 0);
			this.graphics.drawRect($x, $y, $width, $height);
			this.graphics.endFill();
		}
	}
}