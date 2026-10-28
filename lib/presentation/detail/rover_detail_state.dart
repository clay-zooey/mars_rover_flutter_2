import '../../domain/models/app_error.dart';
import '../../domain/models/mars_photo.dart';
import '../common/load_state.dart';

class RoverDetailState {
  const RoverDetailState({
    required this.selectedDate,
    this.photos = const Loading(),
    this.page = 1,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.paginationError,
  });

  final String selectedDate;
  final LoadState<List<MarsPhoto>> photos;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final AppError? paginationError;

  RoverDetailState copyWith({
    LoadState<List<MarsPhoto>>? photos,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    AppError? paginationError,
  }) => RoverDetailState(
    selectedDate: selectedDate,
    photos: photos ?? this.photos,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    paginationError: paginationError,
  );
}
