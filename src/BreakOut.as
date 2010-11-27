package
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
	import com.aircapsule.breakOut.display.PhysicDO;
	import com.aircapsule.breakOut.display.PolygonDO;
	import com.aircapsule.breakOut.display.TriangleDO;
	import com.aircapsule.geom.Minkowski;
	import com.aircapsule.geom.Vector2D;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#FFFFFF")]
	public class BreakOut extends Sprite
	{
//		private var _ball:Ball;
//		
//		private var _box:Box;
//		
//		private var _gjk:GJK;
//		
//		public function BreakOut()
//		{
//			var mon:MonsterDebugger = new MonsterDebugger(this);
//			
//			var world:World = World.getVisual();
//			world.x = this.stage.stageWidth/2;
//			world.y = this.stage.stageHeight/2;
//			this.addChild(world);
//			world.debugDraw();
//			
//			_ball = new Ball(25);
//			world.addChild(_ball);
//			
//			_box = new Box(0,0,50,50);
//			_box.x = 100;
//			_box.y = 100;
//			world.addChild(_box);
//			
//			_gjk = new GJK();
//			
//			this.addEventListener(Event.ENTER_FRAME, mainLoop);
//		}
//		
//		var degree:Number = 0;
//		
//		private function mainLoop($e:Event){
//			
//			World.getVisual().debugDraw();
//			
//			var contactInfo:ContactInfo = _gjk.start(_ball.shape, _box.shape);
//			if(contactInfo != null){
//				var witnesses:Vector.<Vector2D> = contactInfo._witnesses;
//				
//				for(var i:uint=0; i<witnesses.length; ++i){
//					World.getVisual().graphics.beginFill(0xFF9900, 0.8);
//					World.getVisual().graphics.drawCircle(witnesses[0].x, witnesses[0].y, 2);
//					World.getVisual().graphics.drawCircle(witnesses[1].x, witnesses[1].y, 2);
//					World.getVisual().graphics.endFill();
//				}
//			}
//			
//		}
		
		private var _box1:Box;
		
		private var _box2:Ball;
		
		private var _gjk:GJKRaycast;
		
		private var _minkowski:Minkowski;
		
		public function BreakOut(){
			var mon:MonsterDebugger = new MonsterDebugger(this);
						
			var world:World = World.getVisual();
			world.x = this.stage.stageWidth/2;
			world.y = this.stage.stageHeight/2;
			this.addChild(world);
			world.debugDraw();
			
			_box1 = new Box(0,0,50,50);
			_box1.x = 0;
			_box1.y = 0;
			world.addChild(_box1);
			
			_box2 = new Ball(50);
			_box2.x = 100;
			_box2.y = 100;
			world.addChild(_box2);
			
			_gjk = new GJKRaycast();
			_gjk.r = new Vector2D(-300, -300);
			
			_minkowski = new Minkowski(_box1.shape, _box2.shape);
			_minkowski.draw();
			world.addChild(_minkowski);
			
			this.addEventListener(Event.ENTER_FRAME, mainLoop);
		}
		
		private function mainLoop($e:Event):void{
			
			_minkowski.draw();
			
			World.getVisual().debugDraw();
			
			World.getVisual().graphics.beginFill(0x000000, 1);
			World.getVisual().graphics.lineStyle(1,0xFF0099);
			World.getVisual().graphics.moveTo(0,0);
			World.getVisual().graphics.lineTo(_gjk.r.x,_gjk.r.y);
			
			var collided:Boolean = _gjk.start(_box1.shape, _box2.shape);
			
			
			
		}
	}
}