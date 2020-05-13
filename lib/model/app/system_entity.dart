
class SystemEntity {
  final int _id;
  final String _publicKey;
  int _version;

  SystemEntity(this._id, this._version, this._publicKey);

  int get version => _version;
  void set version (v) => _version = v;

}
