import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../database/banco_pessoa.dart';

class FormPessoaScreen extends StatefulWidget {
  final Pessoa? pessoa;

  const FormPessoaScreen({super.key, this.pessoa});

  @override
  State<FormPessoaScreen> createState() => _FormPessoaScreenState();
}

class _FormPessoaScreenState extends State<FormPessoaScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _idadeController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pessoa != null) {
      _nomeController.text = widget.pessoa!.nome;
      _emailController.text = widget.pessoa!.email;
      _idadeController.text = widget.pessoa!.idade.toString();
      _telefoneController.text = widget.pessoa!.telefone;
    }
  }

  void _salvar() async {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final idade = int.tryParse(_idadeController.text) ?? 0;
    final telefone = _telefoneController.text;

    if (nome.isNotEmpty && email.isNotEmpty) {
      if (widget.pessoa == null) {
        final novaPessoa = Pessoa(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nome: nome,
          email: email,
          idade: idade,
          telefone: telefone,
        );
        await BancoPessoa.inserirPessoa(novaPessoa);
      } else {
        final pessoaEditada = Pessoa(
          id: widget.pessoa!.id,
          nome: nome,
          email: email,
          idade: idade,
          telefone: telefone,
        );
        await BancoPessoa.atualizarPessoa(pessoaEditada);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pessoa == null ? 'Nova Pessoa' : 'Editar Pessoa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
              TextField(
                controller: _idadeController,
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}