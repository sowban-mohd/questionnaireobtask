import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspot_host_questionnaire/core/data_handling/result.dart';
import 'package:hotspot_host_questionnaire/models/experience.dart';
import 'package:hotspot_host_questionnaire/services/api_service.dart';

final experiencesRepoProvider = Provider<ExperiencesRepository>((ref) {
  return ExperiencesRepository();
});

class ExperiencesRepository {
  final _dio = ApiService.dio;

  Future<Result<List<Experience>>> getExperiences() async {
    try {
      final response = await _dio.get(
        "/experiences",
        queryParameters: {"active": true},
      );

      final list = (response.data["data"]["experiences"] as List);
      final experiences = list.map((e) => Experience.fromJson(e)).toList();

      return Result.success(experiences);
    } on DioException catch (e) {
      return Result.failure(
        ApiError(message: _mapDioError(e), statusCode: e.response?.statusCode),
      );
    } catch (_) {
      return Result.failure(ApiError(message: "Something went wrong"));
    }
  }

  String _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return "Connection timed out";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return "Server took too long to respond";
    } else if (e.type == DioExceptionType.badResponse) {
      return e.response?.data["message"] ?? "Bad response from server";
    } else if (e.type == DioExceptionType.connectionError) {
      return "No internet connection";
    }

    return "Unexpected error";
  }
}
