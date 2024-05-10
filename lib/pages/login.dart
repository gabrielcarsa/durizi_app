import 'dart:async';

import 'package:durizi_app/pages/home.dart';
import 'package:durizi_app/pages/simulacaoInvestimento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/ClienteProvider.dart';
import '../providers/TipoTemaProvider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Para formatar em número
  final NumberFormat formatadorMoeda =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  //controller dos campos do form
  final TextEditingController _cpfController = TextEditingController();

  //form
  final _formKey = GlobalKey<FormState>();

  // Adicione uma variável de estado booleana para controlar o estado de carregamento
  bool _isLoadingLogin = false;

  //Variaveis de erro
  String msgError = '';

  //Função para validar login
  void login() async {
    final clienteProvider =
        Provider.of<ClientesProvider>(context, listen: false);

    if (_cpfController.text.isNotEmpty) {
      try {
        clienteProvider.consultarCPFExistente(_cpfController.text).then((e) {
          setState(() {
            if (e == null) {
              msgError = 'Cliente não encontrado!';
              _isLoadingLogin = false;
            } else {
              msgError = '';
              _isLoadingLogin = false;
            }
          });
        }).catchError((e) {
          setState(() {
            msgError = e
                .toString(); // Define a mensagem de erro se ocorrer algum erro na consulta
            _isLoadingLogin = false;
          });
        });
      } catch (e) {
        setState(() {
          msgError =
              e.toString(); // Define a mensagem de erro em caso de exceção
          _isLoadingLogin = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ClientesProvider>(
        builder: (context, clienteProvider, _) {
          if (clienteProvider.clienteAtual != null) {
            return const Home();
          } else {
            return buildLoginScreen();
          }
        },
      ),
    );
  }

  //Tela não logado
  Scaffold buildLoginScreen() {
    final themeProvider = Provider.of<TipoTemaProvider>(context);

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).viewInsets.bottom == 0
                  ? MediaQuery.of(context).size.height * 0.7
                  : MediaQuery.of(context).size.height * 0.3,
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  themeProvider.obterTema().brightness == Brightness.dark ?
                  Container(
                    height: 150.0,
                    width: 150.0,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo-em-branco.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ) : Container(
                    height: 150.0,
                    width: 150.0,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/logo_light.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MediaQuery.of(context).viewInsets.bottom == 0
                      ? RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.displayLarge,
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Invista hoje, construa\n',
                              ),
                              TextSpan(
                                text: 'seu amanhã',
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 30,
                  ),
                  MediaQuery.of(context).viewInsets.bottom == 0
                      ? ElevatedButton(
                          onPressed: () {
                            //Ir para tela de simulação
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SimulacaoInvestimento(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
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
                            'Fazer simulação',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                color: Theme.of(context).backgroundColor,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        msgError,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextFormField(
                          controller: _cpfController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            filled: true,
                            hintText: 'Digite seu CPF...',
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Preencha o CPF';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: _isLoadingLogin
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoadingLogin = true;
                                    });
                                    Timer(const Duration(seconds: 1), () {
                                      login();
                                    });
                                  }
                                },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(1),
                            shadowColor:
                                MaterialStateProperty.all(Colors.white),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                          child: _isLoadingLogin
                              ? CircularProgressIndicator(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                )
                              : Text(
                                  'Entrar',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
