class TrackLibrary {
  static final playList = {
    0: Track(
      'https://it-dk.com/media-demo/demo-1.mp3',
      'First Author',
      'Title 1',
    ),
    1: Track(
      'https://it-dk.com/media-demo/demo-2.mp3',
      'Second Author',
      'Title 2',
    ),
    2: Track(
      'https://it-dk.com/media-demo/demo-1.mp3',
      'Third Author',
      'Title 3',
    ),
  };
}

class Track {
  final String url;
  final String author;
  final String title;

  Track(this.url, this.author, this.title);
}
