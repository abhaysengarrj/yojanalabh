import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart' as app;
import 'data/repository/scheme_repository.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    MobileAds.instance.initialize();
  } catch (_) {}
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => SchemeRepository()),
        ChangeNotifierProvider(create: (_) => app.AppState()),
      ],
      child: const YojanaLabhApp(),
    ),
  );
}
