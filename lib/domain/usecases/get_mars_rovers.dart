import '../models/mars_rover.dart';
import '../repositories/mars_rover_repository.dart';

class GetMarsRovers {
  const GetMarsRovers(this._repository);

  final MarsRoverRepository _repository;

  Future<List<MarsRover>> call() => _repository.getRovers();
}
