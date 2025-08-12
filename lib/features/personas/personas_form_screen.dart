import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_text_field.dart';
import 'personas_provider.dart';

class PersonasFormScreen extends ConsumerStatefulWidget {
  final String? tipoDocumento;
  final String? numeroDocumento;

  const PersonasFormScreen({
    super.key,
    this.tipoDocumento,
    this.numeroDocumento,
  });

  @override
  ConsumerState<PersonasFormScreen> createState() => _PersonasFormScreenState();
}

class _PersonasFormScreenState extends ConsumerState<PersonasFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String tipoDocumento = '';

  late TextEditingController numeroDocumentoController;
  late TextEditingController fechaExpedicionDocumentoController;
  late TextEditingController primerNombreController;
  late TextEditingController segundoNombreController;
  late TextEditingController primerApellidoController;
  late TextEditingController segundoApellidoController;

  bool get isEdit =>
      widget.tipoDocumento != null && widget.numeroDocumento != null;

  @override
  void initState() {
    super.initState();

    numeroDocumentoController = TextEditingController();
    fechaExpedicionDocumentoController = TextEditingController();
    primerNombreController = TextEditingController();
    segundoNombreController = TextEditingController();
    primerApellidoController = TextEditingController();
    segundoApellidoController = TextEditingController();

    if (isEdit) {
      tipoDocumento = widget.tipoDocumento!; // para el dropdown
      _loadData();
    }
  }

  @override
  void dispose() {
    numeroDocumentoController.dispose();
    fechaExpedicionDocumentoController.dispose();
    primerNombreController.dispose();
    segundoNombreController.dispose();
    primerApellidoController.dispose();
    segundoApellidoController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final persona = await ref.read(getPersonaByIdProvider({
      'tipoDocumento': widget.tipoDocumento!,
      'numeroDocumento': widget.numeroDocumento!,
    }).future);

    if (persona != null) {
      setState(() {
        tipoDocumento = persona['tipoDocumento'] ?? tipoDocumento;
        numeroDocumentoController.text = persona['numeroDocumento'] ?? '';
        fechaExpedicionDocumentoController.text =
            persona['fechaExpedicionDocumento'] ?? '';
        primerNombreController.text = persona['primerNombre'] ?? '';
        segundoNombreController.text = persona['segundoNombre'] ?? '';
        primerApellidoController.text = persona['primerApellido'] ?? '';
        segundoApellidoController.text = persona['segundoApellido'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    late String? fechaExpedicionDocumento;
    late String? primerNombre;
    late String? segundoNombre;
    late String? primerApellido;
    late String? segundoApellido;
    late String? numeroDocumento;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(isEdit ? 'Editar Persona' : 'Crear Persona'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/personas'),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Icon(isEdit ? Icons.edit : Icons.person_add,
                      size: 80, color: Colors.blueAccent),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Documento',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                    value: tipoDocumento.isNotEmpty ? tipoDocumento : null,
                    items: const [
                      DropdownMenuItem(
                          value: 'CC',
                          child: Text('Cédula de ciudadanía (CC)')),
                      DropdownMenuItem(
                          value: 'TI',
                          child: Text('Tarjeta de identidad (TI)')),
                      DropdownMenuItem(
                          value: 'CE',
                          child: Text('Cédula de extranjería (CE)')),
                      DropdownMenuItem(
                          value: 'PA', child: Text('Pasaporte (PA)')),
                    ],
                    onChanged: isEdit
                        ? null // readonly en edición
                        : (val) => setState(() {
                              tipoDocumento = val ?? '';
                            }),
                    onSaved: (val) => tipoDocumento = val ?? '',
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Campo requerido' : null,
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Número de Documento',
                    icon: Icons.numbers,
                    controller: numeroDocumentoController,
                    readOnly: isEdit,
                    onSaved: (val) => numeroDocumento = val ?? '',
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Fecha Expedición (opcional)',
                    icon: Icons.date_range,
                    isOptional: true,
                    controller: fechaExpedicionDocumentoController,
                    onSaved: (val) => fechaExpedicionDocumento = val,
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Primer Nombre',
                    icon: Icons.person,
                    controller: primerNombreController,
                    onSaved: (val) => primerNombre = val ?? '',
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Segundo Nombre (opcional)',
                    icon: Icons.person_outline,
                    isOptional: true,
                    controller: segundoNombreController,
                    onSaved: (val) => segundoNombre = val,
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Primer Apellido (opcional)',
                    icon: Icons.family_restroom,
                    isOptional: true,
                    controller: primerApellidoController,
                    onSaved: (val) => primerApellido = val,
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Segundo Apellido (opcional)',
                    icon: Icons.family_restroom_outlined,
                    isOptional: true,
                    controller: segundoApellidoController,
                    onSaved: (val) => segundoApellido = val,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          final personaData = {
                            "tipoDocumento": tipoDocumento,
                            "numeroDocumento": numeroDocumento,
                            "fechaExpedicionDocumento":
                                fechaExpedicionDocumento,
                            "primerNombre": primerNombre,
                            "segundoNombre": segundoNombre,
                            "primerApellido": primerApellido,
                            "segundoApellido": segundoApellido
                          };

                          bool ok;
                          if (isEdit) {
                            ok = await ref.read(
                                updatePersonasProvider(personaData).future);
                          } else {
                            ok = await ref.read(
                                createPersonasProvider(personaData).future);
                          }

                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isEdit
                                    ? 'Persona actualizada con éxito'
                                    : 'Persona creada con éxito'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            context.go('/personas');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isEdit
                                    ? 'Error al actualizar persona'
                                    : 'Error al crear persona'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      label: Text(isEdit ? 'Actualizar' : 'Guardar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
