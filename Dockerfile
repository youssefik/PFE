# ÉTAPE 1 : Construction
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# ÉTAPE 2 : Exécution
FROM eclipse-temurin:17-jre
WORKDIR /app

# Dossiers pour les données (volumes)
RUN mkdir -p /app/data/uploads /app/data/history /app/tomcat_temp

# Copier uniquement le WAR
COPY --from=build /app/target/*.war app.war

# Variables d'environnement (à adapter)
ENV SPRING_PROFILES_ACTIVE=prod \
    APP_EXCEL_DDA_PATH=/app/data/DDA.xlsx \
    APP_EXCEL_RISK_PATH=/app/data/risques_final.xlsx \
    APP_EXCEL_ASSETS_PATH=/app/data/Inventaire_Actifs.xlsx \
    APP_EXCEL_JOURNAL_PATH=/app/data/Journal_Amelioration.xlsx

EXPOSE 8080
ENTRYPOINT ["java", "-Djava.io.tmpdir=/app/tomcat_temp", "-jar", "app.war"]