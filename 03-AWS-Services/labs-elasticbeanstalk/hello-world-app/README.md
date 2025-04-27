# Hello World Spring Boot Application

This is a simple Spring Boot application that demonstrates a basic "Hello, World!" REST API.

## Project Structure

```
hello-world-app
├── src
│   ├── main
│   │   ├── java
│   │   │   └── io
│   │   │       └── glaciar
│   │   │           └── elbns
│   │   │               └── helloworld
│   │   │                   ├── HelloWorldApplication.java
│   │   │                   └── controller
│   │   │                       └── HelloWorldController.java
│   │   └── resources
│   │       ├── application.properties
│   │       └── static
│   └── test
│       └── java
│           └── io
│               └── glaciar
│                   └── elbns
│                       └── helloworld
│                           └── HelloWorldApplicationTests.java
├── pom.xml
└── README.md
```

## Prerequisites

- Java 11 or higher
- Maven

## Build the Application

To build the application, navigate to the project directory and run:

```
mvn clean package
```

## Run the Application

To run the application, use the following command:

```
mvn spring-boot:run
```

## Access the API

Once the application is running, you can access the "Hello, World!" message by navigating to:

```
http://localhost:8080/hello
```

## Testing

To run the tests, execute:

```
mvn test
```

## License

This project is licensed under the MIT License.