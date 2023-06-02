import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debounce.dart';
import 'package:peliculas/models/models.dart';

class MovieServices extends ChangeNotifier {
  final String _apiKey = '887a4d160784d8f19864891e0398f43a';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> onPopularMovies = [];
  int _popularPage = 0;
  Map<int, List<Cast>> movieCast = {};

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500)
    );

  final StreamController<List<Movie>> _sugesstionStreamController = StreamController.broadcast(); 
  Stream<List<Movie>> get sugesstionStream => _sugesstionStreamController.stream;

  

  MovieServices() {
    print("Movies provider inicializado");
    getOnDisplayMovies();
    getPopularMovies();
  }
  Future<String> _getJsonData(String endPoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endPoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('/3/movie/now_playing');
    final res = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = res.results;

    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('/3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
    onPopularMovies = [...onPopularMovies, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    movieCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> getSearchMovie(String query) async {
    final url = Uri.https(_baseUrl, '/3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSugesstionByQuery(String searchQuery){

    debouncer.value = '';
    debouncer.onValue=(value)async {
      final result = await getSearchMovie(value);
      _sugesstionStreamController.add(result);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchQuery;
     });

     Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());

  }
}
