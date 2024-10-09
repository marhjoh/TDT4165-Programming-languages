object Main extends App {
  def thread(body: => Unit): Thread = {
    new Thread(new Runnable {
      def run(): Unit = body
    })
  }
}