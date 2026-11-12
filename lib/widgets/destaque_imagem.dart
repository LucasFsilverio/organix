import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DestaqueImagem extends StatefulWidget {
  const DestaqueImagem({super.key});

  @override
  State<DestaqueImagem> createState() => _DestaqueImagemState();
}

class _DestaqueImagemState extends State<DestaqueImagem> {
  static const _corPrincipal = Color(0xFF3F51B5);
  static const _corSuave = Color(0xFF7986CB);

  Uint8List? _bytes;

  Future<void> _escolherImagem() async {
    final arquivo = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
    );
    if (arquivo == null) return;

    final bytes = await arquivo.readAsBytes();
    if (!mounted) return;
    setState(() => _bytes = bytes);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _escolherImagem,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 130,
          child: _bytes == null
              ? Container(
                  color: _corSuave.withAlpha(60),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        color: _corPrincipal,
                        size: 32,
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Escolher imagem',
                        style: TextStyle(color: _corPrincipal),
                      ),
                    ],
                  ),
                )
              : Image.memory(_bytes!, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
