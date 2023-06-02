import 'package:flutter/material.dart';
import 'package:peliculas/services/movies_services.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../search/movie_delegate.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MovieServices>(context);


    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Peliculas en cine')),
          actions: [
            IconButton(
                onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate() ),
                icon: const Icon(Icons.search_outlined))
          ],
        ),
        // ignore: avoid_unnecessary_containers
        body: SingleChildScrollView(
          child: Column(
            children: [
              //tarjetas principales
              CardSwiper(movies: moviesProvider.onDisplayMovies),

              //tarjetas de slider

              MovieSlider(
                popularMovies: moviesProvider.onPopularMovies,
                title: 'Populares!',
                onNextPage: ()=>moviesProvider.getPopularMovies(),
                )
            ],
          ),
        ));
  }
}
