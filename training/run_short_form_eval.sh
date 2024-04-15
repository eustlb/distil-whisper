#!/bin/bash

#SBATCH --job-name=distil-test 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=hopper-prod    
#SBATCH --cpus-per-task=48         
#SBATCH --mem-per-cpu=11G        
#SBATCH --gres=gpu:h100:8           
#SBATCH --time=12:00:00  
#SBATCH --requeue          
#SBATCH --output=/admin/home/eustache_lebihan/dev/logs/%x-%j.out

source /admin/home/eustache_lebihan/.bashrc
conda activate dw

set -x -e

./short_form_eval.sh "openai/whisper-medium" "fr-medium-teacher-baseline"

./short_form_eval.sh "openai/whisper-small" "fr-small-teacher-baseline"

./short_form_eval.sh "openai/whisper-base" "fr-base-teacher-baseline"

./short_form_eval.sh "openai/whisper-tiny" "fr-tiny-teacher-baseline"




