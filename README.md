## Install docker and dependencies

Install docker desktop using the instructions provided in [this page](https://docs.docker.com/desktop/install/ubuntu/)

Install dependencies:
```
sudo apt-get install -y nvidia-container-toolkit
```
### Note:

If you got the error:

```
ERROR: permission denied while trying to connect to the Docker daemon socket
```

do the following:

```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
restart
```


## Build the docker

This will take 10-20 minutes to complete

```
docker build -t ros_noetic:latest .
```

## Run the docker

```
sudo chmod +x run.sh
./run.sh
```

## Run the simulation

In the terminal that you started the docker, source the workspace

```
source devel/setup.bash
```

In another terminal, open the docker interactive session and run the roscore

```
docker exec -it 16_667_VS bash
roscore
```

In the original session, run the simulation

```
mon launch core_central 16_667_visual_servo.launch
```

After the simulation has finished loading, in the left hand side of the rqt gui, press Offboard, then Arm, then Takeoff. This will make the drone take off from the ship's dock. Then you can use the Point tab of the right hand side of the rqt gui to select the point where you want the drone to go to. For this to work, you'll need to change x, y, and height to your desired values and then press Save Target, and then press Publish Target on the left hand side. On the Switch Panel tab, you can select the controller you want to use, the default is Position Controller, to change to the visual servo mode, first select the type of visual servo (IBVS or PBVS), and then change to the visual servo mode.

## Viewing camera stream and target detection for debugging

In another terminal, open another docker interactive session and open rqt_image_view

```
docker exec -it 16_667_VS bash
rqt_image_view
```

change the topic to '/image_debug' to view the camera view and target detection