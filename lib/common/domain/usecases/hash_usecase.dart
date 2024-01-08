import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/errors/app_error.dart';

final _iv = encrypt.IV.fromLength(16);

class HashUsecase {
  const HashUsecase();

  String encode(String str, BasePin pin) {
    if (str.isEmpty) {
      return '';
    }

    if (pin is Pin) {
      return _encryptAES(str, pin.pin);
    } else {
      throw const HashUsecaseError.emptyPin();
    }
  }

  String? tryDecode(String str, BasePin pin) {
    if (str.isEmpty) {
      return '';
    }

    if (pin is Pin) {
      return _tryDecryptAES(str, pin.pin);
    } else {
      throw const HashUsecaseError.emptyPin();
    }
  }

  String _encryptAES(String str, String pin) {
    const requiredPinHashLength = 32;
    if (pin.length != requiredPinHashLength) {
      throw const HashUsecaseError.wrongPinLength();
    }
    try {
      final key = encrypt.Key.fromUtf8(pin);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      if (str.isNotEmpty) {
        final encrypted = encrypter.encrypt(str, iv: _iv);
        return encrypted.base64;
      } else {
        return '';
      }
    } catch (e) {
      return throw HashUsecaseError.encrypt(parentError: e);
    }
  }

  String? _tryDecryptAES(String str, String pin) {
    const requiredPinHashLength = 32;
    if (pin.length != requiredPinHashLength) {
      throw const HashUsecaseError.wrongPinLength();
    }
    try {
      final key = encrypt.Key.fromUtf8(pin);
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final bytes = base64.decode(str);

      return encrypter.decrypt(encrypt.Encrypted(bytes), iv: _iv);
    } catch (_) {
      return null;
    }
  }

  // static
  String pinHash(String pin) => md5.convert(utf8.encode(pin)).toString();

  List<int> pinHash512(String pin) {
    if (kDebugMode) {
      print('Key str:${sha512.convert(utf8.encode(pin))}');
    }
    return sha512.convert(utf8.encode(pin)).bytes;
  }
}

// Errors
abstract class HashUsecaseError extends AppError {
  const HashUsecaseError({super.parentError})
      : super(
          message: '',
        );

  const factory HashUsecaseError.emptyPin() = HashUsecaseEmptyPinError;
  const factory HashUsecaseError.wrongPinLength() =
      HashUsecaseWrongPinLengthError;

  const factory HashUsecaseError.encrypt({Object? parentError}) =
      HashUsecaseEncryptError;
}

class HashUsecaseEmptyPinError extends HashUsecaseError {
  const HashUsecaseEmptyPinError() : super(parentError: null);
}

class HashUsecaseWrongPinLengthError extends HashUsecaseError {
  const HashUsecaseWrongPinLengthError() : super(parentError: null);
}

class HashUsecaseEncryptError extends HashUsecaseError {
  const HashUsecaseEncryptError({super.parentError});
}
