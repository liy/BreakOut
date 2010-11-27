package com.aircapsule.breakOut.display
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.shape.Circle;
	import com.aircapsule.geom.Vector2D;
	
	import flash.display.Sprite;

	public class Ball extends PhysicDO
	{
		public function Ball($radius=50)
		{
			shape = new Circle($radius);
			
			World.getVisual().addShape(shape);
			
//			var v:Vector2D = new Vector2D($radius, 0);
//			var numOfVertices:uint = 50;
//			var interval:Number = Math.PI*2/numOfVertices;
//			for(var i:uint=0; i<numOfVertices; ++i){
//				var nv:Vector2D = v.clone();
//				nv.rotate(interval*i);
//				shape._vertices.push(nv);
//			}
			
			this.graphics.beginFill(0, 0);
			this.graphics.drawCircle(0, 0, $radius);
			this.graphics.endFill();
		}
	}
}