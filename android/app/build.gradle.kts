plugins {
    id("com.android.application")
    id("kotlin-android") // Ensure Kotlin plugin is applied
    id("dev.flutter.flutter-gradle-plugin") // Apply Flutter plugin after Android and Kotlin
}

android {
    namespace = "com.blank.rent_a_car"
    compileSdk = flutter.compileSdkVersion

    // ✅ Override NDK version manually
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.blank.rent_a_car"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Customize for release signing if needed
        }
    }
}

flutter {
    source = "../.."
}

apply(plugin = "com.google.gms.google-services") // Apply Google services plugin (for Firebase)
