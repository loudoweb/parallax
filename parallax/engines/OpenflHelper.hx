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