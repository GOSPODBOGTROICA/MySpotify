import 'package:audioplayers/audioplayers.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class AudioService {
  final AudioPlayer _player1 = AudioPlayer();
  final AudioPlayer _player2 = AudioPlayer();
  final YoutubeExplode _yt = YoutubeExplode();
  
  bool _usePlayer1 = true;
  double _crossfadeDuration = 3.0;

  void setCrossfade(double seconds) {
    _crossfadeDuration = seconds;
  }

  Future<void> playTrack(String query) async {
    try {
      // 1. Search YouTube for high-quality audio
      var searchResults = await _yt.search.search(query);
      if (searchResults.isEmpty) return;
      var video = searchResults.first;

      // 2. Get audio stream manifest
      var manifest = await _yt.videos.streamsClient.getManifest(video.id);
      var audioInfo = manifest.audioOnly.withHighestBitrate();

      // 3. Play stream
      AudioPlayer activePlayer = _usePlayer1 ? _player1 : _player2;
      AudioPlayer fadingPlayer = _usePlayer1 ? _player2 : _player1;

      // Start new track at volume 0
      await activePlayer.setVolume(0.0);
      await activePlayer.play(UrlSource(audioInfo.url.toString()));

      // Crossfade logic
      for (int i = 0; i <= 10; i++) {
        await Future.delayed(Duration(milliseconds: (_crossfadeDuration * 100).toInt()));
        await activePlayer.setVolume(i / 10.0);
        await fadingPlayer.setVolume(1.0 - (i / 10.0));
      }
      
      await fadingPlayer.stop();
      _usePlayer1 = !_usePlayer1; // Swap active player
    } catch (e) {
      print('Playback error: $e');
    }
  }

  void dispose() {
    _player1.dispose();
    _player2.dispose();
    _yt.close();
  }
}
