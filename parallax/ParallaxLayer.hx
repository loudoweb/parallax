package parallax;
import haxe.xml.Access;
using kadabra.utils.XMLUtils;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
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
	
	public var x:Int;
	public var y:Int;
	public var scale:Float;
	
	public var sprites:Array<ParallaxSprite>;
	
	public function new(id:String, depth:Float, x:Int, y:Int) 
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
		var layer = new ParallaxLayer(xml.att.id, xml.getFloat("depth", 1), xml.getInt("x"), xml.getInt("y"));
		
		if (layer.sprites == null)
			layer.sprites = [];
		
		for (item in xml.nodes.sprite)
		{
			layer.addSprite(ParallaxSprite.parse(item));
		}
		return layer;
	}
	
}