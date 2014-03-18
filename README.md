Walkman Project
---------------

This is the main repository for the Walkman European Project

Installation instructions
=========================
Just run
```
setup.sh
```

There are three types of setup.
- robot, when you need to install the system on the robot's PC104 / control desktop
- default, when you install on a PC
- simulation, same as default

If you need to install on your PC, you need to run, from the walkman folder

After the command finishes to get all dependencies, it will proceed to
bootstrap the superbuild, i.e. make all

Once you have setup and bootstrapped the superbuild, you can switch configuration
between default (used to control the robot) or simulation (used when simulating) configurations.

By default the superbuild is setup to control the robot with your laptop (e.g. yarpserver running locally)
but you can setup the system to control the robot using a remote yarpserver (e.g. using the PC104)
by going through the "Switch Profile" menu in setup.sh


The same is true for simulation, so the sebuperbuild is setup  to run a local simulation by default,
but you can use a remote simulation machine by going through the "Switch Profile" menu in setup.sh
If you have no clue what address you should put that, and you know the simulator machine is
inside your local network, you could try by running
```
yarp detect
```
which will work of course only if the simulator machine is the only machine in your network
running a yarpserver.
