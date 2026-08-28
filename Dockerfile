FROM runpod/worker-comfyui:5.8.4-base

ARG HF_TOKEN=""

RUN git clone https://github.com/kijai/ComfyUI-KJNodes /comfyui/custom_nodes/ComfyUI-KJNodes && \
    git clone https://github.com/rgthree/rgthree-comfy /comfyui/custom_nodes/rgthree-comfy && \
    git clone https://github.com/kijai/ComfyUI-segment-anything-2 /comfyui/custom_nodes/ComfyUI-segment-anything-2 && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite /comfyui/custom_nodes/ComfyUI-VideoHelperSuite && \
    git clone https://github.com/chflame163/ComfyUI_LayerStyle /comfyui/custom_nodes/ComfyUI_LayerStyle && \
    git clone https://github.com/yolain/ComfyUI-Easy-Use /comfyui/custom_nodes/ComfyUI-Easy-Use && \
    git clone https://github.com/cubiq/ComfyUI_essentials /comfyui/custom_nodes/ComfyUI_essentials && \
    git clone https://github.com/kijai/ComfyUI-WanAnimatePreprocess /comfyui/custom_nodes/ComfyUI-WanAnimatePreprocess && \
    git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts /comfyui/custom_nodes/ComfyUI-Custom-Scripts && \
    git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus /comfyui/custom_nodes/ComfyUI_IPAdapter_plus && \
    git clone https://github.com/cubiq/ComfyUI_InstantID /comfyui/custom_nodes/ComfyUI_InstantID && \
    git clone https://github.com/cubiq/ComfyUI_FaceAnalysis /comfyui/custom_nodes/ComfyUI_FaceAnalysis && \
    git clone https://github.com/Gourieff/comfyui-reactor-node /comfyui/custom_nodes/comfyui-reactor-node && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux /comfyui/custom_nodes/comfyui_controlnet_aux && \
    git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet /comfyui/custom_nodes/ComfyUI-Advanced-ControlNet && \
    git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale /comfyui/custom_nodes/ComfyUI_UltimateSDUpscale && \
    git clone https://github.com/jags111/efficiency-nodes-comfyui /comfyui/custom_nodes/efficiency-nodes-comfyui

RUN comfy node install --exit-on-fail was-ns || true
RUN comfy node install --exit-on-fail comfyui-impact-pack || true
RUN comfy node install --exit-on-fail comfyui-impact-subpack || true
RUN comfy node install --exit-on-fail comfyui_fill-nodes || true
RUN comfy node install --exit-on-fail llm-toolkit --mode remote || true

RUN for req in /comfyui/custom_nodes/*/requirements.txt; do \
      if [ -f "$req" ]; then \
        /comfyui/.venv/bin/pip install --no-cache-dir -r "$req" || true; \
      fi \
    done

ADD extra_model_paths.yaml /comfyui/extra_model_paths.yaml

COPY download_models.sh /download_models.sh
RUN chmod +x /download_models.sh && /download_models.sh
