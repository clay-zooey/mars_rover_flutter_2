import '../../domain/models/app_error.dart';

sealed class LoadState<T> {
  const LoadState();
}

final class Loading<T> extends LoadState<T> {
  const Loading();
}

final class Empty<T> extends LoadState<T> {
  const Empty();
}

final class Success<T> extends LoadState<T> {
  const Success(this.value);

  final T value;
}

final class Failure<T> extends LoadState<T> {
  const Failure(this.error);

  final AppError error;
}
