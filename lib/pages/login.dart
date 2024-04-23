import 'package:durizi_app/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/ClienteProvider.dart';

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

  //Variaveis de erro
  String msgError = '';

  //Função para validar login
  void login() {
    if (_cpfController.text.isNotEmpty) {
      try {
        setState(() {
          msgError = '';
        });
        final clienteProvider =
            Provider.of<ClientesProvider>(context, listen: false);
        clienteProvider
            .consultarCPFExistente(_cpfController.text)
            .then((_) {
          setState(() {
            msgError = ''; // Limpar a mensagem de erro se o CPF for encontrado
          });
        }).catchError((e) {
          setState(() {
            msgError = e.toString(); // Define a mensagem de erro se ocorrer algum erro na consulta
          });
        });
      } catch (e) {
        setState(() {
          msgError = e.toString(); // Define a mensagem de erro em caso de exceção
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
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MediaQuery.of(context).viewInsets.bottom == 0
                      ? RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.headline1,
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Invista conosco e\ntenha um ',
                              ),
                              TextSpan(
                                text: 'lucro \nde 5% ao mês',
                                style: Theme.of(context).textTheme.headline2,
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
                          onPressed: () {},
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).accentColor),
                          ),
                          child: Text(
                            'Fazer simulação',
                            style: Theme.of(context).textTheme.button,
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              login();
                            }
                          },
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(1),
                            shadowColor:
                                MaterialStateProperty.all(Colors.white),
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).accentColor),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                          child: Text(
                            'Entrar',
                            style: Theme.of(context).textTheme.button,
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
