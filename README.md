ansible-bcl2fastq
=================

Ansible playbook to convert bcl to fastq for Illumina NextSeq

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

```sh
$ ansible-playbook -i hosts bcl2fast.yml
```
