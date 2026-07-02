import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../domain/entities/home_entities_export.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._dataSource);

  final HomeLocalDataSource _dataSource;

  @override
  Future<Either<Failure, HomeContent>> getHomeContent() async {
    try {
      final (articles, videos) = await (
        _dataSource.fetchArticles(),
        _dataSource.fetchVideoShorts(),
      ).wait;
      if (articles.isEmpty) {
        return Left(UnexpectedFailure(msg: 'No article available'));
      }
      final sorted = [...articles]
        ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      // The most recent "bourse" story is promoted to the top of the page;
      // the remaining articles feed the "Dernières actualités".
      final featured = sorted.firstWhere(
        (article) => article.category == NewsCategory.bourse,
        orElse: () => sorted.first,
      );
      return Right(
        HomeContent(
          featured: featured,
          latestArticles: sorted.where((a) => a != featured).toList(),
          videoShorts: videos,
        ),
      );
    } catch (e) {
      return Left(UnexpectedFailure(msg: e.toString()));
    }
  }
}
