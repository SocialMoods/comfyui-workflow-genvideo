#!/bin/bash
set -e

if [ -d "/runpod-volume" ]; then
    VOLUME_DIR="/runpod-volume/models"
elif [ -d "/workspace" ]; then
    VOLUME_DIR="/workspace/models"
else
    VOLUME_DIR="/comfyui/models"
fi

echo "==> Using models volume directory: $VOLUME_DIR"

download_and_link() {
    local url="$1"
    local rel_path="$2"
    local filename="$3"

    local target_dir="$VOLUME_DIR/$rel_path"
    local target_file="$target_dir/$filename"
    local comfy_dir="/comfyui/models/$rel_path"
    local comfy_file="$comfy_dir/$filename"

    mkdir -p "$target_dir"
    mkdir -p "$comfy_dir"

    if [ ! -f "$target_file" ]; then
        echo "--> [Downloading] $filename to $target_dir..."
        if [ -n "$HF_TOKEN" ]; then
            curl -s -L -H "Authorization: Bearer $HF_TOKEN" "$url" -o "$target_file"
        else
            curl -s -L "$url" -o "$target_file"
        fi
    else
        echo "--> [Exists] $filename found in volume. Skipping download."
    fi

    if [ "$target_file" != "$comfy_file" ]; then
        ln -sf "$target_file" "$comfy_file"
        echo "--> [Linked] $comfy_file -> $target_file"
    fi
}

download_and_link "https://huggingface.co/fofr/comfyui/resolve/main/sam2/sam2.1_hiera_large-fp16.safetensors" "sams" "sam2.1_hiera_large.safetensors"
download_and_link "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth" "sams" "sam_vit_b_01ec64.pth"

download_and_link "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors" "vae" "wan_2.1_vae.safetensors"
download_and_link "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" "text_encoders" "umt5_xxl_fp8_e4m3fn_scaled.safetensors"
download_and_link "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors" "clip_vision" "clip_vision_h.safetensors"
download_and_link "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_t2v_14B_fp8_e4m3fn.safetensors" "diffusion_models" "Wan2_2-Animate-14B_fp8_scaled_e4m3fn_KJ_v2.safetensors"

download_and_link "https://huggingface.co/Comfy-Org/flux2-klein-4B/resolve/main/split_files/diffusion_models/flux-2-klein-4b.safetensors" "diffusion_models" "flux-2-klein-4b.safetensors"
download_and_link "https://huggingface.co/Comfy-Org/flux2-klein-4B/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors" "text_encoders" "qwen_3_4b.safetensors"
download_and_link "https://huggingface.co/Comfy-Org/flux2-klein-4B/resolve/main/split_files/vae/flux2-vae.safetensors" "vae" "flux2-vae.safetensors"

download_and_link "https://huggingface.co/estaksi/Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors/resolve/main/Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors" "loras" "Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors"
download_and_link "https://huggingface.co/dci05049/Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors/resolve/main/Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors" "loras" "Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors"
download_and_link "https://huggingface.co/f5aiteam/Wan/resolve/main/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors" "loras" "wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors"
download_and_link "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors" "loras" "lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors"

download_and_link "https://huggingface.co/Kim2091/UltraSharp/resolve/main/4x-UltraSharp.pth" "upscale_models" "4x-UltraSharp.pth"
download_and_link "https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt" "ultralytics/bbox" "face_yolov8m.pt"
download_and_link "https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8s.pt" "ultralytics/bbox" "hand_yolov8s.pt"
download_and_link "https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8m-seg.pt" "ultralytics/segm" "person_yolov8m-seg.pt"

mkdir -p /comfyui/models/clip
if [ -f "$VOLUME_DIR/text_encoders/qwen_3_4b.safetensors" ]; then
    ln -sf "$VOLUME_DIR/text_encoders/qwen_3_4b.safetensors" "/comfyui/models/clip/qwen_3_4b.safetensors"
fi

echo "==> All models ready and linked!"
