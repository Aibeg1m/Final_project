
class NewsArticle{
  final String title;
  final String image;
  final String url;

  NewsArticle({
    required this.title,
    required this.image,
    required this.url,
});

  factory NewsArticle.fromJson(Map<String,dynamic> json){
    return NewsArticle(
        title: json["title"]?? "",
        image: json["urlToImage"]?? "",
        url: json["url"]??"",
    );
  }
}