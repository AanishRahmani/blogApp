int calculateReadingTime(String content) {
  // Calculate word count
  final wordCount =
      content.trim().isEmpty ? 0 : content.split(RegExp(r'\s+')).length;

  const wordsPerMinute = 225;

  final readingTime = wordCount / wordsPerMinute;

  return wordCount == 0 ? 1 : readingTime.ceil();
}
