import scala.collection.mutable.Queue

object TransactionStatus extends Enumeration {
  val SUCCESS, PENDING, FAILED = Value
}

class Transaction(val from: String, val to: String, val amount: Double, var retries: Int = 3) {
  private var status: TransactionStatus.Value = TransactionStatus.PENDING
  private var attempts = 0

  def getStatus(): TransactionStatus.Value = status

  def setStatus(newStatus: TransactionStatus.Value): Unit = {
    status = newStatus
  }

  def incrementAttempts(): Unit = {
    attempts += 1
  }

  def getAttempts: Int = attempts
}

class TransactionPool {
  // Thread-safe queue to hold transactions
  private val transactions: Queue[Transaction] = Queue()

  // Adds a transaction to the pool
  def add(t: Transaction): Boolean = synchronized {
    transactions.enqueue(t)
    true
  }

  // Removes a transaction from the pool
  def remove(t: Transaction): Boolean = synchronized {
    transactions.dequeueFirst(_ == t).isDefined
  }

  // Returns whether the queue is empty
  def isEmpty: Boolean = synchronized {
    transactions.isEmpty
  }

  // Returns the size of the pool
  def size: Int = synchronized {
    transactions.size
  }

  // Returns an iterator over the transactions
  def iterator: Iterator[Transaction] = synchronized {
    transactions.iterator
  }
}