import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class StudyDetailPage extends StatefulWidget {
  final String id;
  final Map<String, dynamic> dados;

  const StudyDetailPage({super.key, required this.id, required this.dados});

  @override
  State<StudyDetailPage> createState() => _StudyDetailPageState();
}

class _StudyDetailPageState extends State<StudyDetailPage> {
  static const _corPrincipal = Color(0xFF3F51B5);

  final _firestore = FirestoreService();
  late final TextEditingController _anotacoesController;
  late String _status;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _anotacoesController = TextEditingController(
      text: widget.dados['anotacoes'] ?? '',
    );
    _status = widget.dados['status'] ?? 'naoIniciado';
  }

  @override
  void dispose() {
    _anotacoesController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    setState(() => _salvando = true);
    try {
      await _firestore.atualizarEstudo(widget.id, {
        'anotacoes': _anotacoesController.text,
        'status': _status,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alterações salvas!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final materia = widget.dados['materia'] ?? '';
    final conteudo = widget.dados['conteudo'] ?? '';
    final tempo = widget.dados['tempoPrevisto'] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: Text(materia),
        centerTitle: true,
        backgroundColor: _corPrincipal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(conteudo, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    'Tempo previsto: $tempo min',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'naoIniciado', child: Text('Não iniciado')),
                DropdownMenuItem(value: 'emAndamento', child: Text('Em andamento')),
                DropdownMenuItem(value: 'concluido', child: Text('Concluído')),
              ],
              onChanged: (valor) {
                if (valor != null) setState(() => _status = valor);
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'Anotações',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _anotacoesController,
              maxLines: 12,
              decoration: const InputDecoration(
                hintText: 'Escreva suas anotações sobre este estudo...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
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
                icon: const Icon(Icons.save),
                label: Text(_salvando ? 'Salvando...' : 'Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}