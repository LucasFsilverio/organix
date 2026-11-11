import 'dart:convert';
import 'package:http/http.dart' as http;

class Frase {
  final String texto;
  final String autor;

  const Frase({required this.texto, required this.autor});
}

class QuoteService {
  static const _urlFrase = 'https://dummyjson.com/quotes/random';
  static const _urlTraducao = 'https://api.mymemory.translated.net/get';

  static const _fallback = Frase(
    texto: 'Pequenos passos todos os dias levam longe.',
    autor: 'Organix',
  );

  Future<Frase> buscarFraseAleatoria() async {
    try {
      final resposta = await http
          .get(Uri.parse(_urlFrase))
          .timeout(const Duration(seconds: 5));

      if (resposta.statusCode != 200) return _fallback;

      final json = jsonDecode(resposta.body) as Map<String, dynamic>;
      final textoIngles = json['quote'] as String;
      final autor = json['author'] as String;

      final textoPortugues = await _traduzir(textoIngles);

      return Frase(texto: textoPortugues, autor: autor);
    } catch (_) {
      return _fallback;
    }
  }

  // Traduz do inglês para o português. Se falhar, devolve o texto original.
  Future<String> _traduzir(String texto) async {
    try {
      final uri = Uri.parse(_urlTraducao).replace(
        queryParameters: {
          'q': texto,
          'langpair': 'en|pt-br',
        },
      );

      final resposta = await http.get(uri).timeout(const Duration(seconds: 5));
      if (resposta.statusCode != 200) return texto;

      final json = jsonDecode(resposta.body) as Map<String, dynamic>;
      final traducao = json['responseData']['translatedText'] as String?;

      return (traducao == null || traducao.isEmpty) ? texto : traducao;
    } catch (_) {
      return texto;
    }
  }
}