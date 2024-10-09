class Account(val code: String, val balance: Double) {

  // Withdraw an amount from the account, returning either an error message or a new Account
  def withdraw(amount: Double): Either[String, Account] = synchronized {
    if (amount < 0) {
      Left("Withdrawal amount cannot be negative")
    } else if (amount > balance) {
      Left("Insufficient funds")
    } else {
      Right(new Account(code, balance - amount))
    }
  }

  // Deposit an amount to the account, returning either an error message or a new Account
  def deposit(amount: Double): Either[String, Account] = synchronized {
    if (amount < 0) {
      Left("Deposit amount cannot be negative")
    } else {
      Right(new Account(code, balance + amount))
    }
  }

  override def toString: String = s"Account($code, Balance: $balance)"
}