import 'package:hive_flutter/hive_flutter.dart';
import '../models/pessoa.dart';

class BancoPessoa {
  static const String _boxName = 'pessoasBox';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox(_boxName);
  }

  static Box _getBox() {
    return Hive.box(_boxName);
  }

  static Future<void> inserirPessoa(Pessoa pessoa) async {
    final box = _getBox();
    await box.put(pessoa.id, pessoa.toMap());
  }

  static List<Pessoa> listarPessoas() {
    final box = _getBox();
    final List<Pessoa> lista = [];
    for (var value in box.values) {
      if (value is Map) {
        lista.add(Pessoa.fromMap(Map<String, dynamic>.from(value)));
      }
    }
    return lista;
  }

  static Future<void> atualizarPessoa(Pessoa pessoa) async {
    final box = _getBox();
    await box.put(pessoa.id, pessoa.toMap());
  }

  static Future<void> excluirPessoa(Pessoa pessoa) async {
    final box = _getBox();
    await box.delete(pessoa.id);
  }
}