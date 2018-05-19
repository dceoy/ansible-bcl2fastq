ansible-bcl2fastq
=================

Ansible playbook to convert bcl into fastq for Illumina NextSeq

Requirements of remote servers
------------------------------

There are two alternative modes (Docker-based or command-based) for execution, and their requirements are the followings:

- Docker-based mode (`use_docker: true`)
  - Docker
  - Docker Compose
- Command-based mode (`use_docker: false`)
  - bcl2fastq

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
