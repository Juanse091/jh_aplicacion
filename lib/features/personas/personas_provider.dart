import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jh_aplicacion/main.dart';

final personasFullProvider = FutureProvider<List<dynamic>>((ref) async {
  final token = ref.read(authTokenProvider);

  final res = await http.get(
    Uri.parse('http://3.142.35.195:5000/clinica/api/medico'),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (res.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(res.body));
  }
  throw Exception('Error al cargar personas');
});

final createPersonasProvider =
    FutureProvider.family<bool, Map<String, dynamic>>(
        (ref, nuevaPersona) async {
  final token = ref.watch(authTokenProvider);
  final res = await http.post(
    Uri.parse('http://3.142.35.195:5000/clinica/api/medico'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(nuevaPersona),
  );

  print('Respuesta del servidor: ${res.statusCode} - ${res.body}');

  return res.statusCode == 200;
});

final deletePersonasProvider =
    FutureProvider.family<bool, Map<String, String>>((ref, params) async {
  final token = ref.watch(authTokenProvider);

  print(params);

  final tipoDoc = params['tipoDoc']!;
  final doc = params['doc']!;

  final res = await http.delete(
    Uri.parse('http://3.142.35.195:5000/clinica/api/medico'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'tipoDocumento': tipoDoc,
      'numeroDocumento': doc,
    }),
  );

  print(res.body);

  return res.statusCode == 200;
});

final getPersonaByIdProvider =
    FutureProvider.family<Map<String, dynamic>?, Map<String, String>>(
        (ref, params) async {
  final token = ref.watch(authTokenProvider);

  final tipoDocumento = params['tipoDocumento'];
  final numeroDocumento = params['numeroDocumento'];

  if (tipoDocumento == null || numeroDocumento == null) {
    throw Exception(
        'Parámetros tipoDocumento y numeroDocumento son obligatorios');
  }

  final res = await http.get(
    Uri.parse(
        'http://3.142.35.195:5000/clinica/api/medico/$tipoDocumento/$numeroDocumento'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (res.statusCode == 200) {
    return jsonDecode(res.body) as Map<String, dynamic>;
  } else {
    print('Error al obtener persona: ${res.body}');
    return null;
  }
});

final updatePersonasProvider =
    FutureProvider.family<bool, Map<String, dynamic>>((ref, personaData) async {
  final token = ref.watch(authTokenProvider);

  final tipoDocumento = personaData['tipoDocumento'];
  final numeroDocumento = personaData['numeroDocumento'];

  final res = await http.put(
    Uri.parse(
        'http://3.142.35.195:5000/clinica/api/medico/$tipoDocumento/$numeroDocumento'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(personaData),
  );

  if (res.statusCode == 200) {
    return true;
  } else {
    print('Error al actualizar persona: ${res.body}');
    return false;
  }
});
