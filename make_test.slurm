#!/bin/bash
# --------------------------------------------------------------
### PART 1: Requests resources to run your job.RT 1: Requests resources to run your job.
# --------------------------------------------------------------
### Optional. Set the job name
#SBATCH --job-name=build_make_test
### Optional. Set the output filename.
### SLURM reads %x as the job name and %j as the job ID
#SBATCH --output=%x-%j.out
### REQUIRED. Specify the PI group for this job
#SBATCH --account=mstrout
### Optional. Request email when job begins and ends
### SBATCH --mail-type=ALL
### Optional. Specify email address to use for notification
### SBATCH --mail-user=<YOUR NETID>@email.arizona.edu
### REQUIRED. Set the partition for your job.
#SBATCH --partition=standard
### REQUIRED. Set the number of cores that will be used for this job.
#SBATCH --ntasks=27
#SBATCH --nodes=1
### REQUIRED. Set the memory required for this job.
#SBATCH --mem=1gb
### REQUIRED. Specify the time required for this job, hhh:mm:ss
#SBATCH --time=00:30:00

# --------------------------------------------------------------
### PART 2: Execute bash commands to run your job
# --------------------------------------------------------------

module load openmpi3
module load hypre
### module load silo
module load pmix
module load cmake

cd ${HOME}/parflow

rm -r parflow
rm -r parflow_build

git clone https://github.com/parflow/parflow.git

mkdir parflow_build

cd parflow_build

cmake ../parflow -DCMAKE_INSTALL_PREFIX=${PARFLOW_DIR} -DPARFLOW_HAVE_CLM=ON -DPARFLOW_AMPS_LAYER=mpi1 -DPARFLOW_ENABLE_TIMING=TRUE -DCMAKE_BUILD_TYPE=Release -DHYPRE_ROOT=${HYPRE_BASE} ### -DPARFLOW_AMPS_SEQUENTIAL_IO=TRUE ### -DSILO_ROOT=${SILO_BASE}

make

make install

make test
