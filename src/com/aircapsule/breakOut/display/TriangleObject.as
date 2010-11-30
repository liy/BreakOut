package com.aircapsule.breakOut.display
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.shape.Triangle;
	import com.aircapsule.geom.Vector2D;

	public class TriangleObject extends PhysicObject
	{
		public function TriangleObject($edgeLen:Number=15)
		{
			var margin:Number = 4;
			var v:Vector2D = new Vector2D($edgeLen+margin*2, 0);
			var A:Vector2D = new Vector2D(-margin, -margin);
			var B:Vector2D = A.addNew(v);
			v.rotate(Math.PI/3);
			var	C:Vector2D = A.addNew(v);
			
			shape = new Triangle($edgeLen, A, B, C);
			
			World.getVisual().addShape(shape);
			
			var v:Vector2D = new Vector2D($edgeLen+shape._margin*2, 0);
			v.rotate(Math.PI/3);
			C = A.addNew(v);
			
			this.graphics.beginFill(0x00FFCC, 0.4);
			this.graphics.moveTo(A.x, A.y);
			this.graphics.lineTo(B.x, B.y);
			this.graphics.lineTo(C.x, C.y);
			this.graphics.lineTo(A.x, A.y);
			this.graphics.endFill();
		}
	}
}