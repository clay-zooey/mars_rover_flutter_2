import '../models/mars_photo.dart';
import '../repositories/mars_rover_repository.dart';

class GetMarsPhotos {
  const GetMarsPhotos(this._repository);

  final MarsRoverRepository _repository;

  Future<PhotoPage> call({
    required String roverId,
    required String date,
    required int page,
  }) => _repository.getPhotos(roverId: roverId, date: date, page: page);
}
