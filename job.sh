#!/bin/bash
_target="${PWD}/manjaro" && mkdir -p "$_target"
_tmp="$PWD/.tmp" && mkdir -p "$_tmp";
_log_file="$_tmp/.logfile";

function sync_pkgs() {
	echo "===== Syncing packages ...";

	local _source="rsync://mirrorservice.org/repo.manjaro.org/repos/pool/";

	if ! stty &>/dev/null; then
		local _extra_args+=("-q");
	fi

	rsync -rtlH --safe-links \
		--out-format="%n" \
		-h "${_extra_args[@]}" --timeout=12000 \
		--contimeout=1200 -p \
		--delay-updates --no-motd \
		--temp-dir="${_tmp}" --ignore-existing \
		--exclude='*.sig' \
		--exclude=pool/overlay --exclude=pool/sync \
		${_source} "${_target}" 2>/dev/null

		# --exclude=stable --exclude=stable-staging \
		# --exclude=unstable --exclude=testing \
		# --exclude=arm-testing --exclude=arm-unstable \
}

function upload_pkgs() {
	echo "===== Uploading synced packages ...";
	gh auth login --with-token <<<"$API_GITHUB_TOKEN";
	gh release upload $(grep -v '/$' "$_log_file" | xargs);
}

sync_pkgs;
upload_pkgs;
