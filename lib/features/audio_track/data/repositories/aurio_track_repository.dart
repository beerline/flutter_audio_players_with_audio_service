import 'package:audioplayersaudioservice/data/track_library.dart';
import 'package:audioplayersaudioservice/features/audio_track/data/model/audio_track_model.dart';
import 'package:audioplayersaudioservice/features/audio_track/domain/entities/audio_track.dart';
import 'package:audioplayersaudioservice/features/audio_track/domain/repositories/audio_track_repository_abstract.dart';

class AudioTrackRepository extends AudioTrackRepositoryAbstract {
  @override
  Future<AudioTrack> next({int currentTrackIndex}) async {
    final library = TrackLibrary.playList;

    final nextTrackIndex =
        currentTrackIndex == null ? 0 : currentTrackIndex + 1;

    if (nextTrackIndex >= library.length) {
      return null;
    }

    var nextTrack = TrackLibrary.playList[nextTrackIndex];

    return AudioTrackModel(
      nextTrack.url,
      nextTrack.author,
      nextTrack.title,
      nextTrackIndex,
    );
  }

  @override
  Future<AudioTrack> previous(int currentTrackIndex) async {
    final prevTrackIndex = currentTrackIndex - 1;

    if (prevTrackIndex < 0) {
      return null;
    }

    var prevTrack = TrackLibrary.playList[prevTrackIndex];

    return AudioTrackModel(
      prevTrack.url,
      prevTrack.author,
      prevTrack.title,
      prevTrackIndex,
    );
  }
}
