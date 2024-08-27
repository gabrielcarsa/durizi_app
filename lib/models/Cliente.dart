class Cliente {
  final String? id;
  final String nome;
  final String cpf;
  final String dataNascimento;
  final String rg;
  final Endereco endereco;
  List<Saldo>? saldo;
  double reajusteDiario;

  Cliente({
    this.id,
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.rg,
    required this.endereco,
    this.saldo,
    required this.reajusteDiario,
  });

  Cliente.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        cpf = json['cpf'],
        dataNascimento = json['data_nascimento'],
        nome = json['nome'],
        rg = json['rg'],
        reajusteDiario = json['reajusteDiario'],
        endereco = Endereco.fromJson(json['endereco']),
        saldo = json['saldo'] != null
            ? (json['saldo'] is List
                ? (json['saldo'] as List)
                    .map((saldoJson) => Saldo.fromJson(saldoJson))
                    .toList()
                : (json['saldo'] as Map<String, dynamic>)
                    .values
                    .map((saldoJson) => Saldo.fromJson(saldoJson))
                    .toList())
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'cpf': cpf,
        'data_nascimento': dataNascimento,
        'nome': nome,
        'rg': rg,
        'reajusteDiario': reajusteDiario,
        'endereco': endereco.toJson(),
        'saldo': saldo?.map((saldo) => saldo.toJson()).toList(),
      };

  //setters
  void setReajusteDiario(double value) {
    reajusteDiario = value;
  }
}

class Endereco {
  final String bairro;
  final String cep;
  final String complemento;
  final int numero;
  final String cidade;
  final String estado;
  final String rua;

  Endereco({
    required this.bairro,
    required this.cep,
    required this.complemento,
    required this.numero,
    required this.cidade,
    required this.estado,
    required this.rua,
  });

  Endereco.fromJson(Map<String, dynamic> json)
      : bairro = json['bairro'],
        cep = json['cep'],
        complemento = json['complemento'],
        numero = json['numero'],
        cidade = json['cidade'],
        estado = json['estado'],
        rua = json['rua'];

  Map<String, dynamic> toJson() => {
        'bairro': bairro,
        'cep': cep,
        'complemento': complemento,
        'numero': numero,
        'cidade': cidade,
        'estado': estado,
        'rua': rua,
      };
}

class Saldo {
  final String data;
  final double valor;

  Saldo({
    required this.data,
    required this.valor,
  });

  factory Saldo.fromJson(Map<String, dynamic> json) {
    return Saldo(
      data: json['data'],
      valor: json['valor'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data,
        'valor': valor,
      };
}
