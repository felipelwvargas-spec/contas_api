import 'dart:convert';
class Transaction {
    String id;
    String senderAccountId;
    String receiverAccountId;
    DateTime date;
    double amount;
    double taxes;

    Transaction({
        required this.id,
        required this.senderAccountId,
        required this.receiverAccountId,
        required this.date,
        required this.amount,
        required this.taxes,
    });
    /// 🏭 Factory constructor — cria um Transaction a partir de um Map (ex: de um banco ou API)
    factory Transaction.fromMap(Map<String, dynamic> map) {
        return Transaction(
            id: map['id'],
            senderAccountId: map['senderAccountId'],
            receiverAccountId: map['receiverAccountId'],
            date: DateTime.parse(map['date']),
            amount: map['amount'],
            taxes: map['taxes'],
        );
    }
    /// 🔁 Converte o objeto em Map (útil para salvar no banco ou converter pra JSON)
    Map<String, dynamic> toMap() {
        return {
            'id': id,
            'senderAccountId': senderAccountId,
            'receiverAccountId': receiverAccountId,
            'date': date.toIso8601String(),
            'amount': amount,
            'taxes': taxes,
        };
    }
    /// 🧬 Cria uma cópia do objeto alterando apenas os campos desejados
    Transaction copyWith({
        String? id,
        String? senderAccountId,
        String? receiverAccountId,
        DateTime? date,
        double? amount,
        double? taxes,
    }) {
        return Transaction(
            id: id ?? this.id,
            senderAccountId: senderAccountId ?? this.senderAccountId,
            receiverAccountId: receiverAccountId ?? this.receiverAccountId,
            date: date ?? this.date,
            amount: amount ?? this.amount,
            taxes: taxes ?? this.taxes,
        );
    }
    /// 🧾 Converte para JSON (String)
    String toJson() => json.encode(toMap());

    /// 📥 Cria uma instância a partir de uma string JSON
    factory Transaction.fromJson(String source) => Transaction.fromMap(json.decode(source));
    /// 🧠 Facilita debug e logs
    @override
    String toString() {
        return 'Transaction(id: $id, senderAccountId: $senderAccountId, receiverAccountId: $receiverAccountId, date: $date, amount: $amount, taxes: $taxes)';
    }
    /// ⚖️ Garante que duas transações com os mesmos dados sejam consideradas iguais
    @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true; // Verifica se são a mesma instância

    return other is Transaction &&
        other.id == id &&
        other.senderAccountId == senderAccountId &&
        other.receiverAccountId == receiverAccountId &&
        other.date == date &&
        other.amount == amount &&
        other.taxes == taxes;
  }
  /// 🔢 Necessário quando sobrescrevemos `==`
  @override
  int get hashCode {
    return id.hashCode ^
        senderAccountId.hashCode ^
        receiverAccountId.hashCode ^
        date.hashCode ^
        amount.hashCode ^
        taxes.hashCode;
  }




}