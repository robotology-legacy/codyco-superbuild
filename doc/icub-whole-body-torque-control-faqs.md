-Frequent Asked Questions on whole-body torque control on the iCub robot  {#icub-whole-body-control-faqs}
-==================================
-
 ## iCub preliminary checks 
 
 ### What are the things to check on the iCub robot before performing whole-body torque control experiments? 
 
+# Do a complete update of information (before the calibration)
+
+## Usual update before processing
+First, update the new version of yarp/icub_main/codyco\-superbuild (git pull on the pcload). You don't have to repeat this operation on the other computers of the network, because the sources are shared.
+Then, if there are some updates, you have to build them (make) on all the computers (because the builds are not shared) with the usual:  
+`cd build  
+ccmake  ../ make`
+
+You only have to update the codyco-superbuild program on the pc from where you will launch programs (with a make update all in the build folder).  /*verify it is really for that*/  
+To do the required updates on the iCub board (pc104), you have to connect to it using the command:  
+`ssh -X pc104` (\-X option to redirect the graphic output to your local machine)
+
+## Firmware update
+This is only a little summary of what you have to do. For more information look [here](http://wiki.icub.org/wiki/Firmware).
+
+`cd /usr/local/src/robot/icub-firmware-build/`  
+`git pull`  
+
+Then, launch the cluster by using icub\_cluster.py  (or a script that configures and launch the icub_cluster.py).  
+Now, you can open _eth_loader_ and click “_discover_” to make sure that the server is connected (where yarpserver is launched). Now, you can check that all computers are connected together (if not, you just have to select the unconnected computer and click connect).
+Open [_can_loader_](http://wiki.icub.org/wiki/CanLoader) and update the version of devices by searching the corresponding EMS_file and uploading it.  
+
+# Check the joint calibration
+After changing an iCub component, or the first time we obtain an iCub, it is required to calibrate the “zero position” of the robot (home position). To do that, we launch the home position in yarpmanager and we use a level tool.
+
+## Devices update
+Before the calibration, you have to update the device information.
+You can find [Here](http://wiki.icub.org/wiki/Can_addresses_and_associated_firmware#PCAN2:_Right_arm) the information about the can bus number and the can bus device driver. Example for the icubDarmstadt01:  
+- Select EMS and can2: you can see the F/T sensors information (called strain).  
+- For the id 1,3,6,7,8,9 ID, we select the strain.hex file one by one and we update them.  
+- For the id 2, 4 it is different because they correspond to the skin sensors: download the skin.hex file if needed.  
+- If you select EMS and can1, is about motion control: type MAIS for the skin and RM 4DC for motors. Download all corresponding "\.hex" files by pushing the download button.  
+- If you select _net0_ can\-bus _cfw2_, you have information about the chest: Download the .out.s files linked to BLL (motor\-driver card) and RMHDC.  
+- The net 9 is here for the neck.  
+- There are BLL and RMHDC drivers. Download all corresponding file.out.s where the name correspond to the current version.  
+
+# Calibration of the robot
+Perform the calibration in this order: from the torso to the legs, then the head and the arm.  
+You can follow [these information](http://wiki.icub.org/wiki/Manual#Three._Calibration) to do it this [part](http://wiki.icub.org/wiki/ArmFineCalibration) explain quickly what you have to do.  
+The following lines give other information and an example.  
+In _Yarpmanager_, go to the part linked to the member you want to calibrate. Then, choose the "_idle mode_" wich allows you to move it. With a level, put the joint in the parallel position to the floor. Then put the mode of the considered joint in “_run mode_”. Note the encoder value.  
+This value has to be added in the specific file linked to the joint. Go to the folder:  
+`$CODYCO_SUPERBUILD_ROOT/external/ICUB/app/robots/$ROBOT_NAME/conf/calibration`     
+**/*Check it*/**   
+Search the corresponding file (for example left\_leg\_calib.xml), and add the “encoder value” that you have noted to the current one (parameter _calibrationDelta_: all numbers correspond to the joints). For example, we add some values to the line:  
+`<param name="calibrationDelta">         -5.0        8.7        -11.4        -0.6        0.0        0.0       3.0        0.0        0.0        0.0        0.0        0.0        0.0        0.0        0.0        0.0        </param>`  
+
+Thus, the source file shared between the load\_computer and the icub\_board (pc104) has been changed. Now, you have to update the icub\_board.  
+`ssh -X pc104`  
+`cd $YARP_DIR/icub_main/build`  
+`ccmake […]`  
+`make`  
+
+At the end, if all is correct, you have to commit it.  
+_Remarks_:  
+It is better to do many commit and not to commit at the end all the configuration files to avoid errors.  
+If you have the same configuration file in the local folder, the computer will use this file and not the one you modify. In that case, when you do tests, edit the file in the local folder. When you are sure of the calibration, modify the correct one and commit it.  
+
+To calibrate the head:  
+The configuration file for the head is on another folder:  
+`$CODYCO_SUPERBUILD_ROOT/external/ICUB/app/robots/$ROBOT_NAME/hardware/mecanicals`    
+Take the file linked to the head and modify the _zero parameter_.  
+You need to receive the acceleration values of the head to be able to calibrate it: choose (or create) a programm which writes these acceleration data and launch it. Choose to the _idle mode_ in the _yarpmanager_ for the two first joints of the head. Then, turn the head until the acceleration values are near (0;0;9) (the gravity has to be sensed only on the z axis). If the x and y positions have an error of less than 0.1, it is ok.  After that, click on run and copy the encoder value on the corresponding XML file. 
+
+To calibrate the arm:  
+Follow [this configuration](http://wiki.icub.org/wiki/ArmFineCalibration).
+
+ ### move these parts to an installation tips and tricks page. 
+
+# Things to know before downloading the project.
+* Install only Gazebo from binaries. The other programs will have to be installed from sources (not binaries). Thanks to that you can choose where there are installed, where are the libraries are placed, and you are able to update them easily.  
+* To be able to clean up easily the whole project, we have to avoid the program to be installed in the _/usr_ folder and avoid to install the library in the _/lib_ folder. To do that, follow these recommendations:  
+1. Create a new folder (for example “software”) in your home directory and install all programs in this folder.  
+2. When you download the files allowing to install the program, a new folder is created. Go to it and create two directories called "build" and "libraries". Then, go to the "build" folder, and build the program using the command line `ccmake [_options_] ../`. You should have something like: `~/software/$yourProgram/build`. Moreother, all librairies of your programm has be installed in the "libraries" file that you should have created. To do that, add to the previous command line the option `\-DCMAKE\_INSTALL\_PREFIX=~/software/$yourProgram/install`).  
+3. Normaly, after the command line `make` we write the command `make install`. Don't write this last command because we want to keep this program in the current directories without installing it in the "/usr" and "/lib" folders. Thanks to that, it is easier to clean up the program. Due to this specification, the program is not accessible from other folders. 
+4. Now, configure some variables to allow our programm to be found from anywhere. These configurations are precised during the installation guide. For example you will be informed to add to the "~/.bashrc" file the command lines:    
+`export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/software/$yourProgram/install/lib)`  
+`export PATH=$PATH:~/software/$yourProgram/build`
+
+# Launch the first iCub test
+Now, all is correctly updated and calibrated.  
+1. Open the power suppliers (wait a little for the power to come to the iCub).  
+2. Open the CPO.  
+3. It is recommended to create three terminals called yarpserver/yarpmanger/yarpmotorgui to avoid making some mistakes between them.  
+4. Go to the yarpserver terminal and launch "_icub\_cluster.py_" that launches yarpserver + yarprun (or, if you have it, launch the file that configures the cluster correctly. It should be called "launchApplicationGui.sh").  
+5. Check that the main computer is correctly connected: correct the name  of the computer if it is not correct, and click the "_verify_" button.  
+Then, click “_check all_” for all computers that you want to connect. If one of them is not connected, select it and connect it.  
+6. Now, you can push the switch that launches the motors.  
+7. Launch yarpmanager and run, for example, the basic application “_icubstartup_”. For some applications that require to connect components, you have to click on “connect”.  
 
+# Some little things to know 
+* Be careful with the head and hands of the robot.  
+* If you modify some source files on one computer of the network linked to the robot, these files will not be taken into account if their names are also in the ./local directory. Indeed, when you build a program, files are first read in the /local directory, then in the source folder.  
+* How to hide DEBUG information: in the cmake information, put the variable DEBUG from DEBUG to RELEASE  
