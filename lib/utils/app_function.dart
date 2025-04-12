class AppFunction {
  static String? converLinkYoutube(String? link) {
    if (link == null || link.isEmpty) return null;

    final regex = RegExp(
        r'^(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|shorts\/|.*[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})');
    final match = regex.firstMatch(link);
    return match?.group(1) ?? '';
  }
}
