# Maven 빌드 단계
FROM maven:3.8.5-openjdk-17 AS builder

WORKDIR /app

# Maven 종속성을 캐싱하기 위해 pom.xml 먼저 복사
COPY pom.xml .

# 종속성만 먼저 다운로드 (캐싱을 위해)
RUN mvn dependency:go-offline -B

# 소스 코드 복사
COPY src ./src

# 프로젝트 빌드 (WAR 파일 생성)
RUN mvn clean package -DskipTests

# Tomcat을 포함한 실행 환경
FROM tomcat:10-jdk17-temurin

# WAR 파일을 Tomcat에 복사
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
