class Recado {
  final String? id;
  final String recado;
  final String data;
  bool isAtivo;

  Recado({
    this.id,
    required this.recado,
    required this.data,
    required this.isAtivo,
  });

  Recado.fromJson(Map<String, dynamic> json, String id)
      : id = id,
        recado = json['recado'] ?? '',
        data = json['data'] ?? '',
        isAtivo = json['isAtivo'] ?? false;

  Map<String, dynamic> toJson() => {
    'id': id,
    'recado': recado,
    'data': data,
    'isAtivo': isAtivo,
  };

  //setters
  void setIsAtivo(bool isAtivo) {
    this.isAtivo = isAtivo;
  }
}