enum StoryGenre {
  comedy,
  drama,
  horror,
  adventure,
  romance,
  fantasy,
  sciFi,
  mystery,
}

extension StoryGenreExtension on StoryGenre {
  String get name {
    switch (this) {
      case StoryGenre.comedy:
        return 'Comédia';
      case StoryGenre.drama:
        return 'Drama';
      case StoryGenre.horror:
        return 'Terror';
      case StoryGenre.adventure:
        return 'Aventura';
      case StoryGenre.romance:
        return 'Romance';
      case StoryGenre.fantasy:
        return 'Fantasia';
      case StoryGenre.sciFi:
        return 'Ficção Científica';
      case StoryGenre.mystery:
        return 'Mistério';
    }
  }
}
