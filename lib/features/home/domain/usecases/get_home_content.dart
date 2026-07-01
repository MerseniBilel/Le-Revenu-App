import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures/failures.dart';
import '../entities/home_entities_export.dart';
import '../repositories/home_repository.dart';

/// Loads the content of the home page.
@lazySingleton
class GetHomeContent {
  const GetHomeContent(this._repository);

  final HomeRepository _repository;

  Future<Either<Failure, HomeContent>> call() =>
      _repository.getHomeContent();
}
