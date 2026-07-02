import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/news_category.dart';
import '../cubit/home_cubit.dart';
import 'rubrique_chips.dart';

/// The rubrique chips wired to the [HomeCubit] filter.
class RubriqueFilters extends StatelessWidget {
  const RubriqueFilters({
    required this.rubriques,
    required this.selected,
    super.key,
  });

  final List<NewsCategory> rubriques;
  final NewsCategory? selected;

  @override
  Widget build(BuildContext context) => RubriqueChips(
    rubriques: rubriques,
    selected: selected,
    onSelected: context.read<HomeCubit>().selectRubrique,
  );
}
