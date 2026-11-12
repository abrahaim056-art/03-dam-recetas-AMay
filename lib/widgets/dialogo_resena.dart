import 'package:flutter/material.dart';
import 'package:dam03_recetas_amay/services/resena_db.dart';

Future<void> mostrarDialogoResena(BuildContext context, int fraseId) async {
  final controller = TextEditingController();

  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Escribir reseña'),
      content: TextField(
        controller: controller,
        maxLines: 3,
        decoration: const InputDecoration(hintText: 'Escribe tu reseña...'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () async {
            final texto = controller.text.trim();
            if (texto.isEmpty) return;
            await ResenaDb.instance.insertar(Resena(
              fraseId: fraseId,
              texto: texto,
              fecha: DateTime.now().toIso8601String(),
            ));
            if (ctx.mounted) Navigator.pop(ctx);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reseña guardada')),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}