import '../../domain/models/mars_photo.dart';

class PhotosResponseDto {
  const PhotosResponseDto({required this.photos, required this.hasMore});

  factory PhotosResponseDto.fromJson(
    Map<String, dynamic> json, {
    required int pageSize,
  }) {
    final data = json['data'] as List<dynamic>;
    return PhotosResponseDto(
      photos: data
          .map((item) => PhotoDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      hasMore: data.length == pageSize,
    );
  }

  final List<PhotoDto> photos;
  final bool hasMore;

  PhotoPage toDomain() => PhotoPage(
    photos: photos.map((photo) => photo.toDomain()).nonNulls.toList(),
    hasMore: hasMore,
  );
}

class PhotoDto {
  const PhotoDto({required this.id, required this.images});

  factory PhotoDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String && id is! num) {
      throw const FormatException('Invalid photo identifier');
    }
    final attributes = json['attributes'] as Map<String, dynamic>;
    return PhotoDto(
      id: id.toString(),
      images: attributes['images'] == null
          ? null
          : PhotoImagesDto.fromJson(
              attributes['images'] as Map<String, dynamic>,
            ),
    );
  }

  final String id;
  final PhotoImagesDto? images;

  MarsPhoto? toDomain() {
    final url =
        images?.medium ?? images?.large ?? images?.full ?? images?.small;
    if (url == null) return null;
    return MarsPhoto(id: id, imageUrl: url, fullResolutionUrl: images?.full);
  }
}

class PhotoImagesDto {
  const PhotoImagesDto({this.small, this.medium, this.large, this.full});

  factory PhotoImagesDto.fromJson(Map<String, dynamic> json) => PhotoImagesDto(
    small: json['small'] as String?,
    medium: json['medium'] as String?,
    large: json['large'] as String?,
    full: json['full'] as String?,
  );

  final String? small;
  final String? medium;
  final String? large;
  final String? full;
}
