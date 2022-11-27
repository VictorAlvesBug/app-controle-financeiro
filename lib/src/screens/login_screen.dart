import 'package:controle_financeiro/src/components/app_logo.dart';
import 'package:controle_financeiro/src/components/button_loading.dart';
import 'package:controle_financeiro/src/components/labeled_divider.dart';
import 'package:controle_financeiro/src/components/my_text_field.dart';
import 'package:controle_financeiro/src/dto/user_dto.dart';
import 'package:controle_financeiro/src/screens/home_screen.dart';
import 'package:controle_financeiro/src/screens/register_screen.dart';
import 'package:controle_financeiro/src/services/login_service.dart';
import 'package:controle_financeiro/src/utils/utils.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailNotifier = ValueNotifier<String>('');
  final _senhaNotifier = ValueNotifier<String>('');
  final _exibirSenhaNotifier = ValueNotifier<bool>(false);
  final _loadingNotifier = ValueNotifier<bool>(false);

  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  @override
  void didChangeDependencies() {
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      UserDTO userDTO = settings.arguments as UserDTO;

      _emailNotifier.value = userDTO.email;
      _emailController.value = TextEditingValue(
          text: _emailNotifier.value, selection: _emailController.selection);

      _senhaNotifier.value = userDTO.senha;
      _senhaController.value = TextEditingValue(
          text: _senhaNotifier.value, selection: _senhaController.selection);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailNotifier.dispose();
    _senhaNotifier.dispose();
    _exibirSenhaNotifier.dispose();
    _loadingNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF444444),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(minWidth: 250, maxWidth: 500),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogo(size: 60),
                    const SizedBox(height: 20),
                    ValueListenableBuilder(
                      valueListenable: _emailNotifier,
                      builder: (_, email, __) => MyTextField(
                        validator: _validadorEmail,
                        labelText: 'E-mail',
                        onChanged: (value) {
                          _emailController.value = TextEditingValue(
                              text: value.toLowerCase().trim(),
                              selection: _emailController.selection);

                          _emailNotifier.value = value.toLowerCase().trim();
                        },
                        iconData: Icons.alternate_email_outlined,
                        valido: _validadorEmail(email) == null,
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: _senhaNotifier,
                      builder: (_, senha, __) => ValueListenableBuilder(
                        valueListenable: _exibirSenhaNotifier,
                        builder: (_, exibirSenha, __) => MyTextField(
                          validator: _validadorSenha,
                          labelText: 'Senha',
                          obscureText: !exibirSenha,
                          onChanged: (value) {
                            _senhaController.value = TextEditingValue(
                                text: value,
                                selection: _senhaController.selection);

                            _senhaNotifier.value = value;
                          },
                          iconData: Icons.lock_outline,
                          valido: _validadorSenha(senha) == null,
                          controller: _senhaController,
                          onFieldSubmitted: (_) => _logar(),
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: _exibirSenhaNotifier,
                      builder: (_, exibirSenha, __) => CheckboxListTile(
                        title: const Text('Exibir senha',
                            style: TextStyle(color: Colors.white70)),
                        controlAffinity: ListTileControlAffinity.leading,
                        // ListTileControlAffinity.trailing
                        value: exibirSenha,
                        onChanged: (value) {
                          _exibirSenhaNotifier.value = value!;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: _loadingNotifier,
                      builder: (_, loading, __) => ElevatedButton(
                        onPressed: _loadingNotifier.value
                            ? null
                            : _logar,
                        child: _loadingNotifier.value
                            ? ButtonLoading()
                            : const Text('Entrar'),
                      ),
                    ),
                    LabeledDivider(text: 'ou', verticalPadding: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          RegisterScreen.id,
                          arguments: UserDTO(
                            email: _emailNotifier.value,
                            senha: _senhaNotifier.value,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF444444),
                          side: BorderSide(
                              color: Theme.of(context).primaryColorLight),
                          foregroundColor: Theme.of(context).primaryColorLight),
                      child: const Text('Criar conta'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validadorEmail(String? value) {
    String email = (value ?? "").toLowerCase().trim();
    RegExp regexEmail = RegExp(r"^\w+((-\w+)|(\.\w+))*\@\w+((\.|-)\w+)*\.\w+$");

    if (regexEmail.allMatches(email).isEmpty) {
      return "Informe um e-mail válido";
    }

    return null;
  }

  String? _validadorSenha(String? value) {
    String senha = value ?? "";

    if (senha.length < 8) {
      return "Utilize ao menos 8 caracteres";
    }

    RegExp regexContemNumero = RegExp(r"\d");
    RegExp regexContemLetraMinuscula = RegExp(r"[a-z]");
    RegExp regexContemLetraMaiuscula = RegExp(r"[A-Z]");

    if (regexContemNumero.allMatches(senha).isEmpty) {
      return "Utilize ao menos um caracter numérico";
    }

    if (regexContemLetraMinuscula.allMatches(senha).isEmpty) {
      return "Utilize ao menos uma letra minúscula";
    }

    if (regexContemLetraMaiuscula.allMatches(senha).isEmpty) {
      return "Utilize ao menos uma letra maiúscula";
    }

    return null;
  }

  void _logar() async {
    _loadingNotifier.value = true;
    bool valido = _formKey.currentState?.validate() ?? false;

    if (!valido) {
      _loadingNotifier.value = false;
      return;
    }
    dynamic loginResponse =
        await LoginService().login(_emailNotifier.value, _senhaNotifier.value);

    if (loginResponse['sucesso']) {
      Utils.message(context, loginResponse['mensagem']);
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    } else {
      Utils.message(context, loginResponse['mensagem']);
    }

    _loadingNotifier.value = false;
  }
}
