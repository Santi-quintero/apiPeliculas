import 'package:flutter/material.dart';
import 'package:peliculas/widgets/casting_cards.dart';

import '../models/models.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _CustomAppBar(detailsMovie: movie,),
        SliverList(delegate: SliverChildListDelegate(
          [
            _PosterAndTitle(detailsMovie: movie,),
            _Overview(detailsMovie: movie,),
            _Overview(detailsMovie: movie,),
            _Overview(detailsMovie: movie,),
            
            CastingCards(movieId: movie.id,)

            ]))
      ],
    ));
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie detailsMovie;

  const _CustomAppBar({required this.detailsMovie});
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          color: Colors.black12,
          padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
          child: Text(
            detailsMovie.title,
            style:const TextStyle(fontSize: 16,),
            textAlign: TextAlign.center,
          ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/images/loading.gif'),
          image: NetworkImage(detailsMovie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {

  final Movie detailsMovie;

  const _PosterAndTitle({required this.detailsMovie});
  
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: detailsMovie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage( 
                placeholder: const AssetImage('assets/images/no-image.jpg'),
                image: NetworkImage(detailsMovie.fullPosterImg),
                height: 150,
              ),
            ),
          ),
          const SizedBox(width: 20),
          ConstrainedBox(
            constraints: BoxConstraints( maxWidth: size.width - 190 ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Text(
                  detailsMovie.title,
                  style: textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  detailsMovie.originalTitle,
                  style: textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
          
                Row(
                  children:[
                    const Icon(Icons.star_outlined, size: 15, color: Colors.white,),
                    const SizedBox(width: 5),
                    Text("${detailsMovie.voteAverage}", style: textTheme.bodySmall,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}


class _Overview extends StatelessWidget {
  
  final Movie detailsMovie;

  const _Overview({required this.detailsMovie});

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(detailsMovie.overview  ,
      textAlign: TextAlign.justify, style: Theme.of(context).textTheme.bodyLarge,),
  
    );
  }
}