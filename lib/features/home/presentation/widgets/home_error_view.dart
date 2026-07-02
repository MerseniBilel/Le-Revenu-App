import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context.dart';
import '../cubit/home_cubit.dart';

/// Full-body error state with a retry action.
class HomeErrorView extends StatelessWidget {
  const HomeErrorView({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 32, color: context.paragraph),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.h6.copyWith(color: context.paragraph),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: context.read<HomeCubit>().load,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    ),
  );
}
