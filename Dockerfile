# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

ARG HF_TOKEN=""

RUN comfy node install --exit-on-fail llm-toolkit@1.3.0 --mode remote || (echo "WARN: llm-toolkit@1.3.0 unavailable in registry, falling back to latest" >&2 && comfy node install --exit-on-fail llm-toolkit --mode remote)
RUN comfy node install --exit-on-fail comfyui-impact-pack@8.28.2 || (echo "WARN: comfyui-impact-pack@8.28.2 unavailable in registry, falling back to latest" >&2 && comfy node install --exit-on-fail comfyui-impact-pack)
RUN comfy node install --exit-on-fail comfyui_fill-nodes@2.3.4 || (echo "WARN: comfyui_fill-nodes@2.3.4 unavailable in registry, falling back to latest" >&2 && comfy node install --exit-on-fail comfyui_fill-nodes)
RUN comfy node install --exit-on-fail comfyui-impact-subpack@1.3.5 || (echo "WARN: comfyui-impact-subpack@1.3.5 unavailable in registry, falling back to latest" >&2 && comfy node install --exit-on-fail comfyui-impact-subpack)
RUN comfy node install --exit-on-fail comfyui-easy-use@1.3.6 || (echo "WARN: comfyui-easy-use@1.3.6 unavailable in registry, falling back to latest" >&2 && comfy node install --exit-on-fail comfyui-easy-use)

