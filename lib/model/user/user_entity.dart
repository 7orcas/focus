


//ToDO Delete
class User {
  final int _id;
  final String _lang;

  User(this._id, this._lang);

  String get language => _lang;
  int get id => _id;

  operator ==(other) =>
      (other != null) && (other is User) && (_id == other._id);

  int get hashCode => _id.hashCode;
}