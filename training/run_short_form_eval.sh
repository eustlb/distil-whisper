#!/bin/bash

#SBATCH --job-name=distil_test 
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
conda activate dw-py311

set -x -e

./short_form_eval.sh \
"/fsx/eustache/distilled-models/distil-large-v3-fr-0-31-half-fr-mix-es" \
"distil-large-v3-fr-0-31-half-fr-mix-es"

./short_form_eval.sh \
"/fsx/eustache/distilled-models/distil-large-v3-fr-0-31-half-fr" \
"distil-large-v3-fr-0-31-half-fr"

# ./short_form_eval.sh \
# "/fsx/eustache/distilled-models/distil-large-v3-fr-3-layers" \
# "distil-whisper-distil-large-v3-fr-3-layers-short-form"

# ./short_form_eval.sh \
# "/fsx/eustache/distilled-models/distil-large-v3-fr-4-layers" \
# "distil-large-v3-fr-4-layers-short-form"

# ./short_form_eval.sh \
# "openai/whisper-large-v3" \
# "whisper-large-v3-short-form"




