import 'package:billcheck/viewmodel/banner_view_model.dart';
import 'package:billcheck/viewmodel/clothes_view_model.dart';
import 'package:billcheck/viewmodel/customer_view_model.dart';
import 'package:billcheck/viewmodel/history_view_model.dart';
import 'package:billcheck/viewmodel/login_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => LoginViewModel()),
  ChangeNotifierProvider(create: (_) => CustomerViewModel()),
  ChangeNotifierProvider(create: (_) => ClothesViewModel()),
  ChangeNotifierProvider(create: (_) => BannerViewModel()),
  ChangeNotifierProvider(create: (_) => HistoryViewModel()),
];
