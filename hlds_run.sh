#!/usr/bin/env bash

set -axe

CONFIG_FILE="/opt/hlds/startup.cfg"

if [ -r "${CONFIG_FILE}" ]; then
    # TODO: make config save/restore mechanism more solid
    set +e
    # shellcheck source=/dev/null
    source "${CONFIG_FILE}"
    set -e
fi

EXTRA_OPTIONS=( "$@" )

EXECUTABLE="/opt/hlds/hlds_run"
GAME="${GAME:-cstrike}"
MAXPLAYERS="${MAXPLAYERS:-32}"
START_MAP="${START_MAP:-de_dust2}"
SERVER_NAME="${SERVER_NAME:-Counter-Strike 1.6 Server}"
START_MONEY="${START_MONEY:-800}"
BUY_TIME="${BUY_TIME:-0.25}"
FRIENDLY_FIRE="${FRIENDLY_FIRE:-1}"
ROUNDTIME="${mp_roundtime:-3}"
TIMELIMIT="${mp_timelimit:-15}"
WINLIMIT="${mp_winlimit:-5}"
MAP_VOTE_RATIO="${mp_mapvoteratio:-0.6}"
MAP_FREEZETIME="${mp_freezetime:-3}"
MAP_AUTOTEAMBALANCE="${mp_autoteambalance:-0}"
MAP_MAXROUNDS="${mp_maxrounds:-0}"

OPTIONS=( "-game" "${GAME}" "+maxplayers" "${MAXPLAYERS}" "+map" "${START_MAP}" "+hostname" "\"${SERVER_NAME}\"" "+mp_startmoney" "${START_MONEY}" "+mp_friendlyfire" "${FRIENDLY_FIRE}" "+mp_buytime" "${BUY_TIME}" "+mp_roundtime" "${ROUNDTIME}" "+mp_timelimit" "${TIMELIMIT}" "+mp_winlimit" "${WINLIMIT}" "+mp_mapvoteratio" "${MAP_VOTE_RATIO}" "+mp_freezetime" "${MAP_FREEZETIME}" "+mp_autoteambalance" "${MAP_AUTOTEAMBALANCE}" "+mp_maxrounds" "${MAP_MAXROUNDS}")

if [ -z "${RESTART_ON_FAIL}" ]; then
    OPTIONS+=('-norestart')
fi

if [ -n "${SERVER_PASSWORD}" ]; then
    OPTIONS+=("+sv_password" "${SERVER_PASSWORD}")
fi

if [ -n "${RCON_PASSWORD}" ]; then
    OPTIONS+=("+rcon_password" "${RCON_PASSWORD}")
fi

if [ -n "${ADMIN_STEAM}" ]; then
    echo "\"STEAM_${ADMIN_STEAM}\" \"\"  \"abcdefghijklmnopqrstu\" \"ce\"" >> "/opt/hlds/cstrike/addons/amxmodx/configs/users.ini"
fi

set > "${CONFIG_FILE}"

source "/bin/extract_maps.bash"
exec "${EXECUTABLE}" "${OPTIONS[@]}" "${EXTRA_OPTIONS[@]}"
