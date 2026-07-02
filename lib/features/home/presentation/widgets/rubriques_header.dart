import 'package:flutter/material.dart';

import '../../../../core/extensions/snackbar.dart';
import '../../../../core/shared/widgets/section_header.dart';

/// "Rubriques" section title with its "Tout voir" action.
class RubriquesHeader extends StatelessWidget {
  const RubriquesHeader({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
    child: SectionHeader(
      title: 'Rubriques',
      actionLabel: 'Tout voir',
      onActionTap: () => context.showComingSoon('Cette section'),
    ),
  );
}
