import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:samurai_studios/core/network/dio_client.dart';

final dioProvider = Provider<Dio>((ref) {
  final dioClient = DioClient();
  return dioClient.dio;
});
