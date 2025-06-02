import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
dependencies {

  // Import the Firebase BoM

  implementation(platform("com.google.firebase:firebase-bom:33.12.0"))


  // TODO: Add the dependencies for Firebase products you want to use

  // When using the BoM, don't specify versions in Firebase dependencies

  implementation("com.google.firebase:firebase-analytics")


  // Add the dependencies for any other desired Firebase products

  // https://firebase.google.com/docs/android/setup#available-libraries

}

android {
    namespace = "com.caffeing.caffeing"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.caffeing.caffeing"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = 30
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        if (project.hasProperty("GOOGLE_MAPS_API_KEY")) {
            resValue("string", "google_maps_key", project.property("GOOGLE_MAPS_API_KEY") as String)
        } else {
            println("No GOOGLE_MAPS_API_KEY passed. Falling back to strings.xml.")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
