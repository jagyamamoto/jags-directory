#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SERVICES="$HOME/Library/Services"

escape_xml() {
  sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g' "$1"
}

write_info_file_service() {
  local path="$1"
  local name="$2"
  cat >"$path" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSServices</key>
	<array>
		<dict>
			<key>NSBackgroundColorName</key><string>background</string>
			<key>NSIconName</key><string>NSActionTemplate</string>
			<key>NSMenuItem</key><dict><key>default</key><string>${name}</string></dict>
			<key>NSMessage</key><string>runWorkflowAsService</string>
			<key>NSSendFileTypes</key><array><string>public.item</string></array>
		</dict>
	</array>
</dict>
</plist>
PLIST
}

write_info_text_service() {
  local path="$1"
  local name="$2"
  cat >"$path" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>NSServices</key>
	<array>
		<dict>
			<key>NSBackgroundColorName</key><string>background</string>
			<key>NSIconName</key><string>NSActionTemplate</string>
			<key>NSMenuItem</key><dict><key>default</key><string>${name}</string></dict>
			<key>NSMessage</key><string>runWorkflowAsService</string>
			<key>NSSendTypes</key>
			<array>
				<string>NSStringPboardType</string>
				<string>NSRTFPboardType</string>
				<string>public.plain-text</string>
				<string>public.utf8-plain-text</string>
				<string>public.rtf</string>
				<string>public.url</string>
				<string>public.file-url</string>
			</array>
		</dict>
	</array>
</dict>
</plist>
PLIST
}

write_workflow() {
  local path="$1"
  local script="$2"
  local input_method="$3"
  local input_type="$4"
  local application_bundle_id="$5"
  local service_application_path="$6"
  local uuid1 uuid2 uuid3
  uuid1="$(uuidgen)"
  uuid2="$(uuidgen)"
  uuid3="$(uuidgen)"

  cat >"$path" <<HEAD
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>AMApplicationBuild</key><string>528</string>
	<key>AMApplicationVersion</key><string>2.10</string>
	<key>AMDocumentVersion</key><string>2</string>
	<key>actions</key>
	<array>
		<dict>
			<key>action</key>
			<dict>
				<key>AMAccepts</key>
				<dict>
					<key>Container</key><string>List</string>
					<key>Optional</key><true/>
					<key>Types</key><array><string>com.apple.cocoa.string</string></array>
				</dict>
				<key>AMActionVersion</key><string>2.0.3</string>
				<key>AMApplication</key><array><string>Automator</string></array>
				<key>AMParameterProperties</key>
				<dict>
					<key>COMMAND_STRING</key><dict/>
					<key>CheckedForUserDefaultShell</key><dict/>
					<key>inputMethod</key><dict/>
					<key>shell</key><dict/>
					<key>source</key><dict/>
				</dict>
				<key>AMProvides</key>
				<dict>
					<key>Container</key><string>List</string>
					<key>Types</key><array><string>com.apple.cocoa.string</string></array>
				</dict>
				<key>ActionBundlePath</key><string>/System/Library/Automator/Run Shell Script.action</string>
				<key>ActionName</key><string>Run Shell Script</string>
				<key>ActionParameters</key>
				<dict>
					<key>COMMAND_STRING</key><string>
HEAD

  escape_xml "$script" >>"$path"

  cat >>"$path" <<TAIL
</string>
					<key>CheckedForUserDefaultShell</key><true/>
					<key>inputMethod</key><integer>${input_method}</integer>
					<key>shell</key><string>/bin/bash</string>
					<key>source</key><string></string>
				</dict>
				<key>BundleIdentifier</key><string>com.apple.RunShellScript</string>
				<key>CFBundleVersion</key><string>2.0.3</string>
				<key>CanShowSelectedItemsWhenRun</key><false/>
				<key>CanShowWhenRun</key><true/>
				<key>Category</key><array><string>AMCategoryUtilities</string></array>
				<key>Class Name</key><string>RunShellScriptAction</string>
				<key>InputUUID</key><string>${uuid2}</string>
				<key>OutputUUID</key><string>${uuid3}</string>
				<key>UUID</key><string>${uuid1}</string>
				<key>UnlocalizedApplications</key><array><string>Automator</string></array>
				<key>arguments</key>
				<dict>
					<key>0</key><dict><key>default value</key><integer>0</integer><key>name</key><string>inputMethod</string><key>required</key><string>0</string><key>type</key><string>0</string><key>uuid</key><string>0</string></dict>
					<key>1</key><dict><key>default value</key><false/><key>name</key><string>CheckedForUserDefaultShell</string><key>required</key><string>0</string><key>type</key><string>0</string><key>uuid</key><string>1</string></dict>
					<key>2</key><dict><key>default value</key><string></string><key>name</key><string>source</string><key>required</key><string>0</string><key>type</key><string>0</string><key>uuid</key><string>2</string></dict>
					<key>3</key><dict><key>default value</key><string></string><key>name</key><string>COMMAND_STRING</string><key>required</key><string>0</string><key>type</key><string>0</string><key>uuid</key><string>3</string></dict>
					<key>4</key><dict><key>default value</key><string>/bin/sh</string><key>name</key><string>shell</string><key>required</key><string>0</string><key>type</key><string>0</string><key>uuid</key><string>4</string></dict>
				</dict>
				<key>conversionLabel</key><integer>0</integer>
				<key>isViewVisible</key><integer>1</integer>
				<key>location</key><string>697.500000:305.000000</string>
				<key>nibPath</key><string>/System/Library/Automator/Run Shell Script.action/Contents/Resources/Base.lproj/main.nib</string>
			</dict>
			<key>isViewVisible</key><integer>1</integer>
		</dict>
	</array>
	<key>connectors</key><dict/>
	<key>workflowMetaData</key>
	<dict>
TAIL

  if [ -n "$application_bundle_id" ]; then
    cat >>"$path" <<TAIL
		<key>applicationBundleID</key><string>${application_bundle_id}</string>
		<key>applicationBundleIDsByPath</key><dict><key>${service_application_path}</key><string>${application_bundle_id}</string></dict>
		<key>applicationPath</key><string>${service_application_path}</string>
		<key>applicationPaths</key><array><string>${service_application_path}</string></array>
TAIL
  else
    cat >>"$path" <<'TAIL'
		<key>applicationBundleIDsByPath</key><dict/>
		<key>applicationPaths</key><array/>
TAIL
  fi

  cat >>"$path" <<TAIL
		<key>inputTypeIdentifier</key><string>${input_type}</string>
		<key>outputTypeIdentifier</key><string>com.apple.Automator.nothing</string>
		<key>presentationMode</key><integer>15</integer>
		<key>processesInput</key><false/>
TAIL

  if [ -n "$application_bundle_id" ]; then
    cat >>"$path" <<TAIL
		<key>serviceApplicationBundleID</key><string>${application_bundle_id}</string>
		<key>serviceApplicationPath</key><string>${service_application_path}</string>
TAIL
  fi

  cat >>"$path" <<TAIL
		<key>serviceInputTypeIdentifier</key><string>${input_type}</string>
		<key>serviceOutputTypeIdentifier</key><string>com.apple.Automator.nothing</string>
		<key>serviceProcessesInput</key><false/>
		<key>systemImageName</key><string>NSActionTemplate</string>
		<key>useAutomaticInputType</key><false/>
		<key>workflowTypeIdentifier</key><string>com.apple.Automator.servicesMenu</string>
	</dict>
</dict>
</plist>
TAIL
}

