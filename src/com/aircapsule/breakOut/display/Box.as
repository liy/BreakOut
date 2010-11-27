package com.aircapsule.breakOut.display
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.shape.Rectangle;
	import com.aircapsule.geom.Vector2D;

	public class Box extends PhysicObject
	{
		/**
		 * Friction: 0-1, 1 means none, 0 means max friction 
		 */		
		public var _friction:Number = 1;
		
		/**
		 * bounce: 0-infinity, 0 means no bounce at all, 1 means rigid surface, >1 means extra bounce
		 */		
		public var _bounce:Number = 1;
		
		public function Box($x:Number, $y:Number, $width:Number, $height:Number)
		{
			shape = new Rectangle($x, $y, $width, $height);
			
			World.getVisual().addShape(shape);
			
			this.graphics.beginFill(0xFF0000, 1);
			this.graphics.lineStyle(1, 0, 0);
			this.graphics.drawRect($x-shape._margin, $y-shape._margin, $width+shape._margin*2, $height+shape._margin*2);
			this.graphics.endFill();
		}
	}
}