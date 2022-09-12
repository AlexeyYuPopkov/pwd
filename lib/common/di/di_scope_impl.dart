part of 'di_scope.dart';

class DiScopeImpl extends DiScope {
  final Map<String, Binding> _map;
  final Map<String, Set<String>> _modulesMap;

  DiScopeImpl()
      : _map = {},
        _modulesMap = {};

  @override
  void bind(Binding binding) => _map[binding._key] = binding;

  @override
  T? remove<T>() {
    final key = T.runtimeType.toString();
    return _map.remove(key)?.call();
  }

  @override
  T resolve<T>() {
    final key = T.runtimeType.toString();

    final result = _map[key];

    if (result == null) {
      throw Exception('Di: not found requesed instance');
    } else {
      return result();
    }
  }

  @override
  void installModule(DiModule module) {
    final moduleKey = module.runtimeType.toString();
    final Set<String> moduleItemsKeys = {};

    for (final item in module.objects()) {
      final key = item._key;
      moduleItemsKeys.add(key);
      bind(item);
    }

    _modulesMap[moduleKey] = moduleItemsKeys;
  }

  @override
  void installModules(List<DiModule> modules) => modules.forEach(installModule);

  @override
  void dropModule<T extends DiModule>() {
    final moduleKey = T.runtimeType.toString();
    final keys = _modulesMap[moduleKey];

    if (keys != null) {
      for (final key in keys) {
        _map.remove(key);
      }
    }

    _modulesMap.remove(moduleKey);
  }

  @override
  void dropAll() {
    _map.clear();
    _modulesMap.clear();
  }
}

class _ConstructorBox<T> extends Binding {
  final T Function() constructor;

  const _ConstructorBox({
    required this.constructor,
  });

  @override
  call() => constructor();
}

class _InstanceBox<T> extends Binding {
  final T instance;

  const _InstanceBox({
    required this.instance,
  });

  @override
  call() => instance;
}
