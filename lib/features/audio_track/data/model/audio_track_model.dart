import 'package:audioplayersaudioservice/features/audio_track/domain/entities/audio_track.dart';

class AudioTrackModel extends AudioTrack {
  AudioTrackModel(String url, String author, String title, int currentTrackIndex)
      : super(url, author, title, currentTrackIndex);
}
