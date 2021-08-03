package sample;

import haxe.xml.Access;
import motion.Actuate;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.display.StageDisplayState;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import parallax.Parallax;
import parallax.ParallaxLayer;
import parallax.engines.OpenflHelper;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 */
class OpenflSample extends Sprite 
{
	
	var parallax:Parallax;
	var containers:Array<Sprite>;
	
	var dragX:Float;
	var dragY:Float;

	public function new() 
	{
		super();
		
		//parallax
		var xml = Xml.parse(Assets.getText("parallax.xml"));
		parallax = Parallax.parse(xml, stage.stageWidth, stage.stageHeight);
		
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
				var spr:DisplayObject = null;
				if (sprite.img != "")
				{
					spr = new Bitmap(Assets.getBitmapData("img/" + sprite.img), null, true);
					spr.name = sprite.id;
					//width and height can be set by xml, but doing it in code make the xml easier to fulfill
					sprite.width = Std.int(spr.width);
					sprite.height = Std.int(spr.height);
				}else{
					spr = new Sprite();
					spr.name = sprite.id;
				}
				
				spr.x = sprite.originX;
				spr.y = sprite.originY;
				container.addChild(spr);
				OpenflHelper.setWorldBounds(parallax, layer, spr);
			}
		}
		#if (gs || gs2)
		parallax.setZoomBounds(1080);
		#else
		parallax.setZoomBounds(stage.stageHeight);
		#end	
		
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onDragStart);
		stage.addEventListener(MouseEvent.MIDDLE_CLICK, onReset);
		stage.addEventListener(Event.RESIZE, onResize);
	}
	
	function onResize(e:Event):Void
	{
		parallax.camera.width = stage.stageWidth;
		parallax.camera.height = stage.stageHeight;
		#if (gs || gs2)
		parallax.setZoomBounds(1080);
		#else
		parallax.setZoomBounds(stage.stageHeight);
		#end
	}
	
	function onReset(e:MouseEvent):Void
	{
		e.preventDefault();
		parallax.camera.zoom = 1;
		parallax.checkBounds();
		for (i in 0...containers.length)
		{
			var container = containers[i];
			if(parallax.layers[i].depth != 0)
				container.scaleX = container.scaleY = parallax.layers[i].scale * parallax.camera.zoom;
		}
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
			
			if (parallax.pushApartOnZoom > 0)
			{
				for (j in 0...containers[i].numChildren)
				{
					containers[i].getChildAt(j).x = parallax.layers[i].sprites[j].x;
					containers[i].getChildAt(j).y = parallax.layers[i].sprites[j].y;
				}
			}
		}
	
	}

	function onWheel(e:MouseEvent):Void
	{
		parallax.onZoom(e.delta / 100, e.stageX, e.stageY);
		
		for (i in 0...containers.length)
		{
			var container = containers[i];
			if (parallax.layers[i].depth != 0)
			{
				container.scaleX = container.scaleY = parallax.layers[i].scale * parallax.camera.zoom;
				container.x = parallax.layers[i].x;
				container.y = parallax.layers[i].y;
			}
		}
		
	}

}
