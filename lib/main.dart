import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    MobileAds.instance.initialize();
  } catch (_) {}
  runApp(const YojanaLabhApp());
}
