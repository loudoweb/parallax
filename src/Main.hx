package;

import motion.Actuate;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.display.StageDisplayState;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class Main extends Sprite 
{
	
	public var image:Bitmap;
	
	
	var deltaZoom:Float;
	var maxZoom:Float;
	var minZoom:Float;
	var zoom:Float;
	var preZoom:Float;
	var bgPos:Point;
	var imagePivot:Point;

	public function new() 
	{
		super();
		
		zoom = 1;
		
		bgPos = new Point();
		imagePivot = new Point();
		
		// Assets:
		var data = openfl.Assets.getBitmapData("img/background-full0000.png");
		image = new Bitmap(data, null, true);
		addChild(image);
		
		setZoomBounds();
		
		imagePivot.setTo(stage.stageWidth / 2, stage.stageHeight / 2);
		
		
		stage.addEventListener(MouseEvent.CLICK, onClick);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		stage.addEventListener(MouseEvent.RIGHT_CLICK, onReset);
		stage.addEventListener(Event.RESIZE, onResize);
	}
	
	function setZoomBounds():Void
	{
		//zoom bounds
		//to have fluid zoom
		minZoom = stage.stageHeight / (image.height / image.scaleY);
		trace("image height", image.height / image.scaleY, "stage", stage.stageHeight);
		deltaZoom = (1 - minZoom) / 2;
		maxZoom = 1;
		do {
			maxZoom += deltaZoom;
		}while (maxZoom < 1.2);
		
	}
	
	function onResize(e:Event):Void
	{
		setZoomBounds();
		var values = [for (i in 0...5) i * deltaZoom + minZoom];
		trace(values);
		//find closest zoom to current
		var closest = 42.;
		for (item in values)
		{
			if ( Math.abs(item - zoom) < Math.abs(zoom - closest))
				closest = item;
		}
		
		if (closest != zoom)
		{
			trace("resize", minZoom, "old", zoom, "closest", closest, maxZoom);
			zoom = closest;
			applyZoom();
		}
		
	}
	
	function onReset(e:MouseEvent):Void
	{
		zoom = 1;
		Actuate.tween(image, 0.25, {scaleX: zoom, scaleY: zoom});
	}
	
	function onUpdate(e:Event):Void
	{
		if (this.mouseX < 30)
		{
			image.x += 10;
		}else if (this.mouseX > stage.stageWidth - 30)
		{
			image.x -= 10;
		}else if (this.mouseY < 30)
		{
			image.y += 10;
		}else if (this.mouseY > stage.stageHeight - 30)
		{
			image.y -= 10;
		}else{
			return;
		}
		bgPos.setTo(image.x, image.y);
		checkBounds(bgPos, stage.stageWidth, stage.stageHeight, image.width, image.height);
		image.x = bgPos.x;
		image.y = bgPos.y;
			
	}
	function onClick(e:MouseEvent):Void
	{
		stage.displayState = StageDisplayState.FULL_SCREEN;
		
	}
	function onWheel(e:MouseEvent):Void
	{
		preZoom = zoom;
		zoom += e.delta/100 * deltaZoom;
		if (zoom > maxZoom)
			zoom = maxZoom;
		if (zoom < minZoom)
			zoom = minZoom;
		
		imagePivot = image.globalToLocal(new Point(e.stageX, e.stageY));
			
		applyZoom();
		
	}
	
	function applyZoom():Void
	{
		if (preZoom == zoom)
			return;
			
		var offsetX = image.x + imagePivot.x * preZoom - imagePivot.x * zoom;
		var offsetY = image.y + imagePivot.y * preZoom - imagePivot.y * zoom;

		bgPos.setTo(offsetX, offsetY);
		image.scaleX = image.scaleY = zoom;
		checkBounds(bgPos, stage.stageWidth, stage.stageHeight, image.width, image.height);
		image.x = bgPos.x;
		image.y = bgPos.y;
	}
	
	function checkBounds(pt:Point, screenX:Int, screenY:Int, imageWidth:Float, imageHeight:Float):Void{
		if (pt.x > 0){
			pt.x = 0;
		}else if (pt.x < screenX - imageWidth){
			pt.x = screenX - imageWidth;
		}
			
		if (pt.y > 0){
			pt.y = 0;
		}else if (pt.y < screenY - imageHeight){
			pt.y = screenY - imageHeight;
		
		}
	}

}
