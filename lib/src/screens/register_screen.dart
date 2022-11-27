import 'package:controle_financeiro/src/components/app_logo.dart';
import 'package:controle_financeiro/src/components/button_loading.dart';
import 'package:controle_financeiro/src/components/labeled_divider.dart';
import 'package:controle_financeiro/src/components/my_text_field.dart';
import 'package:controle_financeiro/src/dto/user_dto.dart';
import 'package:controle_financeiro/src/screens/home_screen.dart';
import 'package:controle_financeiro/src/services/login_service.dart';
import 'package:controle_financeiro/src/services/register_service.dart';
import 'package:controle_financeiro/src/utils/utils.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String id = 'register_screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeNotifier = ValueNotifier<String>('');
  final _emailNotifier = ValueNotifier<String>('');
  final _senhaNotifier = ValueNotifier<String>('');
  final _confirmacaoSenhaNotifier = ValueNotifier<String>('');
  final _exibirSenhaNotifier = ValueNotifier<bool>(false);
  final _loadingNotifier = ValueNotifier<bool>(false);

  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  @override
  void didChangeDependencies() {
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null) {
      UserDTO userDTO = settings.arguments as UserDTO;

      _emailController.value = TextEditingValue(
          text: userDTO.email, selection: _emailController.selection);
      _emailNotifier.value = userDTO.email;

      _senhaController.value = TextEditingValue(
          text: userDTO.senha, selection: _senhaController.selection);
      _senhaNotifier.value = userDTO.senha;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nomeNotifier.dispose();
    _emailNotifier.dispose();
    _senhaNotifier.dispose();
    _confirmacaoSenhaNotifier.dispose();
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
                      valueListenable: _nomeNotifier,
                      builder: (_, nome, __) => MyTextField(
                        validator: _validadorNome,
                        labelText: 'Nome completo',
                        onChanged: (value) {
                          _nomeNotifier.value = value;
                        },
                        iconData: Icons.people_rounded,
                        valido: _validadorNome(nome) == null,
                        textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                          obscureText: !exibirSenha,
                          labelText: 'Senha',
                          onChanged: (value) {
                            _senhaController.value = TextEditingValue(
                                text: value,
                                selection: _senhaController.selection);

                            _senhaNotifier.value = value;
                          },
                          iconData: Icons.lock_outline,
                          valido: _validadorSenha(senha) == null,
                          controller: _senhaController,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: _senhaNotifier,
                      builder: (_, senha, __) => ValueListenableBuilder(
                        valueListenable: _confirmacaoSenhaNotifier,
                        builder: (_, confirmacaoSenha, __) =>
                            ValueListenableBuilder(
                          valueListenable: _exibirSenhaNotifier,
                          builder: (_, exibirSenha, __) => MyTextField(
                            validator: _validadorConfirmacaoSenha,
                            obscureText: !exibirSenha,
                            labelText: 'Confirmação da senha',
                            onChanged: (value) {
                              _confirmacaoSenhaNotifier.value = value;
                            },
                            iconData: Icons.lock_outline,
                            valido: _validadorSenha(senha) == null &&
                                _validadorConfirmacaoSenha(confirmacaoSenha) ==
                                    null,
                            onFieldSubmitted: (_) => _registrar(),
                            textInputAction: TextInputAction.done,
                          ),
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
                        : _registrar,
                        child: _loadingNotifier.value
                            ? const ButtonLoading()
                            : const Text('Cadastrar'),
                      ),
                    ),
                    const LabeledDivider(text: 'ou', verticalPadding: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          LoginScreen.id,
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
                      child: const Text('Já tenho cadastro'),
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

  String? _validadorNome(String? value) {
    String nome = value ?? "";
    RegExp regexNome = RegExp(r"^(\S)+(\s(\S)+)+$");

    if (regexNome.allMatches(nome).isEmpty) {
      return "Informe seu nome completo";
    }

    return null;
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

  String? _validadorConfirmacaoSenha(String? value) {
    String confirmacaoSenha = value ?? "";

    if (confirmacaoSenha != _senhaNotifier.value) {
      return "As senhas estão diferentes";
    }

    return null;
  }

  void _registrar() async {
    _loadingNotifier.value = true;
    bool valido = _formKey.currentState?.validate() ?? false;

    if (!valido) {
      _loadingNotifier.value = false;
      return;
    }

    dynamic registerResponse = await RegisterService().register(
        _nomeNotifier.value, _emailNotifier.value, _senhaNotifier.value);

    if (!registerResponse['sucesso']) {
      if(registerResponse['alterarParaLoginScreen'])
        {
          Navigator.pushReplacementNamed(
            context,
            LoginScreen.id,
            arguments: UserDTO(
              email: _emailNotifier.value,
              senha: _senhaNotifier.value,
            ),
          );
        }
      Utils.message(context, registerResponse['mensagem']);
      _loadingNotifier.value = false;
      return;
    }

    dynamic loginResponse =
        await LoginService().login(_emailNotifier.value, _senhaNotifier.value);

    if (!loginResponse['sucesso']) {
      Utils.message(context, loginResponse['mensagem']);
      _loadingNotifier.value = false;
      return;
    }

    Utils.message(context, loginResponse['mensagem']);
    Navigator.pushReplacementNamed(context, HomeScreen.id);

    _loadingNotifier.value = false;
  }
}
