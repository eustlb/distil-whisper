#!/bin/bash

# Initialize default values for named parameters
decoder_layers_numbers=""
save_dir=""

# Parse named parameters
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --decoder_layers_numbers) decoder_layers_numbers="$2"; shift ;;
        --save_dir) save_dir="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Validate required parameters
if [[ -z "$decoder_layers_numbers" ]]; then
    echo "Error: --decoder_layers_numbers is required."
    exit 1
fi

if [[ -z "$save_dir" ]]; then
    echo "Error: --save_dir is required."
    exit 1
fi

# Check if save_dir exists. If not, create it.
if [ ! -d "$save_dir" ]; then
    echo "Directory $save_dir does not exist. Creating it..."
    mkdir -p "$save_dir"
fi

# Convert the decoder_layers_numbers array to a space-separated string
decoder_layers_numbers_string=$(echo ${decoder_layers_numbers[@]})

# Run the Python script with the specified arguments
python create_student_model.py \
    --teacher_checkpoint "openai/whisper-large-v3" \
    --encoder_layers 32 \
    --decoder_layers 2 \
    --save_dir "$save_dir" \
    --decoder_layers_numbers $decoder_layers_numbers_string