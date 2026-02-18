enum DataSource {
  manual,
  wearable,
  imported,
  migrated,
  system;

  String toJson() => name;
  static DataSource fromJson(String json) => values.byName(json);
}
