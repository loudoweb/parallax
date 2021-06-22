package;

import haxe.xml.Access;
import motion.Actuate;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.display.StageDisplayState;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import parallax.Parallax;
import parallax.ParallaxLayer;

/**
 * ...
 * @author Ludovic Bas - www.loudoweb.fr
 */
class Main extends Sprite 
{
	var bgPos:Point;
	var imagePivot:Point;
	
	var parallax:Parallax;
	var containers:Array<Sprite>;
	
	var dragX:Float;
	var dragY:Float;

	public function new() 
	{
		super();
		
		//parallax
		var xml = Xml.parse(Assets.getText("parallax.xml"));
		parallax = Parallax.parse(xml);
		
		bgPos = new Point();
		imagePivot = new Point();
		
		containers = [];
		
		// Assets:
		for (layer in parallax.layers)
		{
			var container = new Sprite();
			container.name = layer.id;
			
			container.x = layer.x;
			container.y = layer.y;
			addChild(container);
			containers.push(container);
			for (sprite in layer.sprites)
			{
				var spr = new Bitmap(Assets.getBitmapData("img/" + sprite.img), null, true);
				spr.name = sprite.id;
				spr.x = sprite.originX;
				spr.y = sprite.originY;
				container.addChild(spr);
				if (parallax.world != "" && layer.id == parallax.world)
				{
					parallax.width = container.width;
					parallax.height = container.height;
					parallax.world = "";//reset to avoid setting again with other image
				}
			}
		}
		
		trace(parallax);
		
		parallax.setZoomBounds(stage.stageHeight);
		
		imagePivot.setTo(stage.stageWidth / 2, stage.stageHeight / 2);
		
		
		//stage.addEventListener(MouseEvent.CLICK, onClick);
		//stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onDragStart);
		//stage.addEventListener(MouseEvent.RIGHT_CLICK, onReset);
		//stage.addEventListener(Event.RESIZE, onResize);
	}
	
	function onResize(e:Event):Void
	{
		//parallax.camera.width = stage.stageWidth;
		//parallax.camera.height = stage.stageHeight;
		parallax.setZoomBounds(stage.stageHeight);
		/*var values = [for (i in 0...5) i * deltaZoom + minZoom];
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
		}*/
		
	}
	
	function onReset(e:MouseEvent):Void
	{
		//parallax.zoom = 1;
		/*for (container in containers)
		{
			Actuate.tween(container, 0.25, {scaleX: zoom, scaleY: zoom});
		}*/
	}
	
	function onDragStart(e:MouseEvent):Void
	{
		dragX = e.stageX;
		dragY = e.stageY;
		stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragMove);
		stage.addEventListener(MouseEvent.MOUSE_UP, onDragEnd);
		stage.addEventListener(MouseEvent.RELEASE_OUTSIDE, onDragEnd);
	}
	
	function onDragEnd(e:MouseEvent):Void
	{
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragMove);
		stage.removeEventListener(MouseEvent.MOUSE_UP, onDragEnd);
		stage.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onDragEnd);
	}
	
	function onDragMove(e:MouseEvent):Void
	{

		
		parallax.moveCamera(dragX - e.stageX, dragY - e.stageY);
		dragX = e.stageX;
		dragY = e.stageY;
		for (i in 0...containers.length)
		{
			containers[i].x = parallax.layers[i].x;
			containers[i].y = parallax.layers[i].y;
		}
		//bgPos.setTo(image.x, image.y);
		//checkBounds(bgPos, stage.stageWidth, stage.stageHeight, image.width, image.height);
		//image.x = bgPos.x;
		//image.y = bgPos.y;
			
	}
	function onClick(e:MouseEvent):Void
	{
		stage.displayState = StageDisplayState.FULL_SCREEN;
		
	}
	function onWheel(e:MouseEvent):Void
	{
		parallax.onZoom(e.delta / 100);
		
	}

}
