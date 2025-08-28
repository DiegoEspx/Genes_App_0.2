plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter
}

android {
    namespace = "com.example.genesapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        // Sube de 1_8 a 11
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        // Sube de "1.8" a "11"
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.genesapp"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
