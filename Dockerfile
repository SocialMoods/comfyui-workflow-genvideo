# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.8.4-base

ARG HF_TOKEN=""

RUN comfy node install --exit-on-fail llm-toolkit@1.3.0 --mode remote || \
    (echo "WARN: llm-toolkit@1.3.0 unavailable in registry, falling back to latest" >&2 && \
     comfy node install --exit-on-fail llm-toolkit --mode remote)

RUN clone_pin() { \
      repo="$1"; commit="$2"; dest="$3"; \
      mkdir -p "$dest" && cd "$dest" && git init -q && git remote add origin "$repo" && \
      if git fetch --depth 1 origin "$commit" -q 2>/dev/null && git checkout -q FETCH_HEAD; then \
        echo "OK: $repo @ $commit (shallow)"; \
      else \
        echo "WARN: commit $commit unreachable via shallow fetch in $repo, falling back to default branch HEAD (shallow)" >&2; \
        cd / && rm -rf "$dest" && git clone --depth 1 "$repo" "$dest"; \
      fi; \
    }; \
    clone_pin https://github.com/kijai/ComfyUI-KJNodes 468fcc86f0b29e79a8510e8239eb15714d6747a6 /comfyui/custom_nodes/ComfyUI-KJNodes && \
    clone_pin https://github.com/rgthree/rgthree-comfy 8ff50e4521881eca1fe26aec9615fc9362474931 /comfyui/custom_nodes/rgthree-comfy && \
    clone_pin https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite 993082e4f2473bf4acaf06f51e33877a7eb38960 /comfyui/custom_nodes/ComfyUI-VideoHelperSuite && \
    clone_pin https://github.com/yolain/ComfyUI-Easy-Use 81c510c06e18dffd4f43518644fc35964c9168ca /comfyui/custom_nodes/ComfyUI-Easy-Use && \
    clone_pin https://github.com/cubiq/ComfyUI_essentials 9d9f4bedfc9f0321c19faf71855e228c93bd0dc9 /comfyui/custom_nodes/ComfyUI_essentials && \
    clone_pin https://github.com/kijai/ComfyUI-WanAnimatePreprocess 1a35b81a418bbba093356ad19b19bf2a76a24f4e /comfyui/custom_nodes/ComfyUI-WanAnimatePreprocess && \
    clone_pin https://github.com/pythongosssss/ComfyUI-Custom-Scripts 609f3afaa74b2f88ef9ce8d939626065e3247469 /comfyui/custom_nodes/ComfyUI-Custom-Scripts

RUN dl() { \
      url="$1"; relpath="$2"; fname="$3"; \
      for i in 1 2 3 4 5; do \
        HF_TOKEN=$HF_TOKEN comfy model download --url "$url" --relative-path "$relpath" --filename "$fname" && return 0; \
        if [ "$i" -eq 5 ]; then echo "model-download failed after 5 attempts: $fname" >&2; exit 1; fi; \
        sleep $((10 * i)); echo "model-download attempt $i failed for $fname; retrying" >&2; \
      done; \
    }; \
    dl 'https://huggingface.co/black-forest-labs/FLUX.2-klein-4B/resolve/main/flux-2-klein-4b.safetensors' models/diffusion_models 'flux-2-klein-4b.safetensors' && \
    dl 'https://huggingface.co/jorgeggy/flux2-vae.safetensors/resolve/main/flux2-vae.safetensors' models/vae 'flux2-vae.safetensors' && \
    dl 'https://huggingface.co/Comfy-Org/flux2-klein-4B/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors' models/text_encoders 'qwen_3_4b.safetensors'

RUN mkdir -p /comfyui/models/clip && \
    (cp /comfyui/models/text_encoders/qwen_3_4b.safetensors /comfyui/models/clip/qwen_3_4b.safetensors 2>/dev/null || \
     cp /comfyui/models/text_encoders/qwen_3_4b.safetensors /comfyui/models/clip/ 2>/dev/null || \
     echo "Qwen not found in text_encoders, skipping copy")

RUN dl() { \
      url="$1"; relpath="$2"; fname="$3"; \
      for i in 1 2 3 4 5; do \
        HF_TOKEN=$HF_TOKEN comfy model download --url "$url" --relative-path "$relpath" --filename "$fname" && return 0; \
        if [ "$i" -eq 5 ]; then echo "model-download failed after 5 attempts: $fname" >&2; exit 1; fi; \
        sleep $((10 * i)); echo "model-download attempt $i failed for $fname; retrying" >&2; \
      done; \
    }; \
    dl 'https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/Wan22Animate/Wan2_2-Animate-14B_fp8_scaled_e4m3fn_KJ_v2.safetensors' models/diffusion_models 'Wan2_2-Animate-14B_fp8_scaled_e4m3fn_KJ_v2.safetensors' && \
    dl 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors' models/vae 'wan_2.1_vae.safetensors' && \
    dl 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors' models/text_encoders 'umt5_xxl_fp8_e4m3fn_scaled.safetensors' && \
    dl 'https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors' models/clip_vision 'clip_vision_h.safetensors' && \
    dl 'https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors' models/loras 'lightx2v_I2V_14B_480p_cfg_step_distill_rank256_bf16.safetensors' && \
    dl 'https://huggingface.co/f5aiteam/Wan/resolve/main/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors' models/loras 'wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors' && \
    dl 'https://huggingface.co/JunkyByte/easy_ViTPose/resolve/main/onnx/wholebody/vitpose-l-wholebody.onnx' models/detection 'vitpose-l-wholebody.onnx' && \
    dl 'https://huggingface.co/Wan-AI/Wan2.2-Animate-14B/resolve/main/process_checkpoint/det/yolov10m.onnx' models/detection 'yolov10m.onnx'

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

RUN echo "Installing dependencies for all custom nodes" && \
    pip install onnxruntime-gpu opencv-python-headless && \
    for dir in /comfyui/custom_nodes/*/; do \
      if [ -f "$dir/requirements.txt" ]; then \
        echo "Installing requirements for $dir" && \
        pip install -r "$dir/requirements.txt"; \
      fi; \
    done

COPY handler.py /handler.py

COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml
# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/