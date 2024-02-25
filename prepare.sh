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


function get_json_releases() {
    JQ_FILTER='map(.tag_name)'
    JQ_FILTER_LATEST='[.tag_name]'
    if [[ $ERC == true ]]; then
        #JQ_FILTER='map(select(.tag_name | test("-rc\\.\\d+$") | not))'
        JQ_FILTER='map(select(.tag_name | test("-(rc|b)[0-9]*\\.?[0-9]*$|rc[0-9]*\\.?[0-9]*$|b[0-9]*\\.?[0-9]*$") | not)) | .[] | .tag_name'
    fi
    if [[ $LATEST == true ]]; then
      releases=$(curl ${INSECURE:+-k} -s "$GITHUB_API/repos/$GITHUB_REPO/$GITHUB_PROJECT/releases/latest" | jq -r "$JQ_FILTER_LATEST")
    else
      releases=$(curl ${INSECURE:+-k} -s "$GITHUB_API/repos/$GITHUB_REPO/$GITHUB_PROJECT/releases?per_page=$PER_PAGE" | jq -r "$JQ_FILTER")
    fi

    echo $releases
}

function get_from_pypi() {
  JQ_FILTER='[."releases" | keys[]]'
  JQ_FILTER_LATEST='["\( .info.version )"]'
  if [[ $ERC == true ]]; then
      JQ_FILTER='."releases" | keys | map(select(test("^(?!.*(?:rc|a|b)[0-9]+$).*"))) | .[]'
  fi
  if [[ $LATEST == true ]]; then
    releases=$(curl ${INSECURE:+-k} -s "$PYPI_API/$PYPI_PROJECT/json" | jq -r "$JQ_FILTER_LATEST")
  else
    releases=$(curl ${INSECURE:+-k} -s "$PYPI_API/$PYPI_PROJECT/json" | jq -r "$JQ_FILTER")
  fi

  echo $releases
}


# Init variables
GITHUB_API=${GITHUB_API:-"https://api.github.com"}
PYPI_API=${PYPI_API:-"https://pypi.org/pypi"}
PER_PAGE=100

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"
case ${key} in
    -h|--help)
    log_info "Usage: $0"
    log_info "  [--github-api] (Github API-URL)"
    log_info "  [--pypi-api] (pypi URL)"
    log_info "  [--pypi-project] (pypi Project)"
    log_info "  --github-repo (Github Repository)"
    log_info "  --github-project (Github Project)"
    log_info "  [--exclude-release-candidates]"
    log_info "  [--per-page]"
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
    --pypi-api)
    PYPI_API="$2"
    shift
    shift
    ;;
    --pypi-project)
    PYPI_PROJECT="$2"
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
    --per-page)
    PER_PAGE="$2"
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
if [[ $PYPI_PROJECT == "" ]]; then
  assert_argument "$GITHUB_REPO" "Github Repository has to be defined ('--github-repo' option)"
  assert_argument "$GITHUB_PROJECT" "Github Repository has to be defined ('--github-project' option)"
else
  assert_argument "$PYPI_PROJECT" "Pypi Repository has to be defined ('--pypi-repo' option)"
fi

log_info "Get releases"
if [[ $PYPI_PROJECT == "" ]]; then
log_info "- github api           (--github-api)                   : \\e[33;1m${GITHUB_API}\\e[0m"
log_info "- github repository    (--github-repo)                  : \\e[33;1m${GITHUB_REPO}\\e[0m"
log_info "- github project       (--github-project)               : \\e[33;1m${GITHUB_PROJECT}\\e[0m"
else
log_info "- pypi api             (--pypi-api)                     : \\e[33;1m${PYPI_API}\\e[0m"
log_info "- pypi project         (--pypi-project)                 : \\e[33;1m${PYPI_PROJECT}\\e[0m"
fi
log_info "- release candidates   (--exclude-release-candidates)   : \\e[33;1m${ERC:-false}\\e[0m"
log_info "- latest               (--latest)                       : \\e[33;1m${LATEST:-false}\\e[0m"
log_info "- per page             (--per-page)                     : \\e[33;1m${PER_PAGE}\\e[0m"
log_info "- insecure             (--insecure)                     : \\e[33;1m${INSECURE:-false}\\e[0m"

if [[ $PYPI_PROJECT == "" ]]; then 
get_json_releases
else
get_from_pypi
fi