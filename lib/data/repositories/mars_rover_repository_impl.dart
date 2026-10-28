import '../../domain/models/app_error.dart';
import '../../domain/models/mars_photo.dart';
import '../../domain/models/mars_rover.dart';
import '../../domain/repositories/mars_rover_repository.dart';
import '../marsvista/mars_vista_api.dart';

class MarsRoverRepositoryImpl implements MarsRoverRepository {
  MarsRoverRepositoryImpl(this._api);

  final MarsVistaApi _api;
  List<MarsRover>? _cachedRovers;
  Future<List<MarsRover>>? _pendingRovers;

  @override
  Future<List<MarsRover>> getRovers() async {
    if (_cachedRovers case final cached?) return cached;
    if (_pendingRovers case final pending?) return pending;

    final request = _fetchRovers();
    _pendingRovers = request;
    try {
      return _cachedRovers = await request;
    } finally {
      _pendingRovers = null;
    }
  }

  Future<List<MarsRover>> _fetchRovers() async {
    final response = await _api.getRovers();
    final rovers = await Future.wait(
      response.rovers.map((rover) async {
        try {
          return (await _api.getRover(rover.id)).toDomain();
        } on AppError {
          // The roster remains usable when an optional camera lookup fails.
          return rover.toDomain();
        }
      }),
    );
    return List.unmodifiable(rovers);
  }

  @override
  Future<PhotoPage> getPhotos({
    required String roverId,
    required String date,
    required int page,
  }) async => (await _api.getPhotos(
    roverId: roverId,
    date: date,
    page: page,
  )).toDomain();
}
