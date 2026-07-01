import 'package:dartz/dartz.dart';
import 'package:forge_annotation/forge_annotation.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../domain/entities/home_entities_export.dart';

abstract class HomeRepository {
  @GET(endPoint: 'exemple')
  Future<Either<Failure, HomeEntity>> exemple();
}
