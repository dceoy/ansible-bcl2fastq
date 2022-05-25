ansible-bcl2fastq
=================

Ansible playbook to convert BCL into FASTQ in run directories from Illumina DNA sequencer

Recommended OS: CentOS7

Installation
------------

##### Client

1.  Install Ansible.

2.  Check out the repository.

    ```sh
    $ git clone https://github.com/dceoy/ansible-bcl2fastq.git
    ```

3.  Create a inventory file for Ansible

    ```sh
    $ cd ansible-bcl2fastq
    $ cp example_hosts hosts
    $ vim hosts       # => edit
    ```

##### Server

There are two alternative modes (command-based or Docker-based) for execution, and their requirements are the followings:

###### Command-based mode

1.  Install `bcl2fastq` command on a server.

###### Docker-based mode

(`use_docker: true` must be set `bcl2fastq.yml` of a client.)

1.  Install Docker and Docker Compose.

2.  Download the Linux rpm of bcl2fastq.

3.  Build a Docker image using the rpm file and `docker/Dockerfile` on a server.

Usage
-----

Convert BCL files into FASTQ files in the run directories where `SampleSheet.csv` is put.

```sh
$ ansible-playbook -i hosts bcl2fastq.yml
```

The playbook execute processes on a server as follows:

1.  Copy `roles/bcl2fastq/files/bcl2fastq.sh` into the server.

2.  Find target run directories without converted FASTQ data in a sequencing data directory (`seq_dir_path`).

3.  Convert BCL data using `bcl2fastq.sh` if there are directories where the conversion is possible.

    `bcl2fastq.sh` checks the following trigger conditions:

    - `RTAComplete.txt` exists
    - `SampleSheet.csv` exists
    - `*.fastq.gz` files does not exist under `./Data/Intensities/BaseCalls`
    - `bcl2fastq_log.txt` does not exist

    If all of the above are satisfied in a run directory, the conversion can be executable there.

4.  Notify the result of the conversion to a Slack channel.

Stand-alone script
------------------

The conversion script `bcl2fastq.sh` can be run without Ansible and Docker.

```sh
$ ./roles/bcl2fastq/files/bcl2fastq.sh --help
```
