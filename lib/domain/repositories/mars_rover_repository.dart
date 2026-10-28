import '../models/mars_photo.dart';
import '../models/mars_rover.dart';

abstract interface class MarsRoverRepository {
  Future<List<MarsRover>> getRovers();

  Future<PhotoPage> getPhotos({
    required String roverId,
    required String date,
    required int page,
  });
}
