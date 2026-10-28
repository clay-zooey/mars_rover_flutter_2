import 'package:flutter/foundation.dart';

import '../../domain/models/app_error.dart';
import '../../domain/models/mars_rover.dart';
import '../../domain/usecases/get_mars_rovers.dart';
import '../common/load_state.dart';

class RoversController extends ChangeNotifier {
  RoversController(this._getRovers);

  final GetMarsRovers _getRovers;
  LoadState<List<MarsRover>> _state = const Loading();
  LoadState<List<MarsRover>> get state => _state;
  bool _loading = false;
  bool _disposed = false;

  Future<void> load() async {
    if (_loading || _disposed) return;
    _loading = true;
    _setState(const Loading());
    try {
      final rovers = await _getRovers();
      _setState(rovers.isEmpty ? const Empty() : Success(rovers));
    } on AppError catch (error) {
      _setState(Failure(error));
    } catch (_) {
      _setState(const Failure(AppError.unknown));
    } finally {
      _loading = false;
    }
  }

  void _setState(LoadState<List<MarsRover>> state) {
    if (_disposed) return;
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
