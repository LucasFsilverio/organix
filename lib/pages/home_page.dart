import 'package:flutter/material.dart';
import '../widgets/frase_motivacional.dart';
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
            _cardResumo(),
            const SizedBox(height: 28),
            const Text(
              'Destaques',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _imagem(
                    url: 'https://picsum.photos/seed/organix-estudo/400/300',
                    ajuste: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _imagem(
                    url: 'https://picsum.photos/seed/organix-foco/400/300',
                    ajuste: BoxFit.cover,
                  ),
                ),
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

  Widget _cardResumo() {
    return Container(
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
          _estatistica(icone: Icons.menu_book, valor: '0', rotulo: 'Estudos'),
          _estatistica(icone: Icons.flag, valor: '0', rotulo: 'Para revisar'),
          _estatistica(icone: Icons.timer, valor: '0 min', rotulo: 'Previstos'),
        ],
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

  Widget _imagem({required String url, required BoxFit ajuste}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 130,
        child: Image.network(
          url,
          fit: ajuste,
          errorBuilder: (context, error, stack) => Container(
            color: _corSuave.withAlpha(60),
            child: const Center(
              child: Icon(Icons.image_not_supported, color: _corPrincipal),
            ),
          ),
        ),
      ),
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