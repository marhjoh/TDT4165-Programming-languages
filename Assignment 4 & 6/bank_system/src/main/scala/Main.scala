object Main extends App {
	// Task 1a
	val array = Array.tabulate(50)(i => i + 1)
    println(array.mkString(", "))

  	// Task 1b
	def sumArray(arr: Array[Int]): Int = {
        var sum = 0
        for (i <- arr) sum += i
        sum
    }

    println(sumArray(array))  // Should print 1275

  	// Task 1c
	def sumArrayRecursive(arr: Array[Int], index: Int = 0): Int = {
        if (index >= arr.length) 0
        else arr(index) + sumArrayRecursive(arr, index + 1)
    }
    println(sumArrayRecursive(array))  // Should print 1275


  	// Task 1d
	def fibonacci(n: BigInt): BigInt = {
        if (n == 0) 0
        else if (n == 1) 1
        else fibonacci(n - 1) + fibonacci(n - 2)
    }

    println(fibonacci(10))  // Should print 55

    // Int is a fixed-size 32-bit integer that can represent values between -2,147,483,648 and 2,147,483,647.
    // BigInt can represent arbitrarily large integers but is slower because it requires dynamic memory allocation.


    // Task 2a
    def quadraticEquation(a: Double, b: Double, c: Double): Either[String, (Double, Double)] = {
        val discriminant = b * b - 4 * a * c
        if (discriminant < 0) {
            Left("No real solutions")
        } else {
            val sqrtDiscriminant = math.sqrt(discriminant)
            val x1 = (-b - sqrtDiscriminant) / (2 * a)
            val x2 = (-b + sqrtDiscriminant) / (2 * a)
            Right((x1, x2))
        }
    }

    val result1 = quadraticEquation(2.0, 1.0, -1.0)
    println(result1)  // Expected: Right((-1.0, 0.5))

    val result2 = quadraticEquation(2.0, 1.0, 2.0)
    println(result2)  // Expected: Left("No real solutions")

    // Task 2b
    def quadratic(a: Double, b: Double, c: Double): Double => Double = {
    x => a * x * x + b * x + c
    }
    println(quadratic(3, 2, 1)(2))  // Should print 17

    // Scala supports object-oriented programming in addition to functional programming. Meanwhile, Oz is more specialized 
    // towards functional and declarative paradigms. Scala's syntax is concise and supports immutability through val, while 
    // in Oz, variables are bound only once. Scala provides extensive libraries for concurrency, including higher-order abstractions for threads.

    // Task 3a
    def createThread(f: () => Unit): Thread = {
        new Thread(new Runnable {
        override def run(): Unit = f()
        })
    }

    val thread = createThread(() => println("Thread started!"))
    thread.start()  // Should print "Thread started!"

    // Task 3c
    // One approach is to use synchronized blocks to ensure only one thread can modify the variables at a time.

    var value1 = 1000
    var value2 = 0

    def moveOneUnit(): Unit = synchronized {
        value1 -= 1
        value2 += 1
        if (value1 == 0) {
            value1 = 1000
            value2 = 0
        }
    }

    // Create threads for testing the synchronized method
    val thread1 = createThread(() => for (_ <- 1 to 1000) moveOneUnit())
    val thread2 = createThread(() => for (_ <- 1 to 1000) moveOneUnit())

    thread1.start()
    thread2.start()

    thread1.join()
    thread2.join()

    println(s"value1: $value1, value2: $value2")  // Should print consistent values

    // Another approach could be using AtomicInteger for thread-safe operations without synchronization blocks.

    // Task 3b
    // This code is designed to simulate race conditions due to shared mutable variables value1 and value2. 
    // The issue arises because multiple threads modify the variables concurrently without synchronization.
    // The code is supposed to increment value2 and decrement value1 while ensuring their sum remains constant. 
    // However, due to the lack of thread safety, the values get corrupted. This would not occur in Oz because 
    // Oz uses dataflow variables and avoids race conditions by design, using single-assignment variables.

    def execute(): Unit = {
        while (true) {
        moveOneUnit()
        println(s"Sum: ${value1 + value2}")
        Thread.sleep(100)  // Slow down to observe the output
        }
    }

    // Starting a thread to run the loop
    val safeThread = createThread(() => execute())
    safeThread.start()
}