RUN git clone https://github.com/kijai/ComfyUI-KJNodes /comfyui/custom_nodes/ComfyUI-KJNodes && cd /comfyui/custom_nodes/ComfyUI-KJNodes && (git checkout 468fcc86f0b29e79a8510e8239eb15714d6747a6 2>/dev/null || (git fetch origin 468fcc86f0b29e79a8510e8239eb15714d6747a6 --depth=1 && git checkout 468fcc86f0b29e79a8510e8239eb15714d6747a6) || echo "WARN: commit 468fcc86f0b29e79a8510e8239eb15714d6747a6 unreachable in https://github.com/kijai/ComfyUI-KJNodes, falling back to default branch HEAD")
RUN git clone https://github.com/rgthree/rgthree-comfy /comfyui/custom_nodes/rgthree-comfy && cd /comfyui/custom_nodes/rgthree-comfy && (git checkout 8ff50e4521881eca1fe26aec9615fc9362474931 2>/dev/null || (git fetch origin 8ff50e4521881eca1fe26aec9615fc9362474931 --depth=1 && git checkout 8ff50e4521881eca1fe26aec9615fc9362474931) || echo "WARN: commit 8ff50e4521881eca1fe26aec9615fc9362474931 unreachable in https://github.com/rgthree/rgthree-comfy, falling back to default branch HEAD")
RUN git clone https://github.com/kijai/ComfyUI-segment-anything-2 /comfyui/custom_nodes/ComfyUI-segment-anything-2 && cd /comfyui/custom_nodes/ComfyUI-segment-anything-2 && (git checkout 0c35fff5f382803e2310103357b5e985f5437f32 2>/dev/null || (git fetch origin 0c35fff5f382803e2310103357b5e985f5437f32 --depth=1 && git checkout 0c35fff5f382803e2310103357b5e985f5437f32) || echo "WARN: commit 0c35fff5f382803e2310103357b5e985f5437f32 unreachable in https://github.com/kijai/ComfyUI-segment-anything-2, falling back to default branch HEAD")
RUN git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite /comfyui/custom_nodes/ComfyUI-VideoHelperSuite && cd /comfyui/custom_nodes/ComfyUI-VideoHelperSuite && (git checkout 993082e4f2473bf4acaf06f51e33877a7eb38960 2>/dev/null || (git fetch origin 993082e4f2473bf4acaf06f51e33877a7eb38960 --depth=1 && git checkout 993082e4f2473bf4acaf06f51e33877a7eb38960) || echo "WARN: commit 993082e4f2473bf4acaf06f51e33877a7eb38960 unreachable in https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite, falling back to default branch HEAD")
RUN git clone https://github.com/chflame163/ComfyUI_LayerStyle /comfyui/custom_nodes/ComfyUI_LayerStyle && cd /comfyui/custom_nodes/ComfyUI_LayerStyle && (git checkout d94bef1ee5ed3656f5ff1bb2830a4ffd94f40935 2>/dev/null || (git fetch origin d94bef1ee5ed3656f5ff1bb2830a4ffd94f40935 --depth=1 && git checkout d94bef1ee5ed3656f5ff1bb2830a4ffd94f40935) || echo "WARN: commit d94bef1ee5ed3656f5ff1bb2830a4ffd94f40935 unreachable in https://github.com/chflame163/ComfyUI_LayerStyle, falling back to default branch HEAD")
RUN git clone https://github.com/yolain/ComfyUI-Easy-Use /comfyui/custom_nodes/ComfyUI-Easy-Use && cd /comfyui/custom_nodes/ComfyUI-Easy-Use && (git checkout 81c510c06e18dffd4f43518644fc35964c9168ca 2>/dev/null || (git fetch origin 81c510c06e18dffd4f43518644fc35964c9168ca --depth=1 && git checkout 81c510c06e18dffd4f43518644fc35964c9168ca) || echo "WARN: commit 81c510c06e18dffd4f43518644fc35964c9168ca unreachable in https://github.com/yolain/ComfyUI-Easy-Use, falling back to default branch HEAD")
RUN git clone https://github.com/cubiq/ComfyUI_essentials /comfyui/custom_nodes/ComfyUI_essentials && cd /comfyui/custom_nodes/ComfyUI_essentials && (git checkout 9d9f4bedfc9f0321c19faf71855e228c93bd0dc9 2>/dev/null || (git fetch origin 9d9f4bedfc9f0321c19faf71855e228c93bd0dc9 --depth=1 && git checkout 9d9f4bedfc9f0321c19faf71855e228c93bd0dc9) || echo "WARN: commit 9d9f4bedfc9f0321c19faf71855e228c93bd0dc9 unreachable in https://github.com/cubiq/ComfyUI_essentials, falling back to default branch HEAD")
RUN git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess /comfyui/custom_nodes/ComfyUI-WanAnimatePreprocess && cd /comfyui/custom_nodes/ComfyUI-WanAnimatePreprocess && (git checkout 1a35b81a418bbba093356ad19b19bf2a76a24f4e 2>/dev/null || (git fetch origin 1a35b81a418bbba093356ad19b19bf2a76a24f4e --depth=1 && git checkout 1a35b81a418bbba093356ad19b19bf2a76a24f4e) || echo "WARN: commit 1a35b81a418bbba093356ad19b19bf2a76a24f4e unreachable in https://github.com/kijai/ComfyUI-WanAnimatePreprocess, falling back to default branch HEAD")
RUN comfy node install --exit-on-fail was-ns@3.0.1 --mode remote || (echo "WARN: was-ns@3.0.1 unavailable in registry, falling back to latest" >&2 && comfy node install --exit-on-fail was-ns --mode remote)
RUN git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts /comfyui/custom_nodes/ComfyUI-Custom-Scripts && cd /comfyui/custom_nodes/ComfyUI-Custom-Scripts && (git checkout 609f3afaa74b2f88ef9ce8d939626065e3247469 2>/dev/null || (git fetch origin 609f3afaa74b2f88ef9ce8d939626065e3247469 --depth=1 && git checkout 609f3afaa74b2f88ef9ce8d939626065e3247469) || echo "WARN: commit 609f3afaa74b2f88ef9ce8d939626065e3247469 unreachable in https://github.com/pythongosssss/ComfyUI-Custom-Scripts, falling back to default branch HEAD")

RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Kim2091/UltraSharp/resolve/main/4x-UltraSharp.pth' --relative-path models/upscale_models --filename '4x-UltraSharp.pth' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8m-seg.pt' --relative-path models/ultralytics --filename 'segm/person_yolov8m-seg.pt' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do comfy model download --url 'https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth' --relative-path models/ultralytics --filename 'sam_vit_b_01ec64.pth' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt' --relative-path models/ultralytics --filename 'bbox/face_yolov8m.pt' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8s.pt' --relative-path models/ultralytics --filename 'bbox/hand_yolov8s.pt' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/black-forest-labs/FLUX.2-klein-4B/resolve/main/flux-2-klein-4b.safetensors' --relative-path models/diffusion_models --filename 'flux-2-klein-4b.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/jorgeggy/flux2-vae.safetensors/resolve/main/flux2-vae.safetensors' --relative-path models/vae --filename 'flux2-vae.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/123543o/124052/resolve/d2a34649343469f45d8d9513d29b930f792748a4/checkpoints/XL/gonzalomoXLFluxPony_v60PhotoXLDMD.safetensors' --relative-path models/checkpoints --filename 'gonzalomoXLFluxPony_v60PhotoXLDMD.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done

RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/fofr/comfyui/resolve/main/sam2/sam2.1_hiera_large-fp16.safetensors' --relative-path models/Unknown --filename 'sam2.1_hiera_large.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors' --relative-path models/vae --filename 'wan_2.1_vae.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors' --relative-path models/text_encoders --filename 'umt5_xxl_fp8_e4m3fn_scaled.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors' --relative-path models/clip_vision --filename 'clip_vision_h.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/estaksi/Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors/resolve/main/Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors' --relative-path models/loras --filename 'Wan21_PusaV1_LoRA_14B_rank512_bf16.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/dci05049/Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors/resolve/main/Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors' --relative-path models/loras --filename 'Wan2.2-Fun-A14B-InP-low-noise-HPS2.1.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/f5aiteam/Wan/resolve/main/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors' --relative-path models/loras --filename 'wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors' --relative-path models/loras --filename 'lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/diffusion_models/wan2.1_t2v_14B_fp8_e4m3fn.safetensors' --relative-path models/diffusion_models --filename 'Wan2_2-Animate-14B_fp8_scaled_e4m3fn_KJ_v2.safetensors' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/JunkyByte/easy_ViTPose/resolve/main/onnx/wholebody/vitpose-l-wholebody.onnx' --relative-path models/diffusion_models --filename 'vitpose-l-wholebody.onnx' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done
RUN BACKOFFS="10 20 30 60 90" && for i in 1 2 3 4 5; do HF_TOKEN=$HF_TOKEN comfy model download --url 'https://huggingface.co/Wan-AI/Wan2.2-Animate-14B/resolve/main/process_checkpoint/det/yolov10m.onnx' --relative-path models/diffusion_models --filename 'yolov10m.onnx' && break; if [ $i -eq 5 ]; then echo "model-download failed after 5 attempts" >&2; exit 1; fi; SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i) && echo "model-download attempt $i failed; retrying in $SLEEP seconds" >&2; sleep $SLEEP; done

