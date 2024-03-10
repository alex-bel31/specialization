import java.sql.Connection;
import java.sql.SQLException;

public class Application {
    public static void main(String[] args) {
        try (Connection connection = DatabaseManager.getConnection()) {
            AnimalRegistry animalRegistry = new AnimalRegistry(connection);
            animalRegistry.start();
        } catch (SQLException e) {
            System.err.println("Сбой подключения к базе данных: " + e.getMessage());
        }
    }
}

