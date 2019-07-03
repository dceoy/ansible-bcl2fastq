#!/usr/bin/env bash
#
# bcl2fastq executor for Illumina DNA sequencer
#
# Usage:
#   bcl2fastq.sh [--debug] [--only-print] [--dry-run] <path>...
#   bcl2fastq.sh --version
#   bcl2fastq.sh -h|--help
#
# Options:
#   --debug           Execute the command with debug mode
#   --dry-run         Execute dry runs
#   --only-print      Print bcl2fastq-ready run directories and exit
#   --version         Print version
#   -h, --help        Print usage
#
# Arguments:
#   <path>            Paths to sequencing run directories

set -ue

if [[ ${#} -ge 1 ]]; then
  for a in "${@}"; do
    [[ "${a}" = '--debug' ]] && set -x && break
  done
fi

COMMAND_PATH=$(realpath "${0}")
COMMAND_NAME=$(basename "${COMMAND_PATH}")
COMMAND_VERSION='v0.0.1'
LOG_FILE='bcl2fastq_log.txt'

MAIN_ARGS=()
SEARCH_PATHS=()
DRY_RUN=0
ONLY_PRINT=0

function print_version {
  echo "${COMMAND_NAME}: ${COMMAND_VERSION}"
}

function print_usage {
  sed -ne '1,2d; /^#/!q; s/^#$/# /; s/^# //p;' "${COMMAND_PATH}"
}

function abort {
  {
    if [[ ${#} -eq 0 ]]; then
      cat -
    else
      COMMAND_NAME=$(basename "${COMMAND_PATH}")
      echo "${COMMAND_NAME}: ${*}"
    fi
  } >&2
  exit 1
}

while [[ ${#} -ge 1 ]]; do
  case "${1}" in
    '--debug' )
      shift 1
      ;;
    '--dry-run' )
      DRY_RUN=1 && shift 1
      ;;
    '--only-print' )
      ONLY_PRINT=1 && shift 1
      ;;
    '--version' )
      print_version && exit 0
      ;;
    '-h' | '--help' )
      print_usage && exit 0
      ;;
    -* )
      abort "invalid option: ${1}"
      ;;
    * )
      MAIN_ARGS+=("${1}") && shift 1
      ;;
  esac
done
[[ ${#MAIN_ARGS[@]} -gt 0 ]] || abort 'missing path arguments'

for p in "${MAIN_ARGS[@]}"; do
  [[ -d "${p}" ]] || abort "invalid directory path: ${p}"
  if [[ ! -f "${p}/${LOG_FILE}" ]] \
    && [[ -f "${p}/SampleSheet.csv" ]] \
    && [[ -f "${p}/RTAComplete.txt" ]] \
    && [[ ! $(find "${p}/Data/Intensities/BaseCalls" -type f -name '*.fastq.gz') ]]; then
      SEARCH_PATHS+=("${p}")
      [[ ${ONLY_PRINT} -eq 0 ]] || echo "${p}"
  fi
done

if [[ ${ONLY_PRINT} -eq 0 ]] && [[ ${#SEARCH_PATHS[@]} -gt 0 ]]; then
  echo '>>> Check bcl2fastq command'
  bcl2fastq --version
  FAILED_PATHS=()
  for p in "${SEARCH_PATHS[@]}"; do
    echo ">>> Sequencing run directories: ${p}"
    if [[ ${DRY_RUN} -eq 0 ]]; then
      bcl2fastq --runfolder-dir "${p}" 2>&1 | tee "${p}/${LOG_FILE}"
      [[ ${PIPESTATUS[0]} -eq 0 ]] || FAILED_PATHS+=("${p}")
    else
      echo "bcl2fastq --runfolder-dir ${p} 2>&1 | tee ${p}/${LOG_FILE}"
    fi
  done
  [[ ${#FAILED_PATHS[@]} -eq 0 ]] || abort "bcl2fastq failed: ${#FAILED_PATHS[*]}"
else
  :
fi
