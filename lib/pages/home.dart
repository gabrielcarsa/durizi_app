import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ClienteProvider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //controller dos campos do form
  final TextEditingController _cpfController = TextEditingController();

  //form
  final _formKey = GlobalKey<FormState>();

  //Variaveis de erro
  String msgError = '';

  //Função para validar login
  void login() {
    setState(() {
      msgError = _cpfController.text.isEmpty ? 'Campo CPF é obrigatório' : '';
    });

    if (_cpfController.text.isNotEmpty) {
      try {
        setState(() {
          msgError = '';
        });
        final clienteProvider =
            Provider.of<ClientesProvider>(context, listen: false);
        clienteProvider
            .consultarCPFExistente(_cpfController.text)
            .catchError((e) {
          setState(() {
            msgError = e.toString();
          });
        });
      } catch (e) {
        setState(() {
          msgError = e.toString();
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
            return buildAuthScreen();
          } else {
            return buildUnAuthScreen();
          }
        },
      ),
    );
  }

  //Tela logado
  Scaffold buildAuthScreen() {
    final clienteProvider =
        Provider.of<ClientesProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 0,
        title: Container(
          height: 100.0,
          width: 100.0,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/logo-em-branco.png"),
              fit: BoxFit.fill,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).indicatorColor,
              size: 30,
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        child: Column(
          children: [
            /*Text(
              clienteProvider.clienteAtual!.nome,
              style: Theme.of(context).textTheme.bodyText1,
            ),*/
            const Text(
              'Patrimônio',
              style: TextStyle(
                fontSize: 14.0,
                color: Color(0xFF9F9F9F),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text('${clienteProvider.clienteAtual!.saldo?.last.valor ?? 0}',  style: Theme.of(context).textTheme.headline1,),
          ],
        ),
      ),
    );
  }

  //Tela não logado
  Scaffold buildUnAuthScreen() {
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
