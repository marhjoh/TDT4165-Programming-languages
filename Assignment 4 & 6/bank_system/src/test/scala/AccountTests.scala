import org.scalatest.FunSuite

class AccountTests extends FunSuite {

  test("Test 01: Account should be immutable") {
    val account = new Account("1234", 500)
    val result = account.withdraw(200)
    assert(account.balance == 500)
    assert(account.code == "1234")
  }

  test("Test 02: Valid account withdrawal") {
    val account = new Account("1234", 500)
    val result = account.withdraw(200)
    result match {
      case Right(x) => assert(x.balance == 300)
      case Left(x) => assert(false)
    }
  }

  test("Test 03: Invalid account withdrawal should return error message") {
    val account = new Account("1234",500)
    val result = account.withdraw(1000)
    assert(result.isLeft)
  }

  test("Test 04: Withdrawal of negative amount should return error message") {
    val account = new Account("1234",500)
    val result = account.withdraw(-100)
    assert(result.isLeft)
  }

  test("Test 05: Valid account deposit") {
    val account = new Account("1234",500)
    val result = account.deposit(250)
    assert(result.isRight)
    assert(result.toOption.get.balance == 750)
  }

  test("Test 06: Deposit of negative amount should return an error") {
    val account = new Account("1234",500)
    val result = account.deposit(-50)
    assert(result.isLeft)
  }

  test("Test 07: Correct balance amount after several withdrawals and deposits") {
    var account = new Account("1234",50000)
    val lock: Object = new Object

    val first = Main.thread {
      for (i <- 0 until 100) {
        lock.synchronized {
          account = account.withdraw(10).toOption.get
        }
        Thread.sleep(10)
      }
    }
    val second = Main.thread {
      for (i <- 0 until 100) {
        lock.synchronized {
          account = account.deposit(5).toOption.get
        }
        Thread.sleep(20)
      }
    }
    val third = Main.thread {
      for (i <- 0 until 100) {
        lock.synchronized {
          account = account.withdraw(50).toOption.get
        }
        Thread.sleep(10)
      }
    }
    val fourth = Main.thread {
      for (i <- 0 until 100) {
        lock.synchronized {
          account = account.deposit(100).toOption.get
        }
        Thread.sleep(10)
      }
    }
    first.join()
    second.join()
    third.join()
    fourth.join()
    assert(account.balance == 54500)
  }
}

class AccountTransferTests extends FunSuite {

  test("Test 08: Valid transfer between accounts") {
    val bank = new Bank()

    val code1 = bank.createAccount(100)
    val code2 = bank.createAccount(200)

    bank transfer(code1, code2, 50)
    bank processTransactions

    while (bank.processing) {
      Thread.sleep(100)
    }

    assert(bank.completedTransactions.iterator.toList.last.getStatus == TransactionStatus.SUCCESS)
    assert(bank.getAccount(code1).get.balance == 50)
    assert(bank.getAccount(code2).get.balance == 250)
  }

  test("Test 09: Transfer of negative amount between accounts should fail") {
    val bank = new Bank()

    val code1 = bank.createAccount(500)
    val code2 = bank.createAccount(1000)

    bank transfer(code1, code2, -100)
    bank processTransactions

    while (bank.processing) {
      Thread.sleep(100)
    }

    assert(bank.completedTransactions.iterator.toList.last.getStatus == TransactionStatus.FAILED)
    assert(bank.getAccount(code1).get.balance == 500)
    assert(bank.getAccount(code2).get.balance == 1000)
  }


  test("Test 10: Invalid transfer between accounts due to insufficient funds should lead to transaction status FAILED and no money should be transferred between accounts") {
    val bank = new Bank()
    val code1 = bank.createAccount(100)
    val code2 = bank.createAccount(1000)

    bank transfer(code1, code2, 150)
    bank processTransactions

    while (bank.processing) {
      Thread.sleep(100)
    }

    assert(bank.completedTransactions.iterator.toList.last.getStatus == TransactionStatus.FAILED)
    assert(bank.getAccount(code1).get.balance == 100)
    assert(bank.getAccount(code2).get.balance == 1000)
  }


  test("Test 11: Correct balance amounts after several transfers") {
    val bank = new Bank()
    val code1 = bank.createAccount(3000)
    val code2 = bank.createAccount(5000)

    val first = Main.thread {
      for (i <- 0 until 100) {
        bank transfer(code1, code2, 30)
      }
    }
    val second = Main.thread {
      for (i <- 0 until 100) {
        bank transfer(code2, code1, 23)
      }
    }
    first.join()
    second.join()

    bank processTransactions

    while (bank.processing) {
      Thread.sleep(100)
    }

    assert(bank.getAccount(code1).get.balance == 2300)
    assert(bank.getAccount(code2).get.balance == 5700)
  }

    test("Test 12: All the submitted transactions are processed") {
    val bank = new Bank()
    val code1 = bank.createAccount(3000)
    val code2 = bank.createAccount(5000)

    val first = Main.thread {
      for (i <- 0 until 100) {
        bank transfer(code1, code2, 30)
      }
    }
    val second = Main.thread {
      for (i <- 0 until 100) {
        bank transfer(code2, code1, 23)
      }
    }
    first.join()
    second.join()

    val submitted = bank.transactionsPool.size

    bank processTransactions

    while (bank.processing) {
      Thread.sleep(100)
    }

    assert(bank.completedTransactions.size == submitted)
    assert(bank.transactionsPool.isEmpty)
  }

  
}
