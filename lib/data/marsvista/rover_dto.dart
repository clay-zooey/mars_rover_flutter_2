import '../../domain/models/mars_rover.dart';

class RoversResponseDto {
  const RoversResponseDto(this.rovers);

  factory RoversResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>;
    return RoversResponseDto(
      data
          .map((item) => RoverDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  final List<RoverDto> rovers;
}

class RoverDto {
  const RoverDto({
    required this.id,
    required this.name,
    required this.landingDate,
    required this.launchDate,
    required this.totalPhotos,
    required this.maxDate,
    required this.cameras,
  });

  factory RoverDto.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>;
    final relationships = json['relationships'] as Map<String, dynamic>?;
    final cameras = relationships?['cameras'] as List<dynamic>? ?? const [];

    return RoverDto(
      id: json['id'] as String,
      name: attributes['name'] as String,
      landingDate: attributes['landing_date'] as String,
      launchDate: attributes['launch_date'] as String,
      totalPhotos: attributes['total_photos'] as int,
      maxDate: attributes['max_date'] as String,
      cameras: cameras
          .map((item) => CameraDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String name;
  final String landingDate;
  final String launchDate;
  final int totalPhotos;
  final String maxDate;
  final List<CameraDto> cameras;

  MarsRover toDomain() => MarsRover(
    id: id,
    name: name,
    landingDate: landingDate,
    launchDate: launchDate,
    totalPhotos: totalPhotos,
    maxDate: maxDate,
    cameras: cameras.map((camera) => camera.toDomain()).toList(),
  );
}

class CameraDto {
  const CameraDto({required this.name, required this.fullName});

  factory CameraDto.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>?;
    return CameraDto(
      name: attributes?['name'] as String? ?? json['id'] as String,
      fullName: attributes?['full_name'] as String? ?? '',
    );
  }

  final String name;
  final String fullName;

  RoverCamera toDomain() => RoverCamera(name: name, fullName: fullName);
}
