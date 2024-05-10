import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/ClienteProvider.dart';
import '../providers/TipoTemaProvider.dart';
import 'home.dart';

class SobreScreen extends StatefulWidget {
  const SobreScreen({super.key});

  @override
  State<SobreScreen> createState() => _SobreScreenState();
}

class _SobreScreenState extends State<SobreScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<TipoTemaProvider>(context);

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
                  'Sobre',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              body: SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    themeProvider.obterTema().brightness == Brightness.dark
                        ? Container(
                            height: 150.0,
                            width: 150.0,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/logo-em-branco.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        : Container(
                            height: 150.0,
                            width: 150.0,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage("assets/images/logo_light.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 30.0),
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.6),
                                  Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.3),
                                ],
                                begin: AlignmentDirectional.topStart,
                                end: AlignmentDirectional.bottomEnd,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                width: 1.5,
                                color: Theme.of(context).indicatorColor.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'DURIZI INVESTIMENTOS',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.badge_outlined,
                                          size: 20,
                                          color:
                                              Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'N D S R Consultoria Empresarial Ltda',
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.business_sharp,
                                          size: 20,
                                          color:
                                              Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '52.723.054/0001-89',
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.person,
                                          size: 20,
                                          color:
                                              Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Nathan Durizi Silva Rodrigues',
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.location_on,
                                          size: 20,
                                          color:
                                              Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Rua Padre João Crippa 3122 - Brasil, Campo Grande-MS',
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.call,
                                          size: 20,
                                          color:
                                              Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '67 98112-0303',
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons.email,
                                          size: 20,
                                          color:
                                          Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'duriziinvestimentos@hotmail.com',
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
