#!/bin/bash

source /venv/main/bin/activate
COMFYUI_DIR=${WORKSPACE}/ComfyUI


pip install huggingface_hub[hf_transfer]
pip install hf_transfer
huggingface-cli login --token $HF_TOKEN
export HF_HUB_ENABLE_HF_TRANSFER=1

huggingface-cli download Comfy-Org/flux1-dev flux1-dev-fp8.safetensors --local-dir ${COMFYUI_DIR}/models/unet/
huggingface-cli download comfyanonymous/flux_text_encoders t5xxl_fp16.safetensors --local-dir ${COMFYUI_DIR}/models/clip/
huggingface-cli download comfyanonymous/flux_text_encoders clip_l.safetensors --local-dir ${COMFYUI_DIR}/models/clip/
huggingface-cli download techparasite/tssa --local-dir ${COMFYUI_DIR}/user/default/workflows/




huggingface-cli download zer0int/CLIP-GmP-ViT-L-14 ViT-L-14-TEXT-detail-improved-hiT-GmP-HF.safetensors --local-dir ${COMFYUI_DIR}/models/clip/
huggingface-cli download mcmonkey/google_t5-v1_1-xxl_encoderonly t5xxl_fp8_e4m3fn.safetensors --local-dir ${COMFYUI_DIR}/models/clip/

huggingface-cli download gemasai/4x_NMKD-Siax_200k --local-dir ${COMFYUI_DIR}/models/upscale_models/


huggingface-cli download Phips/4xRealWebPhoto_v4_dat2 4xRealWebPhoto_v4_dat2.safetensors --local-dir ${COMFYUI_DIR}/models/upscale_models/


huggingface-cli download techparasite/modellllsss tessa.safetensors --local-dir ${COMFYUI_DIR}/models/loras/

huggingface-cli download black-forest-labs/FLUX.1-schnell ae.safetensors --local-dir ${COMFYUI_DIR}/models/vae/

huggingface-cli download techparasite/jms --local-dir ./
mv ${WORKSPACE}/Realism-001.safetensors ${COMFYUI_DIR}/models/checkpoints/Realism-001.safetensors
unzip ${WORKSPACE}/loras-20250424T074108Z-001.zip -d ${COMFYUI_DIR}/models/
unzip ${WORKSPACE}/loras-20250424T074108Z-002.zip -d ${COMFYUI_DIR}/models/
wget -O "project0_real1smV2FP16.safetensors" "https://civitai.com/api/download/models/1591370?type=Model&format=SafeTensor&size=pruned&fp=fp16&token=$CIVITAI_TOKEN"
wget -O "Flux_Skin_Detailer.safetensors" "https://civitai.com/api/download/models/1142009?type=Model&format=SafeTensor&token=$CIVITAI_TOKEN"

mv ${WORKSPACE}/project0_real1smV2FP16.safetensors ${COMFYUI_DIR}/models/unet/project0_real1smV2FP16.safetensors

mv ${WORKSPACE}/Flux_Skin_Detailer.safetensors ${COMFYUI_DIR}/models/loras/Flux_Skin_Detailer.safetensors


# Packages are installed after nodes so we can fix them...

APT_PACKAGES=(
    #"package-1"
    #"package-2"
)

PIP_PACKAGES=(
    #"package-1"
    #"package-2"
)

NODES=(
    "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
    "https://github.com/rgthree/rgthree-comfy"
    "https://github.com/yolain/ComfyUI-Easy-Use"
    "https://github.com/WASasquatch/was-node-suite-comfyui"
    "https://github.com/kijai/ComfyUI-KJNodes"
    "https://github.com/cubiq/ComfyUI_FaceAnalysis"
    "https://github.com/BadCafeCode/masquerade-nodes-comfyui"
    "https://github.com/chflame163/ComfyUI_LayerStyle_Advance"
    "https://github.com/Ryuukeisyou/comfyui_face_parsing"
    "https://github.com/MohammadAboulEla/ComfyUI-iTools"
    "https://github.com/giriss/comfy-image-saver"
    "https://github.com/ltdrdata/ComfyUI-Inspire-Pack"
    "https://github.com/kijai/ComfyUI-Florence2"
    "https://github.com/pythongosssss/ComfyUI-Custom-Scripts"
    "https://github.com/Pixelailabs/Save_Florence2_Bulk_Prompts"
    "https://github.com/supersonic13/ComfyUI-RvTools"
    
    
)

WORKFLOWS=(

)

CHECKPOINT_MODELS=(
    "https://civitai.com/api/download/models/798204?type=Model&format=SafeTensor&size=full&fp=fp16"
)

UNET_MODELS=(
)

LORA_MODELS=(
)

