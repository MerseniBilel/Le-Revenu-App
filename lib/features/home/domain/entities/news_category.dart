/// Editorial sections of Le Revenu.
enum NewsCategory {
  bourse('Bourse'),
  immobilier('Immobilier'),
  placements('Placements'),
  fiscalite('Fiscalité'),
  assurance('Assurance'),
  retraite('Retraite');

  const NewsCategory(this.label);

  /// Human readable name, as displayed in the app.
  final String label;
}
