class Themes {
  int themeId;
  String themeName;

  Themes({this.themeId, this.themeName});

  static List<Themes> getThemes() {
    return <Themes>[
      Themes(themeId: 1, themeName: "Light Mode"),
      Themes(themeId: 2, themeName: "Dark Mode"),
    ];
  }
}
