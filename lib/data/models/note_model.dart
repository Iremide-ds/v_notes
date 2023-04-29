class Note {
  final int id;
  final String? audioPath;
  final bool isAudio;
  final String title;
  final String content;

  Note(
      {required this.id,
      this.audioPath,
      required this.isAudio,
      this.title = 'No Title',
      required this.content});

  Map<String, dynamic> toMap() {
    // id is auto incremented in db
    return {
      'id': id,
      'audio_path': audioPath,
      'is_audio': isAudio.toString(),
      'title': title,
      'content': content
    };
  }
}
