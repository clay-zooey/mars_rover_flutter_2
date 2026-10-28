import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app.dart';
import 'core/config/app_config.dart';
import 'data/marsvista/mars_vista_api.dart';
import 'data/repositories/mars_rover_repository_impl.dart';
import 'domain/usecases/get_mars_photos.dart';
import 'domain/usecases/get_mars_rovers.dart';

void main() {
  final client = http.Client();
  final api = MarsVistaApi(
    client: client,
    baseUrl: AppConfig.baseUrl,
    apiKey: AppConfig.apiKey,
  );
  final repository = MarsRoverRepositoryImpl(api);
  runApp(
    MarsRoverApp(
      getRovers: GetMarsRovers(repository),
      getPhotos: GetMarsPhotos(repository),
      onDispose: client.close,
    ),
  );
}
