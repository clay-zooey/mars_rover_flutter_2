import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../domain/models/app_error.dart';
import 'photo_dto.dart';
import 'rover_dto.dart';

class MarsVistaApi {
  MarsVistaApi({
    required this._client,
    required String baseUrl,
    required this._apiKey,
  }) : _baseUri = Uri.parse(baseUrl);

  static const pageSize = 50;
  final http.Client _client;
  final Uri _baseUri;
  final String _apiKey;

  Future<RoversResponseDto> getRovers() =>
      _get('api/v2/rovers', decode: RoversResponseDto.fromJson);

  Future<RoverDto> getRover(String id) => _get(
    'api/v2/rovers/${Uri.encodeComponent(id)}',
    decode: (json) => RoverDto.fromJson(json['data'] as Map<String, dynamic>),
  );

  Future<PhotosResponseDto> getPhotos({
    required String roverId,
    required String date,
    required int page,
  }) => _get(
    'api/v2/photos',
    query: {
      'rovers': roverId,
      'date_min': date,
      'date_max': date,
      'per_page': '$pageSize',
      'page': '$page',
    },
    decode: (json) => PhotosResponseDto.fromJson(json, pageSize: pageSize),
  );

  Future<T> _get<T>(
    String path, {
    Map<String, String>? query,
    required T Function(Map<String, dynamic>) decode,
  }) async {
    if (_apiKey.trim().isEmpty) throw AppError.missingApiKey;
    final uri = _baseUri.resolve(path).replace(queryParameters: query);
    final timer = Stopwatch()..start();
    if (kDebugMode) debugPrint('MarsVista --> GET ${uri.path}');
    try {
      final response = await _client
          .get(
            uri,
            headers: {'X-API-Key': _apiKey, 'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 30));

      if (kDebugMode) {
        debugPrint(
          'MarsVista <-- ${response.statusCode} ${uri.path} '
          '(${timer.elapsedMilliseconds}ms)',
        );
      }
      switch (response.statusCode) {
        case 401 || 403:
          throw AppError.unauthorized;
        case 429:
          throw AppError.rateLimited;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AppError.serverUnavailable;
      }
      return decode(
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>,
      );
    } on AppError {
      rethrow;
    } on TimeoutException {
      throw AppError.noInternet;
    } on http.ClientException {
      throw AppError.noInternet;
    } on FormatException {
      throw AppError.invalidResponse;
    } on TypeError {
      throw AppError.invalidResponse;
    }
  }
}
