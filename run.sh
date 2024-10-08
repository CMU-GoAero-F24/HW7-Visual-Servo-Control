xhost +
TOTAL_MEM=$(grep MemTotal /proc/meminfo | awk '{print $2}')
TOTAL_MEM_MB=$((TOTAL_MEM / 1024))
MAX_CPUS=$(nproc)
docker run -it \
    --name 16_667_VS \
    --env="DISPLAY=${DISPLAY}" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --privileged \
    --memory="${TOTAL_MEM_MB}m" \
    --cpus="${MAX_CPUS}" \
    --memory-swap="${TOTAL_MEM_MB}m" \
    --gpus all \
    ros_noetic:latest \
    bash -c "source ~/.bashrc && cd /home/visual_servo_ws/src/mavros/mavros/scripts/ && ./install_geographiclib_datasets.sh && cd ../../../.. && source devel/setup.bash && bash"

