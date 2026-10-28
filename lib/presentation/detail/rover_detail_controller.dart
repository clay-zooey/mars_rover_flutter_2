import 'package:flutter/foundation.dart';

import '../../domain/models/app_error.dart';
import '../../domain/models/mars_photo.dart';
import '../../domain/usecases/get_mars_photos.dart';
import '../common/date_format.dart';
import '../common/load_state.dart';
import 'rover_detail_state.dart';

class RoverDetailController extends ChangeNotifier {
  RoverDetailController({required this._roverId, required this._getPhotos})
    : _state = RoverDetailState(selectedDate: apiDate(DateTime.now()));

  final String _roverId;
  final GetMarsPhotos _getPhotos;
  RoverDetailState _state;
  RoverDetailState get state => _state;
  int _generation = 0;
  bool _disposed = false;

  Future<void> loadDate(String date) async {
    if (_disposed) return;
    final generation = ++_generation;
    _setState(RoverDetailState(selectedDate: date));
    try {
      final page = await _getPhotos(roverId: _roverId, date: date, page: 1);
      if (!_isCurrent(generation)) return;
      _setState(
        _state.copyWith(
          photos: page.photos.isEmpty ? const Empty() : Success(page.photos),
          hasMore: page.hasMore,
        ),
      );
    } catch (error) {
      if (!_isCurrent(generation)) return;
      _setState(_state.copyWith(photos: Failure(_toError(error))));
    }
  }

  Future<void> retry() => loadDate(_state.selectedDate);

  Future<void> loadMore() async {
    final photos = _state.photos;
    if (_disposed ||
        photos is! Success<List<MarsPhoto>> ||
        _state.isLoadingMore ||
        !_state.hasMore) {
      return;
    }

    final generation = _generation;
    final nextPage = _state.page + 1;
    _setState(_state.copyWith(isLoadingMore: true));
    try {
      final page = await _getPhotos(
        roverId: _roverId,
        date: _state.selectedDate,
        page: nextPage,
      );
      if (!_isCurrent(generation)) return;
      final byId = {
        for (final photo in [...photos.value, ...page.photos]) photo.id: photo,
      };
      _setState(
        _state.copyWith(
          photos: Success(List.unmodifiable(byId.values)),
          page: nextPage,
          hasMore: page.hasMore,
          isLoadingMore: false,
        ),
      );
    } catch (error) {
      if (!_isCurrent(generation)) return;
      _setState(
        _state.copyWith(isLoadingMore: false, paginationError: _toError(error)),
      );
    }
  }

  bool _isCurrent(int generation) => !_disposed && generation == _generation;
  AppError _toError(Object error) =>
      error is AppError ? error : AppError.unknown;

  void _setState(RoverDetailState state) {
    if (_disposed) return;
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }
}
