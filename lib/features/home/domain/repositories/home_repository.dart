import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures/failures.dart';
import '../entities/home_entities_export.dart';

/// Contract used by the presentation layer to load the home page content.
///
/// The current implementation serves fake data, but the contract stays the
/// same the day a real API is plugged in.
abstract class HomeRepository {
  Future<Either<Failure, HomeContent>> getHomeContent();
}
