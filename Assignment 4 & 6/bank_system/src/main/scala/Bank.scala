import collection.mutable.Map

class Bank(val allowedAttempts: Integer = 3) {

    private val accountsRegistry : Map[String,Account] = Map()

    val transactionsPool: TransactionPool = new TransactionPool()
    val completedTransactions: TransactionPool = new TransactionPool()


    def processing : Boolean = !transactionsPool.isEmpty

    // TODO
    // Adds a new transaction for the transfer to the transaction pool
    def transfer(from: String, to: String, amount: Double): Unit = ???

    // TODO
    // Process the transactions in the transaction pool
    // The implementation needs to be completed and possibly fixed
    def processTransactions: Unit = {

        // val workers : List[Thread] = transactionsPool.iterator.toList
        //                                        .filter(/* select only pending transactions */)
        //                                        .map(processSingleTransaction)

        // workers.map( element => element.start() )
        // workers.map( element => element.join() )

        /* TODO: change to select only transactions that succeeded */
        // val succeded : List[Transaction] = transactionsPool

        /* TODO: change to select only transactions that failed */
        // val failed : List[Transaction] = transactionsPool

        // succeded.map(/* remove transactions from the transaction pool */)
        // succeded.map(/* add transactions to the completed transactions queue */)

        //failed.map(t => { 
            /*  transactions that failed need to be set as pending again; 
                if the number of retry has exceeded they also need to be removed from
                the transaction pool and to be added to the queue of completed transactions */
        //})

        if(!transactionsPool.isEmpty) {
            processTransactions
        }
    }

    // TODO
    // The function creates a new thread ready to process
    // the transaction, and returns it as a return value
    private def processSingleTransaction(t : Transaction) : Thread =  ???


    // TODO
    // Creates a new account and returns its code to the user.
    // The account is stored in the local registry of bank accounts.
    def createAccount(initialBalance: Double) : String = ???


    // TODO
    // Return information about a certain account based on its code.
    // Remember to handle the case in which the account does not exist
    def getAccount(code : String) : Option[Account] = ???
}
