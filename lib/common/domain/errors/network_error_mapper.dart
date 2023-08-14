import 'package:pwd/common/domain/errors/network_error.dart';

abstract class NetworkErrorMapper {
  NetworkError call<T>(
    Object error,
  );
}
