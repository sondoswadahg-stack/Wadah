#!/data/data/com.termux/files/usr/bin/bash

echo "🔄 تحديث النظام..."
pkg update -y && pkg upgrade -y

echo "📦 تثبيت الأدوات..."
pkg install openjdk-17 git wget unzip gradle -y

echo "📁 إنشاء مشروع جديد..."
mkdir -p ~/VideoProcessorProject/app/src/main/java/com/example/videoprocessor
mkdir -p ~/VideoProcessorProject/app/src/main/res/layout
cd ~/VideoProcessorProject

# ---------- settings.gradle ----------
cat <<EOL > settings.gradle
rootProject.name = "VideoProcessor"
include ':app'
EOL

# ---------- build.gradle (project) ----------
cat <<EOL > build.gradle
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:7.0.4'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
EOL

# ---------- app/build.gradle ----------
mkdir -p app
cat <<EOL > app/build.gradle
apply plugin: 'com.android.application'

android {
    compileSdkVersion 31
    defaultConfig {
        applicationId "com.example.videoprocessor"
        minSdkVersion 21
        targetSdkVersion 31
        versionCode 1
        versionName "1.0"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.3.1'
    implementation 'com.google.android.material:material:1.4.0'
}
EOL

# ---------- AndroidManifest.xml ----------
mkdir -p app/src/main
cat <<EOL > app/src/main/AndroidManifest.xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.videoprocessor">

    <application
        android:allowBackup="true"
        android:label="VideoProcessor"
        android:icon="@mipmap/ic_launcher"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.AppCompat.Light.NoActionBar">
        <activity android:name=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>

</manifest>
EOL

# ---------- MainActivity.java ----------
cat <<EOL > app/src/main/java/com/example/videoprocessor/MainActivity.java
package com.example.videoprocessor;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }
}
EOL

# ---------- activity_main.xml ----------
cat <<EOL > app/src/main/res/layout/activity_main.xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:gravity="center">
    <TextView

        android:text="🚀 Video Processor جاهز!"
        android:textSize="20sp"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content" />

</LinearLayout>
EOL

echo "⚙️ بدء بناء APK..."
gradle assembleDebug

APK_PATH="app/build/outputs/apk/debug/app-debug.apk"

if [ -f "$APK_PATH" ]; then
    echo "✅ تم البناء بنجاح!"
    echo "📂 ملف APK: $APK_PATH"
    termux-open $APK_PATH
else
    echo "❌ فشل البناء. تحقق من الأخطاء أعلاه."
fi

