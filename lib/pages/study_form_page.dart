import 'package:flutter/material.dart';
import '../models/study_task.dart';
import '../services/firestore_service.dart';

class StudyFormPage extends StatefulWidget {
  final String nomeUsuario;

  const StudyFormPage({super.key, required this.nomeUsuario});

  @override
  State<StudyFormPage> createState() => _StudyFormPageState();
}

class _StudyFormPageState extends State<StudyFormPage> {
  static const _corPrincipal = Color(0xFF3F51B5);

  final _firestore = FirestoreService();

  final _materiaController = TextEditingController();
  final _conteudoController = TextEditingController();
  final _tempoController = TextEditingController();

  Prioridade _prioridade = Prioridade.media;
  bool _precisaRevisar = false;
  bool _salvando = false;

  @override
  void dispose() {
    _materiaController.dispose();
    _conteudoController.dispose();
    _tempoController.dispose();
    super.dispose();
  }

  String _rotuloPrioridade(Prioridade p) {
    switch (p) {
      case Prioridade.baixa:
        return 'Baixa';
      case Prioridade.media:
        return 'Média';
      case Prioridade.alta:
        return 'Alta';
    }
  }

  void _mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  void _limparFormulario() {
    _materiaController.clear();
    _conteudoController.clear();
    _tempoController.clear();
    setState(() {
      _prioridade = Prioridade.media;
      _precisaRevisar = false;
    });
  }

  Future<void> _salvar() async {
    final materia = _materiaController.text.trim();
    final conteudo = _conteudoController.text.trim();
    final tempo = int.tryParse(_tempoController.text.trim());

    if (materia.isEmpty || conteudo.isEmpty || tempo == null) {
      _mostrarMensagem('Preencha todos os campos. O tempo deve ser um número.');
      return;
    }

    setState(() => _salvando = true);

    try {
      await _firestore.adicionarEstudo(
        StudyTask(
          materia: materia,
          conteudo: conteudo,
          tempoPrevisto: tempo,
          prioridade: _prioridade,
          precisaRevisar: _precisaRevisar,
          criadoEm: DateTime.now(),
        ),
      );

      if (!mounted) return;
      _limparFormulario();
      _mostrarMensagem('Estudo salvo!');
    } catch (e) {
      if (!mounted) return;
      _mostrarMensagem('Erro ao salvar: $e');
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo estudo'),
        centerTitle: true,
        backgroundColor: _corPrincipal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, ${widget.nomeUsuario}! Cadastre um novo estudo.',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _materiaController,
              decoration: const InputDecoration(
                labelText: 'Nome da matéria',
                hintText: 'Ex.: Cálculo I',
                prefixIcon: Icon(Icons.book),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _conteudoController,
              decoration: const InputDecoration(
                labelText: 'Conteúdo para estudar',
                hintText: 'Ex.: Limites e derivadas',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _tempoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Tempo previsto (minutos)',
                hintText: 'Ex.: 90',
                prefixIcon: Icon(Icons.timer),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Prioridade',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            RadioGroup<Prioridade>(
              groupValue: _prioridade,
              onChanged: (valor) {
                if (valor != null) {
                  setState(() => _prioridade = valor);
                }
              },
              child: Column(
                children: [
                  for (final p in Prioridade.values)
                    RadioListTile<Prioridade>(
                      title: Text(_rotuloPrioridade(p)),
                      value: p,
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            CheckboxListTile(
              title: const Text('Precisa revisar?'),
              value: _precisaRevisar,
              contentPadding: EdgeInsets.zero,
              activeColor: _corPrincipal,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (valor) {
                setState(() => _precisaRevisar = valor ?? false);
              },
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _corPrincipal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _salvando ? null : _salvar,
                icon: _salvando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(_salvando ? 'Salvando...' : 'Salvar estudo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}