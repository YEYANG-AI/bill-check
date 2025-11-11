import 'package:billcheck/viewmodel/customer_view_model.dart';
import 'package:billcheck/viewmodel/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => LoginViewModel()),
  ChangeNotifierProvider(create: (_) => CustomerViewModel()),
];
