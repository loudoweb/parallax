package parallax.engines;
import openfl.display.DisplayObject;
import parallax.Parallax;
import parallax.ParallaxLayer;

/**
 * ...
 * @author Ludovic Bas - www.lugludum.com
 * TODO could use typedef of whatever to be used with any engines and not just openfl
 */
class OpenflHelper
{
	/**
	 * Helper to get width and height of main image to auto set the bounds of the parallax world.
	 * @param	parallax
	 * @param	layer
	 * @param	container
	 */
	inline public static function setWorldBounds(parallax:Parallax, layer:ParallaxLayer, container:DisplayObject ):Void
	{
		if (parallax.world != "" && layer.id == parallax.world)
		{
			parallax.width = container.width;
			parallax.height = container.height;
			parallax.world = "";//reset to avoid setting again with other image
		}
	}
}