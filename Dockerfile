FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

# Копируем pom.xml и скачиваем зависимости (кэш)
COPY pom.xml .
RUN mvn -q -e -B dependency:go-offline

# Копируем весь проект
COPY src ./src

# Сборка приложения
RUN mvn -q -e -B clean package -DskipTests


FROM eclipse-temurin:17-jre

WORKDIR /app

# Копируем собранный .jar
COPY --from=build /app/target/*.jar app.jar

# Внешний порт
EXPOSE 8080

# Активный профиль по умолчанию
ENV SPRING_PROFILES_ACTIVE=prod

# Команда запуска
CMD ["java", "-jar", "app.jar"]
