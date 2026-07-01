# Le Revenu — Home Page mobile

Test technique **Overlord Technologies** : page d'accueil mobile du média financier
**Le Revenu**, réalisée en **Flutter** avec des données fictives (aucune API).

## Aperçu

La page d'accueil comprend :

- un **en-tête** avec la date du jour, la marque « LE REVENU » et des actions rapides
  (recherche, notifications) ;
- l'**actualité principale** mise en avant (« À la une ») dans une carte héro ;
- des **rubriques** (Bourse, Immobilier, Placements, Fiscalité, Assurance, Retraite)
  sous forme de chips horizontales qui **filtrent** la liste d'articles ;
- la liste des **dernières actualités**, avec catégorie, temps de lecture et
  date relative (« Il y a 35 min ») ;
- une **navigation inférieure** à 5 destinations ;
- **pull-to-refresh**, états de **chargement** et d'**erreur** avec retry ;
- support complet du **mode sombre** (appui long sur le logo pour basculer,
  préférence persistée via `hydrated_bloc`).

> 📸 Captures d'écran : voir le dossier `screenshots/` (ou la vidéo jointe à l'e-mail).

## Lancer le projet

```bash
flutter pub get
flutter run
```

Le code généré (DI, routes, couleurs) est versionné. Pour le régénérer :

```bash
dart run build_runner build --delete-conflicting-outputs --force-jit
```

## Choix techniques

| Sujet | Choix | Pourquoi |
|---|---|---|
| Architecture | Clean Architecture (domain / data / presentation) par feature | Séparation stricte des responsabilités, testabilité, évolutivité |
| État | `flutter_bloc` (Cubit) | États explicites (`HomeLoading` / `HomeLoaded` / `HomeError`), rebuilds ciblés |
| Injection de dépendances | `get_it` + `injectable` | Couplage faible, dépendances déclarées par contrat (interfaces) |
| Navigation | `go_router` (typed routes générées) | Routes type-safe, prêtes pour la montée en charge |
| Gestion d'erreur | `dartz` (`Either<Failure, T>`) | Erreurs modélisées dans le domaine, pas d'exceptions traversantes |
| Thème | `ThemeData` + palette générée (`flutter_gen`) depuis `assets/color/*.xml` | Une seule source de vérité pour les couleurs, clair/sombre sans duplication |
| Typographie | Playfair Display (embarquée dans `assets/fonts/`) | Voix éditoriale « presse » du Revenu, fonctionne hors-ligne |
| Données | Source de données fake, payload « JSON-like » en mémoire | Simule un aller-retour réseau (latence incluse) sans dépendre d'une API |

## Architecture

```
lib/
├── core/                          # Transverse, réutilisable par toutes les features
│   ├── extensions/                # context (thème raccourci), dates FR, spacing…
│   ├── gen/                       # Code généré : DI, couleurs, assets
│   ├── router/                    # go_router + routes typées
│   ├── shared/
│   │   └── widgets/               # Composants UI génériques et réutilisables
│   │       ├── app_bottom_nav.dart    # Barre de navigation paramétrable
│   │       ├── app_chip.dart          # Chip sélectionnable animée
│   │       ├── eyebrow_text.dart      # Surtitre de section / catégorie
│   │       └── section_header.dart    # Titre de section + action optionnelle
│   └── theme/                     # ThemeData clair / sombre
└── features/
    └── home/
        ├── domain/                # Pur Dart, aucune dépendance Flutter
        │   ├── entities/          # Article, HomeContent, NewsCategory
        │   ├── repositories/      # Contrat HomeRepository (Either<Failure, T>)
        │   └── usecases/          # GetHomeContent
        ├── data/
        │   ├── datasources/       # HomeLocalDataSource (+ implémentation fake)
        │   ├── models/            # ArticleModel (mapping JSON → entité)
        │   └── repositories/      # HomeRepositoryImpl
        └── presentation/
            ├── cubit/             # HomeCubit + états scellés
            ├── extensions/        # NewsCategory → couleur / icône (UI only)
            ├── views/             # HomeScreen (composition)
            └── widgets/           # HomeHeader, FeaturedArticleCard,
                                   # ArticleTile, RubriqueChips
```

### Principes SOLID appliqués

- **S** — chaque widget/classe a une responsabilité unique : `ArticleTile` affiche
  un article, `HomeCubit` orchestre l'état, `FakeHomeLocalDataSource` fournit les
  données ;
- **O** — les composants sont ouverts à l'extension par paramètres
  (`AppBottomNav` accepte n'importe quelle liste de destinations, `SectionHeader`
  une action optionnelle) sans modification de leur code ;
- **L** — `ArticleModel` est substituable à l'entité `Article`,
  `FakeHomeLocalDataSource` à tout `HomeLocalDataSource` ;
- **I** — contrats minimaux : `HomeRepository` n'expose que `getHomeContent()` ;
- **D** — la présentation dépend d'abstractions (`GetHomeContent` → `HomeRepository`
  → `HomeLocalDataSource`), câblées par injection : brancher une vraie API se
  résume à une nouvelle implémentation de la data source.

### Réutilisabilité des composants

Les briques génériques (`AppChip`, `SectionHeader`, `EyebrowText`, `AppBottomNav`)
vivent dans `core/shared/widgets` et ne connaissent rien du métier : elles se
paramètrent par props (label, sélection, callbacks). Les widgets de la feature
(`ArticleTile`, `FeaturedArticleCard`…) reçoivent des entités du domaine et des
callbacks — aucun accès direct à l'état global, ce qui les rend testables et
réutilisables tels quels dans d'autres écrans (résultats de recherche, rubrique…).

### Performances

- Listes construites paresseusement (`CustomScrollView` + `SliverList.builder`,
  `ListView.separated` pour les chips) ;
- widgets `const` partout où c'est possible, sous-widgets privés plutôt que
  méthodes-builder pour maximiser le cache de l'arbre ;
- rebuilds limités au `BlocBuilder` du contenu — l'en-tête et la barre de
  navigation ne se reconstruisent pas lors des changements d'état ;
- aucune image réseau : vignettes vectorielles (icônes + couleurs de rubrique).

### Données fictives

`FakeHomeLocalDataSource` sert un payload JSON en mémoire avec une latence
simulée de 450 ms (ce qui rend visibles l'état de chargement et le
pull-to-refresh). Les horodatages sont calculés relativement à `DateTime.now()`
pour que les dates relatives restent réalistes. Le formatage des dates en
français est fait à la main (`core/extensions/date_time.dart`) pour éviter
d'embarquer `intl` pour deux chaînes.

## Détails UX

- La rubrique sélectionnée filtre la liste (chip « Tous » pour revenir à tout) ;
- état vide dédié si une rubrique n'a pas d'article ;
- appui long sur « LE REVENU » : bascule clair/sombre, persistée entre les
  lancements ;
- les actions non couvertes par le test (recherche, article, onglets…) affichent
  un snackbar « arrive bientôt » plutôt que de ne rien faire.
