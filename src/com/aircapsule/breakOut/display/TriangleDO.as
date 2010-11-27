package com.aircapsule.breakOut.display
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.shape.Triangle;

	public class TriangleDO extends PhysicDO
	{
		public function TriangleDO()
		{
			shape = new Triangle();
			
			World.getVisual().addShape(shape);
			
			this.graphics.beginFill(0, 0);
			this.graphics.moveTo(shape._vertices[0].x, shape._vertices[0].y);
			this.graphics.lineTo(shape._vertices[1].x, shape._vertices[1].y);
			this.graphics.lineTo(shape._vertices[2].x, shape._vertices[2].y);
			this.graphics.lineTo(shape._vertices[0].x, shape._vertices[0].y);
			this.graphics.endFill();
		}
	}
}