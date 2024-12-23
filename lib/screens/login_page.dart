import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/screens/home_page.dart';
import 'package:shopping_app/screens/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
RegExp regExps = new RegExp(pattern);

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool passHide = true;

  bool isChange = false;
  bool isGuest = false;

  @override
  Widget build(BuildContext context) {
    login() async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text,
          password: passController.text,
        );
        usernameController.clear();
        passController.clear();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        setState(() {
          isChange = false;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No se encontrò usuario con ese email.")));

          setState(() {
            isChange = false;
          });
          print('No se encontrò usuario con ese email.');
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Contraseña incorrecta.')));

          setState(() {
            isChange = false;
          });
          print('No se encontrò usuario con ese email.');
        }
      }
    }

    void validation() {
      final _form = _formKey.currentState;
      if (_form!.validate()) {
        login();
      } else {
        setState(() {
          isChange = false;
        });
      }
    }

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Iniciar Sesiòn",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 40),
                TextFormField(
                  validator: (value) {
                    if (value == "" || value == null) {
                      return "Por favor llene el email";
                    } else if (!regExp.hasMatch(value)) {
                      return "Email invàlido";
                    }
                  },
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(CupertinoIcons.envelope),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passController,
                  validator: (value) {
                    if (value == "" || value == null) {
                      return "Por favor llene la contraseña";
                    } else if (value.length < 8) {
                      return "Contraseña menor a 8 digitos";
                    }
                  },
                  obscureText: passHide,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(CupertinoIcons.lock),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        // FocusScope.of(context).unfocus();
                        setState(() {
                          passHide = false;
                        });
                      },
                      child: passHide
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () async {
                    setState(() {
                      isChange = true;
                    });

                    await Future.delayed(const Duration(seconds: 1));
                    validation();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: isChange ? 45 : 160,
                    height: isChange ? 45 : 45,
                    alignment: Alignment.center,
                    child: isChange
                        ? const Icon(Icons.done_all)
                        : FittedBox(
                            child: Text(
                              "Iniciar Sesiòn",
                            ),
                          ),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.circular(isChange ? 45 : 8),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                InkWell(
                  onTap: () async {
                    setState(() {
                      isGuest = true;
                    });
                    await Future.delayed(const Duration(seconds: 1));
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    width: isGuest ? 45 : 160,
                    height: isGuest ? 45 : 45,
                    alignment: Alignment.center,
                    child: isGuest
                        ? const Icon(Icons.done_all)
                        : FittedBox(
                            child: Text(
                              "Entrar como invitado",
                            ),
                          ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 226, 255, 65),
                      borderRadius: BorderRadius.circular(isGuest ? 45 : 8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("No tienes cuenta? "),
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      ),
                      child: const Text(
                        "Registrese ahora",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
