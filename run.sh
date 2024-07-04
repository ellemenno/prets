#!/usr/bin/env bash

##### utilities

function out() { printf "%s\n" "$*" >&1; } # stdout for output to be consumed by programs; adds a newline add end
function msg() { printf "%b" "$*" >&2; } # stderr for messaging to be read by users; may use color if [ -t 2 ] is true; BYONL (newlines not supplied here)

function log() {
  local -r hue="$1" # e.g. 32m for plain (dim) green, 91m for bold (bright) red
  local -r label="$2" # when not printing color (i.e. not a terminal), label will be added for differentiation
  shift; shift
  local pre="$(basename "$0"):"
  local col_='\033[' _col='\033[0m'
  if [ -t 2 ]; then msg "$col_$hue$pre $*$_col\n" && return 0; else msg "$pre $label $*\n" && return 0; fi
}

function debug() { log '37m' '::' "$*" ; } # dim white
function note()  { log '36m' '--' "$*" ; } # dim cyan
function info()  { log '32m' '---' "$*" ; } # dim green
function warn()  { log '33m' 'warn' "$*" ; } # dim orange
function error() { log '91m' 'error' "$*" ; } # bright red

function exit_on_error() {
  local -r exit_code=$1
  shift
  [[ $exit_code ]] && ((exit_code != 0)) && {
    error "$@"
    exit "$exit_code"
  }
}

#####

SERVICE="not specified"

function usage() {
  local -r pipe="${1:-2}" # default to stderr, but can be overridden with argument $1
  cat >&$pipe << EOM
simple task runner

usage:
  $(basename "$0") [<service> | --<option>]

options:
  -h --help   show this usage info
  <service>   clean, dist, publish, serve

EOM
}


function do_clean() {
  [[ -d dist ]] && rm -r dist # delete the whole dist dir
}

function do_dist() {
  [[ -d dist ]] || mkdir dist # if no dist dir, create one
  [ "$(ls -A dist)" ] && rm -r dist/* # if not empty, remove files
  cp -a app/* dist/ # copy app files, recursively without following links, into dist
}

function do_publish() {
  ./scripts/deploy --config ./scripts/deploy.config --message 'deploy site'
}

function do_serve() {
  local -r filename='dist/index.html'
  local -r port=8080
  # the user will need to ctrl_c to exit, so capture that and say goodbye
  trap done_serving INT
  # send a simple http header and the file contents to specified port
  while true; do { \
    echo -ne "HTTP/1.0 200 OK\r\nContent-Length: $(wc -c <"$filename")\r\n\r\n"; \
    cat "$filename"; } | nc -l -p $port ; \
  done
}

function done_serving() {
  msg "\n"
  note "web server halted."
  exit 0
}


if [ $# -eq 0 ]; then 
  warn "no service specified"
  msg "\n"
  usage # usage as part of a user message, send to stderr ( &2, default )
  exit 2;
fi

while [ $# -gt 0 ]
do
  opt="$1"

  case $opt in
    -h|--help)
      shift # past option
      usage 1 && exit 0 # usage explicitly requested as output, send to stdout ( &1 )
      ;;

    clean|dist|publish|serve)
      SERVICE="$opt"
      shift # past value
      ;;

    *)      # unmatched option
      warn "unknown option '$opt'."
      msg "\n"
      exit 1
      ;;
  esac
done

case $SERVICE in
  clean)
    note "removing the dist directory.."
    do_clean
    ;;

  dist)
    note "populating the dist directory.."
    do_dist
    ;;

  publish)
    note "pushing files to github.."
    do_dist
    do_publish
    ;;

  serve)
    note "populating the dist directory.."
    do_dist
    note "serving site from localhost (CTRL-C to exit)"
    info "http://localhost:8080/"
    do_serve
    ;;

  *)    # unmatched option
    warn "unknown service '$SERVICE'"
    msg "\n"
    exit 1
    ;;
esac

exit_on_error $? "$SERVICE failed\n"

info "done."
msg "\n"
exit 0
