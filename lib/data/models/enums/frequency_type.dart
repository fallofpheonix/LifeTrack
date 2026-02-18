enum FrequencyType {
  daily,
  weekly,
  monthly,
  interval,
  asNeeded;

  String toJson() => name;
  static FrequencyType fromJson(String json) => values.byName(json);
}
