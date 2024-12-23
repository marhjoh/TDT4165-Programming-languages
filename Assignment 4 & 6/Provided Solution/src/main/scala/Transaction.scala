import collection.mutable.HashSet

object TransactionStatus extends Enumeration {
  val SUCCESS, PENDING, FAILED = Value
}

class TransactionPool {

    private val pool : HashSet[Transaction] = new HashSet()

    // Remove and return the first element from the queue
    def remove(t: Transaction): Boolean = pool.remove(t)

    // Return whether the queue is empty
    def isEmpty: Boolean = pool.isEmpty

    // Return whether the queue is empty
    def size: Integer = pool.size

    // Add new element to the back of the queue
    def add(t: Transaction): Unit = pool.add(t)

    // Return an iterator to allow you to iterate over the queue
    def iterator : Iterator[Transaction] = pool.iterator

}

class Transaction(val from: String,
                  val to: String,
                  val amount: Double,
                  val retries: Int = 3) {

  private var status: TransactionStatus.Value = TransactionStatus.PENDING
  private var attempts = 0

  def getStatus() = status

  def fail() = {
    status = TransactionStatus.FAILED
    attempts = attempts + 1
  }

  def succeed() = {
    status = TransactionStatus.SUCCESS
  }

  def reset() : Boolean = {
    val canReset : Boolean = (attempts < retries)

    if(canReset) {
        status = TransactionStatus.PENDING
    }

    canReset
  }
}
