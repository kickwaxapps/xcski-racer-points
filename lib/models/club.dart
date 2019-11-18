class Club {
  final int id;
  final String name;
  final String iconPath;
  final String province;

  Club({this.id, this.name, this.iconPath, this.province});

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'] as int,
      name: json['name'] as String,
      iconPath: json['icon_path'] as String,
      province: json['province'] as String
    );    
  }

  bool get isNone => id == 575;
}
