class Bank {
  final String id;
  final String nameBank;

  Bank({
    this.id,
    this.nameBank,
  });

  factory Bank.fromJson(Map<String, dynamic> json) =>
      Bank(id: json['id'], nameBank: json['nameBank']);
}

/* class BankAccount {
  final String id;
  final String user;
  final String nameAccount;
  final String rutAccount;
  final String typeAccount;
  final String numberAccount;
  final String bankOfAccount;
  final String emailAccount;

  Bank(
      {this.id,
      this.user,
      this.nameAccount,
      this.rutAccount,
      this.typeAccount,
      this.numberAccount,
      this.bankOfAccount,
      this.emailAccount});

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        id: json['id'],
        user: json['user'],
        nameAccount: json['nameAccount'],
        rutAccount: json['rutAccount'],
        typeAccount: json['typeAccount'],
        numberAccount: json['numberAccount'],
        bankOfAccount: json['bankOfAccount'],
        emailAccount: json['emailAccount'],
      );
}
 */
