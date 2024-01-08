import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<Service>()])
// @GenerateMocks([Service])
import 'mock_test_example_test.mocks.dart';

final class ModelMapper {
  static Model toData(Map<String, dynamic> json) {
    return Model(items: (json['items'] as List<String>).map((e) => e).toList());
  }
}

final class Model {
  final List<String> items;

  Model({required this.items});
}

abstract interface class Service {
  Future<Map<String, dynamic>> getModel();

  Future<void> deleteModel();
}

final class GetModelUsecase {
  final Service service;

  GetModelUsecase({required this.service});

  Future<Model> getModel() async {
    final result = await service.getModel().then((e) => ModelMapper.toData(e));

    return Model(items: result.items.sorted((a, b) => a.compareTo(b)));
  }
}

final class DeleteUsecase {
  final Service service;

  DeleteUsecase({required this.service});

  Future<void> deleteModel() {
    return service.deleteModel();
  }
}

void main() {
  final service = MockService();

  group('GetModelUsecase', () {
    final usecase = GetModelUsecase(service: service);

    test('valid', () async {
      final response = <String, dynamic>{
        'items': ['a', 'c', 'b'],
      };

      when(service.getModel()).thenAnswer((_) {
        return Future.value(response);
      });

      final result = await usecase.getModel();

      expect(result, isA<Model>());
      expect(result.items[0], 'a');
      expect(result.items[1], 'b');
      expect(result.items[2], 'c');
    });

    test('invalid', () async {
      when(service.getModel()).thenThrow(
        Exception(),
      );

      expect(() => usecase.getModel(), throwsException);
      verify(service.getModel());
    });

    test('invalid variant', () async {
      final response = <String, dynamic>{};

      when(service.getModel()).thenAnswer((_) {
        return Future.value(response);
      });

      expect(() => usecase.getModel(), throwsA(isA<Error>()));
      verify(service.getModel());
    });
  });

  group('DeleteUsecase', () {
    final usecase = DeleteUsecase(service: service);

    test('valid', () async {
      when(service.deleteModel()).thenAnswer((_) => Future.value());
      await usecase.deleteModel();
      verify(service.deleteModel());
    });

    test('invalid', () async {
      when(service.deleteModel()).thenThrow(Exception());

      expect(() => usecase.deleteModel(), throwsException);
      verify(service.deleteModel());
      // verifyNever(service.deleteModel());
    });
  });
}
