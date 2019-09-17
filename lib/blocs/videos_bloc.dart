import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_tube_bloc/api.dart';
import 'package:flutter_tube_bloc/models/video.dart';

class VideosBloc implements BlocBase {
  Api api;

  List<Video> videos;

  final StreamController<List<Video>> _videosController =
      StreamController<List<Video>>(); //lembrar de fechar no dispose
  Stream get outVideos => _videosController.stream;

  final StreamController<String> _searchController =
      StreamController<String>(); //lembrar de fechar no dispose
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();
    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    if(search != null){
      _videosController.sink.add([]);
      videos = await api.search(search);
    }else{
     videos += await api.nextPage();
    }
    _videosController.sink.add(videos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }
}
