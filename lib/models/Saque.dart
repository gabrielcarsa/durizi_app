class Saque {
  final String? id;
  final String clienteId;
  final String data;
  String? dataResposta;
  final double valor;
  final String observacao;
  bool? isAprovado;
  bool? isRejeitado;

  Saque({
    this.id,
    required this.clienteId,
    required this.data,
    this.dataResposta,
    required this.valor,
    required this.observacao,
    this.isAprovado,
    this.isRejeitado,
  });

  Saque.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        clienteId = json['clienteId'] ?? '',
        data = json['data'] ?? '',
        dataResposta = json['dataResposta'] ?? '',
        valor = (json['valor'] ?? 0.0).toDouble(),
        observacao = json['observacao'] ?? '',
        isAprovado = json['isAprovado'] ?? false,
        isRejeitado = json['isRejeitado'] ?? false;

  Map<String, dynamic> toJson() => {
    'id': id,
    'clienteId': clienteId,
    'data': data,
    'dataResposta': dataResposta,
    'valor': valor,
    'observacao': observacao,
    'isAprovado': isAprovado,
    'isRejeitado': isRejeitado,
  };

  //setters
  void setAprovarSaque(bool value, dataResposta) {
    isAprovado = value;
    this.dataResposta = dataResposta;
  }

  //setters
  void setRejeitarSaque(bool value, dataResposta) {
    isRejeitado = value;
    this.dataResposta = dataResposta;
  }
}