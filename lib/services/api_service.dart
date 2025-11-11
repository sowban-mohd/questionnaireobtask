import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://staging.chamberofsecrets.8club.co/v1",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  static void init(){
    dio.interceptors.add(LogInterceptor());
  }
}
