package  
{
import cn.geckos.MousePathSmoothing;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
/**
 * ...测试
 * @author 
 */
public class MousePathSmoothingTest extends Sprite 
{
	private var mousePathSmoothing:MousePathSmoothing;
	public function MousePathSmoothingTest() 
	{
		var spt:Sprite = new Sprite();
		this.addChild(spt);
		this.mousePathSmoothing = new MousePathSmoothing(spt, stage, 30);
		this.mousePathSmoothing.init();
		stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
	}
	
	private function KeyDownHandler(event:KeyboardEvent):void 
	{
		this.mousePathSmoothing.destroy();
		this.mousePathSmoothing.init();
	}
}
}