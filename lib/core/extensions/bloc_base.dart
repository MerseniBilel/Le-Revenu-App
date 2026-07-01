import 'package:flutter_bloc/flutter_bloc.dart';

extension BlocBaseExtension on BlocBase {
  String get arrangedString => '$runtimeType($hashCode)';
}

extension BlocBaseIterableExtension on Iterable<BlocBase> {
  String get arrangedString => '${map((bloc) => bloc.arrangedString)}';
}
