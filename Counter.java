public class Counter implements AutoCloseable {
    private int count;

    public void add() {
        count++;
        System.out.println("Счетчик увеличен: " + count);
    }

    @Override
    public void close() {
        System.out.println("Счетчик закрыт");
    }
}

