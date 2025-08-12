// lib/features/personas/personas_list_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/persona_card.dart';
import 'personas_provider.dart';
import 'package:go_router/go_router.dart';

class PersonasListScreen extends ConsumerStatefulWidget {
  const PersonasListScreen({super.key});

  @override
  ConsumerState<PersonasListScreen> createState() => _PersonasListScreenState();
}

class _PersonasListScreenState extends ConsumerState<PersonasListScreen> {
  int page = 1;
  int itemsPerPage = 5; // puedes cambiarlo o hacerlo configurable

  @override
  Widget build(BuildContext context) {
    final personasAsync = ref.watch(personasFullProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personas'),
        actions: [
          IconButton(
            tooltip: 'Refrescar',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(personasFullProvider),
          ),
        ],
      ),
      body: personasAsync.when(
        data: (personas) {
          if (personas.isEmpty) {
            return const Center(child: Text('No hay personas aún'));
          }

          final totalItems = personas.length;
          final totalPages = (totalItems / itemsPerPage).ceil();
          final currentPage =
              math.min(math.max(1, page), math.max(1, totalPages));
          final startIndex = (currentPage - 1) * itemsPerPage;
          final endIndex = math.min(startIndex + itemsPerPage, totalItems);
          final pageItems = personas.sublist(startIndex, endIndex);

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: $totalItems'),
                    Row(
                      children: [
                        const Text('Por página: '),
                        DropdownButton<int>(
                          value: itemsPerPage,
                          items: [5, 10, 15, 25]
                              .map((e) =>
                                  DropdownMenuItem(value: e, child: Text('$e')))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() {
                                itemsPerPage = v;
                                page = 1;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: pageItems.length,
                  itemBuilder: (context, index) {
                    final p = pageItems[index];
                    return PersonaCard(
                      tipoDocumento: (p['tipoDocumento'] ?? '').toString(),
                      numeroDocumento: (p['numeroDocumento'] ?? '').toString(),
                      fechaExpedicionDocumento:
                          p['fechaExpedicionDocumento']?.toString(),
                      primerNombre: (p['primerNombre'] ?? '').toString(),
                      segundoNombre: p['segundoNombre']?.toString(),
                      primerApellido: p['primerApellido']?.toString(),
                      segundoApellido: p['segundoApellido']?.toString(),
                      onEdit: () {
                        context.push('/personas/editar/${p['tipoDocumento']}/${p['numeroDocumento']}');
                      },
                      onDelete: () {
                        ref.read(deletePersonasProvider({
                          'tipoDoc': p['tipoDocumento'],
                          'doc': p['numeroDocumento'],
                        }));
                      },
                    );
                  },
                ),
              ),

              // Paginador
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: currentPage > 1
                          ? () => setState(() => page = currentPage - 1)
                          : null,
                      child: const Text('Anterior'),
                    ),
                    const SizedBox(width: 12),
                    Text('Página $currentPage de $totalPages'),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: currentPage < totalPages
                          ? () => setState(() => page = currentPage + 1)
                          : null,
                      child: const Text('Siguiente'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/personas/nuevo'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
