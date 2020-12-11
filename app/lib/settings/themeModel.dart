class ThemeModel {
  String name;
  int index;
  ThemeModel({this.name, this.index});

  static List<ThemeModel> getTheme() {
    return <ThemeModel>[
      ThemeModel(name: "Light Mode", index: 1),
      ThemeModel(name: "Dark Mode", index: 2),
    ];
  }
}
