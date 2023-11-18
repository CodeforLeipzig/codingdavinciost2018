group = "de.oklab.leipzig.cdv"
version = "1.0.0-SNAPSHOT"

plugins {
    application
    kotlin("jvm")
    idea
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-gradle-plugin:_")
    implementation("com.fasterxml.jackson.core:jackson-core:_")
    implementation("com.fasterxml.jackson.core:jackson-annotations:_")
    implementation("com.fasterxml.jackson.core:jackson-databind:_")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin:_")
    implementation("com.fasterxml.jackson.datatype:jackson-datatype-jsr310:_")
    implementation("com.github.victools:jsonschema-generator:_")
    implementation("com.github.jasminb:jsonapi-converter:_")
    implementation("de.grundid.opendatalab:geojson-jackson:_")
    implementation("org.apache.commons:commons-imaging:_")
    implementation("commons-io:commons-io:_")
    implementation("org.apache.commons:commons-collections4:_")
    implementation("org.apache.poi:poi:_")
    implementation("org.apache.poi:poi-ooxml:_")
    implementation("org.apache.logging.log4j:log4j-core:_")
    implementation(kotlin("stdlib"))
    testImplementation(kotlin("test"))
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
    testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile> {
    kotlinOptions {
        jvmTarget = "17"

        freeCompilerArgs += listOf("-Xuse-ir")
    }
}

tasks.test {
    useJUnitPlatform()
}