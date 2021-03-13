#!/usr/bin/env bash

# Exit immediately on non-zero return codes.
set -ex

function install()
{
  mkdir -p $VALHEIM_HOME
  chown $STEAM_USER:$STEAM_USER $VALHEIM_HOME
  gosu $STEAM_USER steamcmd \
    +@ShutdownOnFailedCommand 1 \
    +login anonymous \
    +force_install_dir $VALHEIM_HOME \
    +app_update 896660 \
    $([ -n "$VALHEIM_BRANCH" ] && printf %s "-beta $VALHEIM_BRANCH") \
    $([ -n "$VALHEIM_BRANCH_PASSWORD" ] && printf %s "-betapassword $VALHEIM_BRANCH_PASSWORD") \
    validate \
    +quit \
    && rm -rf $STEAM_HOME/Steam/logs $STEAM_HOME/Steam/appcache/httpcache \
    && find $STEAM_HOME/package -type f ! -name "steam_cmd_linux.installed" ! -name "steam_cmd_linux.manifest" -delete
}

if [ "$1" = 'validate' ]; then
  install
  exit 0
fi

# Run init scripts before starting the server.
if [ "$1" = 'valheim_server.x86_64' ]; then
  # Prepare the data directory.
  mkdir -p /data

  # Link save games
  VALHEIM_DATA=/data/valheim
  VALHEIM_STEAM_SAVE=$STEAM_HOME/.config/unity3d/IronGate/Valheim
  # Create the directory and parent paths
  mkdir -p $VALHEIM_DATA $VALHEIM_STEAM_SAVE
  # Remove the last directory
  rm -rf $VALHEIM_STEAM_SAVE
  # Link world to data
  ln -sf $VALHEIM_DATA $VALHEIM_STEAM_SAVE
  chown -R $STEAM_USER:$STEAM_USER -R /data
  chown -R $STEAM_USER:$STEAM_USER -R $VALHEIM_STEAM_SAVE

  if [ ! -f "$VALHEIM_HOME/valheim_server.x86_64" ]
  then
    install
  fi

  # Run via steam user if the command is `startserver.sh`.
  cd $VALHEIM_HOME

  ## Default
  export templdpath=$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=./linux64:$LD_LIBRARY_PATH

  export SteamAppId=892970
  echo "Starting server PRESS CTRL-C to exit"

  set -- gosu $STEAM_USER "./$@" -name "$VALHEIM_SERVER_NAME" -port $VALHEIM_SERVER_PORT -world "$VALHEIM_SERVER_WORLD" -password "$VALHEIM_SERVER_PASSWORD"
fi

# Execute the command.
exec "$@"
