allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

/* Removed custom build directory configuration to avoid Gradle incompatibility issues */
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
