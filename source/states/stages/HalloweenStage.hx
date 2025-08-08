package states.stages;

class HalloweenStage extends BaseStage
{
	override function create()
	{
        var sky:BGSprite = new BGSprite('spooky/sky', -1248, -1041, 1, 1);
        add(sky);

        var moon:BGSprite = new BGSprite('spooky/moon', -1315, -995, 0.1, 0.1);
        add(moon);

        var clouds:BGSprite = new BGSprite('spooky/clouds', -1286, -1146, 0.2, 0.2);
        add(clouds);
        
        var buildings:BGSprite = new BGSprite('spooky/buildings', -1288, -1235, 0.6, 0.6);
        add(buildings);

        var bgmain:BGSprite = new BGSprite('spooky/bgmain', -1230, -1378, 1, 1);
        add(bgmain);

        var lolas:BGSprite = new BGSprite('spooky/lolas', -17, 263, 1, 1, ['persjnaoi'], true);
        add(lolas);
	}

	override function createPost()
	{

	}
}