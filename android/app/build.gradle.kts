plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}
android {
    namespace = "com.swifttype.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
    compileOptions { sourceCompatibility = JavaVersion.VERSION_17; targetCompatibility = JavaVersion.VERSION_17 }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_17.toString() }
    defaultConfig { applicationId = "com.swifttype.app"; minSdk = 23; targetSdk = flutter.targetSdkVersion; versionCode = 1; versionName = "0.1.0" }
}
flutter { source = "../.." }
