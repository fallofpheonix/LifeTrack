/// Prototype for Phase 12: Platform Maturity
/// Handles dynamic loading of feature plugins.

abstract class LifeTrackPlugin {
  String get id;
  String get name;
  void init();
}

class PluginManager {
  final Map<String, LifeTrackPlugin> _plugins = {};

  void register(LifeTrackPlugin plugin) {
    _plugins[plugin.id] = plugin;
    plugin.init();
    print('Plugin registered: ${plugin.name}');
  }

  LifeTrackPlugin? getPlugin(String id) => _plugins[id];
}

// Example Plugin
class NutritionPlugin implements LifeTrackPlugin {
  @override
  String get id => 'com.lifetrack.nutrition';
  
  @override
  String get name => 'Advanced Nutrition';
  
  @override
  void init() {
    // Initialize nutrition specific DB tables or Services
  }
}
