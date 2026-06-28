
-keep class io.agora.** { *; }
-dontwarn io.agora.**

# Flutter and Flutter plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.embedding.engine.**  { *; }
-keep class io.flutter.embedding.android.**  { *; }
-keep class com.google.firebase.** { *; }


# Firebase
-keepnames class com.google.firebase.analytics.FirebaseAnalytics
-keepnames class com.google.android.gms.measurement.AppMeasurement
-keep public class com.google.firebase.crashlytics.internal.common.CommonUtils {
    public static java.lang.String getAppIconHashOrNull(android.content.Context);
}
