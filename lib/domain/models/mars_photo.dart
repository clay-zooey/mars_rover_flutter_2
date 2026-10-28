class MarsPhoto {
  const MarsPhoto({
    required this.id,
    required this.imageUrl,
    this.fullResolutionUrl,
  });

  final String id;
  final String imageUrl;
  final String? fullResolutionUrl;
}

class PhotoPage {
  PhotoPage({required List<MarsPhoto> photos, required this.hasMore})
    : photos = List.unmodifiable(photos);

  final List<MarsPhoto> photos;
  final bool hasMore;
}
