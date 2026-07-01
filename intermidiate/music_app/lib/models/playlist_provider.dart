import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:music_app/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // playlist of songs
  final List<Song> _playlist = [
    // song 1
    Song(
      songName: 'So Sick',
      artistName: 'Wizkid',
      albumArtImagePath: "assets/images/album1.jpg",
      audioPath: "assets/audio/wizkid.mp3",
    ),

    // song 2
    Song(
      songName: 'Kese',
      artistName: 'Wande Coal',
      albumArtImagePath: "assets/images/album2.jpg",
      audioPath: "assets/audio/wizkid.mp3",
    ),

    // song 3
    Song(
      songName: 'So Tired',
      artistName: 'Kizz Daniel',
      albumArtImagePath: "assets/images/album3.jpg",
      audioPath: "assets/audio/wizkid.mp3",
    ),
  ];

  // current song playing index

  int? _currentSongIndex;

  /* 
  
    A U D I O P L A Y E R 


   */

  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // constructor
  PlaylistProvider() {
    listenToDuration();
  }

  // initially when not playing
  bool _isPlaying = false;

  // play the song
  void play() async {
    final String path = _playlist[currentSongIndex!].audioPath;
    print("Audio Path: $path");

    await _audioPlayer.stop(); // stop the current song
    // await _audioPlayer.play(AssetSource(path)); // play the new song
    await _audioPlayer.play(
      AssetSource('audio/wizkid.mp3'),
    ); // play the new song
    _isPlaying = true;
    notifyListeners();
  }

  // pause the song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = false;
    notifyListeners();
  }

  // pause or resume the song
  void pauseOrResume() async {
    if (isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next song
  void playNextSong() async {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        // go to the next song if it's not  the last
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        // if it's the last song, loop back to the first song
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPreviousSong() {
    // if more than 2 seconds has passed, restart the current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    }
    // if it's within first 2 second of the song, got to the previous song
    else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = currentSongIndex! - 1;
      } else {
        // if it's the first song, loop back to last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  // listen to duration
  void listenToDuration() {
    // listen for total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }

  // dispose audio player

  /* 
  
    G E T T E R S
    
  */

  List<Song> get playlist => _playlist;

  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /* 
  
    S E T T E R S

  */

  set currentSongIndex(int? newIndex) {
    // update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play(); // play the song at the new index
    }

    // update UI
    notifyListeners();
  }
}
