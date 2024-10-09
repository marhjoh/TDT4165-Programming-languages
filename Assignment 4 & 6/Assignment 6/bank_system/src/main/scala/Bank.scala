import collection.mutable.Map
import java.util.UUID

class Bank(val allowedAttempts: Integer = 3) {

    private val accountsRegistry : Map[String, Account] = Map()

    val transactionsPool: TransactionPool = new TransactionPool()
    val completedTransactions: TransactionPool = new TransactionPool()

    def processing: Boolean = !transactionsPool.isEmpty

    // Creates a new account and returns its code to the user.
    def createAccount(initialBalance: Double): String = {
        val code = UUID.randomUUID().toString
        val account = new Account(code, initialBalance)
        accountsRegistry(code) = account
        code
    }

    // Returns information about a certain account based on its code.
    def getAccount(code: String): Option[Account] = accountsRegistry.get(code)

    // Adds a new transaction for the transfer to the transaction pool.
    def transfer(from: String, to: String, amount: Double): Unit = {
        val transaction = new Transaction(from, to, amount)
        transactionsPool.add(transaction)
    }

    // Processes transactions in the transaction pool concurrently.
    def processTransactions: Unit = {
        val workers = transactionsPool.iterator.filter(_.getStatus == TransactionStatus.PENDING)
            .map(processSingleTransaction)
            .toList

        workers.foreach(_.start())
        workers.foreach(_.join())

        val succeeded = transactionsPool.iterator.filter(_.getStatus == TransactionStatus.SUCCESS).toList
        val failed = transactionsPool.iterator.filter(t => t.getStatus == TransactionStatus.FAILED && t.retries == 0).toList

        succeeded.foreach(t => {
            transactionsPool.remove(t)
            completedTransactions.add(t)
        })

        failed.foreach(t => {
            transactionsPool.remove(t)
            completedTransactions.add(t)
        })

        if (!transactionsPool.isEmpty) processTransactions
    }

    // The function creates a new thread ready to process the transaction.
    private def processSingleTransaction(t: Transaction): Thread = {
        new Thread(new Runnable {
            override def run(): Unit = {
                if (t.retries > 0 && t.getStatus == TransactionStatus.PENDING) {
                    val fromAccount = getAccount(t.from)
                    val toAccount = getAccount(t.to)

                    (fromAccount, toAccount) match {
                        case (Some(fromAcc), Some(toAcc)) =>
                            fromAcc.withdraw(t.amount) match {
                                case Right(updatedFrom) =>
                                    toAcc.deposit(t.amount) match {
                                        case Right(updatedTo) =>
                                            accountsRegistry(t.from) = updatedFrom
                                            accountsRegistry(t.to) = updatedTo
                                            t.setStatus(TransactionStatus.SUCCESS)
                                        case Left(_) => t.retries -= 1
                                    }
                                case Left(_) => t.retries -= 1
                            }
                        case _ => t.setStatus(TransactionStatus.FAILED)
                    }
                }
            }
        })
    }
}