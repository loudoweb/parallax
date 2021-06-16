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
	var bgPos:Point;

	public function new() 
	{
		super();
		
		zoom = 1;
		
		//stage.displayState = StageDisplayState.FULL_SCREEN;
		
		
		// Assets:
		var data = openfl.Assets.getBitmapData("img/background-full0000.png");
		image = new Bitmap(data, null, true);
		addChild(image);
		
		setZoomBounds();
		
		bgPos = new Point();
		
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
		minZoom = stage.stageHeight / image.height;
		deltaZoom = (1 - minZoom) / 2;
		maxZoom = 1;
		do {
			maxZoom += deltaZoom;
		}while (maxZoom < 1.2);
		
		trace(minZoom, zoom, maxZoom);
	}
	
	function onResize(e:Event):Void
	{
		trace("resize");
		setZoomBounds();
		//find closest zoom to current
		var closest = minZoom - deltaZoom;
		var temp = closest;
		var diff = 42.;
		do {
			temp += deltaZoom;
			if (zoom - temp < diff)
			{
				diff = zoom - temp;
				closest = temp;
			}
		}while (closest < maxZoom && diff != 0);
		
		if (closest != zoom)
		{
			zoom = closest;
			//apply zoom TODO
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
		var preZoom = zoom;
		zoom += e.delta/100 * deltaZoom;
		if (zoom > maxZoom)
			zoom = maxZoom;
		if (zoom < minZoom)
			zoom = minZoom;
			
		if (preZoom == zoom)
			return;

		var imagePivot = image.globalToLocal(new Point(e.stageX, e.stageY));
			
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
