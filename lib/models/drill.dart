


/// Represents a tourism location a user can visit.
class Drill  {
  final int id;
  final String title;
  final String description;
  final String imgUrl;
  final List<dynamic> tags;
  final String videoUrl;
  final String thumbimage;

  const Drill({
    this.id,
    this.title,
    this.description,
    this.imgUrl,
    this.tags,
    this.thumbimage,
    this.videoUrl
  });

  factory Drill.fromJson(Map<String, dynamic> json) {
    if (json == null)
      return new Drill();

    return Drill(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imgUrl: json['imgUrl'],
      tags: json['tags'],
      thumbimage: json['thumbimage'],
      videoUrl: json['videoUrl'],
    );
  }
  Map<String, dynamic>toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "imgUrl": imgUrl,
      "tags": tags,
      "thumbimage": thumbimage,
      "videoUrl": videoUrl,
    };
  }


}
