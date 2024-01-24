plugins {
    kotlin("jvm") version "1.9.21"
    id("com.google.devtools.ksp") version "1.9.21-1.0.15"
}

dependencies {
    implementation(kotlin("stdlib-jdk8"))
    implementation(project(":annotations"))
    ksp(project(":processor"))
}
