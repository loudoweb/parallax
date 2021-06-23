package sample;

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
		parallax = Parallax.parse(xml);
		
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
				OpenflHelper.setWorldBounds(parallax, layer, spr);
			}
		}
				
		parallax.setZoomBounds(stage.stageHeight);		
		
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onDragStart);
		stage.addEventListener(MouseEvent.MIDDLE_CLICK, onReset);
		stage.addEventListener(Event.RESIZE, onResize);
	}
	
	function onResize(e:Event):Void
	{
		//parallax.camera.width = stage.stageWidth;
		//parallax.camera.height = stage.stageHeight;
		parallax.setZoomBounds(stage.stageHeight);
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
		}
	
	}

	function onWheel(e:MouseEvent):Void
	{
		parallax.onZoom(e.delta / 100, e.stageX + parallax.camera.x, e.stageY + parallax.camera.y);
		
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
