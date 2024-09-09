plugins {
    id "com.android.application"
    // START: FlutterFire Configuration
    id 'com.google.gms.google-services'
    // END: FlutterFire Configuration
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}
android {
    namespace "com.sgx.sgx_online"
    compileSdk 34
    ndkVersion flutter.ndkVersion

    flavorDimensions "environment"

    productFlavors {
        dev {
            dimension "environment"
            applicationId "com.sgx.onlinedev"
            versionNameSuffix "-dev"
            resValue "string", "app_name", "SGX Online Dev"
            manifestPlaceholders = [schemeName: "sgxonline"]
        }
        qa {
            dimension "environment"
            applicationId "com.sgx.online"
            versionNameSuffix "-qa"
            resValue "string", "app_name", "SGX Online QA"
            manifestPlaceholders = [schemeName: "sgxonline"]
        }
        prod {
            dimension "environment"
            applicationId "com.sgx.onlineprod"
            versionNameSuffix ""
            resValue "string", "app_name", "SGX Online"
            manifestPlaceholders = [schemeName: "sgxonline"]
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    signingConfigs {
        defaultDebug {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
        defaultRelease {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
        multiDexEnabled true
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }

    buildTypes {
        debug {
            signingConfig signingConfigs.defaultDebug
            minifyEnabled false
            shrinkResources false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        release {
            signingConfig signingConfigs.defaultRelease
            minifyEnabled false
            shrinkResources false // Explicitly disable resource shrinking here as well
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation 'com.huawei.agconnect:agconnect-core:1.5.2.300'
    implementation 'com.google.code.gson:gson:2.8.0'
}