VAE_MODELS=(
)

ESRGAN_MODELS=(
)

CONTROLNET_MODELS=(
)

### DO NOT EDIT BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING ###

function provisioning_start() {
    provisioning_print_header
    provisioning_get_apt_packages
    provisioning_get_nodes
    provisioning_get_pip_packages
    provisioning_get_files \
        "${COMFYUI_DIR}/models/checkpoints" \
        "${CHECKPOINT_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/unet" \
        "${UNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/lora" \
        "${LORA_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/controlnet" \
        "${CONTROLNET_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/vae" \
        "${VAE_MODELS[@]}"
    provisioning_get_files \
        "${COMFYUI_DIR}/models/esrgan" \
        "${ESRGAN_MODELS[@]}"
    provisioning_print_end
}

function provisioning_get_apt_packages() {
    if [[ -n $APT_PACKAGES ]]; then
            sudo $APT_INSTALL ${APT_PACKAGES[@]}
    fi
}

function provisioning_get_pip_packages() {
    if [[ -n $PIP_PACKAGES ]]; then
            pip install --no-cache-dir ${PIP_PACKAGES[@]}
    fi
}

function provisioning_get_nodes() {
    for repo in "${NODES[@]}"; do
        dir="${repo##*/}"
        path="${COMFYUI_DIR}/custom_nodes/${dir}"
        requirements="${path}/requirements.txt"
        if [[ -d $path ]]; then
            if [[ ${AUTO_UPDATE,,} != "false" ]]; then
                printf "Updating node: %s...\n" "${repo}"
                ( cd "$path" && git pull )
                if [[ -e $requirements ]]; then
                   pip install --no-cache-dir -r "$requirements"
                fi
            fi
        else
            printf "Downloading node: %s...\n" "${repo}"
            git clone "${repo}" "${path}" --recursive
            if [[ -e $requirements ]]; then
                pip install --no-cache-dir -r "${requirements}"
            fi
        fi
    done
}

function provisioning_get_files() {
    if [[ -z $2 ]]; then return 1; fi
    
    dir="$1"
    mkdir -p "$dir"
    shift
    arr=("$@")
    printf "Downloading %s model(s) to %s...\n" "${#arr[@]}" "$dir"
    for url in "${arr[@]}"; do
        printf "Downloading: %s\n" "${url}"
        provisioning_download "${url}" "${dir}"
        printf "\n"
    done
}

function provisioning_print_header() {
    printf "\n##############################################\n#                                            #\n#          Provisioning container            #\n#                                            #\n#         This will take some time           #\n#                                            #\n# Your container will be ready on completion #\n#                                            #\n##############################################\n\n"
}

function provisioning_print_end() {
    printf "\nProvisioning complete:  Application will start now\n\n"
}

function provisioning_has_valid_hf_token() {
    [[ -n "$HF_TOKEN" ]] || return 1
    url="https://huggingface.co/api/whoami-v2"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $HF_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

function provisioning_has_valid_civitai_token() {
    [[ -n "$CIVITAI_TOKEN" ]] || return 1
    url="https://civitai.com/api/v1/models?hidden=1&limit=1"

    response=$(curl -o /dev/null -s -w "%{http_code}" -X GET "$url" \
        -H "Authorization: Bearer $CIVITAI_TOKEN" \
        -H "Content-Type: application/json")

    # Check if the token is valid
    if [ "$response" -eq 200 ]; then
        return 0
    else
        return 1
    fi
}

# Download from $1 URL to $2 file path
function provisioning_download() {
    if [[ -n $HF_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?huggingface\.co(/|$|\?) ]]; then
        auth_token="$HF_TOKEN"
    elif 
        [[ -n $CIVITAI_TOKEN && $1 =~ ^https://([a-zA-Z0-9_-]+\.)?civitai\.com(/|$|\?) ]]; then
        auth_token="$CIVITAI_TOKEN"
    fi
    if [[ -n $auth_token ]];then
        wget --header="Authorization: Bearer $auth_token" -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    else
        wget -qnc --content-disposition --show-progress -e dotbytes="${3:-4M}" -P "$2" "$1"
    fi
}

# Allow user to disable provisioning if they started with a script they didn't want
if [[ ! -f /.noprovisioning ]]; then
    provisioning_start
fi



mv ${COMFYUI_DIR}/custom_nodes/Save_Florence2_Bulk_Prompts/save_text_node.py ${COMFYUI_DIR}/custom_nodes/Save_Florence2_Bulk_Prompts/save_text_nodeold.py
mv ${COMFYUI_DIR}/user/default/workflows/save_text_node.py ${COMFYUI_DIR}/custom_nodes/Save_Florence2_Bulk_Prompts/save_text_node.py
