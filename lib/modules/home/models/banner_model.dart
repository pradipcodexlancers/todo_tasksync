/// Banner Data Model
///
/// Represents promotional or featured banners on the Home screen.
class BannerModel {
  final String id;
  final String title;
  final String imageUrl;
  final String? redirectUrl;

  const BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.redirectUrl,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      redirectUrl: json['redirect_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'redirect_url': redirectUrl,
    };
  }
}
