package com.aircapsule
{
	import com.aircapsule.air.World;
	import com.aircapsule.air.collision.ContactInfo;
	import com.aircapsule.air.collision.GJK;
	import com.aircapsule.air.collision.GJKRaycast;
	import com.aircapsule.air.collision.shape.Circle;
	import com.aircapsule.air.collision.shape.Rectangle;
	import com.aircapsule.air.collision.shape.Shape;
	import com.aircapsule.breakOut.display.Ball;
	import com.aircapsule.breakOut.display.Box;
	import com.aircapsule.breakOut.display.PhysicObject;
	import com.aircapsule.breakOut.display.TriangleObject;
	import com.aircapsule.breakOut.scenes.GameScene;
	import com.aircapsule.geom.Minkowski;
	import com.aircapsule.geom.Vector2D;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	[SWF(width="400", height="300", frameRate="60", backgroundColor="#FFFFFF")]
	public class BreakOut extends Sprite
	{
		public function BreakOut(){
			var mon:MonsterDebugger = new MonsterDebugger(this);
			
			var game:GameScene = new GameScene();
			this.addChild(game);
			game.init();
		}
	}
}