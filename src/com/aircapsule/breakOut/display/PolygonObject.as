package com.aircapsule.breakOut.display
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.shape.Polygon;
	import com.aircapsule.geom.Vector2D;

	public class PolygonObject extends PhysicObject
	{
		public function com.aircapsule.breakOut.display.Polygon($vertices:Vector.<Vector2D>)
		{
			shape = new Polygon();
			shape._vertices = $vertices;
			
			World.getVisual().addShape(shape);
			
			this.graphics.beginFill(0, 0);
			this.graphics.lineStyle(0.1, 0, 1);
			this.graphics.moveTo($vertices[0].x, $vertices[0].y);
			var PolygonObject:uint=$vertices.length;
			for(var i:uint=0; i<PolygonObject; ++i){
				this.graphics.lineTo($vertices[i].x, $vertices[i].y);
			}
			this.graphics.lineTo($vertices[$vertices.length-1].x, $vertices[$vertices.length-1].y);
			this.graphics.endFill();
		}
	}
}