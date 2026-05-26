class ToiletPhoto {

  final String id;

  final String photoUrl;

  ToiletPhoto({

    required this.id,

    required this.photoUrl,
  });

  factory ToiletPhoto.fromJson(
    Map<String, dynamic> json,
  ) {

    return ToiletPhoto(

      id: json['id'],

      photoUrl: json['photoUrl'],
    );
  }
}