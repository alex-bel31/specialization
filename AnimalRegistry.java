import java.sql.*;
import java.util.Scanner;

public class AnimalRegistry {
    private final Connection connection;

    public AnimalRegistry(Connection connection) {
        this.connection = connection;
    }

    public void start() {
        try (Counter counter = new Counter()) {
            Scanner scanner = new Scanner(System.in);
            boolean running = true;
            while (running) {
                System.out.println("1. Завести новое животное");
                System.out.println("2. Определить животное в правильный класс");
                System.out.println("3. Увидеть список команд, которое выполняет животное");
                System.out.println("4. Обучить животное новым командам");
                System.out.println("5. Выход");

                System.out.print("Выберите действие: ");
                int choice = scanner.nextInt();
                scanner.nextLine();  

                switch (choice) {
                    case 1:
                        addNewAnimal();
                        break;
                    case 2:
                        defineAnimalClass();
                        break;
                    case 3:
                        showAnimalCommands();
                        break;
                    case 4:
                        teachAnimalCommands();
                        break;
                    case 5:
                        running = false;
                        break;
                    default:
                        System.out.println("Неверный выбор. Попробуйте снова.");
                }
            }
        }
    }

    private void addNewAnimal() {
        try (Scanner scanner = new Scanner(System.in)) {
            try {
                System.out.println("Выберите тип животного: ");
                System.out.println("1. Pet animal");
                System.out.println("2. Pack animal");
                int animalTypeChoice = scanner.nextInt();
                scanner.nextLine(); 
   
                System.out.print("Введите имя животного: ");
                String name = scanner.nextLine();
   
                System.out.print("Введите дату рождения животного (гггг-мм-дд): ");
                String birthDate = scanner.nextLine();
   
                PreparedStatement preparedStatement;
                if (animalTypeChoice == 1) {
                    System.out.print("Введите класс животного: ");
                    String petClass = scanner.nextLine();
                    preparedStatement = connection.prepareStatement("INSERT INTO pet_animal (class) VALUES (?)", Statement.RETURN_GENERATED_KEYS);
                    preparedStatement.setString(1, petClass);
                    preparedStatement.executeUpdate();
   
                    ResultSet generatedKeys = preparedStatement.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        long animalId = generatedKeys.getLong(1);
                        preparedStatement = connection.prepareStatement("INSERT INTO dogs (name, birth_date, pet_animal_id) VALUES (?, ?, ?)");
                        preparedStatement.setString(1, name);
                        preparedStatement.setDate(2, Date.valueOf(birthDate));
                        preparedStatement.setLong(3, animalId);
                        preparedStatement.executeUpdate();
                        System.out.println("Животное успешно добавлено.");
                    }
                } else if (animalTypeChoice == 2) {
                    System.out.print("Введите класс животного: ");
                    String packClass = scanner.nextLine();
                    preparedStatement = connection.prepareStatement("INSERT INTO pack_animal (class) VALUES (?)", Statement.RETURN_GENERATED_KEYS);
                    preparedStatement.setString(1, packClass);
                    preparedStatement.executeUpdate();
   
                    ResultSet generatedKeys = preparedStatement.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        long animalId = generatedKeys.getLong(1);
                        preparedStatement = connection.prepareStatement("INSERT INTO horses (name, birth_date, pack_animal_id) VALUES (?, ?, ?)");
                        preparedStatement.setString(1, name);
                        preparedStatement.setDate(2, Date.valueOf(birthDate));
                        preparedStatement.setLong(3, animalId);
                        preparedStatement.executeUpdate();
                        System.out.println("Животное успешно добавлено.");
                    }
                } else {
                    System.out.println("Неверный выбор.");
                }
            } catch (SQLException e) {
                System.err.println("Ошибка при добавлении животного: " + e.getMessage());
            }
        }
    }

    private void showAnimalCommands() {
        try (Scanner scanner = new Scanner(System.in)) {
            try {
                System.out.print("Введите имя животного: ");
                String name = scanner.nextLine();
   
                PreparedStatement preparedStatement = connection.prepareStatement("SELECT command FROM dogs WHERE name = ?");
                preparedStatement.setString(1, name);
                ResultSet resultSet = preparedStatement.executeQuery();
                if (resultSet.next()) {
                    String commands = resultSet.getString("command");
                    System.out.println("Список команд для " + name + ": " + commands);
                } else {
                    System.out.println("Животное с таким именем не найдено.");
                }
            } catch (SQLException e) {
                System.err.println("Ошибка при просмотре команд животного: " + e.getMessage());
            }
        }
    }
    
    private void defineAnimalClass() {
        try (Scanner scanner = new Scanner(System.in)) {
            try {
                System.out.print("Введите имя животного: ");
                String name = scanner.nextLine();
   
                PreparedStatement preparedStatement = connection.prepareStatement("SELECT type FROM animal WHERE id IN (SELECT animal_id FROM pet_animal WHERE id IN (SELECT pet_animal_id FROM dogs WHERE name = ?))");
                preparedStatement.setString(1, name);
                ResultSet resultSet = preparedStatement.executeQuery();
                if (resultSet.next()) {
                    String animalType = resultSet.getString("type");
                    System.out.println("Тип животного " + name + ": " + animalType);
                } else {
                    System.out.println("Животное с таким именем не найдено.");
                }
            } catch (SQLException e) {
                System.err.println("Ошибка при определении класса животного: " + e.getMessage());
            }
        }
    }

    private void teachAnimalCommands() {
        try (Scanner scanner = new Scanner(System.in)) {
            try {
                System.out.print("Введите имя животного: ");
                String name = scanner.nextLine();
   
                System.out.print("Введите новую команду для животного: ");
                String newCommand = scanner.nextLine();
   
                PreparedStatement preparedStatement = connection.prepareStatement("UPDATE dogs SET command = CONCAT(command, ', ', ?) WHERE name = ?");
                preparedStatement.setString(1, newCommand);
                preparedStatement.setString(2, name);
                int rowsAffected = preparedStatement.executeUpdate();
                if (rowsAffected > 0) {
                    System.out.println("Животное успешно обучено новой команде.");
                } else {
                    System.out.println("Животное с таким именем не найдено.");
                }
            } catch (SQLException e) {
                System.err.println("Ошибка при обучении животного: " + e.getMessage());
            }
        }
    }
}

