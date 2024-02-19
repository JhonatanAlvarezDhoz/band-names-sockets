// ignore_for_file: file_names

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/socket_services.dart';

class ProviderDependency {
  static List<SingleChildWidget> dependencies = [
    ChangeNotifierProvider(create: (_) => SocketServices())
  ];
}
