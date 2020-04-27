import 'package:test/test.dart';
import 'package:focus/service/language.dart';

void main() {
  test('Create language item', () {
    Lang i = Lang('key', 'value', mi: 'value mi');
    expect(i.key, 'key');
    expect(i.label, 'value');
    expect(i.mi, 'value mi');
  });

  test('Get language test value', () {
    Language l = Language(LANG_ENGLISH);
    expect(l.label('UTCode1'), 'Unit Test Code 1');
  });

  test('Get Maori', () {
    Language l = Language(LANG_MAORI);
    expect(l.label('UTCode1'), 'Unit Test Code 1 Maori');
    expect(l.label('UTCode2'), 'Unit Test Code 2');  // < came from english
  });
}
