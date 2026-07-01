import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get fileName => switch (kReleaseMode) {
    true => '.env.production',
    _ => '.env.development',
  };

  static String get apiUrl => dotenv.env['API_URL'] ?? 'api not found';
}
