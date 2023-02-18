import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'film.dart';
import 'list.dart';

class FilmNotifier extends StateNotifier<List<Film>> {
  FilmNotifier() : super(allFilms);

  void update(Film film, bool isFavorite) {
    state = state
        .map((e) => e.id == film.id ? e.filmUpdate(isFavorite: isFavorite) : e)
        .toList();
  }

  void add(Film film) {
    state = [...state, film];
  }
}