RUN mkdir -p /comfyui/custom_nodes/KiaraPanels && \
    echo '"""' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo 'KiaraPanels - Control Panel nodes for Stage I (SD) and Stage II (Flux) workflows.' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo 'Drop this folder into ComfyUI/custom_nodes/ to use.' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '"""' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo 'class ControlPanelSD:' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    CATEGORY = "KiaraPanels"' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    FUNCTION = "execute"' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    RETURN_TYPES = ("INT", "INT", "INT", "FLOAT")' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    RETURN_NAMES = ("width", "height", "steps", "cfg")' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    SD_PRESETS = {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "1:1 Square 512x512": (512, 512),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "1:1 Square 768x768": (768, 768),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "1:1 Square 1024x1024": (1024, 1024),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "2:3 Portrait 512x768": (512, 768),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "2:3 Portrait 768x1152": (768, 1152),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "3:2 Landscape 768x512": (768, 512),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "3:2 Landscape 1152x768": (1152, 768),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "9:16 Tall 576x1024": (576, 1024),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "16:9 Wide 1024x576": (1024, 576),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "9:16 Tall 720x1280": (720, 1280),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "16:9 Wide 1280x720": (1280, 720),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "4:7 Tall 576x1008": (576, 1008),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "9:16 Tall 896x1536": (896, 1536),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    }' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    QUALITY_PRESETS = {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "Draft 4 steps": 4,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "Fast 8 steps": 8,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "Normal 12 steps": 12,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "High Quality 20 steps": 20,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "Ultra 30 steps": 30,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "Maximum 50 steps": 50,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    }' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    @classmethod' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    def INPUT_TYPES(cls):' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        return {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            "required": {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '                "resolution": (list(cls.SD_PRESETS.keys()), {"default": "9:16 Tall 896x1536"}),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '                "quality": (list(cls.QUALITY_PRESETS.keys()), {"default": "Fast 8 steps"}),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '                "cfg": ("FLOAT", {"default": 1.0, "min": 1.0, "max": 30.0, "step": 0.5}),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            }' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        }' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    def execute(self, resolution, quality, cfg):' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        w, h = self.SD_PRESETS[resolution]' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        steps = self.QUALITY_PRESETS[quality]' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        return (w, h, steps, cfg)' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo 'class ControlPanelFlux:' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    CATEGORY = "KiaraPanels"' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    FUNCTION = "execute"' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    RETURN_TYPES = ("INT", "INT", "INT")' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    RETURN_NAMES = ("width", "height", "steps")' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    FLUX_PRESETS = {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "1:1 Square 1024x1024": (1024, 1024),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "3:4 Portrait 896x1152": (896, 1152),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "4:3 Landscape 1152x896": (1152, 896),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "9:16 Tall 768x1344": (768, 1344),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "9:16 Tall 896x1536": (896, 1536),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "16:9 Wide 1344x768": (1344, 768),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "2:3 Portrait 832x1216": (832, 1216),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "3:2 Landscape 1216x832": (1216, 832),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    }' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    QUALITY_PRESETS = {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "Fast 4 steps": 4,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "Normal 8 steps": 8,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "High Quality 16 steps": 16,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        "Ultra 28 steps": 28,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    }' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    @classmethod' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    def INPUT_TYPES(cls):' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        return {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            "required": {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '                "resolution": (list(cls.FLUX_PRESETS.keys()), {"default": "9:16 Tall 896x1536"}),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '                "quality": (list(cls.QUALITY_PRESETS.keys()), {"default": "Fast 4 steps"}),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            }' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        }' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    def execute(self, resolution, quality):' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        w, h = self.FLUX_PRESETS[resolution]' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        steps = self.QUALITY_PRESETS[quality]' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        return (w, h, steps)' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo 'class KiaraReferenceLatent:' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    """' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    Injects VAE-encoded reference latent into conditioning for FLUX Klein.' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    Replicates kx7_cb243e9c ("Reference Latent").' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    Uses the native FLUX reference_latents mechanism.' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    """' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    CATEGORY = "KiaraPanels"' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    FUNCTION = "execute"' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    RETURN_TYPES = ("CONDITIONING",)' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    @classmethod' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    def INPUT_TYPES(cls):' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        return {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            "required": {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '                "conditioning": ("CONDITIONING",),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            },' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            "optional": {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '                "latent": ("LATENT",),' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            }' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        }' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    def execute(self, conditioning, latent=None):' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        if latent is None:' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            return (conditioning,)' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        import copy' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        c = []' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        for t in conditioning:' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            d = copy.deepcopy(t[1])' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            ref = latent["samples"]' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            if "reference_latents" in d:' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '                d["reference_latents"] = d["reference_latents"] + [ref]' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            else:' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '                d["reference_latents"] = [ref]' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '            c.append([t[0], d])' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '        return (c,)' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo 'NODE_CLASS_MAPPINGS = {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    "ControlPanelSD": ControlPanelSD,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    "ControlPanelFlux": ControlPanelFlux,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    "KiaraReferenceLatent": KiaraReferenceLatent,' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '}' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo 'NODE_DISPLAY_NAME_MAPPINGS = {' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    "ControlPanelSD": "Control Panel - SD",' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    "ControlPanelFlux": "Control Panel - Flux",' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '    "KiaraReferenceLatent": "Reference Latent (FLUX)",' >> /comfyui/custom_nodes/KiaraPanels/__init__.py && \
    echo '}' >> /comfyui/custom_nodes/KiaraPanels/__init__.py
# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/