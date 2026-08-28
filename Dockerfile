FROM runpod/worker-comfyui:5.8.4-base

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
    git clone https://github.com/pythongosssss/ComfyUI-Custom-Scripts /comfyui/custom_nodes/ComfyUI-Custom-Scripts

RUN git clone https://github.com/WASasquatch/was-node-suite-comfyui /comfyui/custom_nodes/was-node-suite-comfyui && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack /comfyui/custom_nodes/ComfyUI-Impact-Pack && \
    git clone https://github.com/ltdrdata/ComfyUI-Impact-Subpack /comfyui/custom_nodes/ComfyUI-Impact-Subpack && \
    git clone https://github.com/fillipax/comfyui_fill-nodes /comfyui/custom_nodes/comfyui_fill-nodes

RUN git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus /comfyui/custom_nodes/ComfyUI_IPAdapter_plus && \
    git clone https://github.com/cubiq/ComfyUI_InstantID /comfyui/custom_nodes/ComfyUI_InstantID && \
    git clone https://github.com/cubiq/ComfyUI_FaceAnalysis /comfyui/custom_nodes/ComfyUI_FaceAnalysis && \
    git clone https://github.com/Gourieff/comfyui-reactor-node /comfyui/custom_nodes/comfyui-reactor-node && \
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux /comfyui/custom_nodes/comfyui_controlnet_aux && \
    git clone https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet /comfyui/custom_nodes/ComfyUI-Advanced-ControlNet && \
    git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale /comfyui/custom_nodes/ComfyUI_UltimateSDUpscale && \
    git clone https://github.com/jags111/efficiency-nodes-comfyui /comfyui/custom_nodes/efficiency-nodes-comfyui

RUN for req in /comfyui/custom_nodes/*/requirements.txt; do \
      if [ -f "$req" ]; then \
        echo "Installing requirements from $req..."; \
        /comfyui/.venv/bin/pip install --no-cache-dir -r "$req" || true; \
      fi \
    done

COPY download_models.sh /download_models.sh
COPY start.sh /start.sh
RUN chmod +x /download_models.sh /start.sh

CMD ["/start.sh"]
