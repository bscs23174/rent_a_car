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
        isCoreLibraryDesugaringEnabled = true // ✅ Correct
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.blank.rent_a_car"
        minSdk = 21
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

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.10")
}