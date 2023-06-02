// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class MovieSlider extends StatefulWidget {
  List<Movie> popularMovies = [];
  final String? title;
  final Function onNextPage;

  MovieSlider({super.key, required this.popularMovies, this.title, required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
            widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 290,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.title!,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.popularMovies.length,
                itemBuilder: (_, int index) {
                  return _MoviePoster(
                    popular: widget.popularMovies[index],
                    heroId: '${ widget.title }-$index-${ widget.popularMovies[index].id }',
                  );
                }),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie popular;
  final String heroId;
  const _MoviePoster({required this.popular, required this.heroId});

  @override
  Widget build(BuildContext context) {

    popular.heroId = heroId;
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/details',
              arguments: popular),
          child: Hero(
            tag: heroId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/no-image.jpg'),
                image: NetworkImage(popular.fullPosterImg),
                fit: BoxFit.cover,
                width: 130,
                height: 190,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          popular.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.justify,
        )
      ]),
    );
  }
}
