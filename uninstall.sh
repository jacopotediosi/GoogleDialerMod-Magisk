SQLITE3="$MODPATH/sqlite/$ARCH32/sqlite3"
DIALER_PACKAGE="com.google.android.dialer"
PHENOTYPE_PATH="/data/data/com.google.android.gms/databases/phenotype.db"
CALLRECORDINGPROMPT="/data/data/$DIALER_PACKAGE/files/callrecordingprompt"

"$SQLITE3" "$PHENOTYPE_PATH" "DELETE FROM FlagOverrides WHERE packageName = '$DIALER_PACKAGE'"
rm -rf "$CALLRECORDINGPROMPT"