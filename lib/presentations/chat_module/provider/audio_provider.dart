import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import '../../../data/models/messageModel.dart';
import '../../widgets/dialogs/scaffold_messanger.dart';

class AudioProvider with ChangeNotifier{
  AudioPlayer audioPlayer =  AudioPlayer();
  int? indexPlayedAudio;
  bool isPlaying = false;
  double playedSeconds = 0;




  void initAudio(int index,MessageModel model) async {

    if(audioPlayer.state == PlayerState.playing){
      pause();

    }
    indexPlayedAudio = null;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 200));

    audioPlayer.onPlayerStateChanged.listen((state) async{
      isPlaying = state==PlayerState.playing;

      if(state == PlayerState.completed||state == PlayerState.disposed){
        indexPlayedAudio = null;
        playedSeconds = 0;
        notifyListeners();
      }


    });



    if(model.file!=null){
      indexPlayedAudio = index;
      notifyListeners();
      play(model.file!);

    }

  }

 void play(String audioUrl) async{
    playedSeconds = 0;
   try{
      if(audioPlayer.state!=PlayerState.disposed){
        await audioPlayer.play(UrlSource(audioUrl));
        startTimer();

      }

    }catch (e){
      CustomScaffoldMessanger.showToast(title: 'Invalid source');
    }
  }

  void pause() async{

    if(audioPlayer.state!=PlayerState.disposed&&audioPlayer.state==PlayerState.playing){
      await audioPlayer.pause();
    }


  }

  void startTimer() {

    Timer.periodic(const Duration(milliseconds: 50), (t) {
      playedSeconds +=(50/1000) ;
      notifyListeners();
      if(audioPlayer.state==PlayerState.disposed||audioPlayer.state==PlayerState.paused||audioPlayer.state==PlayerState.stopped||audioPlayer.state==PlayerState.completed){
        t.cancel();
      }
    });
  }




}