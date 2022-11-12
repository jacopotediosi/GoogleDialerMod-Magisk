# GoogleDialerMod-Magisk by JacopoMii
# Magisk Module Installer Script

# Set to true if you do *NOT* want Magisk to mount any files for you
# Most modules would NOT want to set this flag to true
SKIPMOUNT=false
# Set to true if you need to load system.prop
PROPFILE=false
# Set to true if you need post-fs-data script
POSTFSDATA=false
# Set to true if you need late_start service script
LATESTARTSERVICE=false

print_modname() {
	ui_print "++++++++++++++++++++++++++++++++"
	ui_print "  ++ GoogleDialerMod-Magisk ++  "
	ui_print "         by JacopoMii           "
	ui_print "++++++++++++++++++++++++++++++++"
}

on_install() {
	DIALER_PACKAGE="com.google.android.dialer"
	DIALER_USER=$(stat -c '%U' "/data/data/$DIALER_PACKAGE/files/")
	DIALER_DATA_PATH="/data/data/$DIALER_PACKAGE"
	PHENOTYPE_PATH="/data/data/com.google.android.gms/databases/phenotype.db"
	PHENOTYPE_CACHE="$DIALER_DATA_PATH/files/phenotype"
	CALLRECORDINGPROMPT="$DIALER_DATA_PATH/files/callrecordingprompt"
	
	ENABLE_CALL_RECORDING_FLAGS="G__enable_call_recording \
	CallRecording__enable_call_recording_for_fi \
	G__force_within_call_recording_geofence_value \
	G__use_call_recording_geofence_overrides \
	G__force_within_crosby_geofence_value"
    SILENCE_CALL_RECORDING_ALERTS_FLAGS="CallRecording__call_recording_countries_with_built_in_audio_file \
	CallRecording__call_recording_force_enable_built_in_audio_file_countries \
	CallRecording__call_recording_force_enable_tts_countries \
	CallRecording__call_recording_countries \
	CallRecording__crosby_countries"
	
	delete_flag_override() { # Arguments: Flag to delete
		"$SQLITE3" -batch "$PHENOTYPE_PATH" "DELETE FROM FlagOverrides WHERE packageName = '$DIALER_PACKAGE' AND name = '$1')"
	}
	
	update_boolean_flag() { # Arguments: Flag to update, new value
		delete_flag_override "$1"
		"$SQLITE3" -batch -list "$PHENOTYPE_PATH" "SELECT DISTINCT user FROM Flags WHERE packageName = 'com.google.android.dialer'" | while read PHENOTYPE_USER; do "$SQLITE3" -batch "$PHENOTYPE_PATH" "INSERT OR REPLACE INTO FlagOverrides(packageName, user, name, flagType, boolVal, committed) VALUES('$DIALER_PACKAGE', '$PHENOTYPE_USER', '$1', 0, '$2', 0)"; done
	}
	
	update_string_flag() { # Arguments: Flag to update, new value
		delete_flag_override "$1"
		"$SQLITE3" -batch -list "$PHENOTYPE_PATH" "SELECT DISTINCT user FROM Flags WHERE packageName = 'com.google.android.dialer'" | while read PHENOTYPE_USER; do "$SQLITE3" -batch "$PHENOTYPE_PATH" "INSERT OR REPLACE INTO FlagOverrides(packageName, user, name, flagType, stringVal, committed) VALUES('$DIALER_PACKAGE', '$PHENOTYPE_USER', '$1', 0, '$2', 0)"; done
	}
	
	ui_print " - Checking your CPU architecture"
	if [ "$ARCH" = "arm" ] || [ "$ARCH" = "arm64" ]; then
		DEVICE_ARCH=arm
	elif [ "$ARCH" = "x86" ] || [ "$ARCH" = "x64" ]; then
		DEVICE_ARCH="x86"
	else
		ui_print " - Error > Unknown CPU architecture $ARCH"
		ui_print " - Exiting..."
		abort
	fi
	
	ui_print " - Checking the Phenotype DB existence"
	if [ ! -f "$PHENOTYPE_PATH" ]; then
		ui_print " - Error > Phenotype DB not found"
		ui_print " - Exiting..."
		abort
	fi
	
	ui_print " - Checking access to the Dialer data folder"
	if [ ! -d "$DIALER_DATA_PATH" ]; then
		ui_print " - Error > Cannot find the $DIALER_DATA_PATH path"
		ui_print " - Exiting..."
		abort
	fi
	
	ui_print " - Extracting files"
	unzip -o "$ZIPFILE" "sqlite/$DEVICE_ARCH/sqlite3" -d "$MODPATH" >&2
	SQLITE3="$MODPATH/sqlite/$DEVICE_ARCH/sqlite3"
	unzip -o "$ZIPFILE" "to-tmpdir/*" -d "$TMPDIR" >&2
	mv "$TMPDIR"/to-tmpdir/* "$TMPDIR"
	rm -rf "$TMPDIR/to-tmpdir"
	
	ui_print " - Setting files permissions"
	set_perm "$SQLITE3" 0 2000 0755
	
	ui_print " - Preparing Volume Key Selector Addon"
	source "$TMPDIR/volume-key-selector/install.sh"
	
	ui_print " - Killing Google Dialer"
	am kill all "$DIALER_PACKAGE"
	
	ui_print " - Deleting Phenotype Cache"
	rm -r "$PHENOTYPE_CACHE"
	
	ui_print " - Do you want to force enable call recording?"
	ui_print "   (Vol+ YES, Vol- NO)"
	if chooseport 10; then
		ui_print " - Force enabling call recording"
		for FLAG in $ENABLE_CALL_RECORDING_FLAGS; do
			update_boolean_flag "$FLAG" 1
		done
	else
		ui_print " - You chose NO"
	fi
	
	ui_print " - Do you want to silence annoying"
	ui_print "   call recording sound alerts?"
	ui_print "   (Vol+ YES, Vol- NO)"
	if chooseport 10; then
		ui_print " - Silencing annoying alerts"
		for FLAG in $SILENCE_CALL_RECORDING_ALERTS_FLAGS; do
			update_string_flag "$FLAG" ""
		done
		rm -rf "$CALLRECORDINGPROMPT"
		mkdir "$CALLRECORDINGPROMPT"
		cp "$TMPDIR/silent_wav.wav" "$CALLRECORDINGPROMPT/starting_voice-en_US.wav"
		cp "$TMPDIR/silent_wav.wav" "$CALLRECORDINGPROMPT/ending_voice-en_US.wav"
		chown -R "$DIALER_USER:$DIALER_USER" "$CALLRECORDINGPROMPT"
		chmod -R 777 "$CALLRECORDINGPROMPT"
		restorecon -R "$CALLRECORDINGPROMPT"
	else
		ui_print " - You chose NO"
	fi
}

set_permissions() {
	set_perm_recursive "$MODPATH" 0 0 0755 0644
}