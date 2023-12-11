import org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi
import org.jetbrains.kotlin.gradle.targets.js.webpack.KotlinWebpackConfig

plugins {
    val kotlinVersion: String by System.getProperties()
    kotlin("plugin.serialization") version kotlinVersion
    kotlin("multiplatform") version kotlinVersion
    val kvisionVersion: String by System.getProperties()
    id("io.kvision") version kvisionVersion
}

version = "1.0.0-SNAPSHOT"
group = "com.tomwyr"

repositories {
    mavenCentral()
    mavenLocal()
}

// Versions
val kotlinVersion: String by System.getProperties()
val kvisionVersion: String by System.getProperties()
val ktorVersion: String by project
val koinKspVersion: String by project
val exposedVersion: String by project
val hikariVersion: String by project
val h2Version: String by project
val pgsqlVersion: String by project
val kweryVersion: String by project
val logbackVersion: String by project
val commonsCodecVersion: String by project
val jdbcNamedParametersVersion: String by project

val mainClassName = "io.ktor.server.netty.EngineMain"

kotlin {
    jvmToolchain(20)
    jvm {
        compilations.all {
            kotlinOptions {
                freeCompilerArgs = listOf("-Xjsr305=strict")
            }
        }
        @OptIn(ExperimentalKotlinGradlePluginApi::class)
        mainRun {
            mainClass.set(mainClassName)
        }
    }
    js(IR) {
        browser {
            runTask {
                mainOutputFileName = "main.bundle.js"
                sourceMaps = false
                devServer = KotlinWebpackConfig.DevServer(
                        open = false,
                        port = 3000,
                        proxy = mutableMapOf(
                                "/kv/*" to "http://localhost:8080",
                                "/login" to "http://localhost:8080",
                                "/logout" to "http://localhost:8080",
                                "/kvws/*" to mapOf("target" to "ws://localhost:8080", "ws" to true)
                        ),
                        static = mutableListOf("${layout.buildDirectory.asFile.get()}/processedResources/js/main")
                )
            }
            webpackTask {
                mainOutputFileName = "main.bundle.js"
            }
            testTask {
                useKarma {
                    useChromeHeadless()
                }
            }
        }
        binaries.executable()
    }
    sourceSets {
        val commonMain by getting {
            dependencies {
                api("io.kvision:kvision-server-ktor-koin:$kvisionVersion")
                implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.4.1")
                implementation("io.ktor:ktor-client-core:$ktorVersion")
                implementation("io.ktor:ktor-client-content-negotiation:$ktorVersion")
                implementation("io.ktor:ktor-serialization-kotlinx-json:$ktorVersion")
                implementation("com.michael-bull.kotlin-result:kotlin-result:1.1.18")
            }
        }
        val commonTest by getting {
            dependencies {
                implementation(kotlin("test-common"))
                implementation(kotlin("test-annotations-common"))
            }
        }
        val jvmMain by getting {
            dependencies {
                implementation(kotlin("reflect"))
                implementation("io.ktor:ktor-serialization-kotlinx-json:$ktorVersion")
                implementation("io.ktor:ktor-serialization:$ktorVersion")
                implementation("io.ktor:ktor-server-netty:$ktorVersion")
                implementation("io.ktor:ktor-server-auth:$ktorVersion")
                implementation("io.ktor:ktor-server-compression:$ktorVersion")
                implementation("io.ktor:ktor-server-default-headers:$ktorVersion")
                implementation("io.ktor:ktor-server-compression:$ktorVersion")
                implementation("io.ktor:ktor-server-call-logging:$ktorVersion")
                implementation("io.ktor:ktor-server-caching-headers:$ktorVersion")
                implementation("io.ktor:ktor-client-core:$ktorVersion")
                implementation("io.ktor:ktor-client-content-negotiation:$ktorVersion")
                implementation("io.ktor:ktor-client-okhttp:$ktorVersion")
                implementation("ch.qos.logback:logback-classic:$logbackVersion")
                implementation("com.h2database:h2:$h2Version")
                implementation("org.jetbrains.exposed:exposed:$exposedVersion")
                implementation("org.postgresql:postgresql:$pgsqlVersion")
                implementation("com.zaxxer:HikariCP:$hikariVersion")
                implementation("commons-codec:commons-codec:$commonsCodecVersion")
                implementation("com.axiomalaska:jdbc-named-parameters:$jdbcNamedParametersVersion")
                implementation("com.github.andrewoma.kwery:core:$kweryVersion")
                implementation("io.insert-koin:koin-annotations:$koinKspVersion")
                implementation("com.charleskorn.kaml:kaml:0.55.0")
                implementation("com.github.ben-manes.caffeine:caffeine:2.8.8")
            }
            kotlin.srcDir("build/generated/ksp/jvm/jvmMain/kotlin")
        }
        val jvmTest by getting {
            dependencies {
                implementation(kotlin("test"))
                implementation(kotlin("test-junit"))
            }
        }
        val jsMain by getting {
            dependencies {
                implementation("io.kvision:kvision:$kvisionVersion")
                implementation("io.kvision:kvision-bootstrap:$kvisionVersion")
                implementation("io.kvision:kvision-state:$kvisionVersion")
                implementation("io.kvision:kvision-fontawesome:$kvisionVersion")
                implementation(npm("@js-joda/timezone", "2.18.2"))
            }
        }
        val jsTest by getting {
            dependencies {
                implementation(kotlin("test-js"))
                implementation("io.kvision:kvision-testutils:$kvisionVersion")
            }
        }
    }
}

dependencies {
    implementation(project(":"))
    add("kspJvm", "io.insert-koin:koin-ksp-compiler:$koinKspVersion")
}

afterEvaluate {
    tasks {
        getByName("kspKotlinJvm").apply {
            dependsOn("kspCommonMainKotlinMetadata")
        }
    }
}