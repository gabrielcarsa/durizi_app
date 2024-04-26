class Aporte {
  final String? id;
  final String clienteId;
  final String data;
  String? dataResposta;
  final double valor;
  final String? observacao;
  bool? isAprovado;
  bool? isRejeitado;

  Aporte({
    this.id,
    required this.clienteId,
    required this.data,
    this.dataResposta,
    required this.valor,
    this.observacao,
    this.isAprovado,
    this.isRejeitado,
  });

  Aporte.fromJson(Map<String, dynamic> json, String id)
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
  void setAprovarAporte(bool value, dataResposta) {
    isAprovado = value;
    this.dataResposta = dataResposta;
  }

  //setters
  void setRejeitarAporte(bool value, dataResposta) {
    isRejeitado = value;
    this.dataResposta = dataResposta;
  }
}