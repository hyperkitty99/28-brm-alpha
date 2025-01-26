package options;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = getLocalizedString("graphics");
		rpcTitle = getLocalizedString("graphicsRPC"); //for Discord Rich Presence

		var option:Option = new Option(getLocalizedString("anti_aliasing"), getLocalizedString("anti_aliasing_des"), 'antialiasing', 'bool');
		addOption(option);

		var option:Option = new Option(getLocalizedString("shaders"), getLocalizedString("shaders_des"), 'shaders', 'bool');
		addOption(option);

		var option:Option = new Option(getLocalizedString("gpu_caching"), getLocalizedString("gpu_caching_des"), 'cacheOnGPU', 'bool');
		addOption(option);

		super();

	}
}