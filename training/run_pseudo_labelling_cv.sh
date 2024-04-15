#!/bin/bash

#SBATCH --job-name=distil  
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

accelerate launch --config_file /admin/home/eustache_lebihan/dev/accelerate-configs/debug8gpu_config.yaml run_pseudo_labelling.py \
  --model_name_or_path "openai/whisper-large-v3" \
  --dataset_name "mozilla-foundation/common_voice_16_1" \
  --dataset_config_name "fr" \
  --dataset_split_name "train+validation+test" \
  --text_column_name "sentence" \
  --id_column_name "path" \
  --output_dir "/fsx/eustache/common_voice_16_1_fr_pseudo_labelled" \
  --wandb_project "distil-whisper-labelling" \
  --per_device_eval_batch_size 32 \
  --dtype "bfloat16" \
  --attn_implementation "sdpa" \
  --logging_steps 500 \
  --max_label_length 256 \
  --concatenate_audio \
  --preprocessing_batch_size 500 \
  --preprocessing_num_workers 48 \
  --dataloader_num_workers 8 \
  --report_to "wandb" \
  --language "fr" \
  --task "transcribe" \
  --return_timestamps \
  --streaming False \
  --generation_num_beams 1 \
  --push_to_hub False
