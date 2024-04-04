import 'dart:async';
import 'package:gql/ast.dart';
import 'package:graphql/client.dart' as graphql;

class Variables$Query$Repository {
  factory Variables$Query$Repository({
    required String name,
    required String owner,
    required String path,
  }) =>
      Variables$Query$Repository._({
        r'name': name,
        r'owner': owner,
        r'path': path,
      });

  Variables$Query$Repository._(this._$data);

  factory Variables$Query$Repository.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$name = data['name'];
    result$data['name'] = (l$name as String);
    final l$owner = data['owner'];
    result$data['owner'] = (l$owner as String);
    final l$path = data['path'];
    result$data['path'] = (l$path as String);
    return Variables$Query$Repository._(result$data);
  }

  Map<String, dynamic> _$data;

  String get name => (_$data['name'] as String);

  String get owner => (_$data['owner'] as String);

  String get path => (_$data['path'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$name = name;
    result$data['name'] = l$name;
    final l$owner = owner;
    result$data['owner'] = l$owner;
    final l$path = path;
    result$data['path'] = l$path;
    return result$data;
  }

  CopyWith$Variables$Query$Repository<Variables$Query$Repository>
      get copyWith => CopyWith$Variables$Query$Repository(
            this,
            (i) => i,
          );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Variables$Query$Repository) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$owner = owner;
    final lOther$owner = other.owner;
    if (l$owner != lOther$owner) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$name = name;
    final l$owner = owner;
    final l$path = path;
    return Object.hashAll([
      l$name,
      l$owner,
      l$path,
    ]);
  }
}

abstract class CopyWith$Variables$Query$Repository<TRes> {
  factory CopyWith$Variables$Query$Repository(
    Variables$Query$Repository instance,
    TRes Function(Variables$Query$Repository) then,
  ) = _CopyWithImpl$Variables$Query$Repository;

  factory CopyWith$Variables$Query$Repository.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$Repository;

  TRes call({
    String? name,
    String? owner,
    String? path,
  });
}

class _CopyWithImpl$Variables$Query$Repository<TRes>
    implements CopyWith$Variables$Query$Repository<TRes> {
  _CopyWithImpl$Variables$Query$Repository(
    this._instance,
    this._then,
  );

  final Variables$Query$Repository _instance;

  final TRes Function(Variables$Query$Repository) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? name = _undefined,
    Object? owner = _undefined,
    Object? path = _undefined,
  }) =>
      _then(Variables$Query$Repository._({
        ..._instance._$data,
        if (name != _undefined && name != null) 'name': (name as String),
        if (owner != _undefined && owner != null) 'owner': (owner as String),
        if (path != _undefined && path != null) 'path': (path as String),
      }));
}

class _CopyWithStubImpl$Variables$Query$Repository<TRes>
    implements CopyWith$Variables$Query$Repository<TRes> {
  _CopyWithStubImpl$Variables$Query$Repository(this._res);

  TRes _res;

  call({
    String? name,
    String? owner,
    String? path,
  }) =>
      _res;
}

class Query$Repository {
  Query$Repository({
    this.repository,
    this.$__typename = 'Query',
  });

  factory Query$Repository.fromJson(Map<String, dynamic> json) {
    final l$repository = json['repository'];
    final l$$__typename = json['__typename'];
    return Query$Repository(
      repository: l$repository == null
          ? null
          : Query$Repository$repository.fromJson(
              (l$repository as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$Repository$repository? repository;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$repository = repository;
    _resultData['repository'] = l$repository?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$repository = repository;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$repository,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Repository) || runtimeType != other.runtimeType) {
      return false;
    }
    final l$repository = repository;
    final lOther$repository = other.repository;
    if (l$repository != lOther$repository) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Repository on Query$Repository {
  CopyWith$Query$Repository<Query$Repository> get copyWith =>
      CopyWith$Query$Repository(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$Repository<TRes> {
  factory CopyWith$Query$Repository(
    Query$Repository instance,
    TRes Function(Query$Repository) then,
  ) = _CopyWithImpl$Query$Repository;

  factory CopyWith$Query$Repository.stub(TRes res) =
      _CopyWithStubImpl$Query$Repository;

  TRes call({
    Query$Repository$repository? repository,
    String? $__typename,
  });
  CopyWith$Query$Repository$repository<TRes> get repository;
}

class _CopyWithImpl$Query$Repository<TRes>
    implements CopyWith$Query$Repository<TRes> {
  _CopyWithImpl$Query$Repository(
    this._instance,
    this._then,
  );

  final Query$Repository _instance;

  final TRes Function(Query$Repository) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? repository = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Repository(
        repository: repository == _undefined
            ? _instance.repository
            : (repository as Query$Repository$repository?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$Repository$repository<TRes> get repository {
    final local$repository = _instance.repository;
    return local$repository == null
        ? CopyWith$Query$Repository$repository.stub(_then(_instance))
        : CopyWith$Query$Repository$repository(
            local$repository, (e) => call(repository: e));
  }
}

class _CopyWithStubImpl$Query$Repository<TRes>
    implements CopyWith$Query$Repository<TRes> {
  _CopyWithStubImpl$Query$Repository(this._res);

  TRes _res;

  call({
    Query$Repository$repository? repository,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$Repository$repository<TRes> get repository =>
      CopyWith$Query$Repository$repository.stub(_res);
}

const documentNodeQueryRepository = DocumentNode(definitions: [
  OperationDefinitionNode(
    type: OperationType.query,
    name: NameNode(value: 'Repository'),
    variableDefinitions: [
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'name')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'owner')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
      VariableDefinitionNode(
        variable: VariableNode(name: NameNode(value: 'path')),
        type: NamedTypeNode(
          name: NameNode(value: 'String'),
          isNonNull: true,
        ),
        defaultValue: DefaultValueNode(value: null),
        directives: [],
      ),
    ],
    directives: [],
    selectionSet: SelectionSetNode(selections: [
      FieldNode(
        name: NameNode(value: 'repository'),
        alias: null,
        arguments: [
          ArgumentNode(
            name: NameNode(value: 'name'),
            value: VariableNode(name: NameNode(value: 'name')),
          ),
          ArgumentNode(
            name: NameNode(value: 'owner'),
            value: VariableNode(name: NameNode(value: 'owner')),
          ),
        ],
        directives: [],
        selectionSet: SelectionSetNode(selections: [
          FieldNode(
            name: NameNode(value: 'object'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'expression'),
                value: VariableNode(name: NameNode(value: 'path')),
              )
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                name: NameNode(value: 'oid'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
              FieldNode(
                name: NameNode(value: '__typename'),
                alias: null,
                arguments: [],
                directives: [],
                selectionSet: null,
              ),
            ]),
          ),
          FieldNode(
            name: NameNode(value: '__typename'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: null,
          ),
        ]),
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ]),
  ),
]);
Query$Repository _parserFn$Query$Repository(Map<String, dynamic> data) =>
    Query$Repository.fromJson(data);
typedef OnQueryComplete$Query$Repository = FutureOr<void> Function(
  Map<String, dynamic>?,
  Query$Repository?,
);

class Options$Query$Repository extends graphql.QueryOptions<Query$Repository> {
  Options$Query$Repository({
    String? operationName,
    required Variables$Query$Repository variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Repository? typedOptimisticResult,
    Duration? pollInterval,
    graphql.Context? context,
    OnQueryComplete$Query$Repository? onComplete,
    graphql.OnQueryError? onError,
  })  : onCompleteWithParsed = onComplete,
        super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          pollInterval: pollInterval,
          context: context,
          onComplete: onComplete == null
              ? null
              : (data) => onComplete(
                    data,
                    data == null ? null : _parserFn$Query$Repository(data),
                  ),
          onError: onError,
          document: documentNodeQueryRepository,
          parserFn: _parserFn$Query$Repository,
        );

  final OnQueryComplete$Query$Repository? onCompleteWithParsed;

  @override
  List<Object?> get properties => [
        ...super.onComplete == null
            ? super.properties
            : super.properties.where((property) => property != onComplete),
        onCompleteWithParsed,
      ];
}

class WatchOptions$Query$Repository
    extends graphql.WatchQueryOptions<Query$Repository> {
  WatchOptions$Query$Repository({
    String? operationName,
    required Variables$Query$Repository variables,
    graphql.FetchPolicy? fetchPolicy,
    graphql.ErrorPolicy? errorPolicy,
    graphql.CacheRereadPolicy? cacheRereadPolicy,
    Object? optimisticResult,
    Query$Repository? typedOptimisticResult,
    graphql.Context? context,
    Duration? pollInterval,
    bool? eagerlyFetchResults,
    bool carryForwardDataOnException = true,
    bool fetchResults = false,
  }) : super(
          variables: variables.toJson(),
          operationName: operationName,
          fetchPolicy: fetchPolicy,
          errorPolicy: errorPolicy,
          cacheRereadPolicy: cacheRereadPolicy,
          optimisticResult: optimisticResult ?? typedOptimisticResult?.toJson(),
          context: context,
          document: documentNodeQueryRepository,
          pollInterval: pollInterval,
          eagerlyFetchResults: eagerlyFetchResults,
          carryForwardDataOnException: carryForwardDataOnException,
          fetchResults: fetchResults,
          parserFn: _parserFn$Query$Repository,
        );
}

class FetchMoreOptions$Query$Repository extends graphql.FetchMoreOptions {
  FetchMoreOptions$Query$Repository({
    required graphql.UpdateQuery updateQuery,
    required Variables$Query$Repository variables,
  }) : super(
          updateQuery: updateQuery,
          variables: variables.toJson(),
          document: documentNodeQueryRepository,
        );
}

extension ClientExtension$Query$Repository on graphql.GraphQLClient {
  Future<graphql.QueryResult<Query$Repository>> query$Repository(
          Options$Query$Repository options) async =>
      await this.query(options);
  graphql.ObservableQuery<Query$Repository> watchQuery$Repository(
          WatchOptions$Query$Repository options) =>
      this.watchQuery(options);
  void writeQuery$Repository({
    required Query$Repository data,
    required Variables$Query$Repository variables,
    bool broadcast = true,
  }) =>
      this.writeQuery(
        graphql.Request(
          operation: graphql.Operation(document: documentNodeQueryRepository),
          variables: variables.toJson(),
        ),
        data: data.toJson(),
        broadcast: broadcast,
      );
  Query$Repository? readQuery$Repository({
    required Variables$Query$Repository variables,
    bool optimistic = true,
  }) {
    final result = this.readQuery(
      graphql.Request(
        operation: graphql.Operation(document: documentNodeQueryRepository),
        variables: variables.toJson(),
      ),
      optimistic: optimistic,
    );
    return result == null ? null : Query$Repository.fromJson(result);
  }
}

class Query$Repository$repository {
  Query$Repository$repository({
    this.object,
    this.$__typename = 'Repository',
  });

  factory Query$Repository$repository.fromJson(Map<String, dynamic> json) {
    final l$object = json['object'];
    final l$$__typename = json['__typename'];
    return Query$Repository$repository(
      object: l$object == null
          ? null
          : Query$Repository$repository$object.fromJson(
              (l$object as Map<String, dynamic>)),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$Repository$repository$object? object;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$object = object;
    _resultData['object'] = l$object?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$object = object;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$object,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Repository$repository) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$object = object;
    final lOther$object = other.object;
    if (l$object != lOther$object) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Repository$repository
    on Query$Repository$repository {
  CopyWith$Query$Repository$repository<Query$Repository$repository>
      get copyWith => CopyWith$Query$Repository$repository(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Repository$repository<TRes> {
  factory CopyWith$Query$Repository$repository(
    Query$Repository$repository instance,
    TRes Function(Query$Repository$repository) then,
  ) = _CopyWithImpl$Query$Repository$repository;

  factory CopyWith$Query$Repository$repository.stub(TRes res) =
      _CopyWithStubImpl$Query$Repository$repository;

  TRes call({
    Query$Repository$repository$object? object,
    String? $__typename,
  });
  CopyWith$Query$Repository$repository$object<TRes> get object;
}

class _CopyWithImpl$Query$Repository$repository<TRes>
    implements CopyWith$Query$Repository$repository<TRes> {
  _CopyWithImpl$Query$Repository$repository(
    this._instance,
    this._then,
  );

  final Query$Repository$repository _instance;

  final TRes Function(Query$Repository$repository) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? object = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Repository$repository(
        object: object == _undefined
            ? _instance.object
            : (object as Query$Repository$repository$object?),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));

  CopyWith$Query$Repository$repository$object<TRes> get object {
    final local$object = _instance.object;
    return local$object == null
        ? CopyWith$Query$Repository$repository$object.stub(_then(_instance))
        : CopyWith$Query$Repository$repository$object(
            local$object, (e) => call(object: e));
  }
}

class _CopyWithStubImpl$Query$Repository$repository<TRes>
    implements CopyWith$Query$Repository$repository<TRes> {
  _CopyWithStubImpl$Query$Repository$repository(this._res);

  TRes _res;

  call({
    Query$Repository$repository$object? object,
    String? $__typename,
  }) =>
      _res;

  CopyWith$Query$Repository$repository$object<TRes> get object =>
      CopyWith$Query$Repository$repository$object.stub(_res);
}

class Query$Repository$repository$object {
  Query$Repository$repository$object({
    required this.oid,
    required this.$__typename,
  });

  factory Query$Repository$repository$object.fromJson(
      Map<String, dynamic> json) {
    switch (json["__typename"] as String) {
      case "Blob":
        return Query$Repository$repository$object$$Blob.fromJson(json);

      case "Commit":
        return Query$Repository$repository$object$$Commit.fromJson(json);

      case "Tag":
        return Query$Repository$repository$object$$Tag.fromJson(json);

      case "Tree":
        return Query$Repository$repository$object$$Tree.fromJson(json);

      default:
        final l$oid = json['oid'];
        final l$$__typename = json['__typename'];
        return Query$Repository$repository$object(
          oid: (l$oid as String),
          $__typename: (l$$__typename as String),
        );
    }
  }

  final String oid;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$oid = oid;
    _resultData['oid'] = l$oid;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$oid = oid;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$oid,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Repository$repository$object) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$oid = oid;
    final lOther$oid = other.oid;
    if (l$oid != lOther$oid) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Repository$repository$object
    on Query$Repository$repository$object {
  CopyWith$Query$Repository$repository$object<
          Query$Repository$repository$object>
      get copyWith => CopyWith$Query$Repository$repository$object(
            this,
            (i) => i,
          );
  _T when<_T>({
    required _T Function(Query$Repository$repository$object$$Blob) blob,
    required _T Function(Query$Repository$repository$object$$Commit) commit,
    required _T Function(Query$Repository$repository$object$$Tag) tag,
    required _T Function(Query$Repository$repository$object$$Tree) tree,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Blob":
        return blob(this as Query$Repository$repository$object$$Blob);

      case "Commit":
        return commit(this as Query$Repository$repository$object$$Commit);

      case "Tag":
        return tag(this as Query$Repository$repository$object$$Tag);

      case "Tree":
        return tree(this as Query$Repository$repository$object$$Tree);

      default:
        return orElse();
    }
  }

  _T maybeWhen<_T>({
    _T Function(Query$Repository$repository$object$$Blob)? blob,
    _T Function(Query$Repository$repository$object$$Commit)? commit,
    _T Function(Query$Repository$repository$object$$Tag)? tag,
    _T Function(Query$Repository$repository$object$$Tree)? tree,
    required _T Function() orElse,
  }) {
    switch ($__typename) {
      case "Blob":
        if (blob != null) {
          return blob(this as Query$Repository$repository$object$$Blob);
        } else {
          return orElse();
        }

      case "Commit":
        if (commit != null) {
          return commit(this as Query$Repository$repository$object$$Commit);
        } else {
          return orElse();
        }

      case "Tag":
        if (tag != null) {
          return tag(this as Query$Repository$repository$object$$Tag);
        } else {
          return orElse();
        }

      case "Tree":
        if (tree != null) {
          return tree(this as Query$Repository$repository$object$$Tree);
        } else {
          return orElse();
        }

      default:
        return orElse();
    }
  }
}

abstract class CopyWith$Query$Repository$repository$object<TRes> {
  factory CopyWith$Query$Repository$repository$object(
    Query$Repository$repository$object instance,
    TRes Function(Query$Repository$repository$object) then,
  ) = _CopyWithImpl$Query$Repository$repository$object;

  factory CopyWith$Query$Repository$repository$object.stub(TRes res) =
      _CopyWithStubImpl$Query$Repository$repository$object;

  TRes call({
    String? oid,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Repository$repository$object<TRes>
    implements CopyWith$Query$Repository$repository$object<TRes> {
  _CopyWithImpl$Query$Repository$repository$object(
    this._instance,
    this._then,
  );

  final Query$Repository$repository$object _instance;

  final TRes Function(Query$Repository$repository$object) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? oid = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Repository$repository$object(
        oid: oid == _undefined || oid == null ? _instance.oid : (oid as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Repository$repository$object<TRes>
    implements CopyWith$Query$Repository$repository$object<TRes> {
  _CopyWithStubImpl$Query$Repository$repository$object(this._res);

  TRes _res;

  call({
    String? oid,
    String? $__typename,
  }) =>
      _res;
}

class Query$Repository$repository$object$$Blob
    implements Query$Repository$repository$object {
  Query$Repository$repository$object$$Blob({
    required this.oid,
    this.$__typename = 'Blob',
  });

  factory Query$Repository$repository$object$$Blob.fromJson(
      Map<String, dynamic> json) {
    final l$oid = json['oid'];
    final l$$__typename = json['__typename'];
    return Query$Repository$repository$object$$Blob(
      oid: (l$oid as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String oid;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$oid = oid;
    _resultData['oid'] = l$oid;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$oid = oid;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$oid,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Repository$repository$object$$Blob) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$oid = oid;
    final lOther$oid = other.oid;
    if (l$oid != lOther$oid) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Repository$repository$object$$Blob
    on Query$Repository$repository$object$$Blob {
  CopyWith$Query$Repository$repository$object$$Blob<
          Query$Repository$repository$object$$Blob>
      get copyWith => CopyWith$Query$Repository$repository$object$$Blob(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Repository$repository$object$$Blob<TRes> {
  factory CopyWith$Query$Repository$repository$object$$Blob(
    Query$Repository$repository$object$$Blob instance,
    TRes Function(Query$Repository$repository$object$$Blob) then,
  ) = _CopyWithImpl$Query$Repository$repository$object$$Blob;

  factory CopyWith$Query$Repository$repository$object$$Blob.stub(TRes res) =
      _CopyWithStubImpl$Query$Repository$repository$object$$Blob;

  TRes call({
    String? oid,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Repository$repository$object$$Blob<TRes>
    implements CopyWith$Query$Repository$repository$object$$Blob<TRes> {
  _CopyWithImpl$Query$Repository$repository$object$$Blob(
    this._instance,
    this._then,
  );

  final Query$Repository$repository$object$$Blob _instance;

  final TRes Function(Query$Repository$repository$object$$Blob) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? oid = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Repository$repository$object$$Blob(
        oid: oid == _undefined || oid == null ? _instance.oid : (oid as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Repository$repository$object$$Blob<TRes>
    implements CopyWith$Query$Repository$repository$object$$Blob<TRes> {
  _CopyWithStubImpl$Query$Repository$repository$object$$Blob(this._res);

  TRes _res;

  call({
    String? oid,
    String? $__typename,
  }) =>
      _res;
}

class Query$Repository$repository$object$$Commit
    implements Query$Repository$repository$object {
  Query$Repository$repository$object$$Commit({
    required this.oid,
    this.$__typename = 'Commit',
  });

  factory Query$Repository$repository$object$$Commit.fromJson(
      Map<String, dynamic> json) {
    final l$oid = json['oid'];
    final l$$__typename = json['__typename'];
    return Query$Repository$repository$object$$Commit(
      oid: (l$oid as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String oid;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$oid = oid;
    _resultData['oid'] = l$oid;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$oid = oid;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$oid,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Repository$repository$object$$Commit) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$oid = oid;
    final lOther$oid = other.oid;
    if (l$oid != lOther$oid) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Repository$repository$object$$Commit
    on Query$Repository$repository$object$$Commit {
  CopyWith$Query$Repository$repository$object$$Commit<
          Query$Repository$repository$object$$Commit>
      get copyWith => CopyWith$Query$Repository$repository$object$$Commit(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Repository$repository$object$$Commit<TRes> {
  factory CopyWith$Query$Repository$repository$object$$Commit(
    Query$Repository$repository$object$$Commit instance,
    TRes Function(Query$Repository$repository$object$$Commit) then,
  ) = _CopyWithImpl$Query$Repository$repository$object$$Commit;

  factory CopyWith$Query$Repository$repository$object$$Commit.stub(TRes res) =
      _CopyWithStubImpl$Query$Repository$repository$object$$Commit;

  TRes call({
    String? oid,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Repository$repository$object$$Commit<TRes>
    implements CopyWith$Query$Repository$repository$object$$Commit<TRes> {
  _CopyWithImpl$Query$Repository$repository$object$$Commit(
    this._instance,
    this._then,
  );

  final Query$Repository$repository$object$$Commit _instance;

  final TRes Function(Query$Repository$repository$object$$Commit) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? oid = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Repository$repository$object$$Commit(
        oid: oid == _undefined || oid == null ? _instance.oid : (oid as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Repository$repository$object$$Commit<TRes>
    implements CopyWith$Query$Repository$repository$object$$Commit<TRes> {
  _CopyWithStubImpl$Query$Repository$repository$object$$Commit(this._res);

  TRes _res;

  call({
    String? oid,
    String? $__typename,
  }) =>
      _res;
}

class Query$Repository$repository$object$$Tag
    implements Query$Repository$repository$object {
  Query$Repository$repository$object$$Tag({
    required this.oid,
    this.$__typename = 'Tag',
  });

  factory Query$Repository$repository$object$$Tag.fromJson(
      Map<String, dynamic> json) {
    final l$oid = json['oid'];
    final l$$__typename = json['__typename'];
    return Query$Repository$repository$object$$Tag(
      oid: (l$oid as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String oid;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$oid = oid;
    _resultData['oid'] = l$oid;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$oid = oid;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$oid,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Repository$repository$object$$Tag) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$oid = oid;
    final lOther$oid = other.oid;
    if (l$oid != lOther$oid) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Repository$repository$object$$Tag
    on Query$Repository$repository$object$$Tag {
  CopyWith$Query$Repository$repository$object$$Tag<
          Query$Repository$repository$object$$Tag>
      get copyWith => CopyWith$Query$Repository$repository$object$$Tag(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Repository$repository$object$$Tag<TRes> {
  factory CopyWith$Query$Repository$repository$object$$Tag(
    Query$Repository$repository$object$$Tag instance,
    TRes Function(Query$Repository$repository$object$$Tag) then,
  ) = _CopyWithImpl$Query$Repository$repository$object$$Tag;

  factory CopyWith$Query$Repository$repository$object$$Tag.stub(TRes res) =
      _CopyWithStubImpl$Query$Repository$repository$object$$Tag;

  TRes call({
    String? oid,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Repository$repository$object$$Tag<TRes>
    implements CopyWith$Query$Repository$repository$object$$Tag<TRes> {
  _CopyWithImpl$Query$Repository$repository$object$$Tag(
    this._instance,
    this._then,
  );

  final Query$Repository$repository$object$$Tag _instance;

  final TRes Function(Query$Repository$repository$object$$Tag) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? oid = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Repository$repository$object$$Tag(
        oid: oid == _undefined || oid == null ? _instance.oid : (oid as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Repository$repository$object$$Tag<TRes>
    implements CopyWith$Query$Repository$repository$object$$Tag<TRes> {
  _CopyWithStubImpl$Query$Repository$repository$object$$Tag(this._res);

  TRes _res;

  call({
    String? oid,
    String? $__typename,
  }) =>
      _res;
}

class Query$Repository$repository$object$$Tree
    implements Query$Repository$repository$object {
  Query$Repository$repository$object$$Tree({
    required this.oid,
    this.$__typename = 'Tree',
  });

  factory Query$Repository$repository$object$$Tree.fromJson(
      Map<String, dynamic> json) {
    final l$oid = json['oid'];
    final l$$__typename = json['__typename'];
    return Query$Repository$repository$object$$Tree(
      oid: (l$oid as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String oid;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$oid = oid;
    _resultData['oid'] = l$oid;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$oid = oid;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$oid,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (!(other is Query$Repository$repository$object$$Tree) ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$oid = oid;
    final lOther$oid = other.oid;
    if (l$oid != lOther$oid) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$Repository$repository$object$$Tree
    on Query$Repository$repository$object$$Tree {
  CopyWith$Query$Repository$repository$object$$Tree<
          Query$Repository$repository$object$$Tree>
      get copyWith => CopyWith$Query$Repository$repository$object$$Tree(
            this,
            (i) => i,
          );
}

abstract class CopyWith$Query$Repository$repository$object$$Tree<TRes> {
  factory CopyWith$Query$Repository$repository$object$$Tree(
    Query$Repository$repository$object$$Tree instance,
    TRes Function(Query$Repository$repository$object$$Tree) then,
  ) = _CopyWithImpl$Query$Repository$repository$object$$Tree;

  factory CopyWith$Query$Repository$repository$object$$Tree.stub(TRes res) =
      _CopyWithStubImpl$Query$Repository$repository$object$$Tree;

  TRes call({
    String? oid,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$Repository$repository$object$$Tree<TRes>
    implements CopyWith$Query$Repository$repository$object$$Tree<TRes> {
  _CopyWithImpl$Query$Repository$repository$object$$Tree(
    this._instance,
    this._then,
  );

  final Query$Repository$repository$object$$Tree _instance;

  final TRes Function(Query$Repository$repository$object$$Tree) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? oid = _undefined,
    Object? $__typename = _undefined,
  }) =>
      _then(Query$Repository$repository$object$$Tree(
        oid: oid == _undefined || oid == null ? _instance.oid : (oid as String),
        $__typename: $__typename == _undefined || $__typename == null
            ? _instance.$__typename
            : ($__typename as String),
      ));
}

class _CopyWithStubImpl$Query$Repository$repository$object$$Tree<TRes>
    implements CopyWith$Query$Repository$repository$object$$Tree<TRes> {
  _CopyWithStubImpl$Query$Repository$repository$object$$Tree(this._res);

  TRes _res;

  call({
    String? oid,
    String? $__typename,
  }) =>
      _res;
}
