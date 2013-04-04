package cn.geckos 
{
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.geom.Point;
/**
 * ...平滑鼠标路径
 * @author Kanon 
 */
public class MousePathSmoothing
{
	//舞台
	private var stage:Stage;
	//画布
	private var canvas:Sprite;
	//存放线条点列表
	private var points:Array;
	//平滑长度 值越大越平滑
	private var smoothLength:int;
	//保存下一个点的绘制距离
	private var distance:Number;
	public function MousePathSmoothing(canvas:Sprite, stage:Stage, smoothLength:int) 
	{
		this.stage = stage;
		this.canvas = canvas;
		this.smoothLength = smoothLength;
	}
	
	/**
	 * 初始化
	 */
	public function init():void
	{
		this.points = [];
		this.distance = 10;
		this.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
	}
	
	private function onMouseDownHandler(event:MouseEvent):void 
	{
		this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
		this.canvas.graphics.clear();
		this.clearList(this.points);
		for (var i:int = 0; i < this.smoothLength + 1; i++)
		{
			this.points.push(new Point(this.stage.mouseX, this.stage.mouseY));
		}
	}
	
	private function onMouseUpHandler(event:MouseEvent):void 
	{
		this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
	}
	
	private function onMouseMoveHandler(event:MouseEvent):void 
	{
		var p:Point = new Point(this.stage.mouseX, this.stage.mouseY);
		var last:Point = this.points[this.points.length - 1];
		if (Point.distance(p, last) > this.distance)
		{
			this.points.push(p);
			this.smoothing(this.points, this.smoothLength);
			this.canvas.graphics.clear();
			this.drawLine(this.canvas, this.points);
		}
	}
	
	/**
	 * 平滑算法
	 * @param	points        路径
	 * @param	smoothLength  平滑长度 值越大越平滑
	 */
	private function smoothing(points:Array, smoothLength:int):void
	{
		for (var i:int = 0; i < smoothLength; i += 1)
		{
			var index:int = points.length - i - 2;
			var p1:Point = points[index];
			var p2:Point = points[index + 1];
			var a:Number = .2;
			points[index] = new Point(p1.x * (1 - a) + p2.x * a, 
									  p1.y * (1 - a) + p2.y * a);
		}
	}
	
	/**
	 * 绘制线条
	 * @param	canvas   画布
	 * @param	points   线条的节点列表
	 */
	private function drawLine(canvas:Sprite, points:Array):void
	{
		var startPos:Point = points[0];
		canvas.graphics.lineStyle(1, 0xFF0000);
		canvas.graphics.moveTo(startPos.x, startPos.y);
		var length:int = points.length;
		var p:Point;
		for (var i:int = 1; i < length; i++)
		{
			p = points[i];
			canvas.graphics.lineTo(p.x, p.y);
		}
	}
	
	/**
	 * 清空列表
	 * @param	arr  需要清空列表
	 */
	private function clearList(arr:Array):void
	{
		if (!arr) return;
		var length:int = arr.length;
		for (var i:int = length - 1; i >= 0; i -= 1)
		{
			arr.splice(i, 1);
		}
	}
	
	/**
	 * 销毁
	 */
	public function destroy():void
	{
		if (this.stage)
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
		}
		this.clearList(this.points);
		this.points = null;
		if (this.canvas)
			this.canvas.graphics.clear();
	}
}
}