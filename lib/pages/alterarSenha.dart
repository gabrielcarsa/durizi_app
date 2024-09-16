import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Cliente.dart';
import '../providers/ClienteProvider.dart';
import 'home.dart';

class AlterarSenha extends StatefulWidget {
  const AlterarSenha({super.key});

  @override
  State<AlterarSenha> createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {
  final TextEditingController _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ClientesProvider>(
        builder: (context, clienteProvider, _) {
          if (clienteProvider.clienteAtual == null) {
            return const Home();
          } else {
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                foregroundColor: Theme.of(context).indicatorColor,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Text(
                  'Alteração de senha',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 1,
                child: Container(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            controller: _senhaController,
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              filled: true,
                              hintText: 'Digite sua nova senha',
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Preencha o campo';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ElevatedButton(
                            onPressed: () {
                              Cliente clienteId = clienteProvider.clienteAtual!;

                              // Se os campos forem válidos
                              if (_formKey.currentState!.validate()) {
                                // Salvando Senha no Firebase
                                Provider.of<ClientesProvider>(context,
                                        listen: false)
                                    .alterarSenha(clienteId, _senhaController.text);
                              }
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 5),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                            ),
                            child: Text(
                              'Salvar',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
