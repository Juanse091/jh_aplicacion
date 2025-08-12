import 'package:flutter/material.dart';

class PersonaCard extends StatelessWidget {
  final String tipoDocumento;
  final String numeroDocumento;
  final String? fechaExpedicionDocumento;
  final String primerNombre;
  final String? segundoNombre;
  final String? primerApellido;
  final String? segundoApellido;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PersonaCard({
    super.key,
    required this.tipoDocumento,
    required this.numeroDocumento,
    this.fechaExpedicionDocumento,
    required this.primerNombre,
    this.segundoNombre,
    this.primerApellido,
    this.segundoApellido,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(
          _buildNombreCompleto(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade800,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '$tipoDocumento • $numeroDocumento',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        trailing: SizedBox(
          width: 96,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.orange.shade700,
                tooltip: 'Editar',
                onPressed: onEdit,
                splashRadius: 20,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Colors.red.shade600,
                tooltip: 'Eliminar',
                onPressed: onDelete,
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildNombreCompleto() {
    final nombres = [
      primerNombre,
      if (segundoNombre != null) segundoNombre!,
      if (primerApellido != null) primerApellido!,
      if (segundoApellido != null) segundoApellido!,
    ];
    return nombres.join(' ');
  }
}
