import collection.mutable.Map

class Bank(val allowedAttempts: Integer = 3) {

    private val accountsRegistry : Map[String,Account] = Map()

    val transactionsPool: TransactionPool = new TransactionPool()
    val completedTransactions: TransactionPool = new TransactionPool()


    def processing : Boolean = !transactionsPool.isEmpty

    def transfer(from: String, to: String, amount: Double): Unit = {
        transactionsPool.add(new Transaction(from, to, amount, allowedAttempts))
    }
                                                // TODO
                                                // project task 2
                                                // create a new transaction object and put it in the queue
                                                // spawn a thread that calls processTransactions

    def processTransactions: Unit = transactionsPool.synchronized {

        val workers : List[Thread] = transactionsPool.iterator.toList
                                                .filter(_.getStatus() == TransactionStatus.PENDING)
                                                .map(processSingleTransaction)

        workers.map( element => element.start() )
        workers.map( element => element.join() )

        val succeded : List[Transaction] = transactionsPool.iterator.toList
                                                .filter(_.getStatus() == TransactionStatus.SUCCESS)

        val failed : List[Transaction] = transactionsPool.iterator.toList
                                                .filter(_.getStatus() == TransactionStatus.FAILED)

        succeded.map(t => transactionsPool.remove(t))
        succeded.map(t => completedTransactions.add(t))

        failed.map(t => {
            if(!t.reset()) {
                transactionsPool.remove(t)
                completedTransactions.add(t)
            }
        })

        if(!transactionsPool.isEmpty) {
            processTransactions
        }
    }

    private def processSingleTransaction(t : Transaction) : Thread = {
        val thread = new Thread {
            override def run = { 

                t.synchronized {
                    executeTransaction(t)
                }
            }
        }

        thread        
    }

    private def executeTransaction(t : Transaction) = accountsRegistry.synchronized {
        val updatedFrom = accountsRegistry.get(t.from).get.withdraw(t.amount)
        val updatedTo = accountsRegistry.get(t.to).get.deposit(t.amount)

        if(updatedFrom.isRight && updatedTo.isRight) {
            accountsRegistry(t.from) = updatedFrom.toOption.get
            accountsRegistry(t.to) = updatedTo.toOption.get
            t.succeed()
        }else{
            t.fail()
        }

    }

    def createAccount(initialBalance: Double) : String = {
        val theCode : String = (accountsRegistry.size + 1).toString()
        val account = new Account(theCode, initialBalance)
        accountsRegistry += theCode -> account
        theCode
    }

    def getAccount(code : String) : Option[Account] = accountsRegistry.get(code)
}
