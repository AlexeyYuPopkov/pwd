import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pwd/common/domain/base_pin.dart';
import 'package:pwd/common/domain/errors/app_error.dart';
import 'package:pwd/common/domain/pin_repository.dart';

class HashUsecase {
  final PinRepository pinRepository;
  final _iv = encrypt.IV.fromLength(16);

  HashUsecase({
    required this.pinRepository,
  });

  String encode(String str) {
    final pin = pinRepository.getPin();

    if (pin is Pin) {
      return _encryptAES(str, pin.pin);
    } else {
      throw const HashUsecaseError.emptyPin();
    }
  }

  String decode(String str) {
    final pin = pinRepository.getPin();

    if (pin is Pin) {
      return _decryptAES(str, pin.pin);
    } else {
      throw const HashUsecaseError.emptyPin();
    }
  }

  String _encryptAES(String str, String pin) {
    if (pin.length != 32) {
      throw const HashUsecaseError.wrongPinLength();
    }
    final key = encrypt.Key.fromUtf8(pin);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(str, iv: _iv);
    return encrypted.base64;
  }

  String _decryptAES(String str, String pin) {
    if (pin.length != 32) {
      throw const HashUsecaseError.wrongPinLength();
    }
    final key = encrypt.Key.fromUtf8(pin);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final bytes = base64.decode(str);
    return encrypter.decrypt(encrypt.Encrypted(bytes), iv: _iv);
  }

  String pinHash(String pin) => md5.convert(utf8.encode(pin)).toString();
}

// Errors
abstract class HashUsecaseError extends AppError {
  const HashUsecaseError() : super(message: '');

  const factory HashUsecaseError.emptyPin() = HashUsecaseEmptyPinError;
  const factory HashUsecaseError.wrongPinLength() =
      HashUsecaseWrongPinLengthError;
}

class HashUsecaseEmptyPinError extends HashUsecaseError {
  const HashUsecaseEmptyPinError();
}

class HashUsecaseWrongPinLengthError extends HashUsecaseError {
  const HashUsecaseWrongPinLengthError();
}
