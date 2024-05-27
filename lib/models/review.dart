import 'dart:convert';

class Review {
  final int stars;
  final String comments;

  Review({
    required this.stars,
    required this.comments,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      stars: json['stars'] as int,
      comments: json['comments'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stars': stars,
      'comments': comments,
    };
  }
}
