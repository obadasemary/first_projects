class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://rickandmortyapi.com/api';
  static const String charactersEndpoint = '/character';
  static const String episodeEndpoint = '/episode';
  static const int defaultPageSize = 20;
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}