install_service() {
  local name="$1"
  local script="$2"
  local kind="$3"
  local input_method="$4"
  local input_type="$5"
  local app_bundle="${6:-}"
  local app_path="${7:-}"

  local workflow="$SERVICES/${name}.workflow"
  local contents="$workflow/Contents"
  mkdir -p "$contents"

  if [ "$kind" = "file" ]; then
    write_info_file_service "$contents/Info.plist" "$name"
  else
    write_info_text_service "$contents/Info.plist" "$name"
  fi

  write_workflow "$contents/document.wflow" "$script" "$input_method" "$input_type" "$app_bundle" "$app_path"
  plutil -lint "$contents/Info.plist" >/dev/null
  plutil -lint "$contents/document.wflow" >/dev/null
  echo "Installed: $workflow"
}

chmod +x "$ROOT"/scripts/*.sh
mkdir -p "$SERVICES"

install_service \
  "Jag's directory: Copy file link" \
  "$ROOT/scripts/copy-file-link.sh" \
  "file" \
  1 \
  "com.apple.Automator.fileSystemObject" \
  "com.apple.finder" \
  "/System/Library/CoreServices/Finder.app"

install_service \
  "Jag's directory: Open file link in Finder" \
  "$ROOT/scripts/open-file-link.sh" \
  "text" \
  0 \
  "com.apple.Automator.text"

install_service \
  "Jag's directory: Set modified date to now" \
  "$ROOT/scripts/touch-modified-now.sh" \
  "file" \
  1 \
  "com.apple.Automator.fileSystemObject" \
  "com.apple.finder" \
  "/System/Library/CoreServices/Finder.app"

/System/Library/CoreServices/pbs -update 2>/dev/null || true
/System/Library/CoreServices/pbs -flush 2>/dev/null || true

echo
echo "Jag's directory is installed."
echo "If the Services menu does not update immediately, restart Finder or log out and back in."
