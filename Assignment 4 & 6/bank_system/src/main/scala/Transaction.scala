object TransactionStatus extends Enumeration {
  val SUCCESS, PENDING, FAILED = Value
}

class TransactionPool {

     // Remove and the transaction from the pool
    def remove(t: Transaction): Boolean = ???

    // Return whether the queue is empty
    def isEmpty: Boolean = ???

    // Return the size of the pool
    def size: Integer = ???

    // Add new element to the back of the queue
    def add(t: Transaction): Boolean = ???

    // Return an iterator to allow you to iterate over the queue
    def iterator : Iterator[Transaction] = ???

}

class Transaction(val from: String,
                  val to: String,
                  val amount: Double,
                  val retries: Int = 3) {

  private var status: TransactionStatus.Value = TransactionStatus.PENDING
  private var attempts = 0

  def getStatus() = status

  // TODO: Implement methods that change the status of the transaction

}
