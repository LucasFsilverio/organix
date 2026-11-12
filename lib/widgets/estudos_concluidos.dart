import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/study_detail_page.dart';
import '../services/firestore_service.dart';

class EstudosConcluidos extends StatelessWidget {
  const EstudosConcluidos({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirestoreService();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: firestore.ouvirEstudos(),
      builder: (context, snapshot) {
        final concluidos = (snapshot.data?.docs ?? [])
            .where((d) => d.data()['status'] == 'concluido')
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'Concluídos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.green.shade500,
                  child: Text(
                    '${concluidos.length}',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (concluidos.isEmpty)
              const Text(
                'Nenhum estudo concluído ainda.',
                style: TextStyle(color: Colors.black54),
              )
            else
              ...concluidos.map((doc) {
                final dados = doc.data();
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.check_circle,
                        color: Colors.green.shade500),
                    title: Text(dados['materia'] ?? ''),
                    subtitle: Text(dados['conteudo'] ?? ''),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              StudyDetailPage(id: doc.id, dados: dados),
                        ),
                      );
                    },
                  ),
                );
              }),
          ],
        );
      },
    );
  }
}