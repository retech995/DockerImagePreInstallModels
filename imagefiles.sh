#!/bin/bash

source /venv/main/bin/activate
COMFYUI_DIR=${WORKSPACE}/ComfyUI
WORKSPACE_DIR=${WORKSPACE}



pip install huggingface_hub[hf_transfer]
pip install hf_transfer
pip install flask huggingface_hub hf_transfer rapidfuzz requests beautifulsoup4 insightface

huggingface-cli login --token $HF_TOKEN
export HF_HUB_ENABLE_HF_TRANSFER=1

huggingface-cli download Tessatessa056/inputdata --local-dir ${COMFYUI_DIR}/input/
huggingface-cli download Tessatessa056/workflowsdata --local-dir ${COMFYUI_DIR}/user/default/workflows/
huggingface-cli download Tessatessa056/outputdata --local-dir ${COMFYUI_DIR}/output/

cd .. && huggingface-cli download Tessatessa056/modeldata --local-dir ./
cd workspace

huggingface-cli download Tessatessa056/flaskapp --local-dir ./
unzip flaskapp.zip

chmod +x ./flaskapp/run_flask.sh
sh ./flaskapp/run_flask.sh

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
    "https://github.com/supersonic13/ComfyUI-RvTools"
    "https://github.com/retech995/Save_Florence2_Bulk_Prompts"
    "https://github.com/florestefano1975/comfyui-portrait-master"
    "https://github.com/chrisgoringe/cg-use-everywhere"
    "https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/Rvage0815/ComfyUI-RvTools"
    "https://github.com/chflame163/ComfyUI_LayerStyle"
    "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/city96/ComfyUI-GGUF"
    "https://github.com/cardenluo/ComfyUI-Apt_Preset"
    "https://github.com/ssitu/ComfyUI_UltimateSDUpscale"
    "https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch"
    "https://github.com/Extraltodeus/ComfyUI-AutomaticCFG"
    "https://github.com/ltdrdata/ComfyUI-Impact-Subpack"
    "https://github.com/cubiq/ComfyUI_essentials"
    "https://github.com/Rvage0815/ComfyUI-RvTools"
    "https://github.com/chflame163/ComfyUI_LayerStyle"
    "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
    "https://github.com/city96/ComfyUI-GGUF"
    "https://github.com/cardenluo/ComfyUI-Apt_Preset"
    "https://github.com/ssitu/ComfyUI_UltimateSDUpscale"
    "https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch"
    "https://github.com/Extraltodeus/ComfyUI-AutomaticCFG"
    "https://github.com/ltdrdata/ComfyUI-Impact-Subpack"
    "https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes"
    "https://github.com/kijai/ComfyUI-WanVideoWrapper"
    "https://github.com/crystian/ComfyUI-Crystools"
    "https://github.com/retech995/ComfyUI-ReActor"


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
