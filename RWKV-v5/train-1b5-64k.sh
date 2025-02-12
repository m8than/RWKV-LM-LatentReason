#!/bin/bash
#######################################################################################################################
#
# Run demo-training-prepare.sh with the same MODEL_TYPE & N_LAYER & N_EMBD first
# Or, rename your base model to rwkv-init.pth and put it in the output folder
#
# The trainer will load the last rwkv-*.pth in the folder, such that it can continue from a stopped run
# Therefore check the log (### Loading rwkv-xxx.pth... ###), and make sure you don't have extra rwkv-*.pth there
#
#######################################################################################################################
#


MODEL_TYPE="x070" # x070 => rwkv-7.0
#
N_LAYER="24"
N_EMBD="2048"
#
CTX_LEN="128000" # !!! change magic_prime if you change ctx_len !!!
PROJ_DIR="out/N-L"$N_LAYER"-D"$N_EMBD"-"$MODEL_TYPE # set output folder
#
#######################################################################################################################
#
M_BSZ="2" # for 80G VRAM GPUs
LR_INIT="1e-5"
LR_FINAL="1e-5"
#
W_DECAY="0.01"
BETA_2="0.99"
ADAM_EPS="1e-18"
#
GRAD_CP=1 # 1 => slower, save VRAM; 0 => faster, more VRAM
EPOCH_SAVE=1 # save every 50 "miniepochs" (1 miniepoch = 40320 * ctx_len tokens) => decrease if your GPU is weak
#
#######################################################################################################################
#
N_NODE=1 # number of nodes
GPU_PER_NODE=8 # number of GPUs per node
#
DS_BUCKET_MB=200 # set to 2 for consumer GPUs, set to 200 for A100 / H100 (affects speed & vram usage)
#
python train.py --load_model "0" --wandb "RWKV-7-1B5-CTX" --proj_dir $PROJ_DIR --my_testing $MODEL_TYPE \
 --ctx_len $CTX_LEN --my_pile_stage 3 --epoch_count 999999 --epoch_begin 0 \
 --data_file "data/ContextExtend64KRWKV/dataset_chunk_0_text_document" --my_exit_tokens 6520020899 --magic_prime 50909 \
 --num_nodes $N_NODE --micro_bsz $M_BSZ --n_layer $N_LAYER --n_embd $N_EMBD --pre_ffn 0 --head_qk 0 \
 --lr_init $LR_INIT --lr_final $LR_FINAL --warmup_steps 10 --beta1 0.9 --beta2 $BETA_2 --adam_eps $ADAM_EPS --my_pile_edecay 0 --data_type "binidx" --vocab_size 65536 \
 --weight_decay $W_DECAY --epoch_save $EPOCH_SAVE --head_size_a 64 \
 --accelerator gpu --devices $GPU_PER_NODE --precision bf16 --strategy deepspeed_stage_2 --grad_cp $GRAD_CP --ds_bucket_mb $DS_BUCKET_MB
