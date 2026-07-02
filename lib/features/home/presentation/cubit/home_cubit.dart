import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/home_entities_export.dart';
import '../../domain/usecases/get_home_content.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getHomeContent) : super(const HomeLoading());

  final GetHomeContent _getHomeContent;

  Future<void> load() async {
    emit(const HomeLoading());
    await _fetch();
  }

  /// Refresh triggered by the pull-to-refresh gesture: reloads the content
  /// without flashing the loading state.
  Future<void> refresh() => _fetch();

  Future<void> _fetch() async {
    final result = await _getHomeContent();
    result.fold(
      (failure) => emit(HomeError(failure.message)),
      (content) => emit(HomeLoaded(content: content)),
    );
  }
}
