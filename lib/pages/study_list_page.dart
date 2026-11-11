import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/study_card.dart';
import 'study_detail_page.dart';

class StudyListPage extends StatelessWidget {
  const StudyListPage({super.key});

  static const _corPrincipal = Color(0xFF3F51B5);

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text('Meus estudos'),
        centerTitle: true,
        backgroundColor: _corPrincipal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestore.ouvirEstudos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Erro ao carregar: ${snapshot.error}'),
              ),
            );
          }

          final documentos = snapshot.data?.docs ?? [];

          if (documentos.isEmpty) {
            return const Center(
              child: Text('Nenhum estudo cadastrado ainda.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: documentos.length,
            itemBuilder: (context, index) {
              final doc = documentos[index];
              final dados = doc.data();

              return StudyCard(
                materia: dados['materia'] ?? '',
                conteudo: dados['conteudo'] ?? '',
                tempoPrevisto: dados['tempoPrevisto'] ?? 0,
                prioridade: dados['prioridade'] ?? 'media',
                precisaRevisar: dados['precisaRevisar'] ?? false,
                status: dados['status'] ?? 'naoIniciado',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudyDetailPage(
                        id: doc.id,
                        dados: dados,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}