enum AppError implements Exception {
  missingApiKey,
  noInternet,
  unauthorized,
  rateLimited,
  serverUnavailable,
  invalidResponse,
  unknown,
}
