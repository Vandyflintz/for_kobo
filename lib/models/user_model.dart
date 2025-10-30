class UserModel {
  final int id;
  final String firstname;
  final String lastname;
  final String emailAddress;
  final String displayProfile;

  UserModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.emailAddress,
    required this.displayProfile,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      emailAddress: map['email_address'] ?? '',
      displayProfile: map['display_profile'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email_address': emailAddress,
      'display_profile': displayProfile,
    };
  }
}
