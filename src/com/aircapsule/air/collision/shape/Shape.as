package com.aircapsule.air.collision.shape
{
	import com.aircapsule.air.World;
	import com.aircapsule.geom.AffineTransform;
	import com.aircapsule.geom.Vector2D;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class Shape
	{
		/**
		 * Geometric vertices. Has not been transformed 
		 */		
		public var _vertices:Vector.<Vector2D>;
		
		protected var _affineTransform:AffineTransform;
		
		public var _fillColour:uint = 0xCCCCCC;
		
		public var _strockColour:uint = 0xDDDDDD;
		
		public var _alpha:Number = 0.8;
		
		public var _margin:Number = 4;
		
		public function Shape()
		{
			_vertices = new Vector.<Vector2D>();
			_affineTransform = new AffineTransform();
		}
		
		/**
		 * 
		 * 
		 */		
		public function draw():void{
			var vertices:Vector.<Vector2D> = this.getTransformedVertices();
			
			World.getVisual().graphics.beginFill(_fillColour, _alpha);
			World.getVisual().graphics.lineStyle(1, _strockColour, _alpha);
			World.getVisual().graphics.moveTo(vertices[0].x, vertices[0].y);
			var len:uint=vertices.length;
			for(var i:uint=0; i<len; ++i){
				World.getVisual().graphics.lineTo(vertices[i].x, vertices[i].y);
			}
			World.getVisual().graphics.lineTo(vertices[vertices.length-1].x, vertices[vertices.length-1].y);
			World.getVisual().graphics.endFill();
		}
		
		/**
		 *
		 * @param $tf No need to clone. 
		 * 
		 */		
		public function set affineTransform($tf:AffineTransform):void{
			_affineTransform = $tf;
			
			// no need to apply any transformations to the vertices. This Shape class only represents the original transformation
			// When comes to read the geometric using support mapping, only search direction should be transformed instead of the whole vertices array.
		}
		
		public function get affineTransform():AffineTransform{
			return _affineTransform;
		}
		
		/**
		 * Get the transformed vertices. 
		 * @return 
		 * 
		 */		
		public function getTransformedVertices():Vector.<Vector2D>{
			var vertices:Vector.<Vector2D> = new Vector.<Vector2D>();
			var len:uint = _vertices.length;
			for(var i:uint=0; i<len; ++i){
				vertices.push(_affineTransform.transformVector(_vertices[i].clone()));
			}
			return vertices;
		}
		
		/**
		 * Get the support point of the shape on a specific direction. 
		 * @param $d The direction, no need to pass clone.
		 * @return The transformed support point furtheset along a give direction.
		 * 
		 */		
		public function getSupport($d:Vector2D):Vector2D{
			// instead of transform the whole vertices array. We only transform the search direction.
			// And the support point transformation only related to the rotation transformation.
			var td:Vector2D = _affineTransform.transformSupportSearchDir($d.clone());
			
			var bestValue:Number = _vertices[0].dot(td);
			var bestIndex:uint = 0;
			
			var len:uint=_vertices.length;
			for(var i:uint=1; i<len; ++i){
				var value:Number = _vertices[i].dot(td);
				if(value>bestValue){
					bestValue = value;
					bestIndex = i;
				}
			}
			
			// return the transformed support vector
			return _affineTransform.transformVector(_vertices[bestIndex].clone());
		}
	}
}