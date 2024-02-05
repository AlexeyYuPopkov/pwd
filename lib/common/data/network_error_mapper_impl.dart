import 'dart:convert';

import 'package:dio/dio.dart' show DioException, DioExceptionType, ResponseType;
import 'package:flutter/foundation.dart';
import 'package:pwd/common/domain/errors/network_error.dart';
import 'package:pwd/common/domain/errors/network_error_mapper.dart';

class NetworkErrorMapperImpl implements NetworkErrorMapper {
  @override
  NetworkError call<T>(
    Object error,
  ) =>
      _responseExceptionMapper(error);

  static NetworkError _responseExceptionMapper<T>(
    Object error,
  ) {
    try {
      final err = error;

      if (err is DioException) {
        final result = err.response;

        Map<String, dynamic>? details;

        if (result != null) {
          final data = result.data;
          switch (result.requestOptions.responseType) {
            case ResponseType.json:
              if (data is Map<String, dynamic>) {
                details = data;
              }
              break;
            case ResponseType.plain:
              if (data is String && data.isNotEmpty) {
                details = jsonDecode(data);
              }
              break;
            case ResponseType.stream:
            case ResponseType.bytes:
              if (data is Uint8List && data.isNotEmpty) {
                final str = String.fromCharCodes(data);
                details = str.isEmpty ? null : jsonDecode(str);
              }
              break;
          }
        }

        return _mapFromStatusCode(
          error: error,
          statusCode: result?.statusCode,
          details: details,
        );
      } else {
        throw error;
      }
    } catch (_) {
      return _mapFromStatusCode(
        error: error,
        statusCode: null,
        details: null,
      );
    }
  }

  static NetworkError _mapFromStatusCode({
    required int? statusCode,
    required Object? error,
    required Map<String, dynamic>? details,
  }) {
    final e = error;

    const unauthenticatedStatusCode = 401;
    const notFoundStatusCode = 404;

    if (statusCode == unauthenticatedStatusCode) {
      return NetworkError.unauthenticated(
        message: '',
        parentError: e,
        details: details,
      );
    } else if (statusCode == notFoundStatusCode) {
      return NetworkError.notFound(
        message: '',
        parentError: e,
        details: details,
      );
    } else {
      return _mapException(e, details);
    }
  }

  static NetworkError _mapException(
    Object? error,
    Map<String, dynamic>? details,
  ) {
    final e = error;

    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
        case DioExceptionType.badCertificate:
          return NetworkError.serviceTimeout(
            message: '',
            parentError: e,
            details: null,
          );
        case DioExceptionType.badResponse:
        case DioExceptionType.cancel:
        case DioExceptionType.unknown:
          break;
      }
    }

    return NetworkError.unknown(
      message: '',
      parentError: e,
      details: null,
    );
  }
}
