#!/bin/bash

poms=$(find . -name pom.xml | egrep -v initial)

modules=()
for pom in $poms; do
	pom=${pom#./*}
	if ! [ $pom == "pom.xml" ] && [ ${pom#*/target} == $pom ]; then
		dir=${pom%*/pom.xml}
		modules+=($dir)
	fi
done

cat <<EOF
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>

	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>3.1.0</version>
	</parent>

	<groupId>com.example</groupId>
	<artifactId>parent-demo</artifactId>
	<version>0.0.1-SNAPSHOT</version>
	<packaging>pom</packaging>
	<name>Parent Demo</name>

	<modules>
EOF

for module in "${modules[@]}"; do
	echo "		<module>"${module}"</module>"
done

cat <<EOF
	</modules>

	<properties>
		<java.version>17</java.version>
	</properties>

	<repositories>
		<repository>
			<id>spring-libs-snapshot</id>
			<url>http://repo.spring.io/snapshot</url>
			<snapshots>
				<enabled>true</enabled>
			</snapshots>
			<releases>
				<enabled>true</enabled>
			</releases>
		</repository>
	</repositories>
	
	<pluginRepositories>
		<pluginRepository>
			<id>spring-libs-snapshot</id>
			<url>http://repo.spring.io/snapshot</url>
			<snapshots>
				<enabled>true</enabled>
			</snapshots>
			<releases>
				<enabled>true</enabled>
			</releases>
		</pluginRepository>
	</pluginRepositories>

</project>
EOF
