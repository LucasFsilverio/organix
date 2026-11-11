import 'package:cloud_firestore/cloud_firestore.dart';

enum Prioridade { baixa, media, alta }

enum StatusEstudo { naoIniciado, emAndamento, concluido }

class StudyTask {
  final String materia;
  final String conteudo;
  final int tempoPrevisto;
  final Prioridade prioridade;
  final bool precisaRevisar;
  final StatusEstudo status;
  final String anotacoes;
  final DateTime criadoEm;

  StudyTask({
    required this.materia,
    required this.conteudo,
    required this.tempoPrevisto,
    required this.prioridade,
    required this.precisaRevisar,
    required this.criadoEm,
    this.status = StatusEstudo.naoIniciado,
    this.anotacoes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'materia': materia,
      'conteudo': conteudo,
      'tempoPrevisto': tempoPrevisto,
      'prioridade': prioridade.name,
      'precisaRevisar': precisaRevisar,
      'status': status.name,
      'anotacoes': anotacoes,
      'criadoEm': Timestamp.fromDate(criadoEm),
    };
  }
}