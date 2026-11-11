import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/study_task.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _estudos =
      FirebaseFirestore.instance.collection('estudos');

  Future<void> adicionarEstudo(StudyTask estudo) async {
    await _estudos.add(estudo.toMap());
  }

  // Atualiza só os campos informados, sem apagar o restante do documento.
  Future<void> atualizarEstudo(
    String id,
    Map<String, dynamic> campos,
  ) async {
    await _estudos.doc(id).update(campos);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> ouvirEstudos() {
    return _estudos.orderBy('criadoEm', descending: true).snapshots();
  }
}