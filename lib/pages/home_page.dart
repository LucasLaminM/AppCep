import 'package:app_cep/models/endereco_model.dart';
import 'package:app_cep/repositories/cep_repository.dart';
import 'package:app_cep/repositories/cep_repository_impl.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  // const HomePage({ super.key });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('Buscar CEP'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      hintText: 'Digite um CEP',
                    ),
                    controller: cepEC,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'CEP Obrigatório';
                      }
                      return null;
                    }),
                ElevatedButton(
                  onPressed: () async {
                    final valid = formKey.currentState?.validate() ?? false;
                    if (valid) {
                      try {
                        setState(() {
                          loading = true;
                        });
                        final endereco = await cepRepository.getCep(cepEC.text);
                        setState(() {
                          loading = false;
                          enderecoModel = endereco;
                        });
                      } catch (e) {
                        setState(() {
                          loading = false;
                          enderecoModel = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Erro ao buscar Endereço')),
                        );
                      }
                    }
                  },
                  child: Text('Buscar'),
                ),
                Visibility(
                  visible: loading,
                  child: const CircularProgressIndicator(),
                ),
                Visibility(
                    visible: enderecoModel != null,
                    child: Text(
                        '${enderecoModel?.logradouro} ${enderecoModel?.complemento} - CEP ${enderecoModel?.cep}')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
