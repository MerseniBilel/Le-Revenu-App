import 'package:injectable/injectable.dart';

import '../models/home_models_export.dart';

/// Provides the raw home page data.
///
/// Abstracted so the repository does not care whether articles come from a
/// local fake, a cache or a remote API.
abstract class HomeLocalDataSource {
  Future<List<ArticleModel>> fetchArticles();

  Future<List<VideoShortModel>> fetchVideoShorts();
}

/// Fake implementation: serves an in-memory, JSON-shaped payload after a
/// short delay, mimicking a network round-trip.
@LazySingleton(as: HomeLocalDataSource)
class FakeHomeLocalDataSource implements HomeLocalDataSource {
  const FakeHomeLocalDataSource();

  static const _networkDelay = Duration(milliseconds: 450);

  @override
  Future<List<ArticleModel>> fetchArticles() async {
    await Future<void>.delayed(_networkDelay);
    final now = DateTime.now();
    return _payload(now).map(ArticleModel.fromJson).toList();
  }

  @override
  Future<List<VideoShortModel>> fetchVideoShorts() async {
    await Future<void>.delayed(_networkDelay);
    return _videosPayload.map(VideoShortModel.fromJson).toList();
  }

  static const List<Map<String, dynamic>> _videosPayload = [
    {
      'id': 'v-01',
      'title': 'Combien gagne vraiment un trader ?',
      'category': 'bourse',
      'duration_seconds': 58,
    },
    {
      'id': 'v-02',
      'title': 'SCPI : faut-il encore investir en 2026 ?',
      'category': 'immobilier',
      'duration_seconds': 72,
    },
    {
      'id': 'v-03',
      'title': "Impôts : l'erreur qui coûte cher",
      'category': 'fiscalite',
      'duration_seconds': 35,
    },
    {
      'id': 'v-04',
      'title': 'PEA ou assurance-vie : le match',
      'category': 'placements',
      'duration_seconds': 65,
    },
  ];

  /// Timestamps are computed relative to [now] so the relative dates
  /// displayed in the UI ("Il y a 2 h") always stay realistic.
  List<Map<String, dynamic>> _payload(DateTime now) {
    String ago({int hours = 0, int minutes = 0}) => now
        .subtract(Duration(hours: hours, minutes: minutes))
        .toIso8601String();

    return [
      {
        'id': 'a-01',
        'title':
            'CAC 40 : les trois valeurs à surveiller avant la saison des résultats',
        'category': 'bourse',
        'published_at': ago(hours: 2),
        'reading_minutes': 4,
      },
      {
        'id': 'a-02',
        'title': 'SCPI : le rendement moyen repasse au-dessus de 4,5 % en 2026',
        'category': 'immobilier',
        'published_at': ago(minutes: 35),
        'reading_minutes': 3,
      },
      {
        'id': 'a-03',
        'title': 'Impôt sur le revenu : ce qui change pour votre déclaration',
        'category': 'fiscalite',
        'published_at': ago(hours: 1),
        'reading_minutes': 5,
      },
      {
        'id': 'a-04',
        'title': 'Assurance-vie : les meilleurs fonds euros du moment',
        'category': 'placements',
        'published_at': ago(hours: 2, minutes: 10),
        'reading_minutes': 6,
      },
      {
        'id': 'a-05',
        'title':
            'Livret A, LEP, LDDS : quel livret choisir après la baisse des taux ?',
        'category': 'placements',
        'published_at': ago(hours: 3),
        'reading_minutes': 4,
      },
      {
        'id': 'a-06',
        'title':
            'Crédit immobilier : les banques rouvrent les vannes, à quelles conditions ?',
        'category': 'immobilier',
        'published_at': ago(hours: 4, minutes: 20),
        'reading_minutes': 5,
      },
      {
        'id': 'a-07',
        'title':
            'Retraite progressive : le dispositif élargi dès le 1er septembre',
        'category': 'retraite',
        'published_at': ago(hours: 5),
        'reading_minutes': 4,
      },
      {
        'id': 'a-08',
        'title':
            'Assurance auto : pourquoi votre prime augmente encore cette année',
        'category': 'assurance',
        'published_at': ago(hours: 6, minutes: 30),
        'reading_minutes': 3,
      },
      {
        'id': 'a-09',
        'title':
            'Dividendes : ces entreprises du CAC 40 qui gâtent leurs actionnaires',
        'category': 'bourse',
        'published_at': ago(hours: 8),
        'reading_minutes': 7,
      },
    ];
  }
}
