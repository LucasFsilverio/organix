import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/destaque_imagem.dart';
import '../widgets/estudos_concluidos.dart';
import '../widgets/frase_motivacional.dart';
import 'study_detail_page.dart';
import 'study_form_page.dart';
import 'study_list_page.dart';

class HomePage extends StatelessWidget {
  final String nomeUsuario;

  const HomePage({super.key, this.nomeUsuario = 'Estudante'});

  static const _corPrincipal = Color(0xFF3F51B5);
  static const _corSuave = Color(0xFF7986CB);
  static const _corFundo = Color(0xFFF4F6FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _corFundo,
      appBar: AppBar(
        title: const Text(
          'Organix',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        centerTitle: true,
        backgroundColor: _corPrincipal,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cabecalho(),
            const SizedBox(height: 20),
            _secaoEstudos(context),
            const EstudosConcluidos(),
            const SizedBox(height: 28),
            const Text(
              'Destaques',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: DestaqueImagem()),
                SizedBox(width: 12),
                Expanded(child: DestaqueImagem()),
              ],
            ),
            const SizedBox(height: 28),
            _botoes(context),
            const SizedBox(height: 24),
            const FraseMotivacional(),
          ],
        ),
      ),
    );
  }

  Widget _cabecalho() {
    return Container(
      height: 170,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_corPrincipal, _corSuave],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D3F51B5),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 0,
            right: 0,
            child: Icon(Icons.auto_awesome, color: Colors.white70, size: 28),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Olá, $nomeUsuario',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Vamos organizar seus estudos hoje?',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _secaoEstudos(BuildContext context) {
    final firestore = FirestoreService();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firestore.ouvirEstudos(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Erro ao carregar os estudos: ${snapshot.error}',
              style: TextStyle(color: Colors.red.shade900),
            ),
          );
        }

        final carregando = snapshot.connectionState == ConnectionState.waiting;
        final docs = snapshot.data?.docs ?? [];

        final total = docs.length;
        final paraRevisar =
            docs.where((d) => d.data()['precisaRevisar'] == true).length;
        final minutos = docs.fold<int>(
          0,
          (soma, d) =>
              soma + ((d.data()['tempoPrevisto'] as num?)?.toInt() ?? 0),
        );
        final pendentes = docs
            .where((d) => d.data()['status'] != 'concluido')
            .take(3)
            .toList();

        final tempoFormatado = minutos >= 60
            ? '${minutos ~/ 60}h ${minutos % 60}min'
            : '$minutos min';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _estatistica(
                    icone: Icons.menu_book,
                    valor: carregando ? '...' : '$total',
                    rotulo: 'Estudos',
                  ),
                  _estatistica(
                    icone: Icons.flag,
                    valor: carregando ? '...' : '$paraRevisar',
                    rotulo: 'Para revisar',
                  ),
                  _estatistica(
                    icone: Icons.timer,
                    valor: carregando ? '...' : tempoFormatado,
                    rotulo: 'Previstos',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Próximos estudos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (!carregando && pendentes.isEmpty)
              const Text(
                'Nenhum estudo pendente. Cadastre um para começar!',
                style: TextStyle(color: Colors.black54),
              ),
            ...pendentes.map(
              (doc) => _itemProximo(context, doc.id, doc.data()),
            ),
          ],
        );
      },
    );
  }

  Widget _itemProximo(
    BuildContext context,
    String id,
    Map<String, dynamic> dados,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: const Icon(Icons.menu_book, color: _corPrincipal),
        title: Text(dados['materia'] ?? ''),
        subtitle: Text(dados['conteudo'] ?? ''),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudyDetailPage(id: id, dados: dados),
            ),
          );
        },
      ),
    );
  }

  Widget _estatistica({
    required IconData icone,
    required String valor,
    required String rotulo,
  }) {
    return Column(
      children: [
        Icon(icone, color: _corPrincipal),
        const SizedBox(height: 6),
        Text(
          valor,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          rotulo,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _botoes(BuildContext context) {
    return Column(
      children: [
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StudyFormPage(nomeUsuario: nomeUsuario),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Adicionar estudo'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: _corPrincipal,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: _corPrincipal),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StudyListPage(),
                ),
              );
            },
            icon: const Icon(Icons.list),
            label: const Text('Ver meus estudos'),
          ),
        ),
      ],
    );
  }
}