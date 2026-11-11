import 'package:flutter/material.dart';

class StudyCard extends StatelessWidget {
  final String materia;
  final String conteudo;
  final int tempoPrevisto;
  final String prioridade;
  final bool precisaRevisar;
  final String status;
  final VoidCallback onTap;

  const StudyCard({
    super.key,
    required this.materia,
    required this.conteudo,
    required this.tempoPrevisto,
    required this.prioridade,
    required this.precisaRevisar,
    required this.status,
    required this.onTap,
  });

  Color get _corPrioridade {
    switch (prioridade) {
      case 'alta':
        return Colors.red.shade400;
      case 'baixa':
        return Colors.green.shade400;
      default:
        return Colors.orange.shade400;
    }
  }

  String get _rotuloPrioridade {
    switch (prioridade) {
      case 'alta':
        return 'Alta';
      case 'baixa':
        return 'Baixa';
      default:
        return 'Média';
    }
  }

  String get _rotuloStatus {
    switch (status) {
      case 'emAndamento':
        return 'Em andamento';
      case 'concluido':
        return 'Concluído';
      default:
        return 'Não iniciado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 6,
              height: 80,
              decoration: BoxDecoration(
                color: _corPrioridade,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    materia,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conteudo,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      Text('$tempoPrevisto min'),
                      Text(
                        'Prioridade: $_rotuloPrioridade',
                        style: TextStyle(color: _corPrioridade),
                      ),
                      Text(
                        _rotuloStatus,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (precisaRevisar)
              const Icon(Icons.flag, color: Colors.indigo, size: 20),
          ],
        ),
      ),
    );
  }
}