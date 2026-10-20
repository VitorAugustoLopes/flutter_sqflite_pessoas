import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../database/banco_pessoa.dart';
import '../services/session_service.dart';
import 'form_pessoa_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pessoa> _pessoas = [];
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    final email = await SessionService.getEmailUsuario();
    final lista = BancoPessoa.listarPessoas();
    setState(() {
      _userEmail = email;
      _pessoas = lista;
    });
  }

  void _excluirPessoa(Pessoa pessoa) async {
    await BancoPessoa.excluirPessoa(pessoa);
    _carregarDados();
  }

  void _logout() async {
    await SessionService.encerrarSessao();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _abrirFormulario() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FormPessoaScreen(),
      ),
    );
    if (result == true) {
      _carregarDados();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Pessoas'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Usuário Logado'),
              accountEmail: Text(_userEmail),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Cadastrar Pessoa'),
              onTap: () {
                Navigator.pop(context);
                _abrirFormulario();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Sair', style: TextStyle(color: Colors.red)),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: _pessoas.isEmpty
          ? const Center(child: Text('Nenhuma pessoa cadastrada.'))
          : ListView.builder(
              itemCount: _pessoas.length,
              itemBuilder: (context, index) {
                final pessoa = _pessoas[index];
                return Dismissible(
                  key: Key(pessoa.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _excluirPessoa(pessoa);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${pessoa.nome} foi removido(a)')),
                    );
                  },
                  child: ListTile(
                    title: Text(pessoa.nome),
                    subtitle: Text('${pessoa.email} - Idade: ${pessoa.idade} - Tel: ${pessoa.telefone}'),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormPessoaScreen(pessoa: pessoa),
                        ),
                      );
                      if (result == true) {
                        _carregarDados();
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormulario,
        child: const Icon(Icons.add),
      ),
    );
  }
}