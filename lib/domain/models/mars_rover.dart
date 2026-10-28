class RoverCamera {
  const RoverCamera({required this.name, required this.fullName});

  final String name;
  final String fullName;
}

class MarsRover {
  MarsRover({
    required this.id,
    required this.name,
    required this.landingDate,
    required this.launchDate,
    required this.totalPhotos,
    required this.maxDate,
    required List<RoverCamera> cameras,
  }) : cameras = List.unmodifiable(cameras);

  final String id;
  final String name;
  final String landingDate;
  final String launchDate;
  final int totalPhotos;
  final String maxDate;
  final List<RoverCamera> cameras;
}
