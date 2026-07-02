# Le Revenu — Home Page mobile

Test technique **Overlord Technologies** : page d'accueil mobile du média financier
**Le Revenu**, réalisée en **Flutter** avec des données fictives (aucune API).

## Aperçu

La page d'accueil comprend :

- un **en-tête** avec la date du jour, la marque « LE REVENU », la recherche et un
  **bouton clair/sombre** (préférence persistée via `hydrated_bloc`) ;
- l'**actualité principale** mise en avant (« À la une ») dans une carte héro ;
- des **rubriques** (Bourse, Immobilier, Placements, Fiscalité, Assurance, Retraite)
  sous forme de chips **épinglées en haut au scroll** avec **scroll-spy** : la
  rubrique active se met à jour selon la position de défilement, et taper une
  chip fait défiler jusqu'à sa section ;
- **« L'actualité en vidéos courtes »** : carrousel horizontal de vignettes.
  Les vidéos **ne se lancent pas sur la home** — un tap ouvre un écran plein
  écran avec **animation Hero**, où la lecture (simulée) démarre, avec
  progression, play/pause et coupure du son ;
- la liste des **dernières actualités**, groupée par rubrique, avec catégorie,
  temps de lecture et date relative (« Il y a 35 min ») ;
- **pull-to-refresh**, états de **chargement** et d'**erreur** avec retry ;
- support complet du **mode sombre**.

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
| Navigation | `go_router` (typed routes générées) | Routes type-safe ; la vidéo est passée en `$extra` à l'écran de lecture |
| Gestion d'erreur | `dartz` (`Either<Failure, T>`) | Erreurs modélisées dans le domaine, pas d'exceptions traversantes |
| Thème | `ThemeData` + palette générée (`flutter_gen`) depuis `assets/color/*.xml` | Une seule source de vérité pour les couleurs, clair/sombre sans duplication |
| Typographie | Playfair Display (embarquée dans `assets/fonts/`) | Voix éditoriale « presse » du Revenu, fonctionne hors-ligne |
| Données | Source de données fake, payload « JSON-like » en mémoire | Simule un aller-retour réseau (latence incluse) sans dépendre d'une API |

## Architecture

```
lib/
├── core/                          # Transverse, réutilisable par toutes les features
│   ├── extensions/                # context (thème raccourci), dates FR, durées…
│   ├── gen/                       # Code généré : DI, couleurs, assets
│   ├── router/                    # go_router + routes typées
│   ├── shared/
│   │   └── widgets/               # Composants UI génériques et réutilisables
│   │       ├── app_chip.dart          # Chip sélectionnable animée
│   │       ├── eyebrow_text.dart      # Surtitre de section / catégorie
│   │       └── section_header.dart    # Titre de section + action optionnelle
│   └── theme/                     # ThemeData clair / sombre
└── features/
    └── home/
        ├── domain/                # Pur Dart, aucune dépendance Flutter
        │   ├── entities/          # Article, VideoShort, HomeContent, NewsCategory
        │   ├── repositories/      # Contrat HomeRepository (Either<Failure, T>)
        │   └── usecases/          # GetHomeContent
        ├── data/
        │   ├── datasources/       # HomeLocalDataSource (+ implémentation fake)
        │   ├── models/            # ArticleModel, VideoShortModel (JSON → entité)
        │   └── repositories/      # HomeRepositoryImpl
        └── presentation/
            ├── cubit/             # HomeCubit + états scellés
            ├── extensions/        # NewsCategory → couleur / icône (UI only)
            ├── routes/            # Routes typées de la feature
            ├── views/             # HomeScreen, VideoShortPlayerScreen
            └── widgets/           # HomeHeader, FeaturedArticleCard, ArticleTile,
                                   # RubriqueChips, VideoShortsRail, VideoShortCard
```

### Principes SOLID appliqués

- **S** — chaque widget/classe a une responsabilité unique : `ArticleTile` affiche
  un article, `HomeCubit` orchestre l'état, `FakeHomeLocalDataSource` fournit les
  données, le scroll-spy vit dans l'état du widget (état éphémère d'UI, pas dans
  le cubit) ;
- **O** — les composants sont ouverts à l'extension par paramètres
  (`RubriqueChips` accepte n'importe quelle liste de rubriques, `SectionHeader`
  une action optionnelle) sans modification de leur code ;
- **L** — `ArticleModel` / `VideoShortModel` sont substituables aux entités,
  `FakeHomeLocalDataSource` à tout `HomeLocalDataSource` ;
- **I** — contrats minimaux : `HomeRepository` n'expose que `getHomeContent()` ;
- **D** — la présentation dépend d'abstractions (`GetHomeContent` → `HomeRepository`
  → `HomeLocalDataSource`), câblées par injection : brancher une vraie API se
  résume à une nouvelle implémentation de la data source.

### Rubriques épinglées + scroll-spy

Volontairement **sans slivers**, pour rester lisible : le corps de page est un
simple `SingleChildScrollView` + `Column`, et l'effet « épinglé » est obtenu
avec un `Stack` — dès que la barre de chips inline passe le haut du corps, une
copie flottante (même widget) est superposée en haut. Les articles sont groupés
par rubrique (`HomeLoaded.articleGroups`) ; chaque groupe porte une
`GlobalKey`. Au défilement, la section dont le haut est passé sous la barre
devient la rubrique active ; taper une chip anime le scroll jusqu'à son groupe
(le scroll-spy est suspendu pendant l'animation pour éviter que les sections
intermédiaires « volent » la sélection). La liste de chips défile
automatiquement pour garder la chip active visible.

### Vidéos courtes

Sur la home, les vignettes sont **statiques** (aucune lecture). Un tap navigue
vers `VideoShortPlayerScreen` via une route typée, la vignette se prolonge en
plein écran grâce à un **Hero** partagé. La lecture y est **simulée** par un
`AnimationController` calé sur la durée réelle de la vidéo (progression,
play/pause au tap, replay en fin de lecture) — fidèle au comportement attendu
sans embarquer de fichiers médias.

### Performances

- Rails horizontaux construits paresseusement (`ListView.separated`) ; le corps
  vertical est un `SingleChildScrollView` assumé : le contenu est court et
  borné (fake data), et garder toutes les sections montées rend le scroll-spy
  fiable sans machinerie sliver ;
- widgets `const` partout où c'est possible, sous-widgets privés plutôt que
  méthodes-builder pour maximiser le cache de l'arbre ;
- rebuilds limités : l'en-tête ne se reconstruit pas lors des changements
  d'état, la barre de progression du player ne reconstruit que via son
  `AnimatedBuilder` ;
- aucune image réseau : vignettes vectorielles (icônes + couleurs de rubrique).

### Données fictives

`FakeHomeLocalDataSource` sert des payloads JSON en mémoire (articles + vidéos,
chargés en parallèle) avec une latence simulée de 450 ms. Les horodatages sont
calculés relativement à `DateTime.now()` pour que les dates relatives restent
réalistes. Le formatage des dates en français est fait à la main
(`core/extensions/date_time.dart`) pour éviter d'embarquer `intl` pour deux
chaînes.

## Détails UX

- Bouton soleil/lune dans l'en-tête : bascule clair/sombre, persistée entre les
  lancements ;
- état vide dédié si une rubrique n'a pas d'article ;
- les actions non couvertes par le test (recherche, article, « Tout voir »)
  affichent un snackbar « arrive bientôt » plutôt que de ne rien faire.
