# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

ARG HF_TOKEN=""
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

RUN git clone https://github.com/kijai/ComfyUI-KJNodes /comfyui/custom_nodes/ComfyUI-KJNodes && \
    git clone https://github.com/rgthree/rgthree-comfy /comfyui/custom_nodes/rgthree-comfy && \
    git clone https://github.com/kijai/ComfyUI-segment-anything-2 /comfyui/custom_nodes/ComfyUI-segment-anything-2 && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite /comfyui/custom_nodes/ComfyUI-VideoHelperSuite && \
    git clone https://github.com/chflame163/ComfyUI_LayerStyle /comfyui/custom_nodes/ComfyUI_LayerStyle && \
    git clone https://github.com/yolain/ComfyUI-Easy-Use /comfyui/custom_nodes/ComfyUI-Easy-Use && \
    git clone https://github.com/cubiq/ComfyUI_essentials /comfyui/custom_nodes/ComfyUI_essentials && \
    git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess /comfyui/custom_nodes/ComfyUI-WanAnimatePreprocess && \
    git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts /comfyui/custom_nodes/ComfyUI-Custom-Scripts && \
    git clone https://github.com/WASasquatch/was-node-suite-comfyui /comfyui/custom_nodes/was-node-suite-comfyui && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack /comfyui/custom_nodes/ComfyUI-Impact-Pack && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Subpack /comfyui/custom_nodes/ComfyUI-Impact-Subpack && \
    git clone https://github.com/fillipax/comfyui_fill-nodes /comfyui/custom_nodes/comfyui_fill-nodes && \
    git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus /comfyui/custom_nodes/ComfyUI_IPAdapter_plus && \
    git clone https://github.com/cubiq/ComfyUI_InstantID /comfyui/custom_nodes/ComfyUI_InstantID && \
    git clone https://github.com/cubiq/ComfyUI_FaceAnalysis /comfyui/custom_nodes/ComfyUI_FaceAnalysis && \
    git clone https://github.com/Gourieff/comfyui-reactor-node /comfyui/custom_nodes/comfyui-reactor-node && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux /comfyui/custom_nodes/comfyui_controlnet_aux && \
    git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet /comfyui/custom_nodes/ComfyUI-Advanced-ControlNet && \
    git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale /comfyui/custom_nodes/ComfyUI_UltimateSDUpscale && \
    git clone https://github.com/jags111/efficiency-nodes-comfyui /comfyui/custom_nodes/efficiency-nodes-comfyui

RUN for req in /comfyui/custom_nodes/*/requirements.txt; do \
      if [ -f "$req" ]; then \
        /comfyui/.venv/bin/pip install --no-cache-dir -r "$req" || true; \
      fi \
    done

RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/fofr/comfyui/resolve/main/sam2/sam2.1_hiera_large-fp16.safetensors' --relative-path models/sams --filename 'sam2.1_hiera_large.safetensors' && break; if [ $i -eq 5 ]; then exit 1; fi; sleep $(echo $BACKOFFS | cut -d ' ' -f $i); done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors' --relative-path models/vae --filename 'wan_2.1_vae.safetensors' && break; if [ $i -eq 5 ]; then exit 1; fi; sleep $(echo $BACKOFFS | cut -d ' ' -f $i); done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors' --relative-path models/text_encoders --filename 'umt5_xxl_fp8_e4m3fn_scaled.safetensors' && break; if [ $i -eq 5 ]; then exit 1; fi; sleep $(echo $BACKOFFS | cut -d ' ' -f $i); done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors' --relative-path models/clip_vision --filename 'clip_vision_h.safetensors' && break; if [ $i -eq 5 ]; then exit 1; fi; sleep $(echo $BACKOFFS | cut -d ' ' -f $i); done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/estaksi/Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors/resolve/main/Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors' --relative-path models/loras --filename 'Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors' && break; if [ $i -eq 5 ]; then exit 1; fi; sleep $(echo $BACKOFFS | cut -d ' ' -f $i); done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/dci05049/Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors/resolve/main/Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors' --relative-path models/loras --filename 'Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors' && break; if [ $i -eq 5 ]; then exit 1; fi; sleep $(echo $BACKOFFS | cut -d ' ' -f $i); done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/f5aiteam/Wan/resolve/main/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors' --relative-path models/loras --filename 'wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors' && break; if [ $i -eq 5 ]; then exit 1; fi; sleep $(echo $BACKOFFS | cut -d ' ' -f $i); done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors' --relative-path models/loras --filename 'lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors' && break; if [ $i -eq 5 ]; then exit 1; fi; sleep $(echo $BACKOFFS | cut -d ' ' -f $i); done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_t2v_14B_fp8_e4m3fn.safetensors' --relative-path models/diffusion_models --filename 'Wan2_2-Animate-14B_fp8_scaled_e4m3fn_KJ_v2.safetensors' && break; if [ $i -eq 5 ]; then exit 1; fi; sleep $(echo $BACKOFFS | cut -d ' ' -f $i); done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/JunkyByte/easy_ViTPose/resolve/main/onnx/wholebody/vitpose-l-wholebody.onnx' --relative-path models/diffusion_models --filename 'vitpose-l-wholebody.onnx' && break; if [ $i -eq 5 ]; then exit 1; fi; sleep $(echo $BACKOFFS | cut -d ' ' -f $i); done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Wan-AI/Wan2.2-Animate-14B/resolve/main/process_checkpoint/det/yolov10m.onnx' --relative-path models/diffusion_models --filename 'yolov10m.onnx' && break; if [ $i -eq 5 ]; then exit 1; fi; sleep $(echo $BACKOFFS | cut -d ' ' -f $i); done
