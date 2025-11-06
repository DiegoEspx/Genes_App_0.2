plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase (si lo usas)
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.genesapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.genesapp"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // ☕ Java/Kotlin 17
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        getByName("debug") {
            // En debug no se minifica ni se eliminan recursos
            isMinifyEnabled = false
            isShrinkResources = false
        }
        getByName("release") {
            // Firma de ejemplo (cámbiala si tienes tu keystore de release)
            signingConfig = signingConfigs.getByName("debug")

            // Si NO quieres minificar ni eliminar recursos en release:
            isMinifyEnabled = false
            isShrinkResources = false

            // Si en el futuro activas minify/shrink, descomenta:
            // isMinifyEnabled = true
            // isShrinkResources = true
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro"
            // )
        }
    }
}

flutter {
    source = "../.."
}
