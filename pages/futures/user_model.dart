class UserModel {
  final String token;
  final String username;
  final String profilePicture;
  final String password;
  final String email;  

  UserModel({
    required this.token,
    required this.username,
    required this.profilePicture,
    required this.password,
    required this.email,  
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['token'] ?? '',
      username: json['username'] ?? 'Unknown',
      profilePicture: json['profile_picture'] ?? 'default.png',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
