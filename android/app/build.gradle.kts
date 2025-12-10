plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("kotlin-android")
}

android {
    namespace = "com.example.flutter_app"

    // --- FIX 1: Update Compile SDK to 36 (Required by camera_android) ---
    compileSdk = 36

    // --- FIX 2: Set specific NDK version (Required by multiple plugins) ---
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_app"

        // --- FIX 3: Set Min SDK to 24 (Required for camera/video plugins) ---
        minSdk = 24

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    packaging {
        jniLibs {
            pickFirsts += "lib/x86/libc++_shared.so"
            pickFirsts += "lib/x86_64/libc++_shared.so"
            pickFirsts += "lib/armeabi-v7a/libc++_shared.so"
            pickFirsts += "lib/arm64-v8a/libc++_shared.so"
        }
    }

    aaptOptions {
        noCompress.addAll(listOf("task", "bin", "tflite"))
    }
}

flutter {
    source = "../.."
}
dependencies {
}