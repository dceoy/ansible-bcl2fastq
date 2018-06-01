ansible-bcl2fastq
=================

Ansible playbook to convert bcl into fastq in run directories from Illumina NextSeq

Recommended OS: CentOS7

Requirements of remote servers
------------------------------

There are two alternative modes (Docker-based or command-based) for execution, and their requirements are the followings:

- Docker-based mode (`use_docker: true`)
  - Docker
  - Docker Compose
- Command-based mode (`use_docker: false`)
  - bcl2fastq

Trigger conditions to execute bcl2fastq
---------------------------------------

- `RTAComplete.txt` exists
- `SampleSheet.csv` exists
- `*.fastq.gz` files does not exist under `./Data/Intensities/BaseCalls`
- `bcl2fastq_log.txt` does not exist

If all of the above are satisfied in a run directory, bcl2fastq can be executable there.

Setup
-----

```sh
$ git clone https://github.com/dceoy/ansible-bcl2fastq.git
$ cd ansible-bcl2fastq
$ cp example_hosts hosts
$ vim hosts       # => edit
```

Usage
-----

Convert bcl files into fastq files in the run directories where `SampleSheet.csv` is put.

```sh
$ ansible-playbook -i hosts bcl2fastq.yml
```

Docker-based mode pulls [dceoy/bcl2fastq](https://hub.docker.com/r/dceoy/bcl2fastq/) image in a run if it does not exist.
