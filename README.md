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


## Pull the docker

```
docker pull mmousaei/16667_visual_servo
```

## Run the docker

```
sudo chmod +x run.sh stop.sh
./run.sh
```

## Run the simulation

In the terminal that you started the docker, source the workspace

```
source /home/visual_servo_ws/devel/setup.bash
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

## Testing your code
to test your code, do the (Run the simulation) steps after editing the code. Then use the 'SwitchPanel' in the gui to switch between Position Controller, or Visual Servo controller. (Position Controller is the default controller that doesn't use your code and you can use it to go to the initial point, then switch to the visual servo controller that uses your code to test your code). Before switching to the visual servo controller, choose the visual servo mode (IBVS or PBVS).

### Note
There is a bug in the gui that doesn't register the first switch in the SwitchPanel. After the second switch, it works fine.

## Stop the docker

To stop the docker, exit the interactive session by

```
exit
```
then run the stop script
```
./stop.sh
```

## Video instructions

Watch [this](https://youtu.be/nH8haXbUuuc) video for step by step instructions.