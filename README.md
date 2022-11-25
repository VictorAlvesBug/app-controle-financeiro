# app-controle-financeiro

Aplicativo Mobile Flutter desenvolvido para a disciplina de Mobile Development
no MBA da FIAP (43SCJ).

Este aplicativo foi criado com base no aplicativo de finanças
[Mobills](https://web.mobills.com.br/dashboard), com objetivo de melhorar o controle de suas
receitas e despesas.

## Configurando o aplicativo

Configure a API utilizada pelo aplicativo
[api-controle-financeiro](https://github.com/VictorAlvesBug/api-controle-financeiro).

Realize o clone do [repositório do aplicativo](https://github.com/VictorAlvesBug/app-controle-financeiro)
executando o seguinte comando no cmd, dentro da pasta desejada:

```bach
git clone https://github.com/VictorAlvesBug/app-controle-financeiro.git
```

No Android Studio, abra o projeto recém-clonado.

Abra o cmd ou o terminal da IDE, na pasta do projeto e execute os seguintes comandos para carregar as
dependências do projeto:

```bash
flutter upgrade
flutter pub get
```

Na barra superior do Android Studio, selecione o dispositivo que deseja utilizar e depois clique no
ícone Run "main.dart".

Para utilizar o aplicativo sem a necessidade de criar uma conta, utilize o seguinte login:

- E-mail: usuario@anonimo.com
- Senha: UsuarioAnonimo123

Obs: lembre-se que, para rodar o aplicativo, é necessário estar com a
[API](https://github.com/VictorAlvesBug/app-controle-financeiro) rodando também.
