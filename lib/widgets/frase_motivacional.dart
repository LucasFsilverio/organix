import 'package:flutter/material.dart';
import '../services/quote_service.dart';

class FraseMotivacional extends StatefulWidget {
  const FraseMotivacional({super.key});

  @override
  State<FraseMotivacional> createState() => _FraseMotivacionalState();
}

class _FraseMotivacionalState extends State<FraseMotivacional> {
  late final Future<Frase> _future;

  @override
  void initState() {
    super.initState();
    _future = QuoteService().buscarFraseAleatoria();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF7986CB).withAlpha(35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: FutureBuilder<Frase>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final frase = snapshot.data!;

          return Column(
            children: [
              const Icon(Icons.format_quote, color: Color(0xFF3F51B5)),
              const SizedBox(height: 8),
              Text(
                '"${frase.texto}"',
                textAlign: TextAlign.center,
                style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Text(
                '— ${frase.autor}',
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          );
        },
      ),
    );
  }
}