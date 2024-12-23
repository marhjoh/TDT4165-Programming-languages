class Account(val code : String, val balance: Double) {

    def withdraw(amount: Double): Either[String,Account] = {
        if (amount > 0) {
            amount < balance match {
                case true => Right(updateBalance(this.balance - amount))
                case false => Left(s"Insufficient funds, unable to withdraw $amount")
            }
        }else{
            Left("The amount to withdraw should be greater than zero")
        }
    }

    def deposit (amount: Double): Either[String,Account] = {
        amount > 0 match {
            case true => Right(updateBalance(this.balance + amount))
            case false => Left("The amount to deposit should be greater than zero")
        }
    }

    private def updateBalance(newBalance: Double) : Account = 
        new Account(code, newBalance)

}
