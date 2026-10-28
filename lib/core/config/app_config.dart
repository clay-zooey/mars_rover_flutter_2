abstract final class AppConfig {
  static const baseUrl = String.fromEnvironment(
    'MARS_VISTA_BASE_URL',
    defaultValue: 'https://api.marsvista.dev/',
  );

  static const apiKey = String.fromEnvironment('MARS_VISTA_API_KEY');
}
