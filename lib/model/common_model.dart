class CommonModel {
  final String icon;
  final String title;
  final String url;
  final String statesBarColor;
  final bool hideAppBar;

  CommonModel({
    required this.icon,
    required this.title,
    required this.url,
    required this.statesBarColor,
    required this.hideAppBar,
  });

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
      icon: json['icon'],
      title: json['title'],
      url: json['url'],
      statesBarColor: json['statesBarColor'],
      hideAppBar: json['hideAppBar'],
    );
  }
}