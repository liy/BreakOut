package com.aircapsule.breakOut.display
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.shape.Circle;
	import com.aircapsule.geom.Vector2D;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class Ball extends PhysicObject
	{
		public var _radius:Number = 15;
		
		public var _velocity:Vector2D = new Vector2D();
		
		// acceleration
		public var _a:Vector2D = new Vector2D();
		
		public function Ball($radius=15)
		{
			_radius = $radius;
			
			// add the physic object into the physical world, for debug draw.
			shape = new Circle(_radius);
			World.getVisual().addShape(shape);
			
			// test graphics
			this.graphics.beginFill(0x000000, 0.5);
			this.graphics.drawCircle(0, 0, _radius+shape._margin);
			this.graphics.endFill();
		}
		
		public function assginExtraVertices():void{
			var v:Vector2D = new Vector2D(_radius, 0);
			var numOfVertices:uint = 50;
			var interval:Number = Math.PI*2/numOfVertices;
			for(var i:uint=0; i<numOfVertices; ++i){
				var nv:Vector2D = v.clone();
				nv.rotate(interval*i);
				shape._vertices.push(nv);
			}
		}
		
		protected override function mouseDownHandler($e:MouseEvent):void{
			_velocity.x = 0;
			_velocity.y = 0;
			super.mouseDownHandler($e);
		}
		
		/**
		 * 
		 * 
		 */		
		public function move():void{
			// accelerate
			_velocity.add(_a);
			
			// translation
			this.x += _velocity.x;
			this.y += _velocity.y;
		}
	}
}