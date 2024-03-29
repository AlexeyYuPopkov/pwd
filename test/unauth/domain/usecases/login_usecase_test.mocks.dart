// Mocks generated by Mockito 5.4.4 from annotations
// in pwd/test/unauth/domain/usecases/login_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;
import 'package:pwd/common/domain/base_pin.dart' as _i4;
import 'package:pwd/common/domain/usecases/hash_usecase.dart' as _i6;
import 'package:pwd/common/domain/usecases/pin_usecase.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [PinUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockPinUsecase extends _i1.Mock implements _i2.PinUsecase {
  @override
  _i3.Stream<_i4.BasePin> get pinStream => (super.noSuchMethod(
        Invocation.getter(#pinStream),
        returnValue: _i3.Stream<_i4.BasePin>.empty(),
        returnValueForMissingStub: _i3.Stream<_i4.BasePin>.empty(),
      ) as _i3.Stream<_i4.BasePin>);

  @override
  _i3.Future<void> dropPin() => (super.noSuchMethod(
        Invocation.method(
          #dropPin,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i4.BasePin getPin() => (super.noSuchMethod(
        Invocation.method(
          #getPin,
          [],
        ),
        returnValue: _i5.dummyValue<_i4.BasePin>(
          this,
          Invocation.method(
            #getPin,
            [],
          ),
        ),
        returnValueForMissingStub: _i5.dummyValue<_i4.BasePin>(
          this,
          Invocation.method(
            #getPin,
            [],
          ),
        ),
      ) as _i4.BasePin);

  @override
  _i4.Pin getPinOrThrow() => (super.noSuchMethod(
        Invocation.method(
          #getPinOrThrow,
          [],
        ),
        returnValue: _i5.dummyValue<_i4.Pin>(
          this,
          Invocation.method(
            #getPinOrThrow,
            [],
          ),
        ),
        returnValueForMissingStub: _i5.dummyValue<_i4.Pin>(
          this,
          Invocation.method(
            #getPinOrThrow,
            [],
          ),
        ),
      ) as _i4.Pin);

  @override
  _i3.Future<void> setPin(_i4.Pin? pin) => (super.noSuchMethod(
        Invocation.method(
          #setPin,
          [pin],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [HashUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockHashUsecase extends _i1.Mock implements _i6.HashUsecase {
  @override
  List<int> pinHash512(String? pin) => (super.noSuchMethod(
        Invocation.method(
          #pinHash512,
          [pin],
        ),
        returnValue: <int>[],
        returnValueForMissingStub: <int>[],
      ) as List<int>);
}
