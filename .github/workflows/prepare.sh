#!/bin/bash

set -e

function log_info() {
  >&2 echo -e "[\\e[1;94mINFO\\e[0m] $*"
}

function log_warn() {
  >&2 echo -e "[\\e[1;93mWARN\\e[0m] $*"
}

function log_error() {
  >&2 echo -e "[\\e[1;91mERROR\\e[0m] $*"
}

function fail() {
  log_error "$@"
  exit 1
}

function assert_argument() {
  if [[ -z "$1" ]]
  then
    fail "$2"
  fi
}

function get_releases() {
    JQ_FILTER='.[].tag_name'
    JQ_FILTER_LATEST='.tag_name'
    if [[ $ERC == true ]]; then
        JQ_FILTER+=' | select(test("-rc\\.\\d+$") | not)'
    fi
    if [[ $LATEST == true ]]; then
      releases=$(curl ${INSECURE:+-k} -s "$GITHUB_API/repos/$GITHUB_REPO/$GITHUB_PROJECT/releases/latest" | jq -r "$JQ_FILTER_LATEST")
    else
      releases=$(curl ${INSECURE:+-k} -s "$GITHUB_API/repos/$GITHUB_REPO/$GITHUB_PROJECT/releases" | jq -r "$JQ_FILTER")
    fi

    echo $releases
}


# Init variables
GITHUB_API=${GITHUB_API:-"https://api.github.com"}


POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case ${key} in
    -h|--help)
    log_info "Usage: $0"
    log_info "  [--github-api] (Github API-URL)"
    log_info "  --github-repo (Github Repository)"
    log_info "  --github-project (Github Project)"
    log_info "  [--exclude-release-candidates]"
    log_info "  [--latest]"
    log_info "  [--insecure]"
    exit 0
    ;;
    --github-api)
    GITHUB_API="$2"
    shift
    shift
    ;;
    --github-repo)
    GITHUB_REPO="$2"
    shift
    shift
    ;;
    --github-project)
    GITHUB_PROJECT="$2"
    shift
    shift
    ;;
    --insecure)
    INSECURE="true"
    shift
    ;;
    --exclude-release-candidates)
    ERC="true"
    shift
    ;;
    --latest)
    LATEST="true"
    shift
    ;;
    *)
    POSITIONAL+=("$1")
    shift
    ;;
esac
done

set -- "${POSITIONAL[@]}"

assert_argument "$GITHUB_REPO" "Github Repository has to be defined ('--github-repo' option)"
assert_argument "$GITHUB_PROJECT" "Github Repository has to be defined ('--github-project' option)"


log_info "Get releases"
log_info "- github api           (--github-api)                   : \\e[33;1m${GITHUB_API}\\e[0m"
log_info "- github repository    (--github-repo)                  : \\e[33;1m${GITHUB_REPO}\\e[0m"
log_info "- github project       (--github-project)               : \\e[33;1m${GITHUB_PROJECT}\\e[0m"
log_info "- release candidates   (--exclude-release-candidates)   : \\e[33;1m${ERC:-false}\\e[0m"
log_info "- latest               (--latest)                       : \\e[33;1m${LATEST:-false}\\e[0m"
log_info "- insecure             (--insecure)                     : \\e[33;1m${INSECURE:-false}\\e[0m"

get_releases