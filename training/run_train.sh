#!/bin/bash

#SBATCH --job-name=distil-train
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=hopper-prod    
#SBATCH --cpus-per-task=48         
#SBATCH --mem-per-cpu=11G        
#SBATCH --gres=gpu:h100:8           
#SBATCH --time=12:00:00  
#SBATCH --requeue          
#SBATCH --output=/admin/home/eustache_lebihan/dev/logs/%x-%j.out

accelerate launch --config_file /admin/home/eustache_lebihan/dev/accelerate-configs/8gpu_config.yaml \
run_distillation.py \
  --model_name_or_path "/admin/home/eustache_lebihan/dev/distil-large-v3-fr-full/distil-init" \
  --teacher_model_name_or_path "openai/whisper-large-v3" \
  --train_dataset_name "/fsx/eustache/common_voice_17_0_fr_pseudo_labelled+/fsx/eustache/multilingual_librispeech_fr_pseudo_labelled" \
  --train_split_name "train+train" \
  --text_column_name "sentence+text" \
  --eval_dataset_name "/fsx/eustache/common_voice_17_0_fr_pseudo_labelled+/fsx/eustache/multilingual_librispeech_fr_pseudo_labelled" \
  --eval_split_name "validation+validation" \
  --eval_text_column_name "sentence+text" \
  --eval_steps 1000 \
  --save_steps 1000 \
  --warmup_steps 500 \
  --learning_rate 0.0001 \
  --lr_scheduler_type "linear" \
  --timestamp_probability 0.2 \
  --condition_on_prev_probability 0.2 \
  --language "fr" \
  --task "transcribe" \
  --logging_steps 25 \
  --save_total_limit 1 \
  --max_steps 80000 \
  --wer_threshold 20 \
  --per_device_train_batch_size 32 \
  --per_device_eval_batch_size 32 \
  --dataloader_num_workers 8 \
  --preprocessing_num_workers 48 \
  --ddp_timeout 7200 \
  --dtype "bfloat16" \
  --attn_implementation "sdpa" \
  --output_dir "/admin/home/eustache_lebihan/dev/distil-large-v3-fr-full" \
  --do_train \
  --do_eval \
  --gradient_checkpointing \
  --overwrite_output_dir \
  --predict_with_generate \
  --freeze_encoder \
  --freeze_embed_positions \
  --streaming False \
  --push_to_hub False \
  --wandb_name large-v3-fr-full \
  --wandb_dir /fsx/eustache/wandb \
  --preprocessing_only 