part 'di_scope_impl.dart';

abstract class DiScope {
  static DiScope? _instance;

  const DiScope();

  factory DiScope.single() {
    if (_instance == null) {
      final result = DiScopeImpl();
      _instance = result;
      return result;
    } else {
      return _instance!;
    }
  }

  factory DiScope.create() => DiScopeImpl();

  void bind(Binding binding);

  T? remove<T>();

  T resolve<T>();

  void installModule(DiModule module);

  void installModules(List<DiModule> modules);

  void dropModule<T extends DiModule>();

  void dropAll();
}

abstract class DiModule {
  List<Binding> objects();
}

abstract class Binding<T> {
  const Binding();

  String get _key => T.runtimeType.toString();

  T call();

  static Binding prototype<T>(T Function() constructor) => _ConstructorBox<T>(
        constructor: constructor,
      );

  static Binding single<T>(T instance) => _InstanceBox<T>(
        instance: instance,
      );
}


// Example of Module
// class Test {}

// class TestModule extends DiModule {
//   @override
//   List<Binding> objects() {
//     return [Binding.prototype(() => Test())];
//   }
// }