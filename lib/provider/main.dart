import 'dart:core';

import 'package:favorite_not_favorite/provider/list.dart';
import 'package:favorite_not_favorite/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'film.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

enum FavoriteStatus { all, favorite, notFavorite }

final favoriteStatuesProvider =
    StateProvider<FavoriteStatus>((ref) => FavoriteStatus.all);

final allListProvider =
    StateNotifierProvider<FilmNotifier, List<Film>>((_) => FilmNotifier());

final favoriteProvider = Provider(
    (ref) => ref.watch(allListProvider).where((element) => element.isFavorite));

final notFavoriteProvider = Provider((ref) =>
    ref.watch(allListProvider).where((element) => !element.isFavorite));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Films')),
        actions: [
          GestureDetector(
            onTap: () {
              for (var s in ref.read(notFavoriteProvider)) {
                print(s.title);
              }
            },
            child: const Icon(Icons.abc),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
            child: Center(
              child: DropDownWidget(),
            ),
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final change = ref.watch(favoriteStatuesProvider);
              switch (change) {
                case FavoriteStatus.all:
                  return ListWidget(alwaysAliveProviderBase: allListProvider);
                case FavoriteStatus.favorite:
                  return ListWidget(alwaysAliveProviderBase: favoriteProvider);
                case FavoriteStatus.notFavorite:
                  return ListWidget(
                      alwaysAliveProviderBase: notFavoriteProvider);
              }
            },
          )
        ],
      ),
    );
  }
}

class ListWidget extends ConsumerWidget {
  const ListWidget({
    required this.alwaysAliveProviderBase,
    super.key,
  });

  final AlwaysAliveProviderBase<Iterable<Film>> alwaysAliveProviderBase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: ListView.builder(
        itemCount: ref.read(alwaysAliveProviderBase).length,
        itemBuilder: (context, index) {
          final filmList = ref.watch(alwaysAliveProviderBase);
          Film film = filmList.elementAt(index);

          return ListTile(
            title: Text(
              film.title,
            ),
            subtitle: Text(
              film.description,
            ),
            trailing: GestureDetector(
              onTap: () {
                final bool isFavorite = !film.isFavorite;
                ref.read(allListProvider.notifier).update(film, isFavorite);
              },
              child: Icon(
                film.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}

class DropDownWidget extends ConsumerWidget {
  const DropDownWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const list = FavoriteStatus.values;

    return DropdownButton(
      value: ref.watch(favoriteStatuesProvider),
      onChanged: (value) {
        ref.read(favoriteStatuesProvider.notifier).state = value!;
      },
      items: list.map<DropdownMenuItem<FavoriteStatus>>((FavoriteStatus value) {
        return DropdownMenuItem<FavoriteStatus>(
          value: value,
          child: Text(value.toString().split('.').last),
        );
      }).toList(),
    );
  }
}
