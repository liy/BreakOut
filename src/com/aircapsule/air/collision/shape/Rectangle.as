package com.aircapsule.air.collision.shape
{
	import com.aircapsule.geom.Vector2D;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class Rectangle extends Shape
	{
		protected var _width:Number;
		
		protected var _height:Number
		
		public function Rectangle($x:Number, $y:Number, $width:Number, $height:Number)
		{
			_vertices[0] = new Vector2D($x, $y);
			_vertices[1] = new Vector2D($x + $width, $y);
			_vertices[2] = new Vector2D($x + $width, $y + $height);
			_vertices[3] = new Vector2D($x, $y + $height);
			
			_width = $width;
			_height = $height;
		}
		
		public function get width():Number{
			return _width;
		}
		
		public function get height():Number{
			return _height;
		}
	}
}