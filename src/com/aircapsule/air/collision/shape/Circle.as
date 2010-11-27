package com.aircapsule.air.collision.shape
{
	import com.aircapsule.air.World;
	import com.aircapsule.geom.Vector2D;
	
	import flash.display.Sprite;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class Circle extends Shape
	{
		public var radius:Number = 50;
		
		public function Circle($radius:Number=50)
		{
			_vertices[0] = new Vector2D();
			
			radius = $radius;
			
//			var v:Vector2D = new Vector2D(radius, 0);
//			var numOfVertices:uint = 50;
//			var interval:Number = Math.PI*2/numOfVertices;
//			for(var i:uint=0; i<numOfVertices; ++i){
//				var nv:Vector2D = v.clone();
//				nv.rotate(interval*i);
//				_vertices.push(nv);
//			}
		}
		
		public override function draw():void{
			World.getVisual().graphics.beginFill(_fillColour, _alpha);
			World.getVisual().graphics.lineStyle(1, _strockColour, _alpha);
			World.getVisual().graphics.drawCircle(_vertices[0].x+_affineTransform.tx, _vertices[0].y+_affineTransform.ty, radius);
			World.getVisual().graphics.endFill();
		}
		
		public override function getSupport($d:Vector2D):Vector2D{
			var s:Vector2D = $d.getUnit();
			
			// transform support point vector
			s.scale(radius);
			s.x += _affineTransform.tx;
			s.y += _affineTransform.ty;
			
			return s;
		}
	}
}