class NavigationBarResponseModel {
  final String itemName;
  final String itemIcon;

  NavigationBarResponseModel({
    required this.itemName,
    required this.itemIcon,
  });
  factory NavigationBarResponseModel.fromJson(Map<String, dynamic> json) {
    return NavigationBarResponseModel(
      itemName: json['itemName'],
      itemIcon: json['itemIcon'],
    );
  }
}
