# Use the official Ubuntu 20.04 base image
FROM ubuntu:20.04

# Prevent prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Update and install necessary dependencies
RUN apt-get update && apt-get install -y \
    locales \
    software-properties-common \
    curl \
    gnupg2 \
    lsb-release \
    && locale-gen en_US en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && export LANG=en_US.UTF-8

# Add the ROS Noetic repository to apt sources
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-noetic.list'
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Update apt and install ROS Noetic desktop full
RUN apt-get update && apt-get install -y \
    ros-noetic-desktop-full \
    ros-noetic-rosbash \
    ros-noetic-rosserial \
    ros-noetic-rosserial-arduino \
    ros-noetic-rosbridge-suite \
    build-essential \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    python3-pip \
    python3-vcstool \
    git \
    wget \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init && rosdep update

# Set up the ROS environment
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash"

# Install additional ROS packages
RUN apt-get update && apt-get install -y \
    ros-noetic-navigation \
    ros-noetic-gmapping \
    ros-noetic-tf2-web-republisher \
    ros-noetic-teleop-twist-keyboard

RUN sudo pip3 install numpy toml Jinja2 future pyros-genmsg torch pandas
    

# Install GStreamer and its plugins
RUN apt-get update && apt-get install -y \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-doc \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-pulseaudio \
    && apt-get clean

# Install Gazebo (Optional: If you want to use Gazebo with ROS Noetic)
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" > /etc/apt/sources.list.d/gazebo-stable.list' \
    && wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add - \
    && apt-get update && apt-get install -y \
    gazebo11 \
    ros-noetic-gazebo-ros-pkgs \
    ros-noetic-gazebo-ros-control

# Create and build the workspace directory

RUN mkdir -p /home/visual_servo_ws/src && \
    cd /home/visual_servo_ws/src && \
    git clone https://github.com/castacks/16_667_visual_servo.git && \
    cd /home/visual_servo_ws/src/16_667_visual_servo && \
    mv * ../ && cd ../ && rm -rf 16_667_visual_servo && \
    git clone https://bitbucket.org/castacks/firmware_am_noetic.git && \
    cd firmware_am_noetic && \
    git checkout 16_667 && \
    make px4_sitl_default gazebo HEADLESS=1 && \
    cd /home/visual_servo_ws/src/mavros/mavros/scripts && \
    ./install_geographiclib_datasets.sh && \
    cd /home/visual_servo_ws && \
    sudo apt install python-jinja2 ros-noetic-geographic-msgs libgeographic-dev geographiclib-tools python-is-python3 python3-catkin-tools x11-apps ros-noetic-rosmon -y && \
    echo "alias python='python3'"  >> ~/.bashrc && \
    /bin/bash -c "source /opt/ros/noetic/setup.bash && cd /home/visual_servo_ws && catkin init && catkin build && source devel/setup.bash" && \
    echo "source /home/visual_servo_ws/devel/setup.bash"  >> ~/.bashrc
# Install yolo dependencies
RUN sudo pip3 install --upgrade numpy pandas matplotlib importlib_metadata && \
    cd /tmp && git clone https://github.com/ultralytics/yolov5.git && \
    cd yolov5 && pip install -r requirements.txt

CMD ["bash", "-c", "source /opt/ros/noetic/setup.bash && cd /home/visual_servo_ws/src/mavros/mavros/scripts/ && ./install_geographiclib_datasets.sh && nohup roscore > /dev/null 2>&1 & exec bash"]

# RUN cd /home/visual_servo_ws/src && git clone https://github.com/ultralytics/yolov5.git && \
#     cd yolov5 && pip install -r requirements.txt

    # sudo pip3 install numpy==1.24.4 matplotlib==3.7.5 opencv-python==4.10.0.84 pillow==10.4.0 requests==2.32.3 scipy==1.10.1 torch>=1.8.0 torchvision==0.19.0 tqdm==4.66.5 seaborn==0.13.2 ultralytics==8.2.86 ultralytics-thop==2.0.6

# # Clean up
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# # Expose any necessary ports (adjust according to your use case)
# EXPOSE 11311

# # Set the default command to run when the container starts
# CMD ["bash"]
