package parallax;
import haxe.xml.Access;
using parallax.ParallaxHelper;

/**
 * ...
 * @author Ludovic Bas - www.loudoweb.fr
 */
class ParallaxLayer
{
	/**
	 * Name of the layer
	 */
	public var id:String;
	/**
	 * Depth of the layer in the world. This allow the layer to move at different speed
	 */
	public var depth:Float;
	
	public var originX:Float;
	public var originY:Float;
	
	public var x:Float;
	public var y:Float;
	public var scale:Float;
	
	public var sprites:Array<ParallaxSprite>;
	
	public function new(id:String, depth:Float, x:Float, y:Float) 
	{
		this.id = id;
		this.depth = depth;
		this.originX = x;
		this.originY = y;
		this.x = x;
		this.y = y;
		this.scale = 1;
	}
		
	public function addSprite(sprite:ParallaxSprite):Void
	{
		sprites.push(sprite);
	}
	
	public static function parse(xml:Access):ParallaxLayer
	{
		var layer = new ParallaxLayer(xml.att.id, xml.getFloat("depth", 1), xml.getFloat("x"), xml.getFloat("y"));
		
		if (layer.sprites == null)
			layer.sprites = [];
		
		for (item in xml.nodes.sprite)
		{
			layer.addSprite(ParallaxSprite.parse(item));
		}
		return layer;
	}
	
}