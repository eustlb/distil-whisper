#!/bin/bash

MODEL_NAME_OR_PATH=$1
WANDB_NAME=$2

python run_eval.py \
--model_name_or_path "$MODEL_NAME_OR_PATH" \
--dataset_name "/fsx/eustache/common_voice_16_1_fr_pseudo_labelled+/fsx/eustache/multilingual_librispeech_fr_pseudo_labelled+facebook/voxpopuli+google/fleurs" \
--dataset_config_name "default+default+fr+fr_fr" \
--dataset_split_name "test+test+test+test" \
--text_column_name "sentence+text+raw_text+transcription" \
--batch_size 16 \
--dtype "bfloat16" \
--generation_max_length 256 \
--language "fr" \
--attn_implementation "sdpa" \
--streaming False \
--wandb_name "$WANDB_NAME"