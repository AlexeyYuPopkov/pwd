import 'package:pwd/common/di/di_scope.dart';
import 'package:pwd/data/datasource/datasource.dart';
import 'package:pwd/data/datasource/datasource_impl.dart';
import 'package:pwd/data/datasource/gateway_impl.dart';
import 'package:pwd/domain/gateway.dart';

class MainModule extends DiModule {
  @override
  List<Binding> objects() {
    final datasource = Binding.prototype<Datasource>(
      () => DatasourceImpl(),
    );

    final gateway = Binding.prototype<Gateway>(
      () => GatewayImpl(datasource: datasource()),
    );

    return [
      datasource,
      gateway,
    ];
  }
}
