import 'package:audioplayersaudioservice/features/audio_track/domain/entities/audio_track.dart';
import 'package:audioplayersaudioservice/features/audio_track/domain/repositories/audio_track_repository_abstract.dart';

class GetAudioTrackUseCase{
  final AudioTrackRepositoryAbstract repository;

  GetAudioTrackUseCase(this.repository);

  Future<AudioTrack> next({int currentTrackIndex}) {
    return repository.next(currentTrackIndex: currentTrackIndex);
  }

  Future<AudioTrack> previous(int currentTrackIndex) {
    return repository.previous(currentTrackIndex);
  }
}
