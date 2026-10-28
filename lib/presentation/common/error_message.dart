import '../../domain/models/app_error.dart';

String errorMessage(AppError error) => switch (error) {
  AppError.missingApiKey =>
    'Add a Mars Vista API key before loading rover data.',
  AppError.noInternet => 'Check your internet connection and try again.',
  AppError.unauthorized =>
    'Mars Vista could not authorize this request. Check your API key.',
  AppError.rateLimited =>
    'Too many requests. Please wait a moment and try again.',
  AppError.serverUnavailable =>
    'Mars Vista is unavailable right now. Please try again.',
  AppError.invalidResponse =>
    'Mars Vista returned an unexpected response. Please try again.',
  AppError.unknown => 'Something went wrong. Please try again.',
};
