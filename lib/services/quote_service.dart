import 'dart:convert';
import 'package:http/http.dart' as http;

class Frase {
  final String texto;
  final String autor;

  const Frase({required this.texto, required this.autor});
}

class QuoteService {
  static const _url = 'https://dummyjson.com/quotes/random';

  static const _fallback = Frase(
    texto: 'Pequenos passos todos os dias levam longe.',
    autor: 'Organix',
  );

  Future<Frase> buscarFraseAleatoria() async {
    try {
      final resposta = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 5));

      if (resposta.statusCode != 200) return _fallback;

      final json = jsonDecode(resposta.body) as Map<String, dynamic>;
      return Frase(
        texto: json['quote'] as String,
        autor: json['author'] as String,
      );
    } catch (_) {
      return _fallback;
    }
  }
}