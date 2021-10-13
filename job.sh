#!/bin/bash
_source="rsync://mirrorservice.org/repo.manjaro.org/repos/pool/";
_target="${PWD}/registry" && mkdir -p "$_target"
_tmp="$PWD/.tmp" && mkdir -p "$_tmp";
_log_file="$_tmp/.logfile";

function sync_pkgs() {
	echo "===== Syncing packages ...";


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
		--exclude=overlay --exclude=sync \
		${_source} "${_target}" 2>/dev/null | tee "$_log_file";

		# --exclude=stable --exclude=stable-staging \
		# --exclude=unstable --exclude=testing \
		# --exclude=arm-testing --exclude=arm-unstable \
}

function upload_pkgs() {
	echo "===== Uploading synced packages ...";
	gh auth login --with-token <<<"$API_GITHUB_TOKEN";
	cd registry
	gh release upload packages $(grep -v '/$' "$_log_file" | xargs) --clobber;
}

sync_pkgs
upload_pkgs